// Import Required Models

const { blockchainWalletModel, userModel } = require("../../models/client");

const { blockchainWalletModel: dashBlockchainWalletModel } = require("../../models/dashboard");

// Import blockchain network libraries

const { Web3 } = require("web3");

const { encryptWalletPrivateKey } = require("../../helpers/wallet_encryption");

const { getSuitableTranslations } = require("../../helpers/translation");

const { isPartnerCustody, createDepositAddressesWithPartner } = require("../../helpers/custody");

const { clientDB } = require("../../database/connections");

async function createBlockchainWallets(userId, transferId, language, dbSession = null) {
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
            const existingWallets = await blockchainWalletModel
                .find({ transfer: transferId })
                .sort({ createdAt: 1 })
                .session(dbSession || null);
            if (existingWallets.length >= 2) {
                return {
                    msg: getSuitableTranslations("Creating New Blockchain Wallets Process Has Been Successfully !!", language),
                    error: false,
                    data: existingWallets
                };
            }
            // Guard the seam: if someone flips CUSTODY_PROVIDER to "partner"
            // without an adapter, fail loudly here rather than quietly
            // generating self-custody keys under a partner label.
            if (isPartnerCustody()) {
                await createDepositAddressesWithPartner();
            }
            // Set up the Web3 library to connect to the Polygon network node
            const web3ForPolygon = new Web3(process.env.POLYGON_NODE_BASE_API_URL);
            // Set up the Web3 library to connect to the Binance Smart Chain node
            const web3ForBSC = new Web3(process.env.BINANCE_SMART_CHAIN_NODE_BASE_API_URL);
            // Create an account on the Polygon network
            const polygonAccount = web3ForPolygon.eth.accounts.create();
            // Create an account on the Binance Smart Chain network
            const bscAccount = web3ForBSC.eth.accounts.privateKeyToAccount(polygonAccount.privateKey);
            // Encrypt The Private Key Of The Blockchain Account Using The AES Algorithm
            const encryptedPrivateKey = encryptWalletPrivateKey(polygonAccount.privateKey);
            const blockchainWallets = [
                {
                    user: userId,
                    network: "MATIC",
                    address: polygonAccount.address,
                    privateKey: encryptedPrivateKey,
                    transfer: transferId,
                },
                {
                    user: userId,
                    network: "BSC",
                    address: bscAccount.address,
                    privateKey: encryptedPrivateKey,
                    transfer: transferId,
                },
            ];
            if (existingWallets.length > 0) {
                return {
                    msg: getSuitableTranslations("Creating New Blockchain Wallets Process Has Been Successfully !!", language),
                    error: false,
                    data: existingWallets
                };
            }
            if (!dbSession) {
                dbSession = await clientDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            const newBlockchainWallets = await blockchainWalletModel.insertMany(blockchainWallets, { session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Creating New Blockchain Wallets Process Has Been Successfully !!", language),
                error: false,
                data: newBlockchainWallets
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
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

async function getBlockhainWallet(filters, language) {
    try {
        const wallet = await blockchainWalletModel.findOne(filters).populate("user");
        if (wallet) {
            return {
                msg: getSuitableTranslations("Get Blockchain Wallet Process Has Been Successfully !!", language),
                error: false,
                data: wallet
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Blockchain Wallet Is Not Exist !!", language),
            error: true,
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getSuitableAdminWalletsForWithdrawFromClientWallet(network, symbol, language) {
    try {
        const wallets = await dashBlockchainWalletModel.find({ network, symbol });
        const centralWalletIndex = wallets.findIndex((wallet) => wallet.type === "central");
        const networkFeeFundingWalletIndex = wallets.findIndex((wallet) => wallet.type === "network-fee-funding");
        const centralWallet = wallets[centralWalletIndex];
        const networkFeeFundingWallet = wallets[networkFeeFundingWalletIndex];
        networkFeeFundingWallet.privateKey = networkFeeFundingWallet.decryptPrivateKey();
        return {
            msg: getSuitableTranslations("Get Suitable Admin Wallets For Withdraw From Client Wallet Process Has Been Successfully !!", language),
            error: false,
            data: {
                centralWallet,
                networkFeeFundingWallet
            }
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function updateBlockhainWallet(walletId, newWalletInfo, language, dbSession = null) {
    let internalSession = false;
    try {
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const blockchainWalletInfo = await blockchainWalletModel.findOneAndUpdate({ _id: walletId }, newWalletInfo, { session: dbSession });
        if (blockchainWalletInfo) {
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Updating Blockchain Wallet Info Process Has Been Successfully !!", language),
                error: false,
                data: {},
            }
        }
        if (internalSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Sorry, This Blockchain Wallet Is Not Exist !!", language),
            error: true,
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
    createBlockchainWallets,
    getBlockhainWallet,
    getSuitableAdminWalletsForWithdrawFromClientWallet,
    updateBlockhainWallet
}