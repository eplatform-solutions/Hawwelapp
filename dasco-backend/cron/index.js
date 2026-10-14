const cron = require("node-cron");

const { expireTransfersJob, cleanupTatumSubscriptionsJob, retryFailedWithdrawalsJob } = require("../helpers/cron-jobs");

const { activeLock, unlock } = require("../repositories/cron_lock");

cron.schedule("* * * * *", async () => {
    console.log("expire Transfers Job is started ...");
    const lockName = "expireTransfers";
    try {
        const activeLockResult = await activeLock(lockName, "en");
        if (activeLockResult.error) return;
        await expireTransfersJob();
    } catch (err) {
        console.log("error on execute expire transfers job: ", err.message, "=========================================================");
    } finally {
        await unlock(lockName, "en");
    }
});

cron.schedule("*/30 * * * * *", async () => {
    console.log("cleanup tatum subscriptions Job is started ...");
    const lockName = "cleanupTatumSubscriptions";
    try {
        const activeLockResult = await activeLock(lockName, "en");
        if (activeLockResult.error) return;
        await cleanupTatumSubscriptionsJob();
    } catch (err) {
        console.log("error on execute cleanup tatum subscriptions job: ", err.message, "=========================================================");
    } finally {
        await unlock(lockName, "en");
    }
});

cron.schedule("*/5 * * * *", async () => {
    console.log("retry failed withdrawals Job is started ...");
    const lockName = "retryFailedWithdrawals";
    try {
        const activeLockResult = await activeLock(lockName, "en");
        if (activeLockResult.error) return;
        await retryFailedWithdrawalsJob();
    } catch (err) {
        console.log("error on execute retry failed withdrawals job: ", err.message, "=========================================================");
    } finally {
        await unlock(lockName, "en");
    }
});

module.exports = cron;