const authRateLimitersMiddlewares = require("./auth");

const otpRateLimitersMiddlewares = require("./otp");

const paymentMethodRateLimitersMiddlewares = require("./payment_methods");

module.exports = {
    authRateLimitersMiddlewares,
    otpRateLimitersMiddlewares,
    paymentMethodRateLimitersMiddlewares
};