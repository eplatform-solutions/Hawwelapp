const paymentMethodsRouter = require("express").Router();

const paymentMethodsController = require("../../controllers/payment_methods");

const { getResponseObject } = require("../../helpers/responses");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const { LANGUAGES } = require("../../constants/languages");
const { SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../constants/currencies");
const { currencyRateModel } = require("../../models/dashboard");

const {
    authMiddlewares,
    rateLimitsMiddlewares,
    paymentMethodsMiddlewares,
    filesMiddlewares,
    commonMiddlewares,
    currenciesMiddlewares,
    numbersMiddlewares
} = require("../../middlewares");

const {
    validateJWT
} = authMiddlewares;

const {
    paymentMethodRateLimitersMiddlewares
} = rateLimitsMiddlewares;

const {
    paymentMethodLogoUploadLimitMiddleware
} = paymentMethodRateLimitersMiddlewares;

const {
    uploadPaymentMethodSingleFile
} = paymentMethodsMiddlewares;

const {
    validateIsExistErrorInFiles,
    verifyRealFileType
} = filesMiddlewares;

const {
    validateName
} = commonMiddlewares;

const {
    validateFiatCurrencySymbol
} = currenciesMiddlewares;

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat,
} = numbersMiddlewares;

async function validateSupportedCurrencySymbol(symbol, res, next) {
    const normalized = String(symbol || "").trim().toUpperCase();
    if (!normalized) {
        return res.status(400).json(getResponseObject("Sorry, Please Send Valid Fiat Currency Symbol !!", true, {}));
    }
    if (SUPPORTED_CRYPTO_CURRENCY_SYMBOLS.includes(normalized)) {
        return res.status(400).json(getResponseObject("Sorry, Payment Methods Support Fiat Currencies Only !!", true, {}));
    }
    try {
        const exists = await currencyRateModel.exists({ code: normalized });
        if (!exists) {
            return res.status(400).json(getResponseObject("Sorry, Please Send Valid Fiat Currency Symbol !!", true, {}));
        }
        next();
    } catch (_) {
        validateFiatCurrencySymbol(normalized, res, next);
    }
}

paymentMethodsRouter.post("/create",
    validateJWT,
    paymentMethodLogoUploadLimitMiddleware,
    uploadPaymentMethodSingleFile,
    validateIsExistErrorInFiles,
    verifyRealFileType,
    (req, res, next) => {
        const bodyData = Object.assign({}, req.body);
        const name = bodyData?.name;
        let parsedName;
        try {
            parsedName = JSON.parse(name);
        } catch {
            parsedName = name;
        }
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Name", fieldValue: parsedName, dataTypes: ["object"], isRequiredValue: true },
            ...LANGUAGES.map((language) => (
                { fieldName: `Name In ${language.toUpperCase()}`, fieldValue: parsedName[language], dataTypes: ["string"], isRequiredValue: true }
            )),
            { fieldName: "Symbol", fieldValue: bodyData?.symbol, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Minimum Amount", fieldValue: bodyData?.minAmount, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Maximum Amount", fieldValue: bodyData?.maxAmount, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Fee", fieldValue: Number(bodyData?.fee), dataTypes: ["number"], isRequiredValue: typeof bodyData?.fee === "undefined" || bodyData?.fee === null },
        ], res, next);
    },
    (req, res, next) => validateName(Object.assign({}, req.body).name.ar, res, next),
    (req, res, next) => validateName(Object.assign({}, req.body).name.en, res, next),
    async (req, res, next) => validateSupportedCurrencySymbol(Object.assign({}, req.body).symbol, res, next),
    (req, res, next) => {
        const { minAmount, maxAmount } = Object.assign({}, req.body);
        return validateNumbersIsGreaterThanZero([minAmount, maxAmount], res, next, ["Sorry, Please Send Valid Min Amount Number ( Number Must Be Greater Than Zero ) !!", "Sorry, Please Send Valid Max Amount Number ( Number Must Be Greater Than Zero ) !!"]);
    },
    (req, res, next) => {
        const { minAmount, maxAmount } = Object.assign({}, req.body);
        if (Number(minAmount) > Number(maxAmount)) {
            return res.json(getResponseObject("Sorry, Min Amount Can't Be Greater Than Max Amount !!", true, {}));
        }
        next();
    },
    (req, res, next) => {
        const fee = Object.assign({}, req.body).fee;
        if (fee < 0) {
            return res.json(getResponseObject("Sorry, Fee Can't Be Less Than Zero !!", true, {}));
        }
        else if (fee > 100) {
            return res.json(getResponseObject("Sorry, Fee Can't Be Greater Than 100 !!", true, {}));
        }
        next();
    },
    paymentMethodsController.postCreatePaymentMethod
);

paymentMethodsRouter.get("/all-payment-methods-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Name", fieldValue: queryData?.name, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Symbol", fieldValue: queryData?.symbol, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Region", fieldValue: queryData?.region, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "City", fieldValue: queryData?.city, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Country", fieldValue: queryData?.country, dataTypes: ["ObjectId"], isRequiredValue: false },
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
        const name = req.query?.name;
        if (name) {
            return validateName(name, res, next);
        }
        next();
    },
    (req, res, next) => {
        const symbol = req.query?.symbol;
        if (symbol) {
            return validateSupportedCurrencySymbol(symbol, res, next);
        }
        next();
    },
    paymentMethodsController.getAllPaymentMethodsInsideThePage
);

paymentMethodsRouter.put("/update/:paymentMethodId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Payment Method Id", fieldValue: req.params.paymentMethodId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["object"], isRequiredValue: false },
            ...bodyData?.name ? LANGUAGES.map((language) => (
                { fieldName: `Name In ${language.toUpperCase()}`, fieldValue: bodyData.name[language], dataTypes: ["string"], isRequiredValue: true }
            )) : [],
            { fieldName: "Symbol", fieldValue: bodyData?.symbol, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Minimum Amount", fieldValue: bodyData?.minAmount, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "Maximum Amount", fieldValue: bodyData?.maxAmount, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "Fee", fieldValue: bodyData?.fee, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "Is Activated", fieldValue: bodyData?.isActivated, dataTypes: ["boolean"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const name = req.body?.name?.ar;
        if (name) {
            return validateName(name, res, next);
        }
        next();
    },
    (req, res, next) => {
        const name = req.body?.name?.en;
        if (name) {
            return validateName(name, res, next);
        }
        next();
    },
    (req, res, next) => {
        const symbol = req.body?.symbol;
        if (symbol) {
            return validateSupportedCurrencySymbol(symbol, res, next);
        }
        next();
    },
    (req, res, next) => {
        const minAmount = req.body?.minAmount;
        if (minAmount) {
            return validateNumbersIsGreaterThanZero([minAmount], res, next, ["Sorry, Please Send Valid Min Amount Number ( Number Must Be Greater Than Zero ) !!"]);
        }
        next();
    },
    (req, res, next) => {
        const maxAmount = req.body?.maxAmount;
        if (maxAmount) {
            return validateNumbersIsGreaterThanZero([maxAmount], res, next, ["Sorry, Please Send Valid Max Amount Number ( Number Must Be Greater Than Zero ) !!"]);
        }
        next();
    },
    (req, res, next) => {
        const bodyData = req.body;
        if (bodyData?.minAmount && bodyData?.maxAmount) {
            const { minAmount, maxAmount } = bodyData;
            if (minAmount > maxAmount) {
                return res.json(getResponseObject("Sorry, Min Amount Can't Be Greater Than Max Amount !!", true, {}));
            }
        }
        next();
    },
    (req, res, next) => {
        const fee = req.body?.fee;
        if (fee) {
            if (fee < 0) {
                return res.json(getResponseObject("Sorry, Fee Can't Be Less Than Max Zero !!", true, {}));
            }
        }
        next();
    },
    paymentMethodsController.putPaymentMethodInfo
);

paymentMethodsRouter.put("/change-logo-image/:paymentMethodId",
    validateJWT,
    paymentMethodLogoUploadLimitMiddleware,
    uploadPaymentMethodSingleFile,
    validateIsExistErrorInFiles,
    verifyRealFileType,
    paymentMethodsController.putPaymentMethodLogoImage
);

paymentMethodsRouter.delete("/delete/:paymentMethodId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Payment Method Id", fieldValue: req.params.paymentMethodId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    paymentMethodsController.deletePaymentMethod
);

paymentMethodsRouter.get("/:paymentMethodId/bindings",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Payment Method Id", fieldValue: req.params.paymentMethodId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    paymentMethodsController.getPaymentMethodBindings
);

paymentMethodsRouter.delete("/:paymentMethodId/bindings/country/:countryId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Payment Method Id", fieldValue: req.params.paymentMethodId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Country Id", fieldValue: req.params.countryId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    paymentMethodsController.deleteCountryPaymentMethodBinding
);

paymentMethodsRouter.delete("/:paymentMethodId/bindings/city/:cityId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Payment Method Id", fieldValue: req.params.paymentMethodId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "City Id", fieldValue: req.params.cityId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    paymentMethodsController.deleteCityPaymentMethodBinding
);

paymentMethodsRouter.delete("/:paymentMethodId/bindings/region/:regionId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Payment Method Id", fieldValue: req.params.paymentMethodId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Region Id", fieldValue: req.params.regionId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    paymentMethodsController.deleteRegionPaymentMethodBinding
);

module.exports = paymentMethodsRouter;