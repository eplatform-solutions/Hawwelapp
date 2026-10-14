// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for exchange rates management
const exchangeRatesOperationsManagmentFunctions = require("../../repositories/exchange_rates");

async function getAllExchangeRates(req, res) {
    try {
        const result = await exchangeRatesOperationsManagmentFunctions.getAllExchangeRates(req.query.language);
        res.json(result);
    }
    catch (err) {
        console.error("[exchange-rates/getAllExchangeRates]", err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAllExchangeRates
}