const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const complianceOperationsManagmentFunctions = require("../../repositories/compliance");

// Whitelist rather than passing req.query straight through, so an unexpected
// query parameter can never reach the aggregation as a filter.
function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "type") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "severity") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "fromDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "toDate") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllComplianceAlertsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await complianceOperationsManagmentFunctions.getAllComplianceAlertsInsideThePage(
            req.data._id,
            Number(filters.pageNumber),
            Number(filters.pageSize),
            getFiltersObject(filters),
            filters.language
        );
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getComplianceAlertsStats(req, res) {
    try {
        const result = await complianceOperationsManagmentFunctions.getComplianceAlertsStats(
            req.data._id,
            req.query.language
        );
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putResolveComplianceAlert(req, res) {
    try {
        const result = await complianceOperationsManagmentFunctions.resolveComplianceAlert(
            req.data._id,
            req.params.alertId,
            req.body.status,
            req.body.reviewNote,
            req.query.language
        );
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAllComplianceAlertsInsideThePage,
    getComplianceAlertsStats,
    putResolveComplianceAlert,
}
