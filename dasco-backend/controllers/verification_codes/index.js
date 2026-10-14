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
    isSmsExemptPhone,
} = mobilePhonesHelpers;

const { getSuitableTranslations } = translationHelpers;

const verificationCodeOPerationsManagmentFunctions = require("../../repositories/verification_codes");

const { ACCESS_TOKEN_EXPIRE } = require("../../constants/tokens");

const { sign } = require("jsonwebtoken");

function getSigningSecret() {
    return process.env.JWT_SECRET_KEY || process.env.SECRET_KEY;
}

async function postSendVerificationCode(req, res) {
    try {
        const { email, mobilePhone, channel, typeOfUse } = req.body;
        const { language } = req.query;
        // Exempt staff numbers can never receive a code - say so before
        // creating one, instead of a generic "try again later".
        if (mobilePhone && isSmsExemptPhone(mobilePhone)) {
            return res.json(getResponseObject(getSuitableTranslations("Sorry, Verification Codes Can't Be Sent To This Phone Number, Please Contact Technical Support !!", language), true, {}));
        }
        const result = await verificationCodeOPerationsManagmentFunctions.checkOrCreateVerificationCode(email, mobilePhone, typeOfUse, language);
        if (!result.error) {
            const code = result.data.code;
            console.log("[OTP] Verification code send attempted");
            delete result.data.code;
            // Deliver BEFORE answering, same as forget-password/login: a
            // provider rejection (e.g. a destination Twilio does not serve)
            // must reach the client as an error, not a success followed by
            // an OTP screen that can never be satisfied.
            try {
                if (email) {
                    await sendVerificationCodeToUserEmail(email, code, language);
                }
                else if (mobilePhone) {
                    await sendVerificationCodeToUserMobilePhone(mobilePhone, code, channel, language);
                }
            }
            catch (err) {
                if (email) logSmtpSendError("postSendVerificationCode:email", email, err);
                else logSmsProviderError("postSendVerificationCode:sms", err);
                return res.json(getResponseObject(getSuitableTranslations("Sorry, We Could Not Send The Verification Code Right Now, Please Try Again Later !!", language), true, {}));
            }
            return res.json(result);
        }
        res.json(result);
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
        const result = await verificationCodeOPerationsManagmentFunctions.verifyCode(session, code, undefined, language);
        if (!result.error) {
            delete result.data._doc.code;
            if (result.data.typeOfUse === "login") {
                return res.json({
                    msg: result.msg,
                    error: result.error,
                    data: {
                        ...result.data._doc,
                        token: sign({
                            _id: result.data._doc.user,
                        }, getSigningSecret(), {
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