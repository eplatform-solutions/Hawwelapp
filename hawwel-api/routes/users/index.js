const usersRouter = require("express").Router();

const usersController = require("../../controllers/users");

const { validateHelpers } = require("../../helpers");

const { validateIsExistValueForFieldsAndDataTypes } = validateHelpers;

const {
    authMiddlewares,
    rateLimitsMiddlewares,
    filesMiddlewares,
    usersMiddlewares
} = require("../../middlewares");

const {
    validateJWT,
    validateEmail,
    validateMobilePhone,
    validatePassword,
    validateCode
} = authMiddlewares;

const {
    userRateLimitersMiddlewares
} = rateLimitsMiddlewares;

const {
    userInfoRateLimitMiddleware,
    userUpdateRateLimitMiddleware,
    changeProfileImageLimiterRateLimitMiddleware,
    changePasswordLimiterRateLimitMiddleware,
    change2faLimiterRateLimitMiddleware
} = userRateLimitersMiddlewares;

const {
    validateIsExistErrorInFiles,
    verifyRealFileType
} = filesMiddlewares;

const {
    validate2FAMethods,
    uploadUserProfileImageFileSingle
} = usersMiddlewares;

usersRouter.get("/info", validateJWT, userInfoRateLimitMiddleware, usersController.getUserInfo);

usersRouter.put("/update",
    validateJWT,
    userUpdateRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Code For Email", fieldValue: bodyData?.emailCode, dataTypes: ["string"], isRequiredValue: bodyData?.email ? true : false },
            { fieldName: "Session For Email", fieldValue: bodyData?.sessionForEmail, dataTypes: ["ObjectId"], isRequiredValue: bodyData?.email && bodyData?.emailCode },
            { fieldName: "Code For Mobile Phone", fieldValue: bodyData?.mobilePhoneCode, dataTypes: ["string"], isRequiredValue: bodyData?.mobilePhone ? true : false },
            { fieldName: "Session For Mobile Phone", fieldValue: bodyData?.sessionForMobilePhone, dataTypes: ["ObjectId"], isRequiredValue: bodyData?.mobilePhone && bodyData?.mobilePhoneCode }
        ], res, next);
    },
    (req, res, next) => {
        const mobilePhone = req.body?.mobilePhone;
        if (mobilePhone) {
            return validateMobilePhone(mobilePhone, undefined, res, next);
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
        const emailCode = req.body?.emailCode;
        if (emailCode) {
            return validateCode(emailCode, res, next);
        }
        next();
    },
    (req, res, next) => {
        const mobilePhoneCode = req.body?.mobilePhoneCode;
        if (mobilePhoneCode) {
            return validateCode(mobilePhoneCode, res, next);
        }
        next();
    },
    usersController.putUserInfo
);

usersRouter.put("/change-profile-image",
    validateJWT,
    changeProfileImageLimiterRateLimitMiddleware,
    uploadUserProfileImageFileSingle,
    verifyRealFileType,
    validateIsExistErrorInFiles,
    usersController.putProfileImage
);

usersRouter.put("/change-password",
    validateJWT,
    changePasswordLimiterRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Old Password", fieldValue: bodyData?.password, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "New Password", fieldValue: bodyData?.newPassword, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => validatePassword(req.body.password, res, next),
    (req, res, next) => validatePassword(req.body.newPassword, res, next),
    usersController.putChangePassword
);

usersRouter.put("/change-2fa-status",
    validateJWT,
    change2faLimiterRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Enabled", fieldValue: bodyData?.enabled, dataTypes: ["boolean"], isRequiredValue: true },
            { fieldName: "2FA Methods", fieldValue: bodyData?.methods, dataTypes: ["array"], isRequiredValue: bodyData?.enabled ? true : false },
        ], res, next);
    },
    (req, res, next) => {
        const methods = req.body?.methods;
        if (methods?.length > 0) {
            return validate2FAMethods(methods, res, next);
        }
        next();
    },
    usersController.putChange2FAStatus
);

usersRouter.post("/delete-request",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Note", fieldValue: bodyData?.note, dataTypes: ["string"], isRequiredValue: false },
        ], res, next);
    },
    usersController.postAccountDeletionRequest
);

module.exports = usersRouter;