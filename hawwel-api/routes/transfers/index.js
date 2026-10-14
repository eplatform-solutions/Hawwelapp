const transfersRouter = require("express").Router();

const transfersController = require("../../controllers/transfers");

const { getResponseObject } = require("../../helpers/responses");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    rateLimitsMiddlewares,
    numbersMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
    validateMobilePhone,
} = authMiddlewares;

const {
    transferRateLimitersMiddlewares
} = rateLimitsMiddlewares;

const {
    transferCreateRateLimitMiddleware
} = transferRateLimitersMiddlewares;

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat
} = numbersMiddlewares;

transfersRouter.post("/by-parameter",
    validateJWT,
    transferCreateRateLimitMiddleware,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Currency Symbol", fieldValue: bodyData?.symbol, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Amount", fieldValue: bodyData?.amount, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "To Country", fieldValue: bodyData?.toCountry, dataTypes: ["ObjectId"], isRequiredValue: true },
            // City/Area are optional: a payment method bound directly at the
            // country level (see repositories/payment_methods getPaymentMethodsInCountry)
            // can be used without picking a city/region at all - see
            // transferByParameter, which validates whichever level was sent.
            { fieldName: "City", fieldValue: bodyData?.city, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Area", fieldValue: bodyData?.area, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Payment Method", fieldValue: bodyData?.paymentMethod, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Receiver", fieldValue: bodyData?.receiver, dataTypes: ["object"], isRequiredValue: true },
            { fieldName: "Receiver Full Name", fieldValue: bodyData?.receiver?.fullName, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Receiver Mobile Phone", fieldValue: bodyData?.receiver?.mobilePhone, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => validateNumbersIsGreaterThanZero([req.body.amount], res, next, [], "Sorry, Please Send Valid Amount ( Number Must Be Greater Than Zero ) !!"),
    (req, res, next) => validateMobilePhone(req.body.receiver.mobilePhone, undefined, res, next),
    transfersController.postByParameter
);

// Public debug/on-chain endpoint removed (security). Always 404 — never 200 without auth.
transfersRouter.post("/on-blockchain", (_req, res) => {
    res.status(404).json(getResponseObject("Not Found", true, {}));
});

transfersRouter.get("/all-transfers-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
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
    transfersController.getAllTransfersInsideThePage
);

transfersRouter.get("/main-transfer-page-data", validateJWT, transfersController.getMainTransferPageData);

module.exports = transfersRouter;