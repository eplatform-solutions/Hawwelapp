// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for login logs management
const transfersOperationsManagmentFunctions = require("../../repositories/login_logs");

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "_id") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "userId") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "ipAddress") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "fromDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "toDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "userName") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
    }
    return filtersObject;
}

async function getAllLogsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await transfersOperationsManagmentFunctions.getAllLogsInsideThePage(req.data._id, Number(filters.pageNumber), Number(filters.pageSize), getFiltersObject(filters), req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAllLogsInsideThePage,
}