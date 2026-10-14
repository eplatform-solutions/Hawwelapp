/**
 * Regression check: netAmount (fee deduction) must not drift from
 * IEEE-754 float rounding error. No DB/network needed.
 *   node scripts/manual-test-money-precision.js
 */

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

const { calculateNetAmount } = require("../helpers/money");

// A case where plain JS float arithmetic (amount - amount*fee/100) is known
// to drift from the mathematically exact result.
const floatProneAmount = 0.1 + 0.2; // 0.30000000000000004 in plain JS float math
check(
    "0.1 + 0.2 style float noise is absorbed (no fee case)",
    calculateNetAmount(floatProneAmount, 0) === 0.3
);

check(
    "100 with 1% fee -> exactly 99",
    calculateNetAmount(100, 1) === 99
);

check(
    "100.1 with 2.5% fee -> exactly 97.5975",
    calculateNetAmount(100.1, 2.5) === 97.5975
);

check(
    "0 fee returns the amount unchanged",
    calculateNetAmount(123.456, 0) === 123.456
);

console.log(`\n=== RESULT: ${passCount} passed, ${failCount} failed ===`);
process.exit(failCount > 0 ? 1 : 0);
