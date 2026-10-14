const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const exchangeRateModel = require("../../../models/dashboard/exchange_rate");

const { INITIAL_EXCHANGE_RATES } = require("../../../constants/exchange_rates");

async function create_initial_exchange_rates() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        await exchangeRateModel.bulkWrite(
            INITIAL_EXCHANGE_RATES.map((rate) => ({
                updateOne: {
                    filter: { baseSymbol: rate.baseSymbol, quoteSymbol: rate.quoteSymbol },
                    update: { $setOnInsert: rate },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Initial Exchange Rates Process Has Been Successfuly !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_exchange_rates()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err?.message || err); process.exit(1); });