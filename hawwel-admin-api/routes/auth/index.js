const authRouter = require("express").Router();

const authController = require("../../controllers/auth");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    rateLimitsMiddlewares
} = require("../../middlewares");

const {
    authRateLimitersMiddlewares
} = rateLimitsMiddlewares;

const {
    loginRateLimitMiddleware,
} = authRateLimitersMiddlewares;

const {
    validateMobilePhone,
    validateEmail,
    validatePassword,
} = authMiddlewares;

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

module.exports = authRouter;