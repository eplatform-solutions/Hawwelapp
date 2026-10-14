const { post } = require("axios");

const {
    SCREENING_BLOCK_SCORE,
    SCREENING_REVIEW_SCORE,
    SCREENING_FAIL_OPEN,
    SCREENING_CACHE_TTL_MS,
    SCREENING_TIMEOUT_MS,
    SCREENING_BASE_URL,
    SCREENING_DATASET,
    SCREENING_API_KEY,
} = require("../../constants/compliance");

// Sanctions / PEP screening against an OpenSanctions-compatible endpoint
// (the self-hostable "yente" service speaks the same /match API, so the same
// code works whether the list is hosted by us or by a commercial provider).

function logCompliance(event, payload = {}) {
    console.log(`[COMPLIANCE] ${event} ${JSON.stringify(payload)}`);
}

// Arabic names reach us in many shapes: with/without "Al", with different
// Latin transliterations, and with diacritics. Normalising before caching
// keeps the cache useful and the logs readable.
function normalizeName(name) {
    return String(name || "")
        .normalize("NFKD")
        .replace(/[ً-ٰٟ]/g, "")
        .replace(/[^\p{L}\p{N}\s]/gu, " ")
        .replace(/\s+/g, " ")
        .trim()
        .toLowerCase();
}

const cache = new Map();

function readCache(key) {
    const hit = cache.get(key);
    if (!hit) return null;
    if (Date.now() - hit.at > SCREENING_CACHE_TTL_MS) {
        cache.delete(key);
        return null;
    }
    return hit.value;
}

function writeCache(key, value) {
    // Bounded so a flood of distinct names cannot grow the process heap.
    if (cache.size > 5000) {
        cache.clear();
    }
    cache.set(key, { at: Date.now(), value });
}

function buildQuery(name, countryCode) {
    const properties = { name: [name] };
    if (countryCode) {
        properties.country = [String(countryCode).toLowerCase()];
    }
    return {
        queries: {
            party: {
                schema: "Person",
                properties,
            },
        },
    };
}

// Returns { available, matches } where matches are already sorted by score.
async function queryProvider(name, countryCode) {
    const url = `${SCREENING_BASE_URL}/match/${encodeURIComponent(SCREENING_DATASET)}`;
    const headers = { "Content-Type": "application/json" };
    if (SCREENING_API_KEY) {
        headers.Authorization = `ApiKey ${SCREENING_API_KEY}`;
    }
    const response = await post(url, buildQuery(name, countryCode), {
        headers,
        timeout: SCREENING_TIMEOUT_MS,
        // Cap the body so a misconfigured endpoint cannot stall the request.
        maxContentLength: 2 * 1024 * 1024,
    });
    const results = response?.data?.responses?.party?.results || [];
    const matches = results
        .map((result) => ({
            entityId: String(result?.id || ""),
            caption: String(result?.caption || ""),
            datasets: Array.isArray(result?.datasets) ? result.datasets.map(String) : [],
            score: Number(result?.score) || 0,
        }))
        .filter((match) => match.entityId)
        .sort((a, b) => b.score - a.score);
    return { available: true, matches };
}

/**
 * Screen one party (sender or receiver) against the configured list.
 *
 * Resolves to:
 *   { available, decision, topScore, matches }
 * where decision is "pass" | "review" | "block". When the provider is
 * unreachable, `available` is false and the decision follows
 * COMPLIANCE_SCREENING_FAIL_OPEN - which defaults to failing closed.
 */
async function screenParty(name, countryCode) {
    const normalized = normalizeName(name);
    if (!normalized) {
        // An empty name cannot be screened; treat it as unscreenable rather
        // than as a clean pass.
        return { available: false, decision: SCREENING_FAIL_OPEN ? "pass" : "block", topScore: 0, matches: [], reason: "empty-name" };
    }

    const cacheKey = `${normalized}|${String(countryCode || "").toLowerCase()}`;
    const cached = readCache(cacheKey);
    if (cached) {
        return cached;
    }

    let outcome;
    try {
        const { matches } = await queryProvider(normalized, countryCode);
        const topScore = matches.length ? matches[0].score : 0;
        let decision = "pass";
        if (topScore >= SCREENING_BLOCK_SCORE) {
            decision = "block";
        } else if (topScore >= SCREENING_REVIEW_SCORE) {
            decision = "review";
        }
        outcome = {
            available: true,
            decision,
            topScore,
            // Only keep what a reviewer needs; full payloads are large.
            matches: matches.filter((match) => match.score >= SCREENING_REVIEW_SCORE).slice(0, 10),
        };
        writeCache(cacheKey, outcome);
    }
    catch (err) {
        const reason = err?.response?.status
            ? `provider responded ${err.response.status}`
            : (err?.code || err?.message || "unknown error");
        logCompliance("screening provider unavailable", { reason, failOpen: SCREENING_FAIL_OPEN });
        // Deliberately not cached: the next attempt should retry the provider.
        outcome = {
            available: false,
            decision: SCREENING_FAIL_OPEN ? "pass" : "block",
            topScore: 0,
            matches: [],
            reason,
        };
    }
    return outcome;
}

module.exports = {
    screenParty,
    normalizeName,
    logCompliance,
};
