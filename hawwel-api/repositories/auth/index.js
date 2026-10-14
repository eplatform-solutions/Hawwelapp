// Import Reuired Models

const { userModel, sessionModel, counterModel } = require("../../models/client");

// require bcryptjs module for password encrypting

const { hash, compare } = require("bcryptjs");

// Define Create New User Function

const { getSuitableTranslations } = require("../../helpers/translation");

const { isSmsExemptPhone } = require("../../helpers/mobilePhones");

const { checkOrCreateVerificationCode, verifyCode, checkCodeIsVerified } = require("../verification_codes");

const { clientDB } = require("../../database/connections");
const { createAbortWithResultError, runInTransactionWithRetry } = require("../_utils/transaction_retry");

async function getNextAccountNumber(dbSession) {
    const counter = await counterModel.findOneAndUpdate(
        { name: "accountNumber" },
        [
            {
                $set: {
                    seq: {
                        $cond: [
                            { $ifNull: ["$seq", false] },
                            { $add: ["$seq", 1] },
                            100000
                        ]
                    }
                }
            }
        ],
        { new: true, upsert: true, session: dbSession }
    );
    return counter.seq;
}

function abortOrReturn(result, abortOnError) {
    if (abortOnError) {
        throw createAbortWithResultError(result);
    }
    return result;
}

async function createNewUserCore(data, language, dbSession, abortOnError) {
    const emailNorm = data.user.email && String(data.user.email).trim()
        ? data.user.email.trim().toLowerCase()
        : null;
    const orConditions = [{ mobilePhone: data.user.mobilePhone }];
    if (emailNorm) {
        orConditions.push({ email: emailNorm });
    }
    const user = await userModel.findOne({ $or: orConditions }).session(dbSession);
    if (user) {
        return abortOrReturn({
            msg: getSuitableTranslations("Sorry, Can't Create New User Because It Is Already Exist !!", language),
            error: true,
            data: {},
        }, abortOnError);
    }
    if (emailNorm) {
        if (!data.codes?.forEmail?.session || !data.codes?.forEmail?.code) {
            return abortOrReturn({
                msg: getSuitableTranslations("Sorry, Please Send Valid Email Verification Data !!", language),
                error: true,
                data: {},
            }, abortOnError);
        }
        const verifyCodeForEmailResult = await verifyCode(data.codes.forEmail.session, data.codes.forEmail.code, "Email", language, dbSession);
        if (verifyCodeForEmailResult.error) {
            return abortOrReturn(verifyCodeForEmailResult, abortOnError);
        }
    }
    const verifyCodeForMobilePhoneResult = await verifyCode(data.codes.forMobilePhone.session, data.codes.forMobilePhone.code, "Mobile Phone", language, dbSession);
    if (verifyCodeForMobilePhoneResult.error) {
        return abortOrReturn(verifyCodeForMobilePhoneResult, abortOnError);
    }
    const newUserInstance = {
        name: data.user.name,
        nickname: data.user.nickname,
        fatherName: data.user.fatherName,
        country: data.user.country,
        mobilePhone: data.user.mobilePhone,
        password: await hash(data.user.password, 10),
        accountNumber: await getNextAccountNumber(dbSession),
    };
    if (emailNorm) {
        newUserInstance.email = emailNorm;
    }
    const newUser = await (new userModel(newUserInstance)).save({ session: dbSession });
    delete newUser.password;
    delete newUser.__v;
    return {
        msg: getSuitableTranslations("Creating New User Process Has Been Successfuly !!", language),
        error: false,
        data: {
            _id: newUser._id,
            accountNumber: newUser.accountNumber,

        },
    };
}

async function createNewUser(data, language, dbSession = null) {
    let internalSession = false;
    try {
        if (dbSession) {
            return await createNewUserCore(data, language, dbSession, false);
        }
        internalSession = true;
        return await runInTransactionWithRetry(
            clientDB,
            async (session) => createNewUserCore(data, language, session, true),
            { maxRetries: 4, baseDelayMs: 150 }
        );
    }
    catch (err) {
        if (err?.code === 11000) {
            return {
                msg: getSuitableTranslations("Sorry, Can't Create New User Because It Is Already Exist !!", language),
                error: true,
                data: {},
            };
        }
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

// Operational log only (the client always gets the same generic message):
// tells support whether a failed login was a wrong password or an
// identifier that matches no account. The identifier is masked.
function logLoginFailure(reason, identifier) {
    const value = String(identifier || "");
    const masked = value.length > 4 ? `${"*".repeat(value.length - 4)}${value.slice(-4)}` : "****";
    console.log(`[AUTH] login failed reason=${reason} identifier=${masked} length=${value.length}`);
}

async function login(email, mobilePhone, password, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findOne(email ? { email } : { mobilePhone });
        if (user) {
            // Mobile keyboards sometimes append a space after punctuation;
            // accept the trimmed form too so that never reads as "wrong
            // password".
            const trimmedPassword = String(password ?? "").trim();
            const passwordMatches = await compare(password, user.password)
                || (trimmedPassword !== password && await compare(trimmedPassword, user.password));
            if (passwordMatches) {
                if (user.status === "blocked") {
                    return {
                        msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                        error: true,
                        code: "PERMISSION_DENIED",
                        data: {},
                    }
                }
                // Staff numbers the SMS provider cannot reach log in without
                // the OTP step - otherwise 2FA enabled on such an account
                // locks it out permanently.
                if (user.twoFA.enabled && !isSmsExemptPhone(user.mobilePhone)) {
                    if (!dbSession) {
                        dbSession = await clientDB.startSession();
                        dbSession.startTransaction();
                        internalSession = true;
                    }
                    const checkOrCreateVerificationCodeResult = await checkOrCreateVerificationCode(email, mobilePhone, "login", language, dbSession);
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    if (!checkOrCreateVerificationCodeResult.error) {
                        checkOrCreateVerificationCodeResult.data.twoFA = user.twoFA;
                        // Stripped by the controller before responding - it only
                        // needs these to pick a delivery channel that matches an
                        // enabled 2FA method rather than whatever identifier the
                        // user happened to log in with.
                        checkOrCreateVerificationCodeResult.data.user = {
                            email: user.email || "",
                            mobilePhone: user.mobilePhone || "",
                        };
                        return {
                            msg: getSuitableTranslations("Sorry, Can't Login Now, Beacause You Activate 2FA !!", language),
                            error: true,
                            code: "2FA_NEEDED",
                            data: checkOrCreateVerificationCodeResult.data,
                        }
                    }
                    return checkOrCreateVerificationCodeResult;
                }
                return {
                    msg: getSuitableTranslations("Logining Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        _id: user._id,
                        isVerified: user.isVerified,
                        twoFA: user.twoFA,
                        email: user.email,
                    },
                }
            }
            logLoginFailure("bad_password", email || mobilePhone);
            return {
                msg: getSuitableTranslations("Sorry, Email Or Password Incorrect !!", language),
                error: true,
                data: {},
            }
        }
        logLoginFailure("user_not_found", email || mobilePhone);
        return {
            msg: getSuitableTranslations("Sorry, Email Or Password Incorrect !!", language),
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

async function forgetPassword(email, mobilePhone, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findOne(email ? { email } : { mobilePhone });
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
            const verificationResult = await checkOrCreateVerificationCode(email, mobilePhone, "reset-password", language, dbSession);
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            // A resend-cooldown rejection used to be unwrapped as if it were
            // a success, handing the client a response with no session and
            // an undefined code - and an SMS reading "your code is undefined".
            if (verificationResult.error) {
                return verificationResult;
            }
            return {
                msg: getSuitableTranslations("Forget Password Process Has Been Successfully !!", language),
                error: false,
                data: verificationResult.data,
            };
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

async function resetUserPassword(session, code, newPassword, language, dbSession = null) {
    let internalSession = false;
    try {
        const checkCodeIsVerifiedResult = await checkCodeIsVerified(session, code, language);
        if (!checkCodeIsVerifiedResult.error) {
            const user = await userModel.findOne(
                checkCodeIsVerifiedResult.data?.email ?
                    { email: checkCodeIsVerifiedResult.data.email } :
                    { mobilePhone: checkCodeIsVerifiedResult.data?.mobilePhone },
            );
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            user.password = await hash(newPassword, 10);
            if (!dbSession) {
                dbSession = await clientDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await user.save({ session: dbSession });
            await checkCodeIsVerifiedResult.data.deleteOne().session(dbSession);
            await sessionModel.deleteOne({ _id: session }, { session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            if (user) {
                return {
                    msg: getSuitableTranslations("Reseting Password Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        email: user.email,
                        name: user.name,
                        updatedAt: user.updatedAt
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return checkCodeIsVerifiedResult;
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
    createNewUser,
    login,
    forgetPassword,
    resetUserPassword,
}