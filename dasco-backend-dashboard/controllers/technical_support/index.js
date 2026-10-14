// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for technical support management
const technicalSupportOperationsManagmentFunctions = require("../../repositories/technical_support");

async function getContent(req, res) {
    try {
        const result = await technicalSupportOperationsManagmentFunctions.getContent(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getContent
}