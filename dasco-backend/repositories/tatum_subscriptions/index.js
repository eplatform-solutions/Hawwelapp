// Import Required Models

const { userModel, tatumSubscriptionsModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { createNewSubscriptionInTatumNotificationsService } = require("../../helpers/blockchain/external_deposit");

const { clientDB } = require("../../database/connections");
const { runInTransactionWithRetry } = require("../_utils/transaction_retry");

async function createTatumSubscriptions(userId, transferId, blockchainWallets, language, dbSession = null) {
    let internalSession = false;
    try {
        const user = await userModel.findById(userId);
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const existingSubscriptions = await tatumSubscriptionsModel
                .find({ transfer: transferId, isDeleted: false })
                .sort({ createdAt: 1 });
            if (existingSubscriptions.length >= blockchainWallets.length) {
                return {
                    msg: getSuitableTranslations("Creating Tatum Subscriptions Process Has Been Successfully !!", language),
                    error: false,
                    data: existingSubscriptions
                };
            }

            const walletsToSubscribe = blockchainWallets.slice(existingSubscriptions.length);
            const subscriptions = [];
            for (const wallet of walletsToSubscribe) {
                subscriptions.push({
                    user: userId,
                    transfer: transferId,
                    subscriptionId: await createNewSubscriptionInTatumNotificationsService("INCOMING_FUNGIBLE_TX", wallet.address, wallet.network),
                });
            }
            if (!subscriptions.length) {
                return {
                    msg: getSuitableTranslations("Creating Tatum Subscriptions Process Has Been Successfully !!", language),
                    error: false,
                    data: existingSubscriptions
                };
            }

            if (dbSession) {
                const newTatumSubscriptions = await tatumSubscriptionsModel.insertMany(subscriptions, { session: dbSession });
                return {
                    msg: getSuitableTranslations("Creating Tatum Subscriptions Process Has Been Successfully !!", language),
                    error: false,
                    data: [...existingSubscriptions, ...newTatumSubscriptions]
                };
            }

            internalSession = true;
            const newTatumSubscriptions = await runInTransactionWithRetry(
                clientDB,
                async (session) => tatumSubscriptionsModel.insertMany(subscriptions, { session }),
                { maxRetries: 3, baseDelayMs: 120 }
            );
            return {
                msg: getSuitableTranslations("Creating Tatum Subscriptions Process Has Been Successfully !!", language),
                error: false,
                data: [...existingSubscriptions, ...newTatumSubscriptions]
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
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

async function createDeleteRequestForTatumSubscription(transferId, language, dbSession = null) {
    let internalSession = false;
    try {
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        await tatumSubscriptionsModel.updateMany(
            { transfer: transferId },
            { deleteRequested: true },
            { session: dbSession }
        );
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Creating Delete Request For Tatum Subscription Process Has Been Successfully !!", language),
            error: false,
            data: {}
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
    createTatumSubscriptions,
    createDeleteRequestForTatumSubscription
}