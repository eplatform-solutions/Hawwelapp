const transfersRouter = require("express").Router();

const transfersController = require("../../controllers/transfers");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    numbersMiddlewares,
    transfersMiddlewares,
    filesMiddlewares
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
    uploadTransferProofSingleFile,
    uploadReceivingPlaceSingleFile,
} = transfersMiddlewares;

const { TRANSFER_LIST_FILTER_VALUES } = require("../../constants/transactions");

const {
    validateIsExistErrorInFiles,
    verifyRealFileType,
} = filesMiddlewares;

transfersRouter.get("/all-transfers-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Status", fieldValue: queryData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Same Of Day", fieldValue: queryData?.today, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "From Date", fieldValue: queryData?.fromDate, dataTypes: ["date"], isRequiredValue: false },
            { fieldName: "To Date", fieldValue: queryData?.toDate, dataTypes: ["date"], isRequiredValue: false },
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
        if (status && !TRANSFER_LIST_FILTER_VALUES.includes(status)) {
            return validateStatus(status, res, next);
        }
        next();
    },
    transfersController.getAllTransfersInsideThePage
);

const MONEY_AFFECTING_STATUSES = ["full-paid", "under-paid", "over-paid", "received", "cancelled", "dispute"];

transfersRouter.post("/update-status/:transferId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Transfer Id", fieldValue: req.params?.transferId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Status", fieldValue: req.body?.status, dataTypes: ["string"], isRequiredValue: true },
            {
                fieldName: "Status Change Note",
                fieldValue: req.body?.statusChangeNote,
                dataTypes: ["string"],
                isRequiredValue: MONEY_AFFECTING_STATUSES.includes(req.body?.status),
            },
        ], res, next);
    },
    (req, res, next) => validateStatus(req.body.status, res, next),
    transfersController.postUpdateTransferStatus,
);

transfersRouter.put("/payment-proof/:transferId",
    validateJWT,
    uploadTransferProofSingleFile,
    validateIsExistErrorInFiles,
    verifyRealFileType,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Transfer Id", fieldValue: req.params?.transferId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Payment Proof Note", fieldValue: req.body?.paymentProofNote, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    transfersController.putTransferPaymentProof
);

transfersRouter.put("/receiving-place/:transferId",
    validateJWT,
    uploadReceivingPlaceSingleFile,
    validateIsExistErrorInFiles,
    verifyRealFileType,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Transfer Id", fieldValue: req.params?.transferId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Payment Proof Note", fieldValue: req.body?.paymentProofNote, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    transfersController.putTransferReceivingPlace
);

module.exports = transfersRouter;