// Import Required Models Object

const { adminModel, exchangeRateModel, currencyRateModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { dashboardDB } = require("../../database/connections");

async function getAllExchangeRates(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "accounting_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const exchangeRates = await exchangeRateModel.find({}, { __v: false });
            return {
                msg: getSuitableTranslations("Get All Exchange Rates Process Has Been Successfully !!", language),
                error: false,
                data: exchangeRates,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function updateExchangeRates(adminId, newExchangeRates, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "quick_control_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const exchangeRates = [
                newExchangeRates?.USDT_RATE && { baseSymbol: "USDT", rate: Number(newExchangeRates?.USDT_RATE) },
                newExchangeRates?.USDC_RATE && { baseSymbol: "USDC", rate: Number(newExchangeRates?.USDC_RATE) }
            ].filter(Boolean);
            const hasUsdt = exchangeRates.some((item) => item.baseSymbol === "USDT");
            const hasUsdc = exchangeRates.some((item) => item.baseSymbol === "USDC");
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            if (exchangeRates.length > 0) {
                await exchangeRateModel.bulkWrite(
                    exchangeRates.map((rate) => ({
                        updateOne: {
                            filter: { baseSymbol: rate.baseSymbol, quoteSymbol: "SYP" },
                            update: {
                                $set: { rate: rate.rate },
                                $setOnInsert: {
                                    baseSymbol: rate.baseSymbol,
                                    quoteSymbol: "SYP",
                                },
                            },
                            upsert: true,
                        },
                    })),
                    { session: dbSession }
                );
            }

            // Keep mobile-facing fiat rates in sync with quick-control rates.
            if (hasUsdt || hasUsdc) {
                const existingSypRate = await currencyRateModel.findOne({ code: "SYP" }, null, { session: dbSession });
                const nextUsdtRate = hasUsdt
                    ? exchangeRates.find((item) => item.baseSymbol === "USDT").rate
                    : Number(existingSypRate?.usdtRate);
                const nextUsdcRate = hasUsdc
                    ? exchangeRates.find((item) => item.baseSymbol === "USDC").rate
                    : Number(existingSypRate?.usdcRate);

                let safeUsdtRate = Number(nextUsdtRate);
                let safeUsdcRate = Number(nextUsdcRate);

                if (!(safeUsdtRate > 0) && safeUsdcRate > 0) safeUsdtRate = safeUsdcRate;
                if (!(safeUsdcRate > 0) && safeUsdtRate > 0) safeUsdcRate = safeUsdtRate;

                if (safeUsdtRate > 0 && safeUsdcRate > 0) {
                    await currencyRateModel.updateOne(
                        { code: "SYP" },
                        {
                            $set: {
                                code: "SYP",
                                name: existingSypRate?.name || "Syrian Pound",
                                usdtRate: safeUsdtRate,
                                usdcRate: safeUsdcRate,
                            },
                        },
                        { upsert: true, session: dbSession }
                    );

                    const synced = await currencyRateModel.findOne({ code: "SYP" }, null, { session: dbSession });
                    if (!synced || Number(synced.usdtRate) !== safeUsdtRate || Number(synced.usdcRate) !== safeUsdcRate) {
                        throw new Error("SYP currency_rate sync mismatch after exchange-rates update");
                    }
                }
            }
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Updating Exchange Rates Process Has Been Successfully !!", language),
                error: false,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

module.exports = {
    getAllExchangeRates,
    updateExchangeRates,
}