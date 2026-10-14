function errorMessage(err) {
    if (!err) {
        return "unknown error";
    }
    if (typeof err === "string") {
        return err;
    }
    return err.message || "unknown error";
}

function logBlockchainOps(message, meta = {}) {
    const safe = {};
    if (meta.transferId !== undefined) {
        safe.transferId = String(meta.transferId);
    }
    if (meta.walletId !== undefined) {
        safe.walletId = String(meta.walletId);
    }
    if (meta.userId !== undefined) {
        safe.userId = String(meta.userId);
    }
    if (meta.step !== undefined) {
        safe.step = meta.step;
    }
    if (meta.reason !== undefined) {
        safe.reason = meta.reason;
    }
    console.error(`[blockchain-ops] ${message}`, safe);
}

module.exports = {
    errorMessage,
    logBlockchainOps,
};
