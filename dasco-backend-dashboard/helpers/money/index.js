const Decimal = require("decimal.js");

// Crypto amounts need more than IEEE-754 double precision can reliably give
// for repeated arithmetic (percentage fee deduction here). 8 decimal places
// covers every currency this platform currently supports (USDT/USDC) with
// room to spare; the DB field itself stays a plain Number (Decimal128 would
// need a separate, carefully-planned migration on a live collection), but
// every value written to it is computed via Decimal first and rounded once
// at the end instead of accumulating float error mid-calculation.
const MONEY_DECIMAL_PLACES = 8;

// netAmount = amount - amount * (feePercent / 100), rounded once at the end.
function calculateNetAmount(amount, feePercent) {
    const net = new Decimal(amount).minus(
        new Decimal(amount).times(feePercent).dividedBy(100)
    );
    return net.toDecimalPlaces(MONEY_DECIMAL_PLACES).toNumber();
}

module.exports = {
    MONEY_DECIMAL_PLACES,
    calculateNetAmount,
};
