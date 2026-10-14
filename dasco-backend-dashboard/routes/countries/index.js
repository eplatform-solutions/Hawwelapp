const countriesRouter = require("express").Router();

const countriesController = require("../../controllers/countries");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    commonMiddlewares
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

const {
    validateCountry,
} = commonMiddlewares;

countriesRouter.post("/create",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Country Code", fieldValue: req.body?.code, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => validateCountry(req.body.code, res, next),
    countriesController.postCreateCountry
);

countriesRouter.get("/all", validateJWT, countriesController.getAllCountries);

countriesRouter.delete("/delete/:countryId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Country Id", fieldValue: req.params.countryId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    countriesController.deleteCountry
);

countriesRouter.post("/:countryId/payment-methods",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Country Id", fieldValue: req.params.countryId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Payment Methods", fieldValue: bodyData?.paymentMethods, dataTypes: ["array"], isRequiredValue: true },
            ...bodyData?.paymentMethods ? bodyData.paymentMethods.map((paymentMethod, paymentMethodIndex) => (
                { fieldName: `Payment Method Id In Index: ${paymentMethodIndex}`, fieldValue: paymentMethod, dataTypes: ["ObjectId"], isRequiredValue: true }
            )) : []
        ], res, next);
    },
    countriesController.postBindPaymentMethodsToCountry
);

module.exports = countriesRouter;