const authRateLimitersMiddlewares = require("./auth");

const kycRateLimitersMiddlewares = require("./kyc");

const otpRateLimitersMiddlewares = require("./otp");

const transferRateLimitersMiddlewares = require("./transfer");

const userRateLimitersMiddlewares = require("./user");

module.exports = {
    authRateLimitersMiddlewares,
    kycRateLimitersMiddlewares,
    otpRateLimitersMiddlewares,
    transferRateLimitersMiddlewares,
    userRateLimitersMiddlewares
};