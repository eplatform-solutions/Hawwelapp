// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for permissions management
const permissionsOperationsManagmentFunctions = require("../../repositories/permissions");

async function getPermissionInfo(req, res) {
    try {
        const result = await permissionsOperationsManagmentFunctions.getPermission(req.data._id, req.params.permissionId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getAllPermissions(req, res) {
    try {
        const result = await permissionsOperationsManagmentFunctions.getAllPermissions(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getPermissionInfo,
    getAllPermissions,
}