const {
    transferCreateRateLimiter
} = require("../../../config/rate-limiters/transfer");

const { consumeOrRespond } = require("../../../helpers/rate_limit");

const transferCreateRateLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id ?? req.ip;
    await consumeOrRespond(transferCreateRateLimiter, key, res, next);
};

module.exports = {
    transferCreateRateLimitMiddleware
};
