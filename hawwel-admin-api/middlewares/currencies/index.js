const { getResponseObject } = require("../../helpers/responses");

const { SUPPORTED_FIAT_CURRENCY_SYMBOLS, SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../constants/currencies");

function validateFiatCurrencySymbol(symbol, res, nextFunc, errorMsg = "Sorry, Please Send Valid Fiat Currency Symbol !!") {
    if (!SUPPORTED_FIAT_CURRENCY_SYMBOLS.includes(symbol)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

function validateCryptoCurrencySymbol(symbol, res, nextFunc, errorMsg = "Sorry, Please Send Valid Crypto Currency Symbol !!") {
    if (!SUPPORTED_CRYPTO_CURRENCY_SYMBOLS.includes(symbol)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

module.exports = {
    validateFiatCurrencySymbol,
    validateCryptoCurrencySymbol
}