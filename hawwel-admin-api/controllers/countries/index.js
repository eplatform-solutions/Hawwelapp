// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for countries management
const countriesOperationsManagmentFunctions = require("../../repositories/countries");

async function postCreateCountry(req, res) {
    try {
        const result = await countriesOperationsManagmentFunctions.createCountry(req.data._id, req.body.code, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getAllCountries(req, res) {
    try {
        const result = await countriesOperationsManagmentFunctions.getAllCountries(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deleteCountry(req, res) {
    try {
        const result = await countriesOperationsManagmentFunctions.deleteCountry(req.data._id, req.params.countryId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function postBindPaymentMethodsToCountry(req, res) {
    try {
        const result = await countriesOperationsManagmentFunctions.bindPaymentMethodsToCountry(req.data._id, req.params.countryId, req.body.paymentMethods, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postCreateCountry,
    getAllCountries,
    deleteCountry,
    postBindPaymentMethodsToCountry
}