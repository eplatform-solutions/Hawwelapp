const quickControlRouter = require("express").Router();

const quickControlController = require("../../controllers/quick_control");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    appIdentityMiddlewares,
    filesMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

const {
    uploadAppIdentitySingleFile,
} = appIdentityMiddlewares;

const {
    validateIsExistErrorInFiles,
    verifyRealFileType,
} = filesMiddlewares;

quickControlRouter.get("/system-overview", validateJWT, quickControlController.getSystemOverview);

quickControlRouter.get("/wallet-balances", validateJWT, quickControlController.getWalletBalances);

quickControlRouter.put("/update-system-settings",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Is Transfer Disabled", fieldValue: bodyData?.isTransferDisabled, dataTypes: ["boolean"], isRequiredValue: false },
            { fieldName: "Is Maintenance Mode", fieldValue: bodyData?.isMaintenanceMode, dataTypes: ["boolean"], isRequiredValue: false },
            { fieldName: "App Visual Identity", fieldValue: bodyData?.appVisualIdentity, dataTypes: ["object"], isRequiredValue: false },
        ], res, next);
    },
    quickControlController.putUpdateSystemSettings
);

quickControlRouter.put("/update-app-logo",
    validateJWT,
    uploadAppIdentitySingleFile("logoImage"),
    validateIsExistErrorInFiles,
    verifyRealFileType,
    quickControlController.putUpdateAppLogo
);

quickControlRouter.put("/update-app-background-image",
    validateJWT,
    uploadAppIdentitySingleFile("backgroundImage"),
    validateIsExistErrorInFiles,
    verifyRealFileType,
    quickControlController.putUpdateAppBackgroundImage
);

module.exports = quickControlRouter;