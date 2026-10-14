const CRON_JOB_NAMES = [
    "expireTransfers",
    "cleanupTatumSubscriptions",
];

const MAX_RETRIES = 5;

const BATCH_SIZE = 50;

module.exports = {
    CRON_JOB_NAMES,
    MAX_RETRIES,
    BATCH_SIZE
};