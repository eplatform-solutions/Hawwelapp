const {
    loginRateLimiter,
    signupRateLimiter,
    forgotPasswordRateLimiter,
    resetPasswordRateLimiter
} = require("../../../config/rate-limiters/auth");

const { consumeOrRespond } = require("../../../helpers/rate_limit");

const loginRateLimitMiddleware = async (req, res, next) => {
    const email = req.body?.email;
    const mobilePhone = req.body?.mobilePhone;
    const key = `${req.ip}_${email ?? mobilePhone}`;
    await consumeOrRespond(loginRateLimiter, key, res, next);
};

const signupRateLimitMiddleware = async (req, res, next) => {
    const email = req.body?.email;
    const mobilePhone = req.body?.mobilePhone;
    const key = `${req.ip}_${email ?? mobilePhone}`;
    await consumeOrRespond(signupRateLimiter, key, res, next);
};

const forgotPasswordRateLimitMiddleware = async (req, res, next) => {
    const email = req.body?.email;
    const mobilePhone = req.body?.mobilePhone;
    const key = `${req.ip}_${email ?? mobilePhone}`;
    await consumeOrRespond(forgotPasswordRateLimiter, key, res, next);
};

const resetPasswordRateLimitMiddleware = async (req, res, next) => {
    const session = req.body?.session;
    const key = `${req.ip}_${session}`;
    await consumeOrRespond(resetPasswordRateLimiter, key, res, next);
};

module.exports = {
    loginRateLimitMiddleware,
    signupRateLimitMiddleware,
    forgotPasswordRateLimitMiddleware,
    resetPasswordRateLimitMiddleware
};
