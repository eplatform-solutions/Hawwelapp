// Import Reqquired Models

const { cronLockModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

async function activeLock(name, language) {
    try {
        const now = new Date();
        const lock = await cronLockModel.findOneAndUpdate(
            {
                name,
                $or: [
                    { locked: false },
                    { lockExpiresAt: { $lt: now } }
                ]
            },
            {
                locked: true,
                lockedAt: now,
                lockExpiresAt: new Date(now.getTime() + 60 * 1000)
            },
            {
                new: true,
                upsert: true,
            }
        );
        if (lock) {
            return {
                msg: getSuitableTranslations("Active Lock Process Has Been Successfully !!", language),
                error: false,
                data: lock
            }
        }
        return {
            msg: getSuitableTranslations("Lock For This Name Is Already Activated !!", language),
            error: true,
            data: lock
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function unlock(name, language) {
    try {
        const lock = await cronLockModel.findOneAndUpdate(
            { name },
            {
                locked: false,
                lockExpiresAt: null
            }
        );
        if (lock) {
            return {
                msg: getSuitableTranslations("UnLock For This Cron Job Name Process Has Been Successfully !!", language),
                error: false,
                data: lock
            }
        }
        return {
            msg: getSuitableTranslations("Already Unlock For This Cron Job Name !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    activeLock,
    unlock
}