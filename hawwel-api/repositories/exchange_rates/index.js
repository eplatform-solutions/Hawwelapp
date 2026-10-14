// Import Required Models Object

const { exchangeRateModel, currencyRateModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

async function getAllExchangeRate(filters, language) {
    try {
        const exchangeRate = await exchangeRateModel.findOne(filters, { __v: false });
        return {
            msg: getSuitableTranslations("Get Exchange Rate By Filters Process Has Been Successfully !!", language),
            error: false,
            data: exchangeRate,
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getAllExchangeRates(language) {
    try {
        const exchangeRates = await exchangeRateModel.find({}, { __v: false });
        const currencyRates = await currencyRateModel.find({}, { code: 1, usdtRate: 1, usdcRate: 1 });

        const exchangeRatesMapped = {
            // Keep legacy keys for backward compatibility.
            USDT: 1,
            USDC: 1,
        };

        // Prefer dynamic per-currency rates if available.
        for (const rate of currencyRates) {
            const code = String(rate.code || "").trim().toUpperCase();
            if (!code) continue;
            exchangeRatesMapped[code] = {
                USDT: Number(rate.usdtRate) || 0,
                USDC: Number(rate.usdcRate) || 0,
            };
        }

        // Fallback from legacy exchange_rate records (USDT/USDC -> SYP)
        if (!exchangeRatesMapped.SYP) {
            const usdtToSyp = exchangeRates.find((r) => r.baseSymbol === "USDT");
            const usdcToSyp = exchangeRates.find((r) => r.baseSymbol === "USDC");
            exchangeRatesMapped.SYP = {
                USDT: Number(usdtToSyp?.rate) || 0,
                USDC: Number(usdcToSyp?.rate) || 0,
            };
        }

        return {
            msg: getSuitableTranslations("Get All Exchange Rates Process Has Been Successfully !!", language),
            error: false,
            data: exchangeRatesMapped,
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getExchangeRateByBaseAndQuote(baseSymbol, quoteSymbol, language) {
    try {
        const base = String(baseSymbol || "").trim().toUpperCase();
        const quote = String(quoteSymbol || "").trim().toUpperCase();

        if (!base || !quote) {
            return {
                msg: getSuitableTranslations("Sorry, Base Symbol And Quote Symbol Are Required !!", language),
                error: true,
                data: {},
            };
        }

        if (base !== "USDT" && base !== "USDC") {
            return {
                msg: getSuitableTranslations("Sorry, This Base Symbol Is Not Supported !!", language),
                error: true,
                data: {},
            };
        }

        const currencyRate = await currencyRateModel.findOne(
            { code: quote },
            { code: 1, usdtRate: 1, usdcRate: 1, _id: 0 }
        );

        if (currencyRate) {
            const rate = base === "USDT"
                ? Number(currencyRate.usdtRate)
                : Number(currencyRate.usdcRate);
            if (Number.isFinite(rate) && rate > 0) {
                return {
                    msg: getSuitableTranslations("Get Exchange Rate By Base And Quote Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        baseSymbol: base,
                        quoteSymbol: quote,
                        rate,
                        source: "currency_rate",
                    },
                };
            }
        }

        const fallback = await exchangeRateModel.findOne(
            { baseSymbol: base, quoteSymbol: quote },
            { baseSymbol: 1, quoteSymbol: 1, rate: 1, _id: 0 }
        );
        if (fallback && Number(fallback.rate) > 0) {
            return {
                msg: getSuitableTranslations("Get Exchange Rate By Base And Quote Process Has Been Successfully !!", language),
                error: false,
                data: {
                    baseSymbol: base,
                    quoteSymbol: quote,
                    rate: Number(fallback.rate),
                    source: "exchange_rate",
                },
            };
        }

        return {
            msg: getSuitableTranslations("Sorry, Exchange Rate For This Currency Pair Is Not Exist !!", language),
            error: true,
            data: {},
        };
    } catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getAllExchangeRate,
    getAllExchangeRates,
    getExchangeRateByBaseAndQuote,
}