// Import Required Models

const { adminModel } = require("../../models/dashboard");

const { blockchainWalletModel } = require("../../models/client");

const { blockchainWalletModel: dashBlockchainWalletModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { decryptWalletPrivateKey } = require("../../helpers/wallet_encryption");

const { dashboardDB } = require("../../database/connections");

async function getAllClientsWalletsInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "blockchain_wallets_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const matchWallet = {};
            const matchTransfer = {};
            if (filters.network) matchWallet.network = filters.network;
            if (filters.address) matchWallet.address = { $regex: filters.address, $options: "i" };
            if (filters.withdrawStatus) matchWallet.withdrawStatus = filters.withdrawStatus;
            if (filters.symbol) matchTransfer.symbol = filters.symbol;
            if (filters.amount) matchTransfer.amount = filters.amount;
            if (filters.paid) matchTransfer.paid = filters.paid;
            if (filters.status) matchTransfer.status = filters.status;
            if (filters.transferNumber) matchTransfer.transferNumber = filters.transferNumber;
            const pipeline = [
                { $match: matchWallet },
                {
                    $lookup: {
                        from: "transfers",
                        let: { transferId: "$transfer" },
                        pipeline: [
                            {
                                $match: {
                                    $expr: { $eq: ["$_id", "$$transferId"] },
                                    ...matchTransfer
                                }
                            }
                        ],
                        as: "transfer"
                    }
                },
                { $unwind: "$transfer" },
                // Every transfer gets one candidate wallet per supported
                // network up front, but only one of them ever actually
                // receives a deposit, and a "pending" withdraw status only
                // ever means "no withdrawal was ever attempted here" - by
                // default that's just noise (either the transfer hasn't
                // been paid yet, or this is the never-funded sibling of a
                // transfer paid on the other network). A pending wallet
                // whose network DOES match a transfer that really was paid
                // is the one exception worth surfacing, since that means a
                // real withdrawal is stuck. Skipped entirely when the admin
                // explicitly filters by withdraw status, so it stays
                // possible to audit every pending wallet on demand.
                ...(filters.withdrawStatus ? [] : [{
                    $match: {
                        $expr: {
                            $or: [
                                { $ne: ["$withdrawStatus", "pending"] },
                                {
                                    $and: [
                                        { $ne: [{ $ifNull: ["$transfer.network", ""] }, ""] },
                                        { $eq: ["$transfer.network", "$network"] },
                                    ]
                                },
                            ]
                        }
                    }
                }]),
                { $sort: { createdAt: -1, _id: -1 } },
                {
                    $facet: {
                        wallets: [
                            { $skip: (pageNumber - 1) * pageSize },
                            { $limit: pageSize }
                        ],
                        walletsCount: [
                            { $count: "count" }
                        ]
                    }
                }
            ];
            const result = await blockchainWalletModel.aggregate(pipeline);
            const wallets = result[0]?.wallets || [];
            const walletsCount = result[0]?.walletsCount[0]?.count || 0;
            if (walletsCount > 0) {
                // Never send a client's private key to the dashboard; only a masked hint (last 4 chars).
                const walletsWithMaskedKey = wallets.map(wallet => {
                    const decrypted = decryptWalletPrivateKey(wallet.privateKey);
                    if (!decrypted) {
                        console.error(`[blockchain-wallets] wallet private key decrypt failed for walletId=${wallet?._id}`);
                    }
                    const maskedKey = decrypted ? `********${decrypted.slice(-4)}` : "********";
                    return { ...wallet, privateKey: maskedKey };
                });
                return {
                    msg: getSuitableTranslations("Get All Clients Wallets Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        wallets: walletsWithMaskedKey,
                        walletsCount,
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Blockchain Wallets Were Found !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function updateWalletInfo(adminId, walletId, newData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "quick_control_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const walletInfo = await dashBlockchainWalletModel.findById(walletId);
            if (walletInfo) {
                // A network-fee-funding wallet is stored once per symbol (USDT, USDC) but is the
                // same account on that network, so a new key must replace it on every copy.
                const walletsToSave = [walletInfo];
                if (walletInfo.type === "central" && newData?.address) {
                    walletInfo.address = newData?.address;
                }
                else if (walletInfo.type === "network-fee-funding" && newData?.privateKey) {
                    const siblingWallets = await dashBlockchainWalletModel.find({
                        _id: { $ne: walletInfo._id },
                        type: "network-fee-funding",
                        network: walletInfo.network,
                    });
                    walletsToSave.push(...siblingWallets);
                    for (const wallet of walletsToSave) {
                        wallet.privateKey = newData?.privateKey;
                    }
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                for (const wallet of walletsToSave) {
                    await wallet.save({ session: dbSession });
                }
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Updating Blockchain Wallet Data Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Blockchain Wallet Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
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

module.exports = {
    getAllClientsWalletsInsideThePage,
    updateWalletInfo
}