// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for roles management
const rolesOperationsManagmentFunctions = require("../../repositories/roles");

async function postCreateRole(req, res) {
    try {
        const { name, description, permissions } = req.body;
        const result = await rolesOperationsManagmentFunctions.createRole(req.data._id, name, description, permissions, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getRoleInfo(req, res) {
    try {
        const result = await rolesOperationsManagmentFunctions.getRole(req.data._id, req.params.roleId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getAllRoles(req, res) {
    try {
        const result = await rolesOperationsManagmentFunctions.getAllRoles(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putRoleInfo(req, res) {
    try {
        const result = await rolesOperationsManagmentFunctions.updateRoleInfo(req.data._id, req.params.roleId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        console.log(err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function deleteRole(req, res) {
    try {
        const result = await rolesOperationsManagmentFunctions.deleteRole(req.data._id, req.params.roleId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

module.exports = {
    postCreateRole,
    getRoleInfo,
    getAllRoles,
    putRoleInfo,
    deleteRole
}