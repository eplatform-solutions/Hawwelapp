// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
    blockchainHelpers,
    notificationsHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const { externalDepositHelpers, withdrawHelpers } = blockchainHelpers;

const { getSuitableNetworkByTatum, getSuitableCurrencyNameByTatum } = externalDepositHelpers;

const { sendMoneyOnBlockChain } = withdrawHelpers;

const { sendNotification, getDepositNotificationContent } = notificationsHelpers;

const { errorMessage, logBlockchainOps } = require("../../utils/safe_log");

// Import functions for deposits management
const depositsOperationsManagmentFunctions = require("../../repositories/deposits");

const { markNotificationPushFailed } = require("../../repositories/notifications");

const { getSuitableAdminWalletsForWithdrawFromClientWallet, updateBlockhainWallet } = require("../../repositories/blockchain_wallets");

const { recordTravelRuleForDeposit } = require("../../repositories/travel_rule");

// Define the function for handling Receive Money On Wallet
async function postExternalDeposit(req, res) {
    try {
        const { address, chain, contractAddress, amount, txId } = req.body;
        const network = getSuitableNetworkByTatum(chain);
        const currencyName = getSuitableCurrencyNameByTatum(contractAddress);
        const result = await depositsOperationsManagmentFunctions.externalDeposit(
            network,
            address,
            currencyName,
            Number(amount),
            "crypto",
            "external",
            txId,
            req.query.language
        );
        res.json(result);
        if (!result.error) {
            const token = result.data.deposit.receiver.notificationsToken;
            const transferId = result.data.transfer._id;
            const walletId = result.data.blockchainWallet._id;
            const notificationId = result.data.notificationId;
            // Travel Rule: the originator's wallet address is only knowable
            // from the transaction, and this is the first and only point where
            // we have it. Deliberately not awaited into the response path and
            // never allowed to throw - a failure here must leave a gap in the
            // compliance record, not cost the customer their deposit
            // notification.
            recordTravelRuleForDeposit({
                transferId,
                network,
                txId,
                depositAddress: address,
            }).catch((err) => {
                logBlockchainOps("travel rule capture failed", {
                    transferId,
                    walletId,
                    step: "travel-rule",
                    reason: errorMessage(err),
                });
            });
            try {
                const { title, body } = getDepositNotificationContent(
                    result.data.transfer.status,
                    "Transfer Process",
                    "Amount Deposit {{amount}} {{symbol}} In Wallet: {{address}} On Network: {{network}}"
                );
                await sendNotification({
                    title,
                    body,
                    data: {
                        transferId: String(transferId),
                        amount: String(result.data.transfer.amount),
                        paid: String(amount),
                        symbol: currencyName,
                        address,
                        network,
                        status: result.data.transfer.status,
                        fullName: result.data.transfer.receiver.fullName,
                        toCountry: result.data.transfer.toCountry,
                        city: result.data.transfer.city["en"],
                        area: result.data.transfer.area["en"],
                        paymentMethod: result.data.transfer.paymentMethod.name["en"]
                    },
                    token
                });
            }
            catch (err) {
                logBlockchainOps("deposit notification send failed", {
                    transferId,
                    walletId,
                    step: "send-notification",
                    reason: errorMessage(err),
                });
                if (notificationId) {
                    try {
                        await markNotificationPushFailed(notificationId, errorMessage(err));
                    }
                    catch (markErr) {
                        logBlockchainOps("mark notification push failed errored", {
                            transferId,
                            notificationId,
                            step: "mark-push-failed",
                            reason: errorMessage(markErr),
                        });
                    }
                }
            }
            // Under a licensed custodian the deposit lands in the partner's
            // own address and they settle it; we never hold the key, so there
            // is no sweep to run. The notification above has already gone out.
            if (result.data.blockchainWallet.custodian === "partner") {
                logBlockchainOps("skipping sweep for partner-custodied wallet", {
                    transferId,
                    walletId,
                    step: "withdraw-to-central",
                });
                return;
            }
            let suitableAdminWalletsForWithdraw = {};
            try {
                suitableAdminWalletsForWithdraw = (await getSuitableAdminWalletsForWithdrawFromClientWallet(network, currencyName, "en")).data;
                if (!suitableAdminWalletsForWithdraw) {
                    await updateBlockhainWallet(walletId, {
                        withdrawStatus: "failed",
                        withdrawFailedReason: "error in get suitable admin wallets for withdraw"
                    }, "en");
                    return;
                }
            }
            catch (err) {
                logBlockchainOps("get admin wallets for withdraw failed", {
                    transferId,
                    walletId,
                    step: "get-admin-wallets",
                    reason: errorMessage(err),
                });
                try {
                    await updateBlockhainWallet(walletId, {
                        withdrawStatus: "failed",
                        withdrawFailedReason: "error in get suitable admin wallets for withdraw"
                    }, "en");
                }
                catch (updateErr) {
                    logBlockchainOps("update withdraw status failed", {
                        transferId,
                        walletId,
                        step: "update-withdraw-status",
                        reason: errorMessage(updateErr),
                    });
                }
                finally {
                    return;
                }
            }
            try {
                await sendMoneyOnBlockChain(
                    network,
                    network === "MATIC" ? "MATIC" : "BNB",
                    suitableAdminWalletsForWithdraw.networkFeeFundingWallet.address,
                    result.data.blockchainWallet.address,
                    network === "MATIC" ? 0.8 : 0.001,
                    suitableAdminWalletsForWithdraw.networkFeeFundingWallet.privateKey,
                );
            }
            catch (err) {
                logBlockchainOps("network fee funding failed", {
                    transferId,
                    walletId,
                    step: "network-fee-funding",
                    reason: errorMessage(err),
                });
                try {
                    await updateBlockhainWallet(walletId, {
                        withdrawStatus: "failed",
                        withdrawFailedReason: "error in network fee funding for wallet",
                        withdrawServerError: errorMessage(err)
                    }, "en");
                }
                catch (updateErr) {
                    logBlockchainOps("update withdraw status failed", {
                        transferId,
                        walletId,
                        step: "update-withdraw-status",
                        reason: errorMessage(updateErr),
                    });
                }
                finally {
                    return;
                }
            }
            try {
                await sendMoneyOnBlockChain(
                    network,
                    currencyName,
                    result.data.blockchainWallet.address,
                    suitableAdminWalletsForWithdraw.centralWallet.address,
                    amount,
                    result.data.blockchainWallet.decryptPrivateKey()
                );
                await updateBlockhainWallet(walletId, {
                    withdrawStatus: "success",
                }, "en");
            }
            catch (err) {
                logBlockchainOps("sweep to central wallet failed", {
                    transferId,
                    walletId,
                    step: "sweep-to-central",
                    reason: errorMessage(err),
                });
                try {
                    await updateBlockhainWallet(walletId, {
                        withdrawStatus: "failed",
                        withdrawFailedReason: "error in withdraw from wallet to central wallet",
                        withdrawServerError: errorMessage(err)
                    }, "en");
                }
                catch (updateErr) {
                    logBlockchainOps("update withdraw status failed", {
                        transferId,
                        walletId,
                        step: "update-withdraw-status",
                        reason: errorMessage(updateErr),
                    });
                }
                finally {
                    return;
                }
            }
        }
    }
    catch (err) {
        logBlockchainOps("external deposit handler failed", {
            step: "post-external-deposit",
            reason: errorMessage(err),
        });
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postExternalDeposit
};
