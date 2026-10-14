const {
    userInfoRateLimiter,
    userUpdateRateLimiter,
    changeProfileImageRateLimiter,
    changePasswordRateLimiter,
    change2faRateLimiter,
} = require("../../../config/rate-limiters/user");

const { consumeOrRespond } = require("../../../helpers/rate_limit");

const userInfoRateLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id || req.ip;
    await consumeOrRespond(userInfoRateLimiter, key, res, next);
};

const userUpdateRateLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id || req.ip;
    await consumeOrRespond(userUpdateRateLimiter, key, res, next);
};

const changeProfileImageLimiterRateLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id || req.ip;
    await consumeOrRespond(changeProfileImageRateLimiter, key, res, next);
};

const changePasswordLimiterRateLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id || req.ip;
    await consumeOrRespond(changePasswordRateLimiter, key, res, next);
};

const change2faLimiterRateLimitMiddleware = async (req, res, next) => {
    const key = req?.data?._id || req.ip;
    await consumeOrRespond(change2faRateLimiter, key, res, next);
};

module.exports = {
    userInfoRateLimitMiddleware,
    userUpdateRateLimitMiddleware,
    changeProfileImageLimiterRateLimitMiddleware,
    changePasswordLimiterRateLimitMiddleware,
    change2faLimiterRateLimitMiddleware,
};
