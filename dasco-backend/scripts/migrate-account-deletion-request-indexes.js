const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const { clientDB } = require("../database/connections");
const accountDeletionRequestModel = require("../models/client/account_deletion_request");

async function migrateAccountDeletionRequestIndexes() {
    try {
        await clientDB.openUri(process.env.DB_URL);
        await accountDeletionRequestModel.syncIndexes();
        console.log("Synced account_deletion_request indexes from schema.");
        await clientDB.close();
        return "Account Deletion Request Index Migration Has Been Successfully !!";
    } catch (err) {
        if (clientDB.readyState) {
            await clientDB.close();
        }
        throw err;
    }
}

migrateAccountDeletionRequestIndexes()
    .then((result) => {
        console.log(result);
        process.exit(0);
    })
    .catch((err) => {
        console.error(err?.message || err);
        process.exit(1);
    });
