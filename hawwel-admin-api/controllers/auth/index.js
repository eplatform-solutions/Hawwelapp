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

const authOPerationsManagmentFunctions = require("../../repositories/auth");

async function postLogin(req, res) {
    try {
        const { email, mobilePhone, password } = req.body;
        const { language } = req.query;
        const result = await authOPerationsManagmentFunctions.login(email?.toLowerCase(), mobilePhone, password, language, req.ip);
        delete result.status;
        if (result.data?.token) {
            return res.json(result);
        }
        const code = result.data?.code;
        delete result.data?.code;
        delete result.data?.user;
        res.json(result);
        // Only a login that passed the password check and needs 2FA has a code. Without this
        // guard a wrong password still emailed an empty "code" to whatever address was typed.
        if (!code) {
            return;
        }
        if (email) {
            try {
                return await sendVerificationCodeToUserEmail(email, code, language);
            }
            catch (err) {
                logSmtpSendError("postLogin:email-verification-code", email, err);
                return;
            }
        }
        else if (mobilePhone) {
            try {
                return await sendVerificationCodeToUserMobilePhone(mobilePhone, code, "sms", language);
            }
            catch (err) {
                logSmsProviderError("postLogin:sms-verification-code", err);
                return;
            }
        }
    }
    catch (err) {
        logControllerError("postLogin", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postLogin,
}