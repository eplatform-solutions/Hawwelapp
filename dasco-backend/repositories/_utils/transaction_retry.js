function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

function createAbortWithResultError(result) {
    const err = new Error("TRANSACTION_ABORT_WITH_RESULT");
    err.abortWithResult = result;
    return err;
}

function isRetryableTransactionError(error) {
    const message = String(error?.message || "");
    const labels = Array.isArray(error?.errorLabels) ? error.errorLabels : [];
    if (error?.code === 112) return true;
    if (labels.includes("TransientTransactionError")) return true;
    if (labels.includes("UnknownTransactionCommitResult")) return true;
    if (message.includes("WriteConflict")) return true;
    if (message.includes("Write conflict during plan execution")) return true;
    return false;
}

async function runInTransactionWithRetry(connection, work, options = {}) {
    const maxRetries = Number(options.maxRetries ?? 3);
    const baseDelayMs = Number(options.baseDelayMs ?? 120);

    for (let attempt = 0; attempt <= maxRetries; attempt += 1) {
        const session = await connection.startSession();
        try {
            session.startTransaction();
            const result = await work(session, attempt);
            await session.commitTransaction();
            return result;
        }
        catch (error) {
            try {
                if (session.inTransaction()) {
                    await session.abortTransaction();
                }
            }
            catch (_) {
                // Swallow abort errors to keep original failure/result semantics.
            }

            if (error?.abortWithResult) {
                return error.abortWithResult;
            }

            if (attempt < maxRetries && isRetryableTransactionError(error)) {
                await sleep(baseDelayMs * (2 ** attempt));
                continue;
            }

            throw error;
        }
        finally {
            await session.endSession();
        }
    }
}

module.exports = {
    createAbortWithResultError,
    isRetryableTransactionError,
    runInTransactionWithRetry
};
