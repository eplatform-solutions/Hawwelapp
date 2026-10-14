const adminsRouter = require("express").Router();

const adminsController = require("../../controllers/admins");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    numbersMiddlewares,
    commonMiddlewares,
    adminsMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
    validateEmail,
    validateMobilePhone,
    validatePassword,
} = authMiddlewares;

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat,
} = numbersMiddlewares;

const {
    validateName
} = commonMiddlewares;

const {
    validateStatus
} = adminsMiddlewares;

adminsRouter.post("/create",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Full Name", fieldValue: bodyData?.fullName, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "User Name", fieldValue: bodyData?.userName, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Password", fieldValue: bodyData?.password, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Role", fieldValue: bodyData?.role, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => validateName(req.body.fullName, res, next),
    (req, res, next) => validateEmail(req.body.email, res, next),
    (req, res, next) => validateMobilePhone(req.body.mobilePhone, undefined, res, next),
    (req, res, next) => validatePassword(req.body.password, res, next),
    adminsController.postCreateAdmin
);

adminsRouter.get("/info", validateJWT, adminsController.getAdminInfo);

adminsRouter.get("/admins-count", validateJWT, adminsController.getAdminsCount);

adminsRouter.get("/all-admins-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Admin Id", fieldValue: queryData?._id, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Full Name", fieldValue: queryData?.fullName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "User Name", fieldValue: queryData?.userName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Email", fieldValue: queryData?.email, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Mobile Phone", fieldValue: queryData?.mobilePhone, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Status", fieldValue: queryData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Role", fieldValue: queryData?.role, dataTypes: ["ObjectId"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const queryData = req.query;
        validateNumbersIsGreaterThanZero([queryData.pageNumber, queryData.pageSize], res, next, ["Sorry, Please Send Valid Page Number ( Number Must Be Greater Than Zero ) !!", "Sorry, Please Send Valid Page Size ( Number Must Be Greater Than Zero ) !!"]);
    },
    (req, res, next) => {
        const queryData = req.query;
        validateNumbersIsNotFloat([queryData.pageNumber, queryData.pageSize], res, next, ["Sorry, Please Send Valid Page Number ( Number Must Be Not Float ) !!", "Sorry, Please Send Valid Page Size ( Number Must Be Not Float ) !!"]);
    },
    (req, res, next) => {
        const fullName = req.query?.fullName;
        if (fullName) {
            validateName(fullName, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const email = req.query?.email;
        if (email) {
            validateEmail(email, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const mobilePhone = req.query?.mobilePhone;
        if (mobilePhone) {
            validateMobilePhone(mobilePhone, undefined, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const status = req.query?.status;
        if (status) {
            validateStatus(status, res, next);
            return;
        }
        next();
    },
    adminsController.getAllAdminsInsideThePage
);

adminsRouter.put("/update/:adminId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Admin Id", fieldValue: req.params.adminId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Full Name", fieldValue: bodyData?.fullName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "User Name", fieldValue: bodyData?.userName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Status", fieldValue: bodyData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Role", fieldValue: bodyData?.role, dataTypes: ["ObjectId"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const fullName = req.body?.fullName;
        if (fullName) {
            validateName(fullName, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const email = req.body?.email;
        if (email) {
            validateEmail(email, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const mobilePhone = req.body?.mobilePhone;
        if (mobilePhone) {
            validateMobilePhone(mobilePhone, undefined, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const status = req.body?.status;
        if (status) {
            validateStatus(status, res, next);
            return;
        }
        next();
    },
    adminsController.putAdminInfo
);

adminsRouter.delete("/delete/:adminId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Admin Id", fieldValue: req.params.adminId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    adminsController.deleteAdmin
);

module.exports = adminsRouter;