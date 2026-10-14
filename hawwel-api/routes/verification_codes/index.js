const verificationCodesRouter = require("express").Router();

const verificationCodesController = require("../../controllers/verification_codes");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    rateLimitsMiddlewares,
    authMiddlewares,
} = require("../../middlewares");

const {
    otpRateLimitersMiddlewares
} = rateLimitsMiddlewares;

const {
    sendOtpRateLimitMiddleware,
    verifyOtpRateLimitMiddleware
} = otpRateLimitersMiddlewares;

const {
    validateEmail,
    validateMobilePhone,
    validateCode,
    validateTypeOfUseForCode,
    validateChannel,
} = authMiddlewares;

verificationCodesRouter.post("/send",
    sendOtpRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: !bodyData?.mobilePhone },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: !bodyData?.email },
            { fieldName: "Channel", fieldValue: bodyData?.channel, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Type Of Use", fieldValue: bodyData?.typeOfUse, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => {
        const bodyData = req.body;
        if (bodyData?.email && bodyData?.mobilePhone) {
            return res.status(400).json({
                msg: "Sorry, Can't Send Code To The Email And Mobile Phone In Same Time, Please Send At Most !!",
                error: true,
                data: {},
            });
        }
        next();
    },
    (req, res, next) => {
        const email = req.body?.email;
        if (email) {
            return validateEmail(email, res, next);
        }
        next();
    },
    (req, res, next) => {
        const mobilePhone = req.body?.mobilePhone;
        if (mobilePhone) {
            return validateMobilePhone(mobilePhone, undefined, res, next);
        }
        next();
    },
    (req, res, next) => {
        const bodyData = req.body;
        if (bodyData?.mobilePhone && bodyData?.channel) {
            return validateChannel(bodyData.channel, res, next);
        }
        next();
    },
    (req, res, next) => validateTypeOfUseForCode(req.body.typeOfUse, res, next),
    verificationCodesController.postSendVerificationCode
);

verificationCodesRouter.post("/verify",
    verifyOtpRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Code", fieldValue: bodyData?.code, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Session", fieldValue: bodyData?.session, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => validateCode(req.body.code, res, next),
    verificationCodesController.postVerify
);

module.exports = verificationCodesRouter;