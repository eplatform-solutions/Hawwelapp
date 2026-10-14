const {
    responsesHelpers,
    emailsHelpers,
    mobilePhonesHelpers,
    translationHelpers,
    deliveryLogHelpers,
} = require("../../helpers");

const { logSmtpSendError, logSmsProviderError, logControllerError } = deliveryLogHelpers;

const { getResponseObject } = responsesHelpers;

const {
    sendVerificationCodeToUserEmail,
    sendCongratulationsOnCreatingNewAccountEmail,
    sendChangePasswordEmail
} = emailsHelpers;

const {
    sendVerificationCodeToUserMobilePhone,
    isSmsExemptPhone,
} = mobilePhonesHelpers;

const { getSuitableTranslations } = translationHelpers;

const { ACCESS_TOKEN_EXPIRE } = require("../../constants/tokens");

const authOPerationsManagmentFunctions = require("../../repositories/auth");

const { parsePhoneNumberFromString } = require("libphonenumber-js");

const { sign } = require("jsonwebtoken");

function getSigningSecret() {
    return process.env.JWT_SECRET_KEY || process.env.SECRET_KEY;
}

async function postLogin(req, res) {
    try {
        const { email, mobilePhone, password } = req.body;
        const { language } = req.query;
        const result = await authOPerationsManagmentFunctions.login(email?.toLowerCase(), mobilePhone, password, language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            else if (result?.code == "2FA_NEEDED") {
                delete result.code;
                const code = result.data.code;
                delete result.data.code;
                const storedUser = result.data.user || {};
                delete result.data.user;
                const methods = result.data.twoFA?.methods || [];
                // Pick the channel from what the user actually enabled, using
                // their stored contact details - previously a phone login on an
                // email-only 2FA account (or vice versa) matched neither branch,
                // sent nothing, and still told the app a code was on its way.
                const targetPhone = mobilePhone || storedUser.mobilePhone;
                const targetEmail = email || storedUser.email;
                try {
                    if (methods.includes("mobile-phone") && targetPhone) {
                        await sendVerificationCodeToUserMobilePhone(targetPhone, code, "sms", language);
                    }
                    else if (methods.includes("email") && targetEmail) {
                        await sendVerificationCodeToUserEmail(targetEmail, code, language);
                    }
                    else {
                        return res.json(getResponseObject(getSuitableTranslations("Sorry, No Delivery Channel Is Available For Your Two-Factor Code, Please Contact Technical Support !!", language), true, {}));
                    }
                }
                catch (err) {
                    if (methods.includes("mobile-phone") && targetPhone) logSmsProviderError("postLogin:2fa:sms", err);
                    else logSmtpSendError("postLogin:2fa:email", targetEmail, err);
                    return res.json(getResponseObject(getSuitableTranslations("Sorry, We Could Not Send The Verification Code Right Now, Please Try Again Later !!", language), true, {}));
                }
                return res.json(result);
            }
            return res.json(result);
        }
        res.json({
            msg: result.msg,
            error: result.error,
            data: {
                ...result.data,
                token: sign({
                    _id: result.data._id,
                }, getSigningSecret(), {
                    expiresIn: ACCESS_TOKEN_EXPIRE,
                }),
            },
        });
    }
    catch (err) {
        logControllerError("postLogin", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function postCreateNewUser(req, res) {
    try {
        const { language } = req.query;
        const { name, nickname, fatherName, country, mobilePhone, email, password, emailCode, mobilePhoneCode, sessionForEmail, sessionForMobilePhone } = req.body;
        const mobilePhoneInE164 = parsePhoneNumberFromString(mobilePhone, country).format("E.164");
        const result = await authOPerationsManagmentFunctions.createNewUser({
            user: {
                name,
                nickname,
                fatherName,
                country,
                mobilePhone: mobilePhoneInE164,
                email,
                password,
            },
            codes: {
                forEmail: {
                    code: emailCode,
                    session: sessionForEmail
                },
                forMobilePhone: {
                    code: mobilePhoneCode,
                    session: sessionForMobilePhone
                }
            }
        }, language);
        if (result.error) {
            return res.json(result);
        }
        res.json({
            msg: result.msg,
            error: result.error,
            data: {
                user: result.data,
                token: sign({
                    _id: result.data._id,
                }, getSigningSecret(), {
                    expiresIn: ACCESS_TOKEN_EXPIRE,
                }),
            },
        });
        if (req.body.email) {
            try {
                await sendCongratulationsOnCreatingNewAccountEmail(req.body.email, language);
            }
            catch (err) {
                logSmtpSendError("postCreateNewUser:congratulations", req.body.email, err);
            }
        }
    }
    catch (err) {
        logControllerError("postCreateNewUser", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function postForgetPassword(req, res) {
    try {
        const { email, mobilePhone } = req.body;
        const { language } = req.query;
        // Exempt staff numbers can never receive a code - say so before
        // creating one, instead of a generic "try again later".
        if (mobilePhone && isSmsExemptPhone(mobilePhone)) {
            return res.json(getResponseObject(getSuitableTranslations("Sorry, Verification Codes Can't Be Sent To This Phone Number, Please Contact Technical Support To Reset Your Password !!", language), true, {}));
        }
        const result = await authOPerationsManagmentFunctions.forgetPassword(email, mobilePhone, language);
        if (!result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
            }
            const code = result.data.code;
            delete result.data.code;
            // Deliver BEFORE answering: the old order flushed a 200 and then
            // only console-logged a provider failure, so a user whose region
            // the SMS provider rejects saw a success screen and no code, ever.
            try {
                if (email) {
                    await sendVerificationCodeToUserEmail(email, code, language);
                }
                else if (mobilePhone) {
                    await sendVerificationCodeToUserMobilePhone(mobilePhone, code, "sms", language);
                }
            }
            catch (err) {
                if (email) logSmtpSendError("postForgetPassword:email", email, err);
                else logSmsProviderError("postForgetPassword:sms", err);
                return res.json(getResponseObject(getSuitableTranslations("Sorry, We Could Not Send The Verification Code Right Now, Please Try Again Later !!", language), true, {}));
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        logControllerError("postForgetPassword", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putResetPassword(req, res) {
    try {
        const { session, code, password } = req.body;
        const { language } = req.query;
        const result = await authOPerationsManagmentFunctions.resetUserPassword(session, code, password, language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
            }
            return res.json(result);
        }
        res.json(result);
        try {
            await sendChangePasswordEmail(result.data, language);
        }
        catch (err) {
            logSmtpSendError("putResetPassword:change-password-email", result.data?.email, err);
        }
    }
    catch (err) {
        logControllerError("putResetPassword", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postCreateNewUser,
    postLogin,
    postForgetPassword,
    putResetPassword,
}