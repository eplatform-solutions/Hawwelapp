const { SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../currencies");

const INITIAL_EXCHANGE_RATES = SUPPORTED_CRYPTO_CURRENCY_SYMBOLS.map((symbol) => (
    {
        baseSymbol: symbol,
        quoteSymbol: "SYP",
        rate: 12000
    }
));

module.exports = {
    INITIAL_EXCHANGE_RATES
}