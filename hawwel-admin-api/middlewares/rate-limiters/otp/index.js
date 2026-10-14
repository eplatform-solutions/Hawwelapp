const {
    sendOtpRateLimiter,
    verifyOtpRateLimiter
} = require("../../../config/rate-limiters/otp");

const { consumeOrRespond } = require("../../../helpers/rate_limit");

const sendOtpRateLimitMiddleware = async (req, res, next) => {
    const email = req.body?.email;
    const mobilePhone = req.body?.mobilePhone;
    const typeOfUse = req.body?.typeOfUse;
    const key = `${req.ip}_${email ?? mobilePhone}_${typeOfUse}`;
    await consumeOrRespond(sendOtpRateLimiter, key, res, next);
};

const verifyOtpRateLimitMiddleware = async (req, res, next) => {
    const session = req.body?.session;
    const key = `${req.ip}_${session}`;
    await consumeOrRespond(verifyOtpRateLimiter, key, res, next);
};

module.exports = {
    sendOtpRateLimitMiddleware,
    verifyOtpRateLimitMiddleware
};
