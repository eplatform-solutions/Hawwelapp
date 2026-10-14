const permissionsRouter = require("express").Router();

const permissionsController = require("../../controllers/permissions");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
} = require("../../middlewares");

const {
    validateJWT
} = authMiddlewares;

permissionsRouter.get("/info/:permissionId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: `Permissions Id`, fieldValue: req.params.permissionId, dataTypes: ["ObjectId"], isRequiredValue: true }
        ], res, next);
    },
    permissionsController.getPermissionInfo
);

permissionsRouter.get("/all",
    validateJWT,
    permissionsController.getAllPermissions
);

module.exports = permissionsRouter;