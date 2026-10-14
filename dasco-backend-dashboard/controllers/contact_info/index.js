// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for contact info management
const contactInfoOperationsManagmentFunctions = require("../../repositories/contact_info");

async function putContactInfo(req, res) {
    try {
        const result = await contactInfoOperationsManagmentFunctions.updateContactInfo(req.data._id, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

module.exports = {
    putContactInfo
}