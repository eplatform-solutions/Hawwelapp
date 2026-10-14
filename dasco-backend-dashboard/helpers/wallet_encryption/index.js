const { AES, enc } = require("crypto-js");

// Wallet private keys are encrypted with their own key (WALLET_ENCRYPTION_KEY) so SECRET_KEY,
// which also signs tokens, can be rotated without losing access to any wallet.
// Keys still encrypted with SECRET_KEY are read as a fallback until
// scripts/migrate-wallet-encryption-key.js has re-encrypted them.

const PRIVATE_KEY_PATTERN = /^(0x)?[0-9a-fA-F]{64}$/;

function getWalletEncryptionKey() {
    const key = process.env.WALLET_ENCRYPTION_KEY;
    if (!key) {
        throw new Error("WALLET_ENCRYPTION_KEY is not configured");
    }
    return key;
}

function encryptWalletPrivateKey(privateKey) {
    return AES.encrypt(privateKey, getWalletEncryptionKey()).toString();
}

function tryDecrypt(encryptedPrivateKey, key) {
    if (!encryptedPrivateKey || !key) return "";
    try {
        const privateKey = AES.decrypt(encryptedPrivateKey, key).toString(enc.Utf8);
        return PRIVATE_KEY_PATTERN.test(privateKey) ? privateKey : "";
    } catch {
        return "";
    }
}

function decryptWalletPrivateKey(encryptedPrivateKey) {
    return tryDecrypt(encryptedPrivateKey, process.env.WALLET_ENCRYPTION_KEY)
        || tryDecrypt(encryptedPrivateKey, process.env.SECRET_KEY);
}

function isEncryptedWithWalletKey(encryptedPrivateKey) {
    return tryDecrypt(encryptedPrivateKey, process.env.WALLET_ENCRYPTION_KEY) !== "";
}

module.exports = {
    encryptWalletPrivateKey,
    decryptWalletPrivateKey,
    isEncryptedWithWalletKey,
    tryDecrypt,
};
