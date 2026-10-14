const { MAX_RETRIES, BATCH_SIZE } = require("../../constants/cron");

const { transferModel, tatumSubscriptionsModel, blockchainWalletModel } = require("../../models/client");

const { deleteTatumSubscription } = require("../../helpers/blockchain/external_deposit");

const { getSuitableAdminWalletsForWithdrawFromClientWallet } = require("../../repositories/blockchain_wallets");

const { sendMoneyOnBlockChain, getTokenBalance, getNativeBalance } = require("../../helpers/blockchain/withdraw");

const { errorMessage, logBlockchainOps } = require("../../utils/safe_log");

const { clientDB } = require("../../database/connections");

async function expireTransfersJob() {
    let dbSession = null;
    try {
        const expiredTransfers = await transferModel.find(
            {
                status: "pending",
                expirationAt: { $lt: new Date() }
            },
        );
        dbSession = await clientDB.startSession();
        dbSession.startTransaction();
        const expiredTransferIds = expiredTransfers.map(t => t._id);
        await transferModel.updateMany(
            { _id: { $in: expiredTransferIds } },
            {
                $set: {
                    status: "expired"
                }
            },
            { session: dbSession }
        );
        if (expiredTransferIds.length > 0) {
            const result = await tatumSubscriptionsModel.updateMany(
                {
                    transfer: { $in: expiredTransferIds },
                    isDeleted: false,
                    deleteRequested: false
                },
                {
                    $set: { deleteRequested: true }
                },
                { session: dbSession }
            );
            await dbSession.commitTransaction();
            await dbSession.endSession();
            console.log(`Marked ${result.modifiedCount} subscriptions for deletion (expired transfers)`);
        }
    }
    catch (err) {
        if (dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function cleanupTatumSubscriptionsJob() {
    const subscriptions = await tatumSubscriptionsModel.find({
        deleteRequested: true,
        isDeleted: false,
        retryCount: { $lt: MAX_RETRIES }
    })
        .limit(BATCH_SIZE);
    for (const sub of subscriptions) {
        try {
            await deleteTatumSubscription(sub.subscriptionId);
            sub.isDeleted = true;
            sub.deletedAt = new Date();
            sub.lastError = null;
            await sub.save();
        } catch (err) {
            sub.retryCount += 1;
            sub.lastError = err.message;
            await sub.save();
        }
    }
}

// Recovers withdrawals that were marked "failed" by a transient blockchain
// timeout (e.g. the network-fee-funding transaction wasn't confirmed within
// the node's polling window even though it later landed on-chain) rather
// than a real, permanent failure. Never trusts the stored status alone -
// every retry re-derives what's actually true on-chain (token balance, gas
// balance) before deciding whether there's anything left to do, so it's
// safe to run repeatedly and safe even if the original failure was for a
// completely different reason.
async function retryFailedWithdrawalsJob() {
    // Kept small (unlike the other jobs' shared BATCH_SIZE) because each
    // wallet here can mean up to two real blockchain transactions - a large
    // batch could run past the cron lock's expiry and risk overlapping with
    // the next tick.
    // Partner-custodied addresses are excluded: the licensed custodian holds
    // the key and settles on their side, so there is nothing here to sweep
    // and no key to sweep it with.
    const wallets = await blockchainWalletModel.find({
        withdrawStatus: "failed",
        withdrawRetryCount: { $lt: MAX_RETRIES },
        custodian: { $ne: "partner" },
    }).limit(5);

    for (const wallet of wallets) {
        try {
            const transfer = await transferModel.findById(wallet.transfer);
            if (!transfer) {
                wallet.withdrawRetryCount += 1;
                wallet.withdrawServerError = "Transfer no longer exists";
                await wallet.save();
                continue;
            }

            const requiredAmount = transfer.paid || transfer.amount;
            const currencyName = transfer.currencyName;

            const tokenBalance = await getTokenBalance(wallet.network, currencyName, wallet.address);
            if (tokenBalance < requiredAmount) {
                // The deposited token isn't (fully) on this wallet - either
                // the original deposit never confirmed or someone already
                // moved it. Nothing safe to recover automatically yet.
                wallet.withdrawRetryCount += 1;
                wallet.withdrawServerError = `On-chain balance (${tokenBalance}) below expected (${requiredAmount}) as of retry #${wallet.withdrawRetryCount}`;
                await wallet.save();
                continue;
            }

            const adminWalletsResult = await getSuitableAdminWalletsForWithdrawFromClientWallet(wallet.network, currencyName, "en");
            if (adminWalletsResult.error) {
                wallet.withdrawRetryCount += 1;
                wallet.withdrawServerError = adminWalletsResult.msg;
                await wallet.save();
                continue;
            }
            const { centralWallet, networkFeeFundingWallet } = adminWalletsResult.data;

            const nativeToken = wallet.network === "MATIC" ? "MATIC" : "BNB";
            const requiredGas = wallet.network === "MATIC" ? 0.8 : 0.001;
            const nativeBalance = await getNativeBalance(wallet.network, wallet.address);
            if (nativeBalance < requiredGas) {
                await sendMoneyOnBlockChain(
                    wallet.network,
                    nativeToken,
                    networkFeeFundingWallet.address,
                    wallet.address,
                    requiredGas,
                    networkFeeFundingWallet.privateKey,
                );
            }

            await sendMoneyOnBlockChain(
                wallet.network,
                currencyName,
                wallet.address,
                centralWallet.address,
                requiredAmount,
                wallet.decryptPrivateKey(),
            );

            wallet.withdrawStatus = "success";
            wallet.withdrawFailedReason = undefined;
            wallet.withdrawServerError = undefined;
            await wallet.save();
            logBlockchainOps("recovered stuck withdrawal", {
                transferId: transfer._id,
                walletId: wallet._id,
                network: wallet.network,
            });
        } catch (err) {
            wallet.withdrawRetryCount += 1;
            wallet.withdrawServerError = errorMessage(err).slice(0, 500);
            await wallet.save();
            logBlockchainOps("retry failed withdrawal attempt errored", {
                walletId: wallet._id,
                retryCount: wallet.withdrawRetryCount,
                reason: errorMessage(err),
            });
        }
    }
}

module.exports = {
    expireTransfersJob,
    cleanupTatumSubscriptionsJob,
    retryFailedWithdrawalsJob,
};