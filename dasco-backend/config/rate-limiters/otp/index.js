const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const sendOtpRateLimiter = createRedisRateLimiter({
    keyPrefix: "otp",
    points: 3,
    duration: 60,
});

const verifyOtpRateLimiter = createRedisRateLimiter({
    keyPrefix: "verify_otp",
    points: 3,
    duration: 300,
    blockDuration: 900,
});

module.exports = {
    sendOtpRateLimiter,
    verifyOtpRateLimiter,
};
