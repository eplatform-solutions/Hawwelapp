// Import Required Models Object

const { userModel, notificationModel } = require("../../models/client");

const { adminModel, countryModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { sendNotification } = require("../../helpers/notifications");

const { buildCustomerStatusPushText } = require("../../helpers/notifications/customer_status_text");

const { clientDB } = require("../../database/connections");

// Push/in-app copy for account block/unblock, matching the exact convention
// used for transfer and KYC status notifications (title/body are translation
// keys looked up client-side by dasco-mobile-new's AppTranslations).
const USER_STATUS_NOTIFICATIONS = {
    "blocked": {
        title: "Account Blocked",
        body: "notification_account_blocked",
    },
    "active": {
        title: "Account Unblocked",
        body: "notification_account_unblocked",
    },
};

async function notifyCustomerOfUserStatusChange(user, extraData = {}) {
    const notice = USER_STATUS_NOTIFICATIONS[user.status];
    if (!notice) return;
    try {
        const data = {
            status: String(user.status || ""),
            ...extraData,
        };
        const savedNotification = await new notificationModel({
            userId: user._id,
            title: notice.title,
            body: notice.body,
            data,
        }).save();

        if (user.notificationsToken) {
            try {
                const pushText = buildCustomerStatusPushText("user", user.status, data);
                await sendNotification({
                    title: pushText?.title || notice.title,
                    body: pushText?.body || notice.body,
                    data,
                    token: user.notificationsToken,
                });
            }
            catch (pushErr) {
                savedNotification.pushDeliveryFailed = true;
                savedNotification.pushDeliveryError = String(pushErr?.message || pushErr).slice(0, 500);
                await savedNotification.save();
            }
        }
    }
    catch (err) {
        console.log("Send User Status Notification Failed:", err);
    }
}

async function getUserInfo(adminId, userId, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "users_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const user = await userModel.findById(userId, { __v: false, password: false }).populate("kyc");
            if (user) {
                return {
                    msg: getSuitableTranslations("Get User Info Process Has Been Successfully !!", language),
                    error: false,
                    data: user,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getUsersCount(adminId, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "users_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            return {
                msg: getSuitableTranslations("Get Users Count Process Has Been Successfully !!", language),
                error: false,
                data: await userModel.countDocuments(filters),
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getAllUsersInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "users_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (filters.fromDate && filters.toDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.fromDate;
                delete filters.toDate;
            } else if (filters.fromDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate) };
                delete filters.fromDate;
            } else if (filters.toDate) {
                filters.createdAt = { $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.toDate;
            }
            const users = await userModel.find(filters, { __v: false, password: false }).sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize);
            if (users.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Users Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        users: users,
                        usersCount: await userModel.countDocuments(filters),
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Users Were Found !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function updateUserInfo(adminId, userId, newUserData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "users_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const userInfo = await userModel.findById(userId);
            if (userInfo) {
                if (newUserData?.email && newUserData?.mobilePhone) {
                    const existUser = await userModel.findOne({ $or: [{ email: newUserData.email }, { mobilePhone: newUserData.mobilePhone }] });
                    if (existUser) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Email Or Mobile Phone Is Already Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    userInfo.email = newUserData.email;
                    userInfo.mobilePhone = newUserData.mobilePhone;
                }
                else if (newUserData?.email) {
                    const existUser = await userModel.findOne({ email: newUserData.email });
                    if (existUser) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Email Is Already Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    userInfo.email = newUserData.email;
                }
                else if (newUserData?.mobilePhone) {
                    const existUser = await userModel.findOne({ mobilePhone: newUserData.mobilePhone });
                    if (existUser) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Mobile Phone Is Already Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    userInfo.mobilePhone = newUserData.mobilePhone;
                }
                if (newUserData?.country) {
                    const existCountry = await countryModel.findOne({ code: newUserData.country });
                    if (!existCountry) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Country Is Not Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    userInfo.country = newUserData.country;
                }
                let statusChanged = false;
                if (newUserData?.status) {
                    const status = newUserData?.status;
                    if (status !== userInfo.status) {
                        statusChanged = true;
                    }
                    if (status === "blocked") {
                        userInfo.blockingDate = Date.now();
                        userInfo.blockingReason = newUserData.blockingReason;
                    }
                    userInfo.status = status;
                }
                const name = newUserData?.name;
                if (name) {
                    userInfo.name = name;
                }
                const nickname = newUserData?.nickname;
                if (nickname) {
                    userInfo.nickname = nickname;
                }
                const fatherName = newUserData?.fatherName;
                if (fatherName) {
                    userInfo.fatherName = fatherName;
                }
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await userInfo.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                if (statusChanged) {
                    await notifyCustomerOfUserStatusChange(
                        userInfo,
                        userInfo.status === "blocked" ? { blockingReason: String(userInfo.blockingReason || "") } : {}
                    );
                }
                return {
                    msg: getSuitableTranslations("Updating User Info Process Has Been Successfuly !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
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

async function deleteUser(adminId, userId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "users_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (!dbSession) {
                dbSession = await clientDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            const user = await userModel.findByIdAndDelete(userId, { session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            if (user) {
                return {
                    msg: getSuitableTranslations("Deleting User Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
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

module.exports = {
    getUserInfo,
    getUsersCount,
    getAllUsersInsideThePage,
    updateUserInfo,
    deleteUser
}