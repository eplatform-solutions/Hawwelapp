const blockchainWalletModel = require("./blockchain_wallet");
const complianceAlertModel = require("./compliance_alert");
const counterModel = require("./counter");
const depositModel = require("./deposit");
const kycModel = require("./kyc");
const notificationModel = require("./notification");
const tatumSubscriptionsModel = require("./tatum_subscriptions");
const transferModel = require("./transfer");
const userModel = require("./user");
const walletTransactionsModel = require("./wallet_transaction");

module.exports = {
    blockchainWalletModel,
    complianceAlertModel,
    counterModel,
    depositModel,
    kycModel,
    notificationModel,
    tatumSubscriptionsModel,
    transferModel,
    userModel,
    walletTransactionsModel
}