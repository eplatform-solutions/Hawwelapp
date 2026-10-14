// Administrative password reset for a single customer account.
//
// Stored passwords are bcrypt hashes and cannot be read back, so there is no
// way to recover an existing password - only to set a new one. This script
// does that, and never prints the password it sets.
//
// Usage (identifier is the account's mobile phone in E.164, or its email):
//
//   NODE_ENV=production \
//   RESET_IDENTIFIER="+9639xxxxxxxx" \
//   RESET_PASSWORD="NewPass123" \
//   node scripts/reset-user-password.js
//
// Add RESET_CONFIRM=yes to actually write the change; without it the script
// only reports which account would be affected. Resetting the wrong account
// locks a real customer out of their money, so the dry run is the default.
//
// NOTE: this does not sign existing devices out. Login tokens are stateless
// JWTs valid for 7 days (constants/tokens ACCESS_TOKEN_EXPIRE), and there is
// no server-side session to revoke, so a token issued before the reset keeps
// working until it expires.
const { resolve } = require("path");
const { hash } = require("bcryptjs");
const { clientDB } = require("../database/connections");
const { userModel } = require("../models/client");

require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

// Read at call time rather than at import, so the function can be driven
// directly by a test without going through the environment.
function readInputs(overrides = {}) {
    return {
        identifier: String(overrides.identifier ?? process.env.RESET_IDENTIFIER ?? "").trim(),
        newPassword: String(overrides.newPassword ?? process.env.RESET_PASSWORD ?? ""),
        confirmed: String(overrides.confirm ?? process.env.RESET_CONFIRM ?? "").trim().toLowerCase() === "yes",
    };
}

// Mirrors the rule on the user model, checked here against the plaintext:
// once the value is hashed the model's validator lets it through untouched.
function describePasswordProblem(value) {
    const problems = [];
    if (value.length < 8) problems.push("at least 8 characters");
    if (value.length > 128) problems.push("no more than 128 characters");
    if (!/[A-Z]/.test(value)) problems.push("one uppercase letter");
    if (!/[a-z]/.test(value)) problems.push("one lowercase letter");
    if (!/\d/.test(value)) problems.push("one number");
    return problems;
}

// Enough to recognise the account, not enough to expose it in a shell history
// or a screenshot.
function mask(value) {
    const text = String(value || "");
    if (text.length <= 4) return "****";
    return `${text.slice(0, 3)}***${text.slice(-3)}`;
}

async function resetUserPassword(overrides = {}) {
    const { identifier, newPassword, confirmed } = readInputs(overrides);
    if (!identifier) {
        throw new Error("RESET_IDENTIFIER is required (mobile phone in E.164, or email).");
    }
    const problems = describePasswordProblem(newPassword);
    if (problems.length > 0) {
        throw new Error(`RESET_PASSWORD must contain ${problems.join(", ")}.`);
    }
    // The login flow accepts a trimmed password as well as the raw one, so a
    // stored password with edge whitespace would behave inconsistently.
    if (newPassword !== newPassword.trim()) {
        throw new Error("RESET_PASSWORD must not start or end with a space.");
    }

    if (clientDB.readyState === 0) {
        await clientDB.openUri(process.env.DB_URL);
    }

    const isEmail = identifier.includes("@");
    const query = isEmail
        ? { email: identifier.toLowerCase() }
        : { mobilePhone: identifier };

    const user = await userModel.findOne(query, {
        name: 1, mobilePhone: 1, email: 1, accountNumber: 1, status: 1, isVerified: 1,
    });

    if (!user) {
        throw new Error(`No account found for ${mask(identifier)}.`);
    }

    console.log("[reset-user-password] Account found:");
    console.log(`  name          : ${user.name}`);
    console.log(`  account number: ${user.accountNumber}`);
    console.log(`  mobile        : ${mask(user.mobilePhone)}`);
    console.log(`  email         : ${user.email ? mask(user.email) : "(none)"}`);
    console.log(`  status        : ${user.status}`);

    if (!confirmed) {
        console.log("");
        console.log("[reset-user-password] DRY RUN - nothing was changed.");
        console.log("Re-run with RESET_CONFIRM=yes to set the new password.");
        return { changed: false, userId: user._id };
    }

    await userModel.updateOne(
        { _id: user._id },
        { $set: { password: await hash(newPassword, 10) } }
    );

    console.log("");
    console.log(`[reset-user-password] Password updated for account #${user.accountNumber} at ${new Date().toISOString()}.`);
    console.log("The new password is not printed here. Devices already signed in stay signed in until their token expires (up to 7 days).");
    return { changed: true, userId: user._id };
}

if (require.main === module) {
    resetUserPassword()
        .then(async () => {
            await clientDB.close();
            process.exit(0);
        })
        .catch(async (err) => {
            console.error("[reset-user-password]", err?.message || err);
            await clientDB.close();
            process.exit(1);
        });
}

module.exports = { main: resetUserPassword };
