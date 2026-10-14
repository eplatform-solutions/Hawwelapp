const technicalSupportRouter = require("express").Router();

const technicalSupportController = require("../../controllers/technical_support");

const {
    authMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

technicalSupportRouter.get("/page-content", validateJWT, technicalSupportController.getContent);

module.exports = technicalSupportRouter;