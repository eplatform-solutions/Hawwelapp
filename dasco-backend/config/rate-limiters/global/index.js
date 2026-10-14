const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const globalRateLimiter = createRedisRateLimiter({
    keyPrefix: "global",
    points: 120,
    duration: 60,
});

module.exports = {
    globalRateLimiter,
};
