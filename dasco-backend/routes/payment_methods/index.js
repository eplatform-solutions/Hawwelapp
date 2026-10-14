const paymentMethodsRouter = require("express").Router();

const paymentMethodsController = require("../../controllers/payment_methods");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

paymentMethodsRouter.get("/area/:areaId",
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Area Id", fieldValue: req.params.areaId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    paymentMethodsController.getPaymentMethodsInArea
);

paymentMethodsRouter.get("/country/:countryId",
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Country Id", fieldValue: req.params.countryId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    paymentMethodsController.getPaymentMethodsInCountry
);

module.exports = paymentMethodsRouter;