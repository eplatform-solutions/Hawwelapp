const authRateLimiters = require("./auth");

const globalRateLimiters = require("./global");

const otpRateLimiters = require("./otp");

const paymentMethodRateLimiters = require("./payment_method");

module.exports = {
    authRateLimiters,
    globalRateLimiters,
    otpRateLimiters,
    paymentMethodRateLimiters,
};