// Manual regression test for the store-review account.
// Spins up an in-memory MongoDB replica set - no external services needed.
// Run with: npm run test:reviewer-user
//
// The assertion that matters is the transfer KYC gate. An account that logs in
// but cannot create a transfer looks like a broken app to a store reviewer and
// is the classic App Store 2.1 rejection, so it is checked through the very
// function the transfer flow calls rather than by inspecting fields.
const { resolve } = require("path");
const { existsSync } = require("fs");
const { MongoMemoryReplSet } = require("mongodb-memory-server");

const ROOT = resolve(__dirname, "..");

let failures = 0;
function check(label, condition, extra = "") {
    if (condition) console.log(`  ok    ${label}`);
    else { console.error(`  FAIL  ${label} ${extra}`); failures++; }
}

async function main() {
    const replSet = await MongoMemoryReplSet.create({ replSet: { count: 1 } });
    process.env.NODE_ENV = process.env.NODE_ENV || "development";
    process.env.DB_URL = replSet.getUri("client");

    const { clientDB } = require(`${ROOT}/database/connections`);
    await clientDB.openUri(process.env.DB_URL);

    const mongoose = require("mongoose");
    const { compare } = require("bcryptjs");
    const { userModel, kycModel } = require(`${ROOT}/models/client`);
    const { assertKycApprovedForTransfer } = require(`${ROOT}/repositories/kyc`);
    const { main: createReviewerUser } = require(`${ROOT}/scripts/create-reviewer-user`);

    const email = "reviewer@example.com";

    console.log("\n-- rejects unusable credentials --");
    await createReviewerUser({ email, password: "short" })
        .then(() => check("a too-short password is rejected", false))
        .catch((err) => check("a too-short password is rejected", /8\+ characters/.test(err.message), err.message));

    // The failure mode this guards against: the placeholder password from the
    // runbook, in Arabic, which a reviewer physically cannot type.
    await createReviewerUser({ email, password: "كلمة-مرور-قوية" })
        .then(() => check("a non-ASCII password is rejected", false))
        .catch((err) => check("a non-ASCII password is rejected", /ASCII/.test(err.message), err.message));

    console.log("\n-- first run creates the account --");
    await createReviewerUser({ email, password: "ReviewPass123" });

    const user = await userModel.findOne({ email });
    check("user exists", Boolean(user));
    check("user is active", user.status === "active", user.status);
    check("2FA is disabled", user.twoFA.enabled === false);
    check("password verifies", await compare("ReviewPass123", user.password));
    check("account number assigned", user.accountNumber >= 100000, String(user.accountNumber));

    const kyc = await kycModel.findOne({ user: user._id });
    check("KYC record exists", Boolean(kyc));
    check("KYC status is verified", kyc?.status === "verified", kyc?.status);
    check("verifiedAt is set", Boolean(kyc?.verifiedAt));
    check("placeholder document written to disk", existsSync(resolve(ROOT, kyc.filePath)), kyc.filePath);
    check("two document images recorded", kyc.documentImages?.length === 2, String(kyc.documentImages?.length));

    const gate = await assertKycApprovedForTransfer(user._id, "en");
    check("THE TRANSFER KYC GATE PASSES", gate.error === false, JSON.stringify(gate));

    console.log("\n-- re-running is idempotent and rotates the password --");
    await createReviewerUser({ email, password: "NewReviewPass456" });

    check("still exactly one user", (await userModel.countDocuments({ email })) === 1);
    check("still exactly one KYC record", (await kycModel.countDocuments({ user: user._id })) === 1);

    const reloaded = await userModel.findOne({ email });
    check("new password works", await compare("NewReviewPass456", reloaded.password));
    check("old password no longer works", !(await compare("ReviewPass123", reloaded.password)));

    const gateAfter = await assertKycApprovedForTransfer(user._id, "en");
    check("gate still passes after re-run", gateAfter.error === false, JSON.stringify(gateAfter));

    console.log("\n-- a previously rejected KYC is repaired, not left contradictory --");
    await kycModel.updateOne({ user: user._id }, {
        $set: { status: "rejected", rejectedAt: new Date(), rejectionReason: "test" },
    });
    await createReviewerUser({ email, password: "NewReviewPass456" });
    const repaired = await kycModel.findOne({ user: user._id });
    check("status is verified again", repaired.status === "verified", repaired.status);
    check("stale rejection reason is cleared", !repaired.rejectionReason, repaired.rejectionReason);

    console.log("\n-- an ordinary user is still gated --");
    const other = await userModel.create({
        name: "Normal User", nickname: "normal", country: "DE",
        mobilePhone: "+491700009999", email: "normal@example.com",
        password: "SomePass123", accountNumber: 999999, status: "active",
    });
    const otherGate = await assertKycApprovedForTransfer(other._id, "en");
    check("user without KYC is refused", otherGate.error === true && otherGate.code === "KYC_REQUIRED", JSON.stringify(otherGate));

    console.log("");
    console.log(failures ? `${failures} FAILURE(S)` : "ALL REVIEWER ACCOUNT TESTS PASSED");

    await clientDB.close();
    await replSet.stop();
    process.exit(failures ? 1 : 0);
}

main().catch(async (err) => {
    console.error("[manual-test-reviewer-user]", err?.stack || err);
    process.exit(1);
});
