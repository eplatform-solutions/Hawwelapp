const kycRouter = require("express").Router();

const kycController = require("../../controllers/kyc");

const {
    authMiddlewares,
    rateLimitsMiddlewares,
    kycMiddlewares,
} = require("../../middlewares");

const {
    validateJWT
} = authMiddlewares;

const {
    kycRateLimitersMiddlewares
} = rateLimitsMiddlewares;

const {
    kycUploadRateLimitMiddleware
} = kycRateLimitersMiddlewares;

const {
    uploadKycFilesPair,
    validateKycFilesPair,
    verifyKycFilesPair,
} = kycMiddlewares;

kycRouter.post("/create",
    validateJWT,
    kycUploadRateLimitMiddleware,
    uploadKycFilesPair,
    validateKycFilesPair,
    verifyKycFilesPair,
    kycController.postCreate
);

module.exports = kycRouter;