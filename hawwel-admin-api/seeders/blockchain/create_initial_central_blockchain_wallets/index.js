const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

const blockchainWalletModel = require("../../../models/dashboard/blockchain_wallet");

const INITIAL_CENTRAL_BLOCKCHAIN_WALLETS = [
    ...SUPPORTED_NETWORKS.map((network) => (
        {
            symbol: "USDT",
            network,
            address: "0x8c7aE78104e64C7e91699b5af1133c8690547da1",
            type: "central",
        }
    )),
    ...SUPPORTED_NETWORKS.map((network) => (
        {
            symbol: "USDC",
            network,
            address: "0x8c7aE78104e64C7e91699b5af1133c8690547da1",
            type: "central",
        }
    )),
];

async function create_initial_blockchain_central_wallets() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        await blockchainWalletModel.bulkWrite(
            INITIAL_CENTRAL_BLOCKCHAIN_WALLETS.map((wallet) => ({
                updateOne: {
                    filter: {
                        symbol: wallet.symbol,
                        network: wallet.network,
                        type: wallet.type,
                    },
                    update: { $setOnInsert: wallet },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Initial Central Blockchain Wallets Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_blockchain_central_wallets()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); })