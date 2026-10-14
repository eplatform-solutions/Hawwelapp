// Import Required Models

const { walletTransactionsModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { clientDB } = require("../../database/connections");

async function createNewTransaction(transactionDetails, language, dbSession = null) {
    let internalSession = false;
    try {
        const transactionInstance = new walletTransactionsModel(transactionDetails);
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const newTransaction = await transactionInstance.save({ session: dbSession });
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Creating New Transaction Process Has Been Successfully !!", language),
            error: false,
            data: newTransaction,
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
    createNewTransaction
}