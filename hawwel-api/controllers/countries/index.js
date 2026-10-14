// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for countries management
const countriesOperationsManagmentFunctions = require("../../repositories/countries");

async function getAllCountries(req, res) {
    try {
        res.json(await countriesOperationsManagmentFunctions.getAllCountries(req.query.language));
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAllCountries,
}