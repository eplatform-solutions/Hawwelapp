const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { TRANSACTION_TARGETS, TRANSACTION_STATUSES, DEFAULT_TRANSACTION_STATUS } = require("../../../constants/transactions");

const { CURRENCY_TYPES, SUPPORTED_CRYPTO_CURRENCIES, SUPPORTED_CRYPTO_CURRENCY_SYMBOLS, DEFAULT_CURRENCY_TYPE } = require("../../../constants/currencies");

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

// Create Deposit Schema

const depositSchema = new mongoose.Schema({
    target: {
        type: String,
        required: [true, "Transaction target is required"],
        enum: {
            values: TRANSACTION_TARGETS,
            message: "Invalid transaction target"
        },
        trim: true
    },
    currencyType: {
        type: String,
        enum: {
            values: CURRENCY_TYPES,
            message: "Invalid currency type"
        },
        default: DEFAULT_CURRENCY_TYPE,
        trim: true
    },
    network: {
        type: String,
        required: [
            function () {
                return this.currencyType === "crypto";
            },
            "Network is required for crypto deposits"
        ],
        enum: {
            values: [...SUPPORTED_NETWORKS, "all"],
            message: "Unsupported network"
        },
        trim: true
    },
    currencyName: {
        type: String,
        required: [true, "Currency name is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCIES,
            message: "Unsupported cryptocurrency"
        },
        trim: true
    },
    symbol: {
        type: String,
        required: [true, "Currency symbol is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
            message: "Unsupported cryptocurrency symbol"
        },
        uppercase: true,
        trim: true
    },
    sender: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [
            function () {
                return this.target === "internal";
            },
            "Sender is required for internal transactions"
        ],
        default: null,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return mongoose.Types.ObjectId.isValid(v);
            },
            message: "Invalid sender Id"
        }
    },
    receiver: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "Receiver is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid receiver Id"
        }
    },
    amount: {
        type: Number,
        required: [true, "Amount is required"],
        min: [0, "Amount cannot be negative"]
    },
    status: {
        type: String,
        default: DEFAULT_TRANSACTION_STATUS,
        enum: {
            values: TRANSACTION_STATUSES,
            message: "Invalid transaction status"
        },
        trim: true
    },
    transactionId: {
        type: String,
        required: [true, "Transaction Id is required"],
        trim: true,
        validate: {
            validator: function (v) {
                return /^0x([A-Fa-f0-9]{64})$/.test(v);
            },
            message: "Transaction Id must be a valid 0x hash (64 hex characters)"
        }
    }
}, { timestamps: true });

depositSchema.index({ transactionId: 1 }, { unique: true });

depositSchema.index({ receiver: 1 });

depositSchema.index({ sender: 1 });

depositSchema.index({ status: 1 });

depositSchema.index({ network: 1 });

depositSchema.index({ symbol: 1 });

depositSchema.index({ createdAt: -1 });

depositSchema.index({ receiver: 1, status: 1 });

depositSchema.index({ receiver: 1, createdAt: -1 });

// Create Deposit Model From Deposit Schema

const depositModel = clientDB.model("deposit", depositSchema);

module.exports = depositModel;