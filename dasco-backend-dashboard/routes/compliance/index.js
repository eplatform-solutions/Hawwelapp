const complianceRouter = require("express").Router();

const complianceController = require("../../controllers/compliance");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    numbersMiddlewares,
    complianceMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat
} = numbersMiddlewares;

const {
    validateAlertStatusFilter,
    validateResolveStatus,
    validateAlertType,
    validateAlertSeverity,
} = complianceMiddlewares;

complianceRouter.get("/all-alerts-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Status", fieldValue: queryData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Type", fieldValue: queryData?.type, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Severity", fieldValue: queryData?.severity, dataTypes: ["string"], isRequiredValue: false },
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
        if (status) {
            return validateAlertStatusFilter(status, res, next);
        }
        next();
    },
    (req, res, next) => {
        const type = req.query?.type;
        if (type) {
            return validateAlertType(type, res, next);
        }
        next();
    },
    (req, res, next) => {
        const severity = req.query?.severity;
        if (severity) {
            return validateAlertSeverity(severity, res, next);
        }
        next();
    },
    complianceController.getAllComplianceAlertsInsideThePage
);

complianceRouter.get("/alerts-stats",
    validateJWT,
    complianceController.getComplianceAlertsStats
);

complianceRouter.put("/alerts/:alertId/resolve",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Alert Id", fieldValue: req.params.alertId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Status", fieldValue: req.body?.status, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Review Note", fieldValue: req.body?.reviewNote, dataTypes: ["string"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => validateResolveStatus(req.body.status, res, next),
    complianceController.putResolveComplianceAlert
);

module.exports = complianceRouter;
