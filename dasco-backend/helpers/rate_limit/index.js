const { RateLimiterRedis, RateLimiterMemory, RateLimiterRes } = require("rate-limiter-flexible");

const redis = require("../../config/redis");

// Every Redis-backed limiter gets an in-memory fallback with the same
// points/duration/blockDuration, so a Redis outage degrades rate limiting
// to a per-process approximation instead of taking down the whole API -
// see consumeOrRespond() below for the other half of this: only a genuine
// rate-limit hit (RateLimiterRes) should ever produce a 429.
function createRedisRateLimiter({ keyPrefix, points, duration, blockDuration }) {
    return new RateLimiterRedis({
        storeClient: redis,
        keyPrefix,
        points,
        duration,
        blockDuration,
        insuranceLimiter: new RateLimiterMemory({ points, duration, blockDuration }),
    });
}

async function consumeOrRespond(limiter, key, res, next) {
    try {
        await limiter.consume(key);
        next();
    } catch (rejRes) {
        if (rejRes instanceof RateLimiterRes) {
            res.status(429).json({
                msg: "Too many requests !!",
                error: true,
                data: {
                    retryAfter: Math.round(rejRes.msBeforeNext / 1000),
                },
            });
            return;
        }
        // Not an actual rate-limit rejection - a real error (e.g. both the
        // Redis and the insurance limiter failed). Fail open rather than
        // block every request in the app.
        console.error(`[RateLimit] consume() failed, allowing request through: ${rejRes?.message || rejRes}`);
        next();
    }
}

module.exports = {
    createRedisRateLimiter,
    consumeOrRespond,
};
