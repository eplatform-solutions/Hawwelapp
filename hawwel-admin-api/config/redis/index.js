const Redis = require("ioredis");

const redis = new Redis({
    host: process.env.REDIS_HOST || "127.0.0.1",
    port: Number(process.env.REDIS_PORT) || 6379,
    password: process.env.REDIS_PASSWORD || undefined,
    db: 1,
    // Keep retrying in the background instead of piling up unhandled
    // connection errors - rate limiters fail open via insuranceLimiter
    // (see helpers/rate_limit) while Redis is unreachable.
    maxRetriesPerRequest: 1,
    lazyConnect: false,
});

redis.on("error", (err) => {
    console.error(`[Redis] connection error: ${err.message}`);
});

module.exports = redis;