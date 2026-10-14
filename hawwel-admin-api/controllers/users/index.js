const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const usersOPerationsManagmentFunctions = require("../../repositories/users");

async function getUserInfo(req, res) {
    try {
        const result = await usersOPerationsManagmentFunctions.getUserInfo(req.data._id, req.params.userId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "_id") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "name") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
        if (objectKey === "nickname") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
        if (objectKey === "fatherName") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
        if (objectKey === "country") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "mobilePhone") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "email") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "accountNumber") filtersObject[objectKey] = Number(filters[objectKey]);
        if (objectKey === "fromDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "toDate") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getUsersCount(req, res) {
    try {
        const result = await usersOPerationsManagmentFunctions.getUsersCount(req.data._id, getFiltersObject(req.query), req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getAllUsersInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await usersOPerationsManagmentFunctions.getAllUsersInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUserInfo(req, res) {
    try {
        delete req.body.password;
        delete req.body.accountNumber;
        delete req.body.imagePath;
        const result = await usersOPerationsManagmentFunctions.updateUserInfo(req.data._id, req.params.userId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deleteUser(req, res) {
    try {
        const result = await usersOPerationsManagmentFunctions.deleteUser(req.data._id, req.params.userId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        console.log(err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getUserInfo,
    getUsersCount,
    getAllUsersInsideThePage,
    putUserInfo,
    deleteUser
}