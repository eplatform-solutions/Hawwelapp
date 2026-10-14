// Import Required Models

const { userModel, receiverModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { clientDB } = require("../../database/connections");

async function addReceiver(userId, fullName, mobilePhone, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findById(userId);
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const receiver = await receiverModel.findOne({ userId, fullName, mobilePhone });
            if (!receiver) {
                const receiverInstance = new receiverModel({ userId, fullName, mobilePhone });
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await receiverInstance.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Add New Receiver Process Has Been Successfully !!", language),
                    error: true,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Receiver Is Already Exist For This User !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
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

async function getAllReceivers(userId, filters, language) {
    try {
        const user = await userModel.findById(userId);
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            filters.userId = userId;
            return {
                msg: getSuitableTranslations("Get All Receivers For This User Process Has Been Successfully !!", language),
                error: false,
                data: await receiverModel.find(filters).sort({ createdAt: -1 }),
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

async function updateReceiverInfo(userId, receiverId, newReceiverData, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findById(userId);
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const receiverInfo = await receiverModel.findById(receiverId);
            if (receiverInfo) {
                if (newReceiverData.fullName && newReceiverData.mobilePhone) {
                    const receiver = await receiverModel.findOne({ userId, fullName: newReceiverData.fullName, mobilePhone: newReceiverData.mobilePhone });
                    if (receiver) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Receiver Is Already Exist For This User !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    receiverInfo.fullName = newReceiverData.fullName;
                    receiverInfo.mobilePhone = newReceiverData.mobilePhone;
                }
                else if (newReceiverData.mobilePhone) {
                    const receiver = await receiverModel.findOne({ userId, mobilePhone: newReceiverData.mobilePhone });
                    if (receiver) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Receiver Is Already Exist For This User !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    receiverInfo.mobilePhone = newReceiverData.mobilePhone;
                }
                else {
                    receiverInfo.fullName = newReceiverData.fullName;
                }
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await receiverInfo.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Updating Receiver Data Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Receiver Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
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

async function deleteReceiver(userId, receiverId, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findById(userId);
        if (user) {
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
            const receiver = await receiverModel.findByIdAndDelete(receiverId, { session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            if (receiver) {
                return {
                    msg: getSuitableTranslations("Deleting Receiver Data Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Receiver Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
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
    addReceiver,
    getAllReceivers,
    updateReceiverInfo,
    deleteReceiver
}