// Import Required Models

const { depositModel, transferModel } = require("../../models/client");

const { getMinimumDepositLimits } = require("../minimum_deposit_limits");

const { getBlockhainWallet } = require("../blockchain_wallets");

const { createNewTransaction } = require("../transactions");

const { getSuitableTranslations } = require("../../helpers/translation");

const { getTransfer } = require("../transfers");

const { saveNotifcation } = require("../notifications");

const { utils } = require("web3");

const { clientDB } = require("../../database/connections");

const { calculateNetAmount } = require("../../helpers/money");

const { getDepositNotificationContent } = require("../../helpers/notifications");

const { createDeleteRequestForTatumSubscription } = require("../tatum_subscriptions");
const { createAbortWithResultError, runInTransactionWithRetry } = require("../_utils/transaction_retry");
const { errorMessage, logBlockchainOps } = require("../../utils/safe_log");

// Define the function to get create new deposit in Database
async function createNewDeposit(debositDetails, language, dbSession = null) {
    let internalSession = false;
    try {
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const deposit = await (new depositModel(debositDetails)).save({ session: dbSession });
        const populatedDeposit = await deposit
            .populate("receiver");
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Creating New Deposit Process Has Been Successfully !!", language),
            error: false,
            data: populatedDeposit,
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

async function externalDeposit(network, address, currencyName, amount, currencyType, target, transactionId, language, dbSession = null) {
    let internalSession = false;
    try {
        const blockchainWalletResult = await getBlockhainWallet({ address: utils.toChecksumAddress(address), network }, language);
        if (blockchainWalletResult.error) {
            return blockchainWalletResult;
        }

        const minimumDepositLimitsResult = await getMinimumDepositLimits({ currencyType, network, currencyName }, language);
        if (minimumDepositLimitsResult.error) {
            return minimumDepositLimitsResult;
        }

        const transferResult = await getTransfer(blockchainWalletResult.data.transfer, language);
        const persistDepositFlow = async (session, abortOnError) => {
            let notificationId = null;
            const newDepositResult = await createNewDeposit({
                target,
                currencyType,
                network,
                currencyName,
                symbol: minimumDepositLimitsResult.data[0].symbol,
                receiver: blockchainWalletResult.data.user._id,
                amount,
                transactionId,
                status: "completed"
            }, "en", session);
            if (newDepositResult.error) {
                if (abortOnError) throw createAbortWithResultError(newDepositResult);
                return newDepositResult;
            }

            const newTranscation = await createNewTransaction({
                user: blockchainWalletResult.data.user._id,
                type: "deposit",
                transaction: newDepositResult.data._id
            }, language, session);

            let transfer = {};
            if (!transferResult.error) {
                const now = Date.now();
                if (transferResult.data.status === "pending" && now < new Date(transferResult.data.expirationAt).getTime()) {
                    let nextStatus = "full-paid";
                    if (amount < transferResult.data.amount) {
                        nextStatus = "under-paid";
                    }
                    else if (amount > transferResult.data.amount) {
                        nextStatus = "over-paid";
                    }

                    const transferAfterUpdate = await transferModel.findOneAndUpdate(
                        {
                            _id: transferResult.data._id,
                            status: "pending",
                            expirationAt: { $gt: new Date(now) }
                        },
                        {
                            $set: {
                                status: nextStatus,
                                paid: amount,
                                netAmount: calculateNetAmount(amount, transferResult.data.fee),
                                network,
                                paidAt: now
                            }
                        },
                        { new: true, session }
                    );

                    if (transferAfterUpdate) {
                        transfer = transferAfterUpdate;
                        const { title, body } = getDepositNotificationContent(
                            nextStatus,
                            "Order Process",
                            "Amount deposited {{amount}} {{currencyName}} in wallet: {{address}} on network: {{network}}"
                        );
                        const notification = {
                            title,
                            body,
                            data: {
                                transferId: String(transfer._id),
                                amount: String(transfer.amount),
                                paid: String(amount),
                                symbol: currencyName,
                                address,
                                network,
                                status: transfer.status,
                                fullName: transfer.receiver.fullName,
                                toCountry: transfer.toCountry,
                                city: transfer.city,
                                area: transfer.area,
                                paymentMethod: transfer.paymentMethod.name
                            },
                        };
                        try {
                            const savedNotificationResult = await saveNotifcation(blockchainWalletResult.data.user._id, notification.title, notification.body, notification.data, language, session);
                            if (!savedNotificationResult.error) {
                                notificationId = savedNotificationResult.data._id;
                            }
                        }
                        catch (err) {
                            logBlockchainOps("save in-app deposit notification failed", {
                                userId: blockchainWalletResult.data.user._id,
                                transferId: transfer._id,
                                step: "save-notification",
                                reason: errorMessage(err),
                            });
                        }
                        await createDeleteRequestForTatumSubscription(transferResult.data._id, "en", session);
                    }
                }
            }

            return {
                msg: getSuitableTranslations("{{currencyName}} Deposit Procsss On Network {{network}} Has Been Successfully !!", language, { currencyName, network }),
                error: false,
                data: {
                    transcation: newTranscation,
                    deposit: newDepositResult.data,
                    transfer,
                    blockchainWallet: blockchainWalletResult.data,
                    notificationId,
                },
            };
        };

        if (dbSession) {
            return await persistDepositFlow(dbSession, false);
        }

        internalSession = true;
        return await runInTransactionWithRetry(
            clientDB,
            async (session) => persistDepositFlow(session, true),
            { maxRetries: 4, baseDelayMs: 120 }
        );
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
    createNewDeposit,
    externalDeposit,
}