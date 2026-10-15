const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const blockchainWalletModel = require("../../../models/dashboard/blockchain_wallet");

const OLD_INDEX_NAME = "symbol_1_network_1";

async function migrate_blockchain_wallet_unique_index() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        const collection = blockchainWalletModel.collection;
        // On a fresh database the collection does not exist yet; there is no old index to drop.
        const indexes = await collection.indexes().catch((err) => {
            if (err?.codeName === "NamespaceNotFound") return [];
            throw err;
        });
        const hasOldIndex = indexes.some((idx) => idx.name === OLD_INDEX_NAME);
        if (hasOldIndex) {
            await collection.dropIndex(OLD_INDEX_NAME);
            console.log(`Dropped old index: ${OLD_INDEX_NAME}`);
        } else {
            console.log(`No old index named "${OLD_INDEX_NAME}" found, skipping drop.`);
        }
        await blockchainWalletModel.syncIndexes();
        console.log("Synced indexes from schema (added symbol+network+type unique index).");
        await dashboardDB.close();
        return "Blockchain Wallet Unique Index Migration Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

migrate_blockchain_wallet_unique_index()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); });
