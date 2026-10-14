// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for cities management
const citiesOperationsManagmentFunctions = require("../../repositories/cities");

async function postCreateCity(req, res) {
    try {
        const result = await citiesOperationsManagmentFunctions.createCity(req.data._id, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "country") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllCitiesInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await citiesOperationsManagmentFunctions.getAllCitiesInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putCityInfo(req, res) {
    try {
        const result = await citiesOperationsManagmentFunctions.updateCityInfo(req.data._id, req.params.cityId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function deleteCity(req, res) {
    try {
        const result = await citiesOperationsManagmentFunctions.deleteCity(req.data._id, req.params.cityId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function postBindPaymentMethodsToCity(req, res) {
    try {
        const result = await citiesOperationsManagmentFunctions.bindPaymentMethodsToCity(req.data._id, req.params.cityId, req.body.paymentMethods, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postCreateCity,
    getAllCitiesInsideThePage,
    putCityInfo,
    deleteCity,
    postBindPaymentMethodsToCity
}