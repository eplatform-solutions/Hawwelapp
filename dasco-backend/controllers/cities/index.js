// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for cities management
const citiesOperationsManagmentFunctions = require("../../repositories/cities");

async function getCitiesInCountry(req, res) {
    try {
        res.json(await citiesOperationsManagmentFunctions.getCitiesInCountry(req.params.countryId, req.query.language));
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getCitiesInCountry,
}