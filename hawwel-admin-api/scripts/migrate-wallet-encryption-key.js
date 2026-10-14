/**
 * Re-encrypts every blockchain wallet private key (client deposit wallets and dashboard
 * central / network-fee-funding wallets) from SECRET_KEY to WALLET_ENCRYPTION_KEY.
 *
 * Dry run by default (reports counts only). Pass --apply to write.
 * It never prints a private key. Safe to run more than once: wallets already on
 * WALLET_ENCRYPTION_KEY are skipped.
 *
 * Usage (on the server, inside hawwel-admin-api):
 *   NODE_ENV=production node scripts/migrate-wallet-encryption-key.js
 *   NODE_ENV=production node scripts/migrate-wallet-encryption-key.js --apply
 *   NODE_ENV=production node scripts/migrate-wallet-encryption-key.js --diagnose   (explain failures, no key data)
 */
const { resolve } = require("path");
require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const { clientDB, dashboardDB } = require("../database/connections");
const clientBlockchainWalletModel = require("../models/client/blockchain_wallet");
const dashboardBlockchainWalletModel = require("../models/dashboard/blockchain_wallet");
const { encryptWalletPrivateKey, isEncryptedWithWalletKey, tryDecrypt } = require("../helpers/wallet_encryption");
const { AES, enc } = require("crypto-js");

const APPLY = process.argv.includes("--apply");
const DIAGNOSE = process.argv.includes("--diagnose");

// Describes why a wallet could not be decrypted without revealing any part of its key.
function describeFailure(wallet) {
    const cipherText = String(wallet.privateKey);
    let rawLength = "error";
    let rawIsHex = false;
    try {
        const raw = AES.decrypt(cipherText, process.env.SECRET_KEY).toString(enc.Utf8);
        rawLength = raw.length;
        rawIsHex = /^(0x)?[0-9a-fA-F]+$/.test(raw);
    } catch {
        // Wrong key usually throws "Malformed UTF-8 data".
    }
    return [
        `id=${wallet._id}`,
        `network=${wallet.network}`,
        `created=${wallet._id.getTimestamp().toISOString()}`,
        `withdrawStatus=${wallet.withdrawStatus}`,
        `cryptoJsFormat=${cipherText.startsWith("U2FsdGVkX1")}`,
        `cipherLength=${cipherText.length}`,
        `decryptedLength=${rawLength}`,
        `decryptedIsHex=${rawIsHex}`,
    ].join(" ");
}

async function migrateCollection(label, model) {
    const stats = { total: 0, alreadyMigrated: 0, migrated: 0, failed: 0, failedIds: [] };
    const cursor = model.find(
        { privateKey: { $exists: true, $ne: "" } },
        { privateKey: 1, network: 1, withdrawStatus: 1 }
    ).lean().cursor();
    for await (const wallet of cursor) {
        stats.total++;
        if (isEncryptedWithWalletKey(wallet.privateKey)) {
            stats.alreadyMigrated++;
            continue;
        }
        const privateKey = tryDecrypt(wallet.privateKey, process.env.SECRET_KEY);
        if (!privateKey) {
            stats.failed++;
            stats.failedIds.push(String(wallet._id));
            if (DIAGNOSE) {
                console.log(`[${label}] failed: ${describeFailure(wallet)}`);
            }
            continue;
        }
        if (APPLY) {
            // updateOne skips the schema's pre-save hook, so the key is not encrypted twice.
            await model.updateOne({ _id: wallet._id }, { $set: { privateKey: encryptWalletPrivateKey(privateKey) } });
        }
        stats.migrated++;
    }
    console.log(
        `[${label}] total=${stats.total} alreadyMigrated=${stats.alreadyMigrated} ` +
        `${APPLY ? "migrated" : "toMigrate"}=${stats.migrated} failed=${stats.failed}`
    );
    if (stats.failedIds.length) {
        console.log(`[${label}] could not decrypt with SECRET_KEY, left unchanged: ${stats.failedIds.join(", ")}`);
    }
    return stats;
}

async function main() {
    if (!process.env.WALLET_ENCRYPTION_KEY) {
        throw new Error("WALLET_ENCRYPTION_KEY is not set");
    }
    if (!process.env.SECRET_KEY) {
        throw new Error("SECRET_KEY is not set (needed to read the current wallet keys)");
    }
    if (process.env.WALLET_ENCRYPTION_KEY === process.env.SECRET_KEY) {
        throw new Error("WALLET_ENCRYPTION_KEY must be different from SECRET_KEY");
    }
    console.log(APPLY ? "Mode: APPLY (writing changes)" : "Mode: DRY RUN (no changes). Re-run with --apply to write.");
    await clientDB.openUri(process.env.DB_URL);
    await dashboardDB.openUri(process.env.DASH_DB_URL);
    try {
        const client = await migrateCollection("client wallets", clientBlockchainWalletModel);
        const dashboard = await migrateCollection("dashboard wallets", dashboardBlockchainWalletModel);
        if (client.failed || dashboard.failed) {
            process.exitCode = 2;
        }
    } finally {
        await clientDB.close();
        await dashboardDB.close();
    }
}

main().catch((err) => {
    console.error(`[migrate-wallet-encryption-key] failed: ${err?.message || err}`);
    process.exit(1);
});
