const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

const blockchainWalletModel = require("../../../models/dashboard/blockchain_wallet");

const { encryptWalletPrivateKey } = require("../../../helpers/wallet_encryption");

const web3 = require("web3");

// The private key comes only from the environment; it must never be written in the code.
function buildInitialNetworkFeeFundingWallets(privateKey) {
    const normalizedKey = privateKey.startsWith("0x") ? privateKey : `0x${privateKey}`;
    const address = web3.eth.accounts.privateKeyToAddress(normalizedKey);
    return ["USDT", "USDC"].flatMap((symbol) => SUPPORTED_NETWORKS.map((network) => (
        {
            symbol,
            network,
            address,
            privateKey: encryptWalletPrivateKey(normalizedKey),
            type: "network-fee-funding"
        }
    )));
}

async function create_initial__network_fee_funding_blockchain_wallets() {
    const privateKey = process.env.NETWORK_FEE_FUNDING_PRIVATE_KEY;
    if (!privateKey) {
        return "Skipped: NETWORK_FEE_FUNDING_PRIVATE_KEY is not set, no network fee funding wallets were created.";
    }
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        await blockchainWalletModel.bulkWrite(
            buildInitialNetworkFeeFundingWallets(privateKey).map((wallet) => ({
                updateOne: {
                    filter: { symbol: wallet.symbol, network: wallet.network, type: wallet.type },
                    update: { $setOnInsert: wallet },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Initial Network Fee Funding Blockchain Wallets Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial__network_fee_funding_blockchain_wallets()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); })