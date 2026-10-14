const authRouter = require("express").Router();

const authController = require("../../controllers/auth");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    rateLimitsMiddlewares,
    authMiddlewares,
    commonMiddlewares,
} = require("../../middlewares");

const {
    authRateLimitersMiddlewares
} = rateLimitsMiddlewares;

const {
    signupRateLimitMiddleware,
    loginRateLimitMiddleware,
    forgotPasswordRateLimitMiddleware,
    resetPasswordRateLimitMiddleware
} = authRateLimitersMiddlewares;

const {
    validateMobilePhone,
    validateEmail,
    validatePassword,
    validateCode,
} = authMiddlewares;

const {
    validateName,
    validateCountry
} = commonMiddlewares;

authRouter.post("/sign-up",
    signupRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        const hasEmail = Boolean(bodyData?.email && String(bodyData.email).trim());
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Nickname", fieldValue: bodyData?.nickname, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Father Name", fieldValue: bodyData?.fatherName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Country", fieldValue: bodyData?.country, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Password", fieldValue: bodyData?.password, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Code For Email", fieldValue: bodyData?.emailCode, dataTypes: ["string"], isRequiredValue: hasEmail },
            { fieldName: "Code For Mobile Phone", fieldValue: bodyData?.mobilePhoneCode, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Session For Email", fieldValue: bodyData?.sessionForEmail, dataTypes: ["ObjectId"], isRequiredValue: hasEmail },
            { fieldName: "Session For Mobile Phone", fieldValue: bodyData?.sessionForMobilePhone, dataTypes: ["ObjectId"], isRequiredValue: true }
        ], res, next);
    },
    (req, res, next) => validateName(req.body.name, res, next),
    (req, res, next) => validateName(req.body.nickname, res, next),
    (req, res, next) => {
        const fatherName = req.body?.fatherName;
        if (fatherName) {
            return validateName(fatherName, res, next);
        }
        next();
    },
    (req, res, next) => validateCountry(req.body.country, res, next),
    (req, res, next) => validateMobilePhone(req.body.mobilePhone, req.body.country, res, next),
    (req, res, next) => {
        const email = req.body?.email;
        if (email && String(email).trim()) {
            return validateEmail(email, res, next);
        }
        next();
    },
    (req, res, next) => validatePassword(req.body.password, res, next),
    (req, res, next) => {
        const hasEmail = Boolean(req.body?.email && String(req.body.email).trim());
        if (!hasEmail) {
            return next();
        }
        return validateCode(req.body.emailCode, res, next);
    },
    (req, res, next) => validateCode(req.body.mobilePhoneCode, res, next),
    authController.postCreateNewUser
);

authRouter.post("/login",
    loginRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: !bodyData?.mobilePhone },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: !bodyData?.email },
            { fieldName: "Password", fieldValue: bodyData?.password, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => {
        const bodyData = req.body;
        if (bodyData?.email) {
            return validateEmail(bodyData.email, res, next);
        }
        if (bodyData?.mobilePhone) {
            return validateMobilePhone(bodyData.mobilePhone, undefined, res, next);
        }
        next();
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
    (req, res, next) => validatePassword(req.body.password, res, next),
    authController.postLogin
);

authRouter.post("/forget-password",
    forgotPasswordRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: !bodyData?.mobilePhone },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: !bodyData?.email },
        ], res, next);
    },
    (req, res, next) => {
        const bodyData = req.body;
        if (bodyData?.email) {
            return validateEmail(bodyData.email, res, next);
        }
        if (bodyData?.mobilePhone) {
            return validateMobilePhone(bodyData.mobilePhone, undefined, res, next);
        }
        next();
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
    authController.postForgetPassword
);

authRouter.put("/reset-password",
    resetPasswordRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Session", fieldValue: bodyData?.session, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Code", fieldValue: bodyData?.code, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "New Password", fieldValue: bodyData?.password, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => validateCode(req.body.code, res, next),
    (req, res, next) => validatePassword(req.body.password, res, next),
    authController.putResetPassword
);

module.exports = authRouter;