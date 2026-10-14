const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const adminsOPerationsManagmentFunctions = require("../../repositories/admins");

async function postCreateAdmin(req, res) {
    try {
        const result = await adminsOPerationsManagmentFunctions.createAdmin(req.data._id, { userName, fullName, email, mobilePhone, password, role } = req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function getAdminInfo(req, res) {
    try {
        const result = await adminsOPerationsManagmentFunctions.getAdminInfo({ _id: req.data._id }, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "_id") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "fullName") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
        if (objectKey === "userName") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
        if (objectKey === "email") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "mobilePhone") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "role") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAdminsCount(req, res) {
    try {
        const result = await adminsOPerationsManagmentFunctions.getAdminsCount(req.data._id, getFiltersObject(req.query), req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function getAllAdminsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await adminsOPerationsManagmentFunctions.getAllAdminsInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function putAdminInfo(req, res) {
    try {
        const result = await adminsOPerationsManagmentFunctions.updateAdminInfo(req.data._id, req.params.adminId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function deleteAdmin(req, res) {
    try {
        const result = await adminsOPerationsManagmentFunctions.deleteAdmin(req.data._id, req.params.adminId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

module.exports = {
    getAdminInfo,
    getAdminsCount,
    getAllAdminsInsideThePage,
    postCreateAdmin,
    putAdminInfo,
    deleteAdmin
}