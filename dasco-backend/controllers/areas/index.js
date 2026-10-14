// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for areas management
const areasOperationsManagmentFunctions = require("../../repositories/areas");

async function getAreasInCity(req, res) {
    try {
        res.json(await areasOperationsManagmentFunctions.getAreasInCity(req.params.cityId, req.query.language));
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAreasInCity,
}