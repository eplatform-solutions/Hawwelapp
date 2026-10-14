const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

const minimumDepositLimitsModel = require("../../../models/dashboard/minimum_deposit_limits");

const INITIAL_MINIMUM_DEPOSIT_LIMITS = [
    ...SUPPORTED_NETWORKS.map((network) => ({
        currencyType: "crypto",
        network,
        currencyName: "USDT",
        symbol: "USDT",
        amount: 1,
    })),
    ...SUPPORTED_NETWORKS.map((network) => ({
        currencyType: "crypto",
        network,
        currencyName: "USDC",
        symbol: "USDC",
        amount: 1,
    }))
];

async function create_minimum_deposit_limits_list() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        await minimumDepositLimitsModel.bulkWrite(
            INITIAL_MINIMUM_DEPOSIT_LIMITS.map((minDeposit) => ({
                updateOne: {
                    filter: { currencyType: minDeposit.currencyType, network: minDeposit.network, symbol: minDeposit.symbol },
                    update: { $setOnInsert: minDeposit },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Minimum Deposit Limits List Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_minimum_deposit_limits_list()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); })