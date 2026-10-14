// Compliance thresholds and screening configuration.
//
// Every value is overridable from the environment so that a licensed partner
// can impose their own limits during onboarding without a code change - that
// request comes up in essentially every CASP/PI due-diligence review.

function numberFromEnv(name, fallback) {
    const raw = Number(process.env[name]);
    return Number.isFinite(raw) && raw > 0 ? raw : fallback;
}

function booleanFromEnv(name, fallback) {
    const raw = String(process.env[name] || "").trim().toLowerCase();
    if (raw === "true" || raw === "1") return true;
    if (raw === "false" || raw === "0") return false;
    return fallback;
}

// Name-match score (0..1) at or above which a screening hit is treated as a
// real hit. Arabic-to-Latin transliteration is noisy, so the review threshold
// is deliberately lower than the block threshold and routes to a human
// instead of silently passing.
const SCREENING_BLOCK_SCORE = numberFromEnv("COMPLIANCE_SCREENING_BLOCK_SCORE", 0.75);
const SCREENING_REVIEW_SCORE = numberFromEnv("COMPLIANCE_SCREENING_REVIEW_SCORE", 0.6);

// Master switch. Screening stays OFF until a provider is actually reachable,
// because this gate fails closed: enabling it against a misconfigured endpoint
// would block every single transfer. Verify with scripts/check-screening.js,
// then set COMPLIANCE_SCREENING_ENABLED=true.
const SCREENING_ENABLED = booleanFromEnv("COMPLIANCE_SCREENING_ENABLED", false);

// When the screening provider is unreachable we stop the transfer by default.
// Failing open on sanctions screening is the single finding most likely to end
// a partner's due diligence, so it must be an explicit, deliberate opt-out.
const SCREENING_FAIL_OPEN = booleanFromEnv("COMPLIANCE_SCREENING_FAIL_OPEN", false);

// Screening results are cached per normalised name; sanctions lists move
// slowly and this keeps transfer creation fast.
const SCREENING_CACHE_TTL_MS = numberFromEnv("COMPLIANCE_SCREENING_CACHE_TTL_MINUTES", 720) * 60 * 1000;
const SCREENING_TIMEOUT_MS = numberFromEnv("COMPLIANCE_SCREENING_TIMEOUT_MS", 8000);

// Default provider is an OpenSanctions "yente" instance, which can be
// self-hosted. Point COMPLIANCE_SCREENING_BASE_URL at a commercial provider's
// gateway to switch without touching this code.
const SCREENING_BASE_URL = String(process.env.COMPLIANCE_SCREENING_BASE_URL || "https://api.opensanctions.org").replace(/\/+$/, "");
const SCREENING_DATASET = String(process.env.COMPLIANCE_SCREENING_DATASET || "default").trim();
const SCREENING_API_KEY = String(process.env.COMPLIANCE_SCREENING_API_KEY || "").trim();

// Cumulative limits, denominated in the transfer's crypto symbol (USDT/USDC,
// both ~1 USD). A single-transfer cap already exists per payment method; these
// are the aggregate caps that stop structuring (many small transfers).
const LIMIT_DAILY_AMOUNT = numberFromEnv("COMPLIANCE_LIMIT_DAILY_AMOUNT", 3000);
const LIMIT_MONTHLY_AMOUNT = numberFromEnv("COMPLIANCE_LIMIT_MONTHLY_AMOUNT", 15000);
const LIMIT_DAILY_COUNT = numberFromEnv("COMPLIANCE_LIMIT_DAILY_COUNT", 10);
const LIMIT_MONTHLY_DISTINCT_RECEIVERS = numberFromEnv("COMPLIANCE_LIMIT_MONTHLY_DISTINCT_RECEIVERS", 15);

// Amount at or above which a transfer is flagged for enhanced due diligence
// (source-of-funds evidence). It does not block on its own.
const EDD_AMOUNT_THRESHOLD = numberFromEnv("COMPLIANCE_EDD_AMOUNT_THRESHOLD", 1000);

const ALERT_TYPES = [
    "sanctions-hit",
    "sanctions-review",
    "screening-unavailable",
    "velocity-breach",
    "edd-required",
];

const ALERT_STATUSES = ["open", "cleared", "confirmed"];

const ALERT_SEVERITIES = ["low", "medium", "high"];

const PARTY_TYPES = ["sender", "receiver"];

module.exports = {
    SCREENING_ENABLED,
    SCREENING_BLOCK_SCORE,
    SCREENING_REVIEW_SCORE,
    SCREENING_FAIL_OPEN,
    SCREENING_CACHE_TTL_MS,
    SCREENING_TIMEOUT_MS,
    SCREENING_BASE_URL,
    SCREENING_DATASET,
    SCREENING_API_KEY,
    LIMIT_DAILY_AMOUNT,
    LIMIT_MONTHLY_AMOUNT,
    LIMIT_DAILY_COUNT,
    LIMIT_MONTHLY_DISTINCT_RECEIVERS,
    EDD_AMOUNT_THRESHOLD,
    ALERT_TYPES,
    ALERT_STATUSES,
    ALERT_SEVERITIES,
    PARTY_TYPES,
};
