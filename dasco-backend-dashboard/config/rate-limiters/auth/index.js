const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const loginRateLimiter = createRedisRateLimiter({
    keyPrefix: "login",
    points: 5,
    duration: 60,
    blockDuration: 300,
});

module.exports = {
    loginRateLimiter,
};
