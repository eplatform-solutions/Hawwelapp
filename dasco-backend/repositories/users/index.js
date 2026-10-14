// Import Required Models and Helpers

const { userModel, accountDeletionRequestModel } = require("../../models/client");

// Define Create New User Function

const { getSuitableTranslations } = require("../../helpers/translation");

const { normalizeKycStatus, getKycGateMessage } = require("../../helpers/kyc_status");

const { isSmsExemptPhone, isSmsUnsupportedPhone } = require("../../helpers/mobilePhones");

const { hash, compare } = require("bcryptjs");

const { verifyCode } = require("../verification_codes");

const { clientDB } = require("../../database/connections");

async function getUserInfo(filters, language) {
    try {
        const user = await userModel.findOne(filters).populate("kyc");
        if (user) {
            const userObj = user.toObject();
            delete userObj.password;
            delete userObj.__v;
            const kycStatus = normalizeKycStatus(userObj.kyc);
            userObj.kycStatus = kycStatus;
            userObj.kycRequiredForTransfers = true;
            userObj.kycRequiredMessage = getKycGateMessage(kycStatus);
            return {
                msg: getSuitableTranslations("Get User Info Process Has Been Successfully !!", language),
                error: false,
                data: userObj,
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

async function updateUserInfo(userId, data, language, dbSession = null) {
    let internalSession = false;
    try {
        const userInfo = await userModel.findById(userId);
        if (userInfo) {
            if (userInfo.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            let newUserInfo = data.user;
            if (!dbSession) {
                dbSession = await clientDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            const currentEmail = userInfo.email ? String(userInfo.email).toLowerCase() : "";
            const nextEmail = newUserInfo.email ? String(newUserInfo.email).toLowerCase() : "";
            if (nextEmail && nextEmail !== currentEmail) {
                const verifyCodeForEmailResult = await verifyCode(data.codes.forEmail.session, data.codes.forEmail.code, "Email", language, dbSession);
                if (verifyCodeForEmailResult.error) {
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    return verifyCodeForEmailResult;
                }
                const user = await userModel.findOne({ email: nextEmail });
                if (user) {
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    return {
                        msg: getSuitableTranslations("Sorry, This Email Is Already Exist !!", language),
                        error: true,
                        data: {},
                    }
                }
            }
            if (newUserInfo.mobilePhone && newUserInfo.mobilePhone !== userInfo.mobilePhone) {
                const verifyCodeForMobilePhoneResult = await verifyCode(data.codes.forMobilePhone.session, data.codes.forMobilePhone.code, "Mobile Phone", language, dbSession);
                if (verifyCodeForMobilePhoneResult.error) {
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    return verifyCodeForMobilePhoneResult;
                }
                const user = await userModel.findOne({ mobilePhone: newUserInfo.mobilePhone });
                if (user) {
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    return {
                        msg: getSuitableTranslations("Sorry, This Email Is Already Exist !!", language),
                        error: true,
                        data: {},
                    }
                }
            }
            await userModel.updateOne({ _id: userId }, newUserInfo, { session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Updating User Info Process Has Been Successfuly !!", language),
                error: false,
                data: newUserInfo,
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

async function changeProfileImage(authorizationId, newProfilePath, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findOne({ _id: authorizationId }, { imagePath: newProfilePath }, { session: dbSession });
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const oldImagePath = user.imagePath;
            user.imagePath = newProfilePath;
            if (!dbSession) {
                dbSession = await clientDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await user.save({ session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Changing User Image Process Has Been Successfully !!", language),
                error: false,
                data: { deletedProfileImagePath: oldImagePath }
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

async function changePassword(userId, password, newPassword, language, dbSession = null) {
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
            if (await compare(password, user.password)) {
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await userModel.updateOne({ _id: userId }, {
                    password: await hash(newPassword, 10)
                }, { session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Changing Password Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Password Uncorrect !!", language),
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

async function change2FAStatus(userId, enabled, methods, language, dbSession = null) {
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
            // Phone 2FA needs a deliverable SMS destination; for numbers the
            // provider rejects it would only lock the account out at the next
            // login, so refuse it up front with a clear message.
            const wantsPhoneMethod = enabled && Array.isArray(methods) && methods.includes("mobile-phone");
            if (wantsPhoneMethod && (isSmsUnsupportedPhone(user.mobilePhone) || isSmsExemptPhone(user.mobilePhone))) {
                return {
                    msg: getSuitableTranslations("Sorry, SMS Verification Is Not Available For Your Phone Number, So Two-Factor Authentication By Phone Can't Be Enabled !!", language),
                    error: true,
                    data: {},
                }
            }
            user.twoFA.enabled = enabled;
            if (enabled) {
                user.twoFA.methods = methods;
            }
            else {
                user.twoFA.methods = [];
            }
            if (!dbSession) {
                dbSession = await clientDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await user.save({ session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Changing 2FA Status Process Has Been Successfully !!", language),
                error: false,
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

async function createAccountDeletionRequest(userId, note, language) {
    try {
        const user = await userModel.findById(userId);
        if (!user) {
            return {
                msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
                error: true,
                code: "PERMISSION_DENIED",
                data: {},
            };
        }
        if (user.status === "blocked") {
            return {
                msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                error: true,
                code: "PERMISSION_DENIED",
                data: {},
            };
        }
        const existingPending = await accountDeletionRequestModel.findOne({
            userId,
            status: "pending",
        });
        if (existingPending) {
            return {
                msg: getSuitableTranslations("Your account deletion request is already pending.", language),
                error: false,
                data: {
                    requestStatus: "pending",
                    alreadyPending: true,
                },
            };
        }
        await accountDeletionRequestModel.create({
            userId,
            email: user.email || "",
            mobilePhone: user.mobilePhone || "",
            note: note ? String(note).trim() : "",
            status: "pending",
            source: "mobile_app",
        });
        return {
            msg: getSuitableTranslations("Your account deletion request has been received. Our team will review and process it according to our Privacy Policy and compliance requirements.", language),
            error: false,
            data: {
                requestStatus: "pending",
            },
        };
    } catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getUserInfo,
    updateUserInfo,
    changeProfileImage,
    changePassword,
    change2FAStatus,
    createAccountDeletionRequest,
}