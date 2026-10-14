// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for regions management
const regionsOperationsManagmentFunctions = require("../../repositories/regions");

async function postCreateRegion(req, res) {
    try {
        const result = await regionsOperationsManagmentFunctions.createRegion(req.data._id, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "name") {
            filtersObject["$or"] = [
                { "name.ar": { $regex: new RegExp(`^${filters[objectKey]}`, 'i') } },
                { "name.en": { $regex: new RegExp(`^${filters[objectKey]}`, 'i') } }
            ];
        }
        if (objectKey === "city") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllRegionsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await regionsOperationsManagmentFunctions.getAllRegionsInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putRegionInfo(req, res) {
    try {
        const result = await regionsOperationsManagmentFunctions.updateRegionInfo(req.data._id, req.params.regionId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function deleteRegion(req, res) {
    try {
        const result = await regionsOperationsManagmentFunctions.deleteRegion(req.data._id, req.params.regionId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

module.exports = {
    postCreateRegion,
    getAllRegionsInsideThePage,
    putRegionInfo,
    deleteRegion
}
