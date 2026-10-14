// Manual regression test for the administrative password reset.
// Spins up an in-memory MongoDB replica set - no external services needed.
// Run with: npm run test:reset-password
//
// Resetting the wrong account locks a real customer out of their money, so
// most of what is checked here is the script refusing to act: on a missing
// account, on a weak password, and without an explicit confirmation.
const { resolve } = require("path");
const { MongoMemoryReplSet } = require("mongodb-memory-server");

const ROOT = resolve(__dirname, "..");

let failures = 0;
function check(label, condition, extra = "") {
    if (condition) console.log(`  ok    ${label}`);
    else { console.error(`  FAIL  ${label} ${extra}`); failures++; }
}

async function expectFailure(label, env, pattern) {
    const saved = { ...process.env };
    Object.assign(process.env, env);
    try {
        const { main } = require(`${ROOT}/scripts/reset-user-password`);
        await main();
        check(label, false, "it ran instead of refusing");
    }
    catch (err) {
        check(label, pattern.test(err.message), err.message);
    }
    finally {
        process.env = saved;
    }
}

async function main() {
    const replSet = await MongoMemoryReplSet.create({ replSet: { count: 1 } });
    process.env.NODE_ENV = process.env.NODE_ENV || "development";
    process.env.DB_URL = replSet.getUri("client");

    const { clientDB } = require(`${ROOT}/database/connections`);
    await clientDB.openUri(process.env.DB_URL);

    const { compare, hash } = require("bcryptjs");
    const { userModel } = require(`${ROOT}/models/client`);

    const PHONE = "+963930261806";
    await userModel.create({
        name: "Test Customer", nickname: "test", country: "SY",
        mobilePhone: PHONE, email: "customer@example.com",
        password: await hash("OldPass123", 10),
        accountNumber: 100077, status: "active",
    });

    // The script reads its inputs at call time, so each case sets env and
    // re-invokes the same exported function.
    const { main: reset } = require(`${ROOT}/scripts/reset-user-password`);
    const run = async (env) => {
        const saved = { ...process.env };
        Object.assign(process.env, env);
        try { return await reset(); }
        finally { process.env = saved; }
    };

    console.log("\n-- it refuses bad input --");
    await expectFailure("no identifier is refused",
        { RESET_IDENTIFIER: "", RESET_PASSWORD: "NewPass123" }, /RESET_IDENTIFIER is required/);
    await expectFailure("a password with no uppercase is refused",
        { RESET_IDENTIFIER: PHONE, RESET_PASSWORD: "newpass123" }, /uppercase/);
    await expectFailure("a password with no digit is refused",
        { RESET_IDENTIFIER: PHONE, RESET_PASSWORD: "NewPassword" }, /number/);
    await expectFailure("a short password is refused",
        { RESET_IDENTIFIER: PHONE, RESET_PASSWORD: "Ab1" }, /8 characters/);
    await expectFailure("a password with edge whitespace is refused",
        { RESET_IDENTIFIER: PHONE, RESET_PASSWORD: "NewPass123 " }, /space/);
    await expectFailure("an unknown account is refused",
        { RESET_IDENTIFIER: "+963900000000", RESET_PASSWORD: "NewPass123" }, /No account found/);

    console.log("\n-- the dry run changes nothing --");
    let result = await run({ RESET_IDENTIFIER: PHONE, RESET_PASSWORD: "NewPass123" });
    check("dry run reports it did not change anything", result.changed === false);
    let user = await userModel.findOne({ mobilePhone: PHONE });
    check("the old password still works after a dry run", await compare("OldPass123", user.password));

    console.log("\n-- confirmed reset --");
    result = await run({ RESET_IDENTIFIER: PHONE, RESET_PASSWORD: "NewPass123", RESET_CONFIRM: "yes" });
    check("it reports the change", result.changed === true);
    user = await userModel.findOne({ mobilePhone: PHONE });
    check("the new password works", await compare("NewPass123", user.password));
    check("the old password no longer works", !(await compare("OldPass123", user.password)));
    check("the stored value is a bcrypt hash, not plaintext", /^\$2[aby]\$/.test(user.password), user.password.slice(0, 7));

    console.log("\n-- it finds the account by email too --");
    result = await run({ RESET_IDENTIFIER: "customer@example.com", RESET_PASSWORD: "ByEmail123", RESET_CONFIRM: "yes" });
    check("email identifier works", result.changed === true);
    user = await userModel.findOne({ mobilePhone: PHONE });
    check("the password set via email identifier works", await compare("ByEmail123", user.password));

    console.log("\n-- nothing else on the account is touched --");
    check("status unchanged", user.status === "active", user.status);
    check("account number unchanged", user.accountNumber === 100077, String(user.accountNumber));
    check("name unchanged", user.name === "Test Customer", user.name);

    console.log("");
    console.log(failures ? `${failures} FAILURE(S)` : "ALL PASSWORD RESET TESTS PASSED");

    await clientDB.close();
    await replSet.stop();
    process.exit(failures ? 1 : 0);
}

main().catch(async (err) => {
    console.error("[manual-test-reset-password]", err?.stack || err);
    process.exit(1);
});
