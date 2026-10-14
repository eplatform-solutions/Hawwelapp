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
} = emailsHelpers;

const {
    sendVerificationCodeToUserMobilePhone,
} = mobilePhonesHelpers;

const { getSuitableTranslations } = translationHelpers;

const verificationCodeOPerationsManagmentFunctions = require("../../repositories/verification_codes");

const { ACCESS_TOKEN_EXPIRE } = require("../../constants/tokens");

const { sign } = require("jsonwebtoken");

async function postSendVerificationCode(req, res) {
    try {
        const { email, mobilePhone, channel, typeOfUse } = req.body;
        const { language } = req.query;
        const result = await verificationCodeOPerationsManagmentFunctions.checkOrCreateVerificationCode(email, mobilePhone, typeOfUse, language);
        if (!result.error) {
            const code = result.data.code;
            delete result.data.code;
            res.json(result);
            if (email) {
                try {
                    return await sendVerificationCodeToUserEmail(email, code, language);
                }
                catch (err) {
                    logSmtpSendError("postSendVerificationCode:email", email, err);
                }
            }
            if (mobilePhone) {
                try {
                    return await sendVerificationCodeToUserMobilePhone(mobilePhone, code, channel, language);
                }
                catch (err) {
                    logSmsProviderError("postSendVerificationCode:sms", err);
                }
            }
        }
        else res.json(result);
    }
    catch (err) {
        logControllerError("postSendVerificationCode", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function postVerify(req, res) {
    try {
        const { session, code } = req.body;
        const { language } = req.query;
        const result = await verificationCodeOPerationsManagmentFunctions.verifyCode(session, code, undefined, req.ip, language);
        if (!result.error) {
            if (result.data.typeOfUse === "login") {
                return res.json({
                    msg: result.msg,
                    error: result.error,
                    data: {
                        ...result.data._doc,
                        token: sign({
                            _id: result.data._doc.user,
                        }, process.env.JWT_SECRET_KEY, {
                            expiresIn: ACCESS_TOKEN_EXPIRE,
                        }),
                    },
                });
            }
        }
        res.json(result);
    }
    catch (err) {
        logControllerError("postVerify", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postSendVerificationCode,
    postVerify,
}