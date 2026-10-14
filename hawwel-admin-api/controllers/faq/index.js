// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for faq management
const faqsOperationsManagmentFunctions = require("../../repositories/faq");

async function postCreateFAQ(req, res) {
    try {
        const result = await faqsOperationsManagmentFunctions.createFAQ(req.data._id, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        return filtersObject;
    }
    return filtersObject;
}

async function getAllFAQSInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await faqsOperationsManagmentFunctions.getAllFAQSInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putFAQInfo(req, res) {
    try {
        const result = await faqsOperationsManagmentFunctions.updateFAQInfo(req.data._id, req.params.faqId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function deleteFAQ(req, res) {
    try {
        const result = await faqsOperationsManagmentFunctions.deleteFAQ(req.data._id, req.params.faqId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

module.exports = {
    postCreateFAQ,
    getAllFAQSInsideThePage,
    putFAQInfo,
    deleteFAQ
}