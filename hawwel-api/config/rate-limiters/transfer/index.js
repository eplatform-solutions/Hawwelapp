const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const transferCreateRateLimiter = createRedisRateLimiter({
    keyPrefix: "transfer",
    points: 5,
    duration: 60,
});

module.exports = {
    transferCreateRateLimiter,
};
