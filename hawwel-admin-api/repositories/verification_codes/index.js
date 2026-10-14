// Import Required Models

const { verificationCodeModel, sessionModel, loginLogModel } = require("../../models/dashboard");

const { checkOrCreateSession, getSession } = require("../../repositories/sessions");

const { getSuitableTranslations } = require("../../helpers/translation");

const { checkResendCooldown, refreshAttemptWindow, applyAttemptLock, checkLock, checkExpiration } = require("../../helpers/verification_codes");

// Import module to generate verification codes
const CodeGenerator = require("node-code-generator");

const { CODE_LENGTH, CODE_EXPIRY_MINUTES } = require("../../constants/verification_code");

const { hashSync, compareSync } = require("bcryptjs");

const { dashboardDB } = require("../../database/connections");

async function checkOrCreateVerificationCode(email, mobilePhone, typeOfUse, language, dbSession = null) {
    let internalSession = false;
    try {
        const session = (await checkOrCreateSession(email, mobilePhone, typeOfUse, language)).data;
        const generator = new CodeGenerator();
        const generatedCode = generator.generateCodes("#".repeat(CODE_LENGTH))[0];
        const expiresAt = new Date(Date.now() + CODE_EXPIRY_MINUTES * 60 * 1000);
        let verificationCode = null;
        verificationCode = await verificationCodeModel.findOne({ session: session._id });
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        if (!verificationCode) {
            let user = {};
            if (typeOfUse === "login") {
                const { getAdminInfo } = require("../../repositories/admins");
                user = (await getAdminInfo(email ? { email } : { mobilePhone }, language)).data;
            }
            const verificationCodeInstance = new verificationCodeModel({
                session: session._id,
                code: hashSync(generatedCode, 10),
                expiresAt,
                ...email && { email },
                ...mobilePhone && { mobilePhone },
                typeOfUse,
                ...user?._id && { user: user._id }
            });
            verificationCode = await verificationCodeInstance.save({ session: dbSession });
        } else {
            const checkResendCooldownResult = checkResendCooldown(verificationCode.lastSentAt);
            if (checkResendCooldownResult.error) {
                checkResendCooldownResult.msg = getSuitableTranslations(checkResendCooldownResult.msg);
                return checkResendCooldownResult;
            }
            verificationCode.code = hashSync(generatedCode, 10);
            verificationCode.expiresAt = expiresAt;
            verificationCode.sentCount += 1;
            verificationCode.lastSentAt = Date.now();
            await verificationCode.save({ session: dbSession });
        }
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Creating New Verification Code Process Has Been Successfully !!", language),
            error: false,
            data: {
                session: verificationCode.session,
                code: generatedCode,
                lastSentAt: verificationCode.lastSentAt,
                expiresAt: verificationCode.expiresAt,
                sentCount: verificationCode.sentCount,
                ...verificationCode.user && { user: verificationCode.user }
            }
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

async function getVerificationCode(sessionId, language) {
    try {
        const verificationCode = await verificationCodeModel.findOne({ session: sessionId }, { __v: false });
        if (verificationCode) {
            return {
                msg: getSuitableTranslations("Get Verification Code Process Has Been Successfully !!", language),
                error: false,
                data: verificationCode
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Verification Code Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function checkCode(sessionId, code, id, language) {
    try {
        const sessionResult = await getSession(sessionId, language);
        if (!sessionResult.error) {
            const verificationCodeResult = await getVerificationCode(sessionId, language);
            if (!verificationCodeResult.error) {
                if (verificationCodeResult.data.typeOfUse === sessionResult.data.typeOfUse) {
                    if (compareSync(code, verificationCodeResult.data.code)) {
                        return {
                            msg: getSuitableTranslations("Checking Code Process Has Been Succesfully !!", language),
                            error: false,
                            data: verificationCodeResult.data
                        }
                    }
                    console.log(getSuitableTranslations(`Sorry, This Code For This ${id ?? (verificationCodeResult.data.email ? "Email" : "Mobile Phone")} Is Not Valid !!`, language));
                    return {
                        msg: getSuitableTranslations(`Sorry, This Code For This ${id ?? (verificationCodeResult.data.email ? "Email" : "Mobile Phone")} Is Not Valid !!`, language),
                        error: true,
                        code: "IVALID_CODE",
                        data: verificationCodeResult.data,
                    }
                }
                return {
                    msg: getSuitableTranslations("Sorry, Type Of Use Verification Code Is Not Valid !!", language),
                    error: true,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations(`Sorry, This Verification Code For This ${id ?? (verificationCodeResult.data.email ? "Email" : "Mobile Phone")} Is Not Exist !!`, language),
                error: true,
                data: {}
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Session Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function verifyCode(sessionId, code, id, ipAddress, language, dbSession = null) {
    let internalSession = false;
    try {
        const checkCodeResult = await checkCode(sessionId, code, id, language);
        if (!checkCodeResult.error) {
            const checkLockResult = checkLock(checkCodeResult.data.blockedUntil);
            if (checkLockResult.error) {
                checkLockResult.msg = getSuitableTranslations(checkLockResult.msg, language);
                return checkLockResult;
            }
            const checkExpirationResult = checkExpiration(checkCodeResult.data.expiresAt);
            if (checkExpirationResult.error) {
                checkExpirationResult.msg = getSuitableTranslations(checkExpirationResult.msg, language);
                return checkExpirationResult;
            }
            checkCodeResult.data._doc.verified = true;
            checkCodeResult.data._doc.verifiedAt = new Date();
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await sessionModel.deleteOne({ _id: checkCodeResult.data.session }, { session: dbSession });
            await checkCodeResult.data.deleteOne({ session: dbSession });
            if (checkCodeResult.data.typeOfUse === "login") {
                const newLoginLogInstance = new loginLogModel({
                    user: checkCodeResult.data.user,
                    ipAddress: ipAddress === "::1" ? "192.168.1.1" : ipAddress
                });
                await newLoginLogInstance.save({ session: dbSession });
            }
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Verify Code Process Has Been Succesfully !!", language),
                error: false,
                data: checkCodeResult.data,
            }
        }
        if (checkCodeResult.code === "IVALID_CODE") {
            delete checkCodeResult.code;
            const checkLockResult = checkLock(checkCodeResult.data.blockedUntil);
            if (checkLockResult.error) {
                checkLockResult.msg = getSuitableTranslations(checkLockResult.msg, language);
                return checkLockResult;
            }
            const attemptWindowDataResult = refreshAttemptWindow(checkCodeResult.data.attemptWindowStartedAt, checkCodeResult.data.attemptsCount);
            checkCodeResult.data.attemptWindowStartedAt = attemptWindowDataResult.attemptWindowStartedAt;
            checkCodeResult.data.attemptsCount = attemptWindowDataResult.attemptsCount;
            checkCodeResult.data.attemptsCount += 1;
            checkCodeResult.data.lastAttemptAt = attemptWindowDataResult.lastAttemptAt;
            const applyAttemptLockResult = applyAttemptLock(checkCodeResult.data.attemptsCount);
            if (applyAttemptLockResult) {
                checkCodeResult.data.lockLevel = applyAttemptLockResult.lockLevel;
                checkCodeResult.data.blockedUntil = applyAttemptLockResult.blockedUntil;
                checkCodeResult.data.attemptsCount = 0;
            }
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await checkCodeResult.data.save({ session: dbSession });
            checkCodeResult.data.code = code;
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
        }
        return checkCodeResult;
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
    checkOrCreateVerificationCode,
    getVerificationCode,
    checkCode,
    verifyCode,
}