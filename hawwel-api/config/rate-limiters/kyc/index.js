const { createRedisRateLimiter } = require("../../../helpers/rate_limit");

const kycUploadRateLimiter = createRedisRateLimiter({
    keyPrefix: "kyc_upload",
    points: 10,
    duration: 600,
    blockDuration: 1800,
});

module.exports = {
    kycUploadRateLimiter,
};
