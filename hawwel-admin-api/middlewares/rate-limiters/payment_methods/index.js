const {
    paymentMethodLogoUploadRateLimiter
} = require("../../../config/rate-limiters/payment_method");

const { consumeOrRespond } = require("../../../helpers/rate_limit");

const paymentMethodLogoUploadLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id;
    await consumeOrRespond(paymentMethodLogoUploadRateLimiter, key, res, next);
};

module.exports = {
    paymentMethodLogoUploadLimitMiddleware
};
