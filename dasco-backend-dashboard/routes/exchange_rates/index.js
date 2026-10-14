const exchangeRatesRouter = require("express").Router();

const exchangeRatesController = require("../../controllers/exchange_rates");

const { getResponseObject } = require("../../helpers/responses");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

exchangeRatesRouter.get("/all", validateJWT, exchangeRatesController.getAllExchangeRates);

exchangeRatesRouter.put("/update",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "USDT Exchange Rate", fieldValue: bodyData?.USDT_RATE, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "USDC Exchange Rate", fieldValue: bodyData?.USDC_RATE, dataTypes: ["number"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const USDT_RATE = req.body?.USDT_RATE;
        if (USDT_RATE <= 0) {
            return res.status(400).json(getResponseObject("Sorry, Please Send Valid USDT Rate ( Number Must Be Greater Than Zero ) !!", true, {}));
        }
        next();
    },
    (req, res, next) => {
        const USDC_RATE = req.body?.USDC_RATE;
        if (USDC_RATE <= 0) {
            return res.status(400).json(getResponseObject("Sorry, Please Send Valid USDC Rate ( Number Must Be Greater Than Zero ) !!", true, {}));
        }
        next();
    },
    exchangeRatesController.putUpdateExchangeRates
);

module.exports = exchangeRatesRouter;