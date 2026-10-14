const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const currenciesOperationsManagementFunctions = require("../../repositories/currencies");

async function getAllCurrencies(req, res) {
    try {
        const result = await currenciesOperationsManagementFunctions.getAllCurrencies(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function postCreateCurrency(req, res) {
    try {
        const result = await currenciesOperationsManagementFunctions.createCurrency(req.data._id, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUpdateCurrency(req, res) {
    try {
        const result = await currenciesOperationsManagementFunctions.updateCurrency(req.data._id, req.params.currencyId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deleteCurrency(req, res) {
    try {
        const result = await currenciesOperationsManagementFunctions.deleteCurrency(req.data._id, req.params.currencyId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAllCurrencies,
    postCreateCurrency,
    putUpdateCurrency,
    deleteCurrency,
};
