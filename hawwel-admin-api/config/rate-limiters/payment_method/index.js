const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const paymentMethodLogoUploadRateLimiter = createRedisRateLimiter({
    keyPrefix: "payment_method_log_upload",
    points: 10,
    duration: 600,
    blockDuration: 1800,
});

module.exports = {
    paymentMethodLogoUploadRateLimiter,
};
