const { RESEND_COOLDOWN_MS, ATTEMPT_WINDOW_MS, MAX_ATTEMPTS, LOCK_DURATIONS } = require("../../constants/verification_code");

function checkResendCooldown(lastSentAt) {
    if (!lastSentAt) {
        return {
            msg: "Resend allowed !!",
            error: false,
            data: {
                retryAfterSeconds: 0
            }
        }
    }
    const remainingMs =
        RESEND_COOLDOWN_MS - (Date.now() - lastSentAt.getTime());
    if (remainingMs > 0) {
        return {
            msg: "Sorry, Please Wait Before Resending !!",
            error: true,
            data: {
                retryAfterSeconds: Math.ceil(remainingMs / 1000)
            }
        }
    }
    return {
        msg: "Resend Allowed !!",
        error: false,
        data: {}
    }
}

function refreshAttemptWindow(attemptWindowStartedAt, attemptsCount) {
    if (!attemptWindowStartedAt) {
        attemptWindowStartedAt = new Date();
    }
    const now = Date.now();
    if (now - attemptWindowStartedAt.getTime() > ATTEMPT_WINDOW_MS) {
        attemptsCount = 0;
        attemptWindowStartedAt = new Date();
    }
    lastAttemptAt = new Date();
    return {
        attemptWindowStartedAt,
        attemptsCount,
        lastAttemptAt
    }
}

function applyAttemptLock(attemptsCount) {
    if (attemptsCount >= MAX_ATTEMPTS) {
        const violationCount = Math.floor(
            attemptsCount / MAX_ATTEMPTS
        );
        const lockLevelIndex = Math.min(
            violationCount - 1,
            LOCK_DURATIONS.length - 1
        );
        const lockHours = LOCK_DURATIONS[lockLevelIndex];
        const blockedUntil = new Date(
            Date.now() + lockHours * 60 * 60 * 1000
        );
        return {
            lockLevel: lockLevelIndex + 1,
            blockedUntil,
        };
    }
    return null;
}

function checkExpiration(expiresAt) {
    if (expiresAt && expiresAt < Date.now()) {
        return {
            msg: "Sorry, Verification Code Expired !!",
            error: true,
            data: {}
        }
    }
    return {
        msg: "Code is Valid !!",
        error: false,
        data: {}
    }
}

function checkLock(blockedUntil) {
    if (blockedUntil && blockedUntil > Date.now()) {
        const remainingMs = blockedUntil - Date.now();
        return {
            msg: "Sorry, Too Many Attempts, Please Try Again Later !!",
            error: true,
            data: {
                retryAfterSeconds: Math.ceil(remainingMs / 1000)
            }
        };
    }

    return {
        msg: "Not locked !!",
        error: false,
        data: {}
    };
}

module.exports = {
    checkResendCooldown,
    refreshAttemptWindow,
    applyAttemptLock,
    checkExpiration,
    checkLock
}