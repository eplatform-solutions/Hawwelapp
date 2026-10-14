const currenciesRouter = require("express").Router();

const currenciesController = require("../../controllers/currencies");

const { getResponseObject } = require("../../helpers/responses");
const { SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../constants/currencies");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

function validateFiatOnlyCurrencyCode(req, res, next) {
    const normalized = String(req.body?.code || "").trim().toUpperCase();
    if (!normalized) {
        return next();
    }
    if (SUPPORTED_CRYPTO_CURRENCY_SYMBOLS.includes(normalized)) {
        return res.status(400).json(
            getResponseObject("Sorry, Crypto Symbols Are Managed In Blockchain Configuration Only !!", true, {})
        );
    }
    req.body.code = normalized;
    next();
}

currenciesRouter.get("/all", validateJWT, currenciesController.getAllCurrencies);

currenciesRouter.post("/create",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Code", fieldValue: bodyData?.code, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "USDT Rate", fieldValue: bodyData?.usdtRate, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "USDC Rate", fieldValue: bodyData?.usdcRate, dataTypes: ["number"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => {
        if (req.body?.usdtRate <= 0) {
            return res.status(400).json(getResponseObject("Sorry, Please Send Valid USDT Rate ( Number Must Be Greater Than Zero ) !!", true, {}));
        }
        if (req.body?.usdcRate <= 0) {
            return res.status(400).json(getResponseObject("Sorry, Please Send Valid USDC Rate ( Number Must Be Greater Than Zero ) !!", true, {}));
        }
        next();
    },
    validateFiatOnlyCurrencyCode,
    currenciesController.postCreateCurrency
);

currenciesRouter.put("/update/:currencyId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Currency Id", fieldValue: req.params.currencyId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Code", fieldValue: bodyData?.code, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "USDT Rate", fieldValue: bodyData?.usdtRate, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "USDC Rate", fieldValue: bodyData?.usdcRate, dataTypes: ["number"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        if (req.body?.usdtRate !== undefined && req.body?.usdtRate <= 0) {
            return res.status(400).json(getResponseObject("Sorry, Please Send Valid USDT Rate ( Number Must Be Greater Than Zero ) !!", true, {}));
        }
        if (req.body?.usdcRate !== undefined && req.body?.usdcRate <= 0) {
            return res.status(400).json(getResponseObject("Sorry, Please Send Valid USDC Rate ( Number Must Be Greater Than Zero ) !!", true, {}));
        }
        next();
    },
    validateFiatOnlyCurrencyCode,
    currenciesController.putUpdateCurrency
);

currenciesRouter.delete("/delete/:currencyId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Currency Id", fieldValue: req.params.currencyId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    currenciesController.deleteCurrency
);

module.exports = currenciesRouter;
