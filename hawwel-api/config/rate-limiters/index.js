const authRateLimiters = require("./auth");

const globalRateLimiters = require("./global");

const kycRateLimiters = require("./kyc");

const otpRateLimiters = require("./otp");

const transferRateLimiters = require("./transfer");

const userRateLimiters = require("./user");

module.exports = {
    authRateLimiters,
    globalRateLimiters,
    kycRateLimiters,
    otpRateLimiters,
    transferRateLimiters,
    userRateLimiters
};