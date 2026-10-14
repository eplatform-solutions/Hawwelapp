// Creates (or refreshes) the store-review account that Apple / Google
// reviewers log in with. It is a normal client user with everything a
// reviewer would otherwise be stuck on already done:
//   - status "active", so the account is not blocked
//   - twoFA disabled, so login is email + password only (no OTP mail the
//     reviewer cannot receive)
//   - an approved KYC record, so the reviewer can actually create a transfer
//
// That last one is the part that is easy to get wrong: the transfer gate
// (assertKycApprovedForTransfer) reads the kyc collection, NOT user.isVerified.
// Setting only the user flag produces an account that logs in fine and then
// refuses every transfer with "KYC required" - which reads to a reviewer as a
// broken app and is the classic App Store 2.1 rejection.
//
// Credentials come from the environment so nothing secret lands in git:
//   REVIEWER_EMAIL=... REVIEWER_PASSWORD=... npm run create:reviewer-user
// Use a plain ASCII password: a reviewer on a US/EU keyboard has to type it.
// Re-running with the same email only resets the password and flags.
const { resolve, join } = require("path");
const { existsSync, mkdirSync, writeFileSync } = require("fs");
const { randomUUID } = require("crypto");
const { hash } = require("bcryptjs");
const { clientDB } = require("../database/connections");
const { userModel, counterModel, kycModel } = require("../models/client");

require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

// Read at call time rather than at import, so the function can be driven
// directly by a test without going through the environment.
function readCredentials(overrides = {}) {
    return {
        email: String(overrides.email ?? process.env.REVIEWER_EMAIL ?? "").trim().toLowerCase(),
        password: String(overrides.password ?? process.env.REVIEWER_PASSWORD ?? ""),
        mobilePhone: String(overrides.mobilePhone ?? process.env.REVIEWER_PHONE ?? "+491700000000").trim(),
    };
}

// Same counter the sign-up flow uses, so the reviewer gets a real account
// number instead of colliding with a later sign-up.
async function getNextAccountNumber() {
    const counter = await counterModel.findOneAndUpdate(
        { name: "accountNumber" },
        [{ $set: { seq: { $cond: [{ $ifNull: ["$seq", false] }, { $add: ["$seq", 1] }, 100000] } } }],
        { new: true, upsert: true }
    );
    return counter.seq;
}

// A 1x1 PNG. The transfer gate only reads the KYC record's status, but the
// dashboard's KYC screen renders whatever filePath points at - writing real
// (if tiny) files keeps this account from showing up there as a broken image.
const PLACEHOLDER_PNG = Buffer.from(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=",
    "base64"
);

// Mirrors middlewares/kyc, which writes uploads to ./assets/images/kyc
// relative to the API process's working directory.
const KYC_DIR = resolve(__dirname, "../assets/images/kyc");

function writePlaceholderDocument(label) {
    if (!existsSync(KYC_DIR)) {
        mkdirSync(KYC_DIR, { recursive: true });
    }
    // The model enforces `{uuid}__{name}.{ext}`, so the name is built to match
    // rather than being free-form.
    const fileName = `${randomUUID()}__reviewer_placeholder_${label}.png`;
    writeFileSync(join(KYC_DIR, fileName), PLACEHOLDER_PNG);
    return `assets/images/kyc/${fileName}`;
}

// Without this the reviewer logs in and then cannot create a transfer.
async function ensureApprovedKyc(userId) {
    const existing = await kycModel.findOne({ user: userId });
    if (existing) {
        existing.status = "verified";
        existing.verifiedAt = new Date();
        // Clear any decision fields from a previous run so the record is not
        // simultaneously "verified" and carrying a rejection reason.
        existing.rejectedAt = undefined;
        existing.rejectionReason = undefined;
        existing.blockedAt = undefined;
        existing.blockingReason = undefined;
        await existing.save();
        return "updated";
    }

    const firstDocument = writePlaceholderDocument("1");
    const secondDocument = writePlaceholderDocument("2");
    await new kycModel({
        user: userId,
        filePath: firstDocument,
        documentImages: [firstDocument, secondDocument],
        status: "verified",
        verifiedAt: new Date(),
    }).save();
    return "created";
}

async function createReviewerUser(overrides = {}) {
    const { email, password, mobilePhone } = readCredentials(overrides);
    if (!email || password.length < 8) {
        throw new Error("REVIEWER_EMAIL and REVIEWER_PASSWORD (8+ characters) are required.");
    }

    // A reviewer in Cupertino or Cork types this by hand on a Latin keyboard.
    // Non-ASCII here means they cannot log in, and "could not access the
    // account" is the most common store rejection there is.
    if (/[^\x20-\x7E]/.test(password)) {
        throw new Error("REVIEWER_PASSWORD must be plain ASCII - a store reviewer has to type it on a Latin keyboard.");
    }

    if (clientDB.readyState === 0) {
        await clientDB.openUri(process.env.DB_URL);
    }
    const encryptedPassword = await hash(password, 10);
    const reviewFlags = {
        password: encryptedPassword,
        status: "active",
        isVerified: true,
        verifiedAt: new Date(),
        twoFA: { enabled: false, methods: [] },
    };

    const existing = await userModel.findOne({ $or: [{ email }, { mobilePhone }] });
    let userId;
    if (existing) {
        await userModel.updateOne({ _id: existing._id }, { $set: reviewFlags });
        userId = existing._id;
        console.log(`[create-reviewer-user] Updated existing user ${existing.email || existing.mobilePhone} (account #${existing.accountNumber}).`);
    } else {
        const user = await new userModel({
            name: "App Store Reviewer",
            nickname: "reviewer",
            fatherName: "",
            country: "DE",
            mobilePhone,
            email,
            accountNumber: await getNextAccountNumber(),
            ...reviewFlags,
        }).save();
        userId = user._id;
        console.log(`[create-reviewer-user] Created ${user.email} (account #${user.accountNumber}).`);
    }

    const kycOutcome = await ensureApprovedKyc(userId);
    console.log(`[create-reviewer-user] Approved KYC record ${kycOutcome}.`);

    console.log("[create-reviewer-user] Login: email + password only (2FA off, KYC approved, transfers allowed).");
    return { userId, kycOutcome };
}

// Only self-executes when run directly, so a test can call it in-process and
// keep the connection open to assert on the result - the same shape as
// scripts/seed-dev-admin-if-missing.js in the dashboard API.
if (require.main === module) {
    createReviewerUser()
        .then(async () => {
            await clientDB.close();
            process.exit(0);
        })
        .catch(async (err) => {
            console.error("[create-reviewer-user]", err?.message || err);
            await clientDB.close();
            process.exit(1);
        });
}

module.exports = { main: createReviewerUser };
