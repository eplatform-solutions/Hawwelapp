// Verifies that the configured sanctions-screening provider is reachable and
// actually returns hits, BEFORE COMPLIANCE_SCREENING_ENABLED is turned on.
//
// The transfer gate fails closed, so enabling screening against a provider
// that answers 401/timeout would block every transfer on the platform. Run
// this first:
//
//   NODE_ENV=production node scripts/check-screening.js
//
// It exits non-zero unless the provider is reachable AND flags a name that is
// on every sanctions list - i.e. the list is really loaded, not just an
// endpoint that returns 200 with no data.
const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const { screenParty } = require("../helpers/compliance/screening");
const {
    SCREENING_BASE_URL,
    SCREENING_DATASET,
    SCREENING_API_KEY,
    SCREENING_ENABLED,
    SCREENING_FAIL_OPEN,
    SCREENING_BLOCK_SCORE,
    SCREENING_REVIEW_SCORE,
} = require("../constants/compliance");

// Names that must produce a hit against any real sanctions dataset, and one
// that should stay clean. The control name guards against a provider that
// simply matches everything.
const MUST_HIT = [
    { name: "Vladimir Putin", country: "ru" },
    { name: "Kim Jong Un", country: "kp" },
];
const MUST_PASS = [
    { name: "Zzqx Vbnmqwe Ploktr", country: "de" },
];

async function main() {
    console.log("Screening configuration");
    console.log(`  endpoint : ${SCREENING_BASE_URL}`);
    console.log(`  dataset  : ${SCREENING_DATASET}`);
    console.log(`  api key  : ${SCREENING_API_KEY ? "set" : "NOT SET"}`);
    console.log(`  enabled  : ${SCREENING_ENABLED}`);
    console.log(`  fail open: ${SCREENING_FAIL_OPEN}`);
    console.log(`  scores   : review >= ${SCREENING_REVIEW_SCORE}, block >= ${SCREENING_BLOCK_SCORE}`);
    console.log("");

    let failures = 0;

    for (const subject of MUST_HIT) {
        const result = await screenParty(subject.name, subject.country);
        if (!result.available) {
            console.error(`  FAIL  ${subject.name}: provider unreachable (${result.reason})`);
            failures += 1;
            continue;
        }
        if (result.decision === "pass") {
            console.error(`  FAIL  ${subject.name}: expected a hit, got a pass (top score ${result.topScore})`);
            failures += 1;
            continue;
        }
        console.log(`  ok    ${subject.name}: ${result.decision} (score ${result.topScore.toFixed(2)}, ${result.matches.length} match(es))`);
    }

    for (const subject of MUST_PASS) {
        const result = await screenParty(subject.name, subject.country);
        if (!result.available) {
            console.error(`  FAIL  control name: provider unreachable (${result.reason})`);
            failures += 1;
            continue;
        }
        if (result.decision !== "pass") {
            console.error(`  FAIL  control name matched (score ${result.topScore}) - the matcher is too loose`);
            failures += 1;
            continue;
        }
        console.log(`  ok    control name passes cleanly`);
    }

    console.log("");
    if (failures > 0) {
        console.error(`${failures} check(s) failed. Do NOT set COMPLIANCE_SCREENING_ENABLED=true yet.`);
        console.error("Either supply COMPLIANCE_SCREENING_API_KEY, or point");
        console.error("COMPLIANCE_SCREENING_BASE_URL at a self-hosted yente instance.");
        process.exit(1);
    }
    console.log("All checks passed. It is safe to set COMPLIANCE_SCREENING_ENABLED=true.");
    process.exit(0);
}

main().catch((err) => {
    console.error("[check-screening]", err?.message || err);
    process.exit(1);
});
