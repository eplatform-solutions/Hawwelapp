const citiesRouter = require("express").Router();

const citiesController = require("../../controllers/cities");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const { LANGUAGES } = require("../../constants/languages");

const {
    authMiddlewares,
    commonMiddlewares,
    numbersMiddlewares
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

const {
    validateName,
} = commonMiddlewares;

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat,
} = numbersMiddlewares;

citiesRouter.post("/create",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Country", fieldValue: bodyData?.country, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "City Name", fieldValue: bodyData?.name, dataTypes: ["object"], isRequiredValue: true },
            ...LANGUAGES.map((language) => (
                { fieldName: `City Name In ${language.toUpperCase()}`, fieldValue: bodyData.name[language], dataTypes: ["string"], isRequiredValue: true }
            )),
        ], res, next);
    },
    (req, res, next) => validateName(req.body.name.ar, res, next),
    (req, res, next) => validateName(req.body.name.en, res, next),
    citiesController.postCreateCity
);

citiesRouter.get("/all-cities-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
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
    citiesController.getAllCitiesInsideThePage
);

citiesRouter.put("/update/:cityId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Country", fieldValue: bodyData?.country, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["object"], isRequiredValue: false },
            ...bodyData?.name ? LANGUAGES.map((language) => (
                { fieldName: `New Name In ${language.toUpperCase()}`, fieldValue: bodyData.name[language], dataTypes: ["string"], isRequiredValue: true }
            )) : [],
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
    citiesController.putCityInfo
);

citiesRouter.delete("/delete/:cityId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "City Id", fieldValue: req.params.cityId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    citiesController.deleteCity
);

citiesRouter.post("/:cityId/payment-methods",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "City Id", fieldValue: req.params.cityId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Payment Methods", fieldValue: bodyData?.paymentMethods, dataTypes: ["array"], isRequiredValue: true },
            ...bodyData?.paymentMethods ? bodyData.paymentMethods.map((paymentMethod, paymentMethodIndex) => (
                { fieldName: `Payment Method Id In Index: ${paymentMethodIndex}`, fieldValue: paymentMethod, dataTypes: ["ObjectId"], isRequiredValue: true }
            )) : []
        ], res, next);
    },
    citiesController.postBindPaymentMethodsToCity
);

module.exports = citiesRouter;