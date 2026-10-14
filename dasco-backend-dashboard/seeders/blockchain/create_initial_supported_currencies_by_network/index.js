const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const supportedCurrenciesByNetworksModel = require("../../../models/dashboard/supported_currencies_by_networks");

const INITIAL_SUPPORTED_CURRENCIES_BY_NETWORKS = [
    {
        currencyName: "USDT",
        symbol: "USDT",
        networks: ["POLYGON", "BSC"],
    },
    {
        currencyName: "USDC",
        symbol: "USDC",
        networks: ["POLYGON", "BSC"],
    },
];

async function create_supported_currencies_by_networks_list() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        await supportedCurrenciesByNetworksModel.bulkWrite(
            INITIAL_SUPPORTED_CURRENCIES_BY_NETWORKS.map((curr) => ({
                updateOne: {
                    filter: { symbol: curr.symbol },
                    update: { $setOnInsert: curr },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Supported Currencies By Networks List Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_supported_currencies_by_networks_list()
    .then((result) => { console.log(result); process.exit(0) })
    .catch((err) => { console.log(err); process.exit(1); })