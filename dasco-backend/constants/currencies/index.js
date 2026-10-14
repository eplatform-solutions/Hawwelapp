const CURRENCY_TYPES = ["crypto"];

const DEFAULT_CURRENCY_TYPE = CURRENCY_TYPES[0];

const SUPPORTED_FIAT_CURRENCIES = [
    "SYP",
    "USD",
];

const SUPPORTED_FIAT_CURRENCY_SYMBOLS = [
    "SYP",
    "USD"
];

const SUPPORTED_CRYPTO_CURRENCIES = [
    "USDT",
    "USDC",
];

const SUPPORTED_CRYPTO_CURRENCY_SYMBOLS = [
    "USDT",
    "USDC"
];

// USDC, not USDT. Tether never applied for MiCA authorisation and has said it
// will not; since 1 July 2026 no MiCA-licensed venue in the EEA may offer
// USDT, so a licensed EU partner cannot touch it. USDC is issued under
// Circle's EU e-money licence and is the only one of the two that survives
// here. USDT stays supported for existing transfers and for corridors outside
// the EEA, but it is no longer what a new sender is offered by default.
const DEFAULT_SEND_CURRENCY_SYMBOL = "USDC";

const SUPPORTED_CURRENCIES = {
    fiat: [],
    crypto: SUPPORTED_CRYPTO_CURRENCIES
};

const SUPPORTED_CURRENCY_SYMBOLS = {
    fiat: [],
    crypto: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS
};

module.exports = {
    CURRENCY_TYPES,
    DEFAULT_CURRENCY_TYPE,
    SUPPORTED_FIAT_CURRENCIES,
    SUPPORTED_FIAT_CURRENCY_SYMBOLS,
    SUPPORTED_CURRENCIES,
    SUPPORTED_CURRENCY_SYMBOLS,
    SUPPORTED_CRYPTO_CURRENCIES,
    SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
    DEFAULT_SEND_CURRENCY_SYMBOL
}