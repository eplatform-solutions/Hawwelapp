// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for exchange rates management
const exchangeRatesOperationsManagmentFunctions = require("../../repositories/exchange_rates");

async function getAllExchangeRates(req, res) {
    try {
        const result = await exchangeRatesOperationsManagmentFunctions.getAllExchangeRates(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUpdateExchangeRates(req, res) {
    try {
        const result = await exchangeRatesOperationsManagmentFunctions.updateExchangeRates(req.data._id, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAllExchangeRates,
    putUpdateExchangeRates
}