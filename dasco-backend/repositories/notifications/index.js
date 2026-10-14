// Import User + Notification Model Object

const { userModel, notificationModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { clientDB } = require("../../database/connections");

// Define Register Token Function

async function registerToken(userId, token, language, dbSession = null, platform = "") {
    let internalSession = false;
    try {
        const user = await userModel.findById(userId);
        if (!user) {
            return {
                msg: getSuitableTranslations("Sorry, Can't Register New Token Because This User Is Not Exist !!", language),
                error: true,
                code: "PERMISSION_DENIED",
                data: {},
            }
        }
        if (user.status === "blocked") {
            return {
                msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                error: true,
                code: "PERMISSION_DENIED",
                data: {},
            }
        }
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const normalizedPlatform = String(platform || "").trim().toLowerCase().slice(0, 20);
        await userModel.updateOne(
            { _id: userId },
            { notificationsToken: token, ...(normalizedPlatform && { notificationsPlatform: normalizedPlatform }) },
            { session: dbSession },
        );
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Register New Token Process Has Been Successfuly !!", language),
            error: false,
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function saveNotifcation(userId, title, body, data, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findById(userId);
        if (user) {
            const notificationInstance = new notificationModel({ userId, title, body, data });
            if (!dbSession) {
                dbSession = await clientDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            const notification = await notificationInstance.save({ session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Save New Notification Process Has Been Successfuly !!", language),
                error: false,
                data: notification,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function getAllNotificationsInsideThePage(userId, pageNumber, pageSize, filters, language) {
    try {
        const user = await userModel.findById(userId);
        if (user) {
            // Blocked users must still be able to read their notifications -
            // the "your account was blocked (reason)" notice lives here.
            filters.userId = userId;
            return {
                msg: getSuitableTranslations("Get All Notifications Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                error: false,
                data: {
                    notifications: await notificationModel.find(filters).sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize),
                    notificationsCount: await notificationModel.countDocuments(filters),
                    unreadNotificationsCount: await notificationModel.countDocuments({ ...filters, isRead: false }),
                },
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function markAllRead(userId, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findById(userId);
        if (!user) {
            return {
                msg: getSuitableTranslations("Sorry, Can't Mark All Notifications As Read Because This User Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        await notificationModel.updateMany({ userId, isRead: false }, { $set: { isRead: true } }, { session: dbSession });
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Mark All Notifications As Read For This User Process Has Been Successfully !!", language),
            error: false,
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function markNotificationPushFailed(notificationId, errorMessage) {
    await notificationModel.updateOne(
        { _id: notificationId },
        { $set: { pushDeliveryFailed: true, pushDeliveryError: String(errorMessage || "").slice(0, 500) } }
    );
}

module.exports = {
    registerToken,
    saveNotifcation,
    markAllRead,
    getAllNotificationsInsideThePage,
    markNotificationPushFailed,
}