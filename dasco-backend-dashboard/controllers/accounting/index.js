// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for accounting management
const accountingOperationsManagmentFunctions = require("../../repositories/accounting");

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "fromDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "toDate") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getDailyRestrictions(req, res) {
    try {
        const result = await accountingOperationsManagmentFunctions.getDailyRestrictions(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function getDailyRestrictionsTransfers(req, res) {
    try {
        const filters = req.query;
        const result = await accountingOperationsManagmentFunctions.getDailyRestrictionsTransfers(req.data._id, Number(filters.pageNumber), Number(filters.pageSize), {}, filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function getAccountingRestrictions(req, res) {
    try {
        const filters = req.query;
        const result = await accountingOperationsManagmentFunctions.getAccountingRestrictions(req.data._id, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function getFinancialRestrictionsGlobalStats(req, res) {
    try {
        const filters = req.query;
        const result = await accountingOperationsManagmentFunctions.getFinancialRestrictionsGlobalStats(req.data._id, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function getFinancialRestrictionsUsersStats(req, res) {
    try {
        const filters = req.query;
        const result = await accountingOperationsManagmentFunctions.getFinancialRestrictionsUsersStats(req.data._id, Number(filters.pageNumber), Number(filters.pageSize), getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

module.exports = {
    getDailyRestrictions,
    getDailyRestrictionsTransfers,
    getAccountingRestrictions,
    getFinancialRestrictionsGlobalStats,
    getFinancialRestrictionsUsersStats
}