const {
    loginRateLimiter,
} = require("../../../config/rate-limiters/auth");

const { consumeOrRespond } = require("../../../helpers/rate_limit");

const loginRateLimitMiddleware = async (req, res, next) => {
    const email = req.body?.email;
    const mobilePhone = req.body?.mobilePhone;
    const key = `${req.ip}_${email ?? mobilePhone}`;
    await consumeOrRespond(loginRateLimiter, key, res, next);
};

module.exports = {
    loginRateLimitMiddleware,
};
