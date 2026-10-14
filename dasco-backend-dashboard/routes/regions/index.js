const regionsRouter = require("express").Router();

const regionsController = require("../../controllers/regions");

const { LANGUAGES } = require("../../constants/languages");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    commonMiddlewares,
    numbersMiddlewares
} = require("../../middlewares");

const { getResponseObject } = require("../../helpers/responses");

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

regionsRouter.post("/create",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "City", fieldValue: bodyData?.city, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["object"], isRequiredValue: true },
            ...LANGUAGES.map((language) => (
                { fieldName: `Name In ${language.toUpperCase()}`, fieldValue: bodyData.name[language], dataTypes: ["string"], isRequiredValue: true }
            )),
            { fieldName: "Payment Methods", fieldValue: bodyData?.paymentMethods, dataTypes: ["array"], isRequiredValue: false },
            ...bodyData?.paymentMethods ? bodyData?.paymentMethods.map((paymentMethod, paymentMethodIndex) => (
                { fieldName: `Payment Method Id In Index: ${paymentMethodIndex}`, fieldValue: paymentMethod, dataTypes: ["ObjectId"], isRequiredValue: true }
            )) : []
        ], res, next);
    },
    (req, res, next) => validateName(req.body.name.ar, res, next),
    (req, res, next) => validateName(req.body.name.en, res, next),
    regionsController.postCreateRegion
);

regionsRouter.get("/all-regions-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Name", fieldValue: queryData?.name, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "City", fieldValue: queryData?.city, dataTypes: ["ObjectId"], isRequiredValue: false },
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
    regionsController.getAllRegionsInsideThePage
);

regionsRouter.put("/update/:regionId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "City", fieldValue: bodyData?.city, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["object"], isRequiredValue: false },
            ...bodyData?.name ? LANGUAGES.map((language) => (
                { fieldName: `Name In ${language.toUpperCase()}`, fieldValue: bodyData.name[language], dataTypes: ["string"], isRequiredValue: true }
            )) : [],
            { fieldName: "Payment Methods", fieldValue: bodyData?.paymentMethods, dataTypes: ["array"], isRequiredValue: false },
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
        const paymentMethods = req.body?.paymentMethods;
        if (Array.isArray(paymentMethods)) {
            const paymentMethodsLength = paymentMethods.length;
            if (paymentMethodsLength > 0) {
                return validateIsExistValueForFieldsAndDataTypes(
                    paymentMethods.map((paymentMethod, paymentMethodIndex) => (
                        { fieldName: `Payment Method Id In Index: ${paymentMethodIndex}`, fieldValue: paymentMethod, dataTypes: ["ObjectId"], isRequiredValue: true }
                    )), res, next
                );
            }
        }
        next();
    },
    regionsController.putRegionInfo
);

regionsRouter.delete("/delete/:regionId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Region Id", fieldValue: req.params.regionId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    regionsController.deleteRegion
);

module.exports = regionsRouter;
