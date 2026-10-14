/**
 * Regression check: rate limiting must fail OPEN when Redis is unreachable,
 * not take down every request with a false 429. Run with Redis NOT running
 * (or pointed at an unreachable host) so consume() actually fails.
 *   REDIS_HOST=127.0.0.1 REDIS_PORT=1 node scripts/manual-test-redis-fail-open.js
 */

process.env.REDIS_PORT = process.env.REDIS_PORT || "1"; // nothing listens here

let passCount = 0;
let failCount = 0;

function check(label, condition) {
    if (condition) {
        passCount++;
        console.log(`  PASS: ${label}`);
    } else {
        failCount++;
        console.log(`  FAIL: ${label}`);
    }
}

(async () => {
    const { createRedisRateLimiter, consumeOrRespond } = require("../helpers/rate_limit");

    const limiter = createRedisRateLimiter({
        keyPrefix: "fail_open_test",
        points: 2,
        duration: 60,
    });

    let nextCalled = false;
    let statusCode = null;
    const fakeRes = {
        status(code) {
            statusCode = code;
            return this;
        },
        json() { return this; },
    };
    const fakeNext = () => { nextCalled = true; };

    await consumeOrRespond(limiter, "some-key", fakeRes, fakeNext);

    check("request was allowed through (next() called) despite Redis being unreachable", nextCalled === true);
    check("no 429 was sent", statusCode !== 429);

    console.log(`\n=== RESULT: ${passCount} passed, ${failCount} failed ===`);
    process.exit(failCount > 0 ? 1 : 0);
})();
