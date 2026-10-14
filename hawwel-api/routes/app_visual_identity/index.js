const appVisualIdentityRouter = require("express").Router();

const appVisualIdentityController = require("../../controllers/app_visual_identity");

appVisualIdentityRouter.get("/public", appVisualIdentityController.getPublicAppVisualIdentity);

module.exports = appVisualIdentityRouter;
