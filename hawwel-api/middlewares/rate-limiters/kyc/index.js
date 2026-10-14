const {
    kycUploadRateLimiter
} = require("../../../config/rate-limiters/kyc");

const { consumeOrRespond } = require("../../../helpers/rate_limit");

const kycUploadRateLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id;
    await consumeOrRespond(kycUploadRateLimiter, key, res, next);
};

module.exports = {
    kycUploadRateLimitMiddleware
};
