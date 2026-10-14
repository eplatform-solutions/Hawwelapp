const rolesRouter = require("express").Router();

const rolesController = require("../../controllers/roles");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
} = require("../../middlewares");

const {
    validateJWT
} = authMiddlewares;

rolesRouter.post("/create",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Role Name", fieldValue: bodyData?.name, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Role Description", fieldValue: bodyData?.description, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Permissions", fieldValue: bodyData?.permissions, dataTypes: ["array"], isRequiredValue: false },
            ...bodyData?.permissions ? bodyData?.permissions.map((permission, permissionIndex) => (
                { fieldName: `Permission Id In Index: ${permissionIndex}`, fieldValue: permission, dataTypes: ["ObjectId"], isRequiredValue: true }
            )) : []
        ], res, next);
    },
    rolesController.postCreateRole
);

rolesRouter.get("/info/:roleId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Role Id", fieldValue: req.params.roleId, dataTypes: ["ObjectId"], isRequiredValue: true }
        ], res, next);
    },
    rolesController.getRoleInfo
);

rolesRouter.get("/all",
    validateJWT,
    rolesController.getAllRoles
);

rolesRouter.put("/update/:roleId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Permissions", fieldValue: bodyData?.permissions, dataTypes: ["array"], isRequiredValue: false },
            ...bodyData?.permissions?.length > 0 ? bodyData?.permissions.map((permission, index) => (
                { fieldName: `Id In Permission ${index}`, fieldValue: permission, dataTypes: ["ObjectId"], isRequiredValue: true }
            )) : [],
        ], res, next);
    },
    rolesController.putRoleInfo
);

rolesRouter.delete("/delete/:roleId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Role Id", fieldValue: req.params.roleId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    rolesController.deleteRole
);

module.exports = rolesRouter;