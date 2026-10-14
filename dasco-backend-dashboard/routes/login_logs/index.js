const loginLogsRouter = require("express").Router();

const loginLogsController = require("../../controllers/login_logs");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    numbersMiddlewares,
    networkMiddlewares
} = require("../../middlewares");

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat
} = numbersMiddlewares;

const {
    validateJWT,
} = authMiddlewares;

const {
    validateIpAddress,
} = networkMiddlewares;

loginLogsRouter.get("/all-logs-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Log Id", fieldValue: queryData?._id, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "User Id", fieldValue: queryData?.userId, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Ip Address", fieldValue: queryData?.ipAddress, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "From Date", fieldValue: queryData?.fromDate, dataTypes: ["date"], isRequiredValue: false },
            { fieldName: "To Date", fieldValue: queryData?.toDate, dataTypes: ["date"], isRequiredValue: false },
            { fieldName: "User Name", fieldValue: queryData?.userName, dataTypes: ["string"], isRequiredValue: false },
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
        const ipAddress = req.query?.ipAddress;
        if (ipAddress) {
            return validateIpAddress(ipAddress, res, next);
        }
        next();
    },
    loginLogsController.getAllLogsInsideThePage
);

module.exports = loginLogsRouter;