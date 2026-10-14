const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const userInfoRateLimiter = createRedisRateLimiter({
    keyPrefix: "user_info",
    points: 60,
    duration: 60,
});

const userUpdateRateLimiter = createRedisRateLimiter({
    keyPrefix: "user_update",
    points: 10,
    duration: 600,
    blockDuration: 1800,
});

const changeProfileImageRateLimiter = createRedisRateLimiter({
    keyPrefix: "profile_image",
    points: 5,
    duration: 600,
    blockDuration: 1800,
});

const changePasswordRateLimiter = createRedisRateLimiter({
    keyPrefix: "change_password",
    points: 3,
    duration: 900,
    blockDuration: 3600,
});

const change2faRateLimiter = createRedisRateLimiter({
    keyPrefix: "change_2fa",
    points: 10,
    duration: 600,
    blockDuration: 600,
});

module.exports = {
    userInfoRateLimiter,
    userUpdateRateLimiter,
    changeProfileImageRateLimiter,
    changePasswordRateLimiter,
    change2faRateLimiter,
};
