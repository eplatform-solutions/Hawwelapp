// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for payment methods management
const paymentMethodsOperationsManagmentFunctions = require("../../repositories/payment_methods");

async function getPaymentMethodsInArea(req, res) {
    try {
        res.json(await paymentMethodsOperationsManagmentFunctions.getPaymentMethodsInArea(req.params.areaId, req.query.language));
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getPaymentMethodsInCountry(req, res) {
    try {
        res.json(await paymentMethodsOperationsManagmentFunctions.getPaymentMethodsInCountry(req.params.countryId, req.query.language));
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getPaymentMethodsInArea,
    getPaymentMethodsInCountry,
}