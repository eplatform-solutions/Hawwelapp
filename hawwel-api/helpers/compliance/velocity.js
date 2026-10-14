const { transferModel } = require("../../models/client");

const {
    LIMIT_DAILY_AMOUNT,
    LIMIT_MONTHLY_AMOUNT,
    LIMIT_DAILY_COUNT,
    LIMIT_MONTHLY_DISTINCT_RECEIVERS,
    EDD_AMOUNT_THRESHOLD,
} = require("../../constants/compliance");

// Cumulative ("velocity") limits. The per-payment-method min/max already caps a
// single transfer; these caps are what stop the same amount being split across
// many small transfers, which is the pattern an AML reviewer looks for first.

// Transfers that never resulted in value moving do not consume a user's limit.
const NON_COUNTING_STATUSES = ["cancelled", "expired"];

function startOfTodayUtc() {
    const now = new Date();
    return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}

function startOfRolling30Days() {
    return new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
}

/**
 * Aggregate what the user has already sent. Amounts are in the transfer's
 * crypto symbol (USDT/USDC), which both track the US dollar closely enough
 * for limit purposes.
 */
async function getUserTransferUsage(userId) {
    const [daily, monthly] = await Promise.all([
        transferModel.aggregate([
            {
                $match: {
                    sender: userId,
                    status: { $nin: NON_COUNTING_STATUSES },
                    createdAt: { $gte: startOfTodayUtc() },
                },
            },
            { $group: { _id: null, total: { $sum: "$amount" }, count: { $sum: 1 } } },
        ]),
        transferModel.aggregate([
            {
                $match: {
                    sender: userId,
                    status: { $nin: NON_COUNTING_STATUSES },
                    createdAt: { $gte: startOfRolling30Days() },
                },
            },
            {
                $group: {
                    _id: null,
                    total: { $sum: "$amount" },
                    count: { $sum: 1 },
                    receivers: { $addToSet: "$receiver.mobilePhone" },
                },
            },
        ]),
    ]);

    const dailyRow = daily[0] || {};
    const monthlyRow = monthly[0] || {};

    return {
        dailyAmount: Number(dailyRow.total) || 0,
        dailyCount: Number(dailyRow.count) || 0,
        monthlyAmount: Number(monthlyRow.total) || 0,
        monthlyCount: Number(monthlyRow.count) || 0,
        monthlyReceivers: Array.isArray(monthlyRow.receivers) ? monthlyRow.receivers : [],
    };
}

/**
 * Check a proposed transfer against the cumulative limits.
 *
 * Returns { breached, breaches, usage, eddRequired } - the caller decides how
 * to surface it. `breaches` is a list of { limit, allowed, attempted } so the
 * alert record and the user-facing message can both be precise.
 */
async function checkVelocityLimits(userId, amount, receiverMobilePhone) {
    const usage = await getUserTransferUsage(userId);
    const breaches = [];

    const projectedDaily = usage.dailyAmount + amount;
    if (projectedDaily > LIMIT_DAILY_AMOUNT) {
        breaches.push({ limit: "daily-amount", allowed: LIMIT_DAILY_AMOUNT, attempted: projectedDaily });
    }

    const projectedMonthly = usage.monthlyAmount + amount;
    if (projectedMonthly > LIMIT_MONTHLY_AMOUNT) {
        breaches.push({ limit: "monthly-amount", allowed: LIMIT_MONTHLY_AMOUNT, attempted: projectedMonthly });
    }

    const projectedDailyCount = usage.dailyCount + 1;
    if (projectedDailyCount > LIMIT_DAILY_COUNT) {
        breaches.push({ limit: "daily-count", allowed: LIMIT_DAILY_COUNT, attempted: projectedDailyCount });
    }

    // A single sender fanning out to many different recipients is the classic
    // money-mule shape, so distinct recipients are capped separately.
    const distinctReceivers = new Set(usage.monthlyReceivers);
    if (receiverMobilePhone) {
        distinctReceivers.add(receiverMobilePhone);
    }
    if (distinctReceivers.size > LIMIT_MONTHLY_DISTINCT_RECEIVERS) {
        breaches.push({
            limit: "monthly-distinct-receivers",
            allowed: LIMIT_MONTHLY_DISTINCT_RECEIVERS,
            attempted: distinctReceivers.size,
        });
    }

    return {
        breached: breaches.length > 0,
        breaches,
        usage,
        // Does not block: it marks the transfer for source-of-funds follow-up.
        eddRequired: amount >= EDD_AMOUNT_THRESHOLD,
    };
}

module.exports = {
    checkVelocityLimits,
    getUserTransferUsage,
};
