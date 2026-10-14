const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const loginRateLimiter = createRedisRateLimiter({
    keyPrefix: "login",
    points: 5,
    duration: 60,
    blockDuration: 300,
});

const signupRateLimiter = createRedisRateLimiter({
    keyPrefix: "signup",
    points: 3,
    duration: 60,
    blockDuration: 600,
});

const forgotPasswordRateLimiter = createRedisRateLimiter({
    keyPrefix: "forgot_password",
    points: 3,
    duration: 300,
    blockDuration: 900,
});

const resetPasswordRateLimiter = createRedisRateLimiter({
    keyPrefix: "reset_password",
    points: 5,
    duration: 300,
    blockDuration: 900,
});

module.exports = {
    loginRateLimiter,
    signupRateLimiter,
    forgotPasswordRateLimiter,
    resetPasswordRateLimiter,
};
