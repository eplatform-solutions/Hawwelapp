const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

const blockchainWalletModel = require("../../../models/dashboard/blockchain_wallet");

const web3 = require("web3");

// Customer deposits are swept to this address, so it must come from the operator's own
// configuration (CENTRAL_WALLET_ADDRESS); it is never written in the code.
function buildInitialCentralWallets(address) {
    return ["USDT", "USDC"].flatMap((symbol) => SUPPORTED_NETWORKS.map((network) => (
        {
            symbol,
            network,
            address,
            type: "central",
        }
    )));
}

async function create_initial_blockchain_central_wallets() {
    const address = (process.env.CENTRAL_WALLET_ADDRESS || "").trim();
    if (!address) {
        return "Skipped: CENTRAL_WALLET_ADDRESS is not set, no central wallets were created.";
    }
    if (!web3.utils.isAddress(address)) {
        throw new Error("CENTRAL_WALLET_ADDRESS is not a valid address");
    }
    const INITIAL_CENTRAL_BLOCKCHAIN_WALLETS = buildInitialCentralWallets(address);
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