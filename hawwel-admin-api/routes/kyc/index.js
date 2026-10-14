const kycRouter = require("express").Router();

const kycController = require("../../controllers/kyc");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    numbersMiddlewares,
    kycMiddlewares,
    commonMiddlewares,
} = require("../../middlewares");

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat
} = numbersMiddlewares;

const {
    validateJWT,
} = authMiddlewares;

const {
    validateStatus,
} = kycMiddlewares;

const {
    validateCountry,
} = commonMiddlewares;

kycRouter.get("/:kycId/files/:fileIndex",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "KYC Id", fieldValue: req.params.kycId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "File Index", fieldValue: req.params.fileIndex, dataTypes: ["number"], isRequiredValue: true },
        ], res, next);
    },
    kycController.getKycFile
);

kycRouter.get("/all-kycs-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Status", fieldValue: queryData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "From Date", fieldValue: queryData?.fromDate, dataTypes: ["date"], isRequiredValue: false },
            { fieldName: "To Date", fieldValue: queryData?.toDate, dataTypes: ["date"], isRequiredValue: false },
            { fieldName: "Country", fieldValue: queryData?.country, dataTypes: ["string"], isRequiredValue: false },
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
        const status = req.query?.status;
        if (status) {
            return validateStatus(status, res, next);
        }
        next();
    },
    (req, res, next) => {
        const country = req.query?.country;
        if (country) {
            return validateCountry(country, res, next);
        }
        next();
    },
    kycController.getAllKYCsInsideThePage
);

kycRouter.put("/approve/:kycId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "KYC Id", fieldValue: req.params.kycId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    kycController.putApproveKYC
);

kycRouter.put("/reject/:kycId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "KYC Id", fieldValue: req.params.kycId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Rejection Reason", fieldValue: req.body?.rejectionReason, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    kycController.putRejectKYC
);

kycRouter.put("/remove-verifying/:kycId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "KYC Id", fieldValue: req.params.kycId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Remove Verifying Reason", fieldValue: req.body?.removeVerifyingReason, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    kycController.putRemoveKycVerifying
);

kycRouter.put("/blocking/:kycId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "KYC Id", fieldValue: req.params.kycId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Blocking Reason", fieldValue: req.body?.blockingReason, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    kycController.putBlockingKYC
);

kycRouter.put("/cancel-blocking/:kycId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "KYC Id", fieldValue: req.params.kycId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    kycController.putCancelBlockingKYC
);

module.exports = kycRouter;