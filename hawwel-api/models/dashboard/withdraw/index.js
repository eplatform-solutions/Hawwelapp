const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { TRANSACTION_TARGETS, TRANSACTION_STATUSES, DEFAULT_TRANSACTION_STATUS } = require("../../../constants/transactions");

const { CURRENCY_TYPES, SUPPORTED_CRYPTO_CURRENCIES, SUPPORTED_CRYPTO_CURRENCY_SYMBOLS, DEFAULT_CURRENCY_TYPE } = require("../../../constants/currencies");

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

// Create Withdraw Schema

const withdrawShema = new mongoose.Schema({
    target: {
        type: String,
        required: true,
        enum: TRANSACTION_TARGETS,
    },
    currencyType: {
        type: String,
        required: true,
        enum: CURRENCY_TYPES,
        default: DEFAULT_CURRENCY_TYPE
    },
    network: {
        type: String,
        enum: SUPPORTED_NETWORKS,
    },
    currencyName: {
        type: String,
        required: true,
        enum: SUPPORTED_CRYPTO_CURRENCIES,
    },
    symbol: {
        type: String,
        required: true,
        enum: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
    },
    sender: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: true,
    },
    receiver: {
        type: String,
        default: null,
    },
    receiverAddress: {
        type: String,
        required: () => this.target === "external" && this.currencyType === "crypto",
    },
    amount: {
        type: Number,
        required: true,
    },
    fee: {
        type: Number,
        required: true,
    },
    total: {
        type: Number,
        required: true,
    },
    status: {
        type: String,
        default: "pending",
        default: DEFAULT_TRANSACTION_STATUS,
        enum: TRANSACTION_STATUSES,
    },
    transactionId: String,
}, { timestamps: true });

// Create Withdraw Model From Withdraw Schema

const withdrawModel = dashboardDB.model("withdraw", withdrawShema);

module.exports = withdrawModel;