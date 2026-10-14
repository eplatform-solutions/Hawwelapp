const overviewRouter = require("express").Router();

const overviewController = require("../../controllers/overview");

const {
    authMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

overviewRouter.get("/statistics", validateJWT, overviewController.getStatistics);

module.exports = overviewRouter;