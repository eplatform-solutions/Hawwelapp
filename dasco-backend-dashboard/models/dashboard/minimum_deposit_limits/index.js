const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

const { CURRENCY_TYPES, SUPPORTED_CRYPTO_CURRENCIES, SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../../constants/currencies");

// Create Minimum Deposit Limits Schema

const minimumDepositLimitsSchema = new mongoose.Schema({
    currencyType: {
        type: String,
        required: [true, "Currency type is required"],
        enum: {
            values: CURRENCY_TYPES,
            message: "Invalid currency type"
        },
        trim: true
    },
    network: {
        type: String,
        enum: {
            values: SUPPORTED_NETWORKS,
            message: "Invalid network"
        },
        trim: true
    },
    currencyName: {
        type: String,
        required: [true, "Currency name is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCIES,
            message: "Invalid currency name"
        },
        trim: true
    },
    symbol: {
        type: String,
        required: [true, "Currency symbol is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
            message: "Invalid currency symbol"
        },
        uppercase: true,
        trim: true
    },
    amount: {
        type: Number,
        required: [true, "Minimum deposit amount is required"],
        min: [0.00000001, "Amount must be greater than 0"] // قيمة دنيا واقعية للعملات الرقمية
    }
}, { timestamps: true });

minimumDepositLimitsSchema.index({ currencyType: 1, network: 1, currencyName: 1, symbol: 1 }, { unique: true });

// Create Minimum Deposit Limits From Minimum Deposit Limits Schema

const minimumDepositLimitsModel = dashboardDB.model("minimum_deposit_limits", minimumDepositLimitsSchema);

module.exports = minimumDepositLimitsModel;