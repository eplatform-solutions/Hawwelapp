const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const employeesRepository = require("../../repositories/employees");

async function postCreateEmployee(req, res) {
    try {
        const result = await employeesRepository.createEmployee(req.data._id, { fullName, email, mobilePhone, password, city } = req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getEmployeesCount(req, res) {
    try {
        const result = await employeesRepository.getEmployeesCount(req.data._id, getFiltersObject(req.query), req.query.language);
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
        if (objectKey === "fullName") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
        if (objectKey === "email") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "mobilePhone") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "city") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllEmployeesInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await employeesRepository.getAllEmployeesInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putEmployeeInfo(req, res) {
    try {
        const result = await employeesRepository.updateEmployeeInfo(req.data._id, req.params.employeeId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deleteEmployee(req, res) {
    try {
        const result = await employeesRepository.deleteEmployee(req.data._id, req.params.employeeId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getEmployeeInfo(req, res) {
    try {
        const result = await employeesRepository.getEmployeeInfo(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getEmployeeTransfers(req, res) {
    try {
        const { language, pageNumber, pageSize, status, today, fromDate, toDate } = req.query;
        const result = await employeesRepository.getTransfersForEmployeeCity(
            req.data._id,
            Number(pageNumber),
            Number(pageSize),
            { status, today, fromDate, toDate },
            language
        );
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postCreateEmployee,
    getEmployeesCount,
    getAllEmployeesInsideThePage,
    putEmployeeInfo,
    deleteEmployee,
    getEmployeeInfo,
    getEmployeeTransfers,
}