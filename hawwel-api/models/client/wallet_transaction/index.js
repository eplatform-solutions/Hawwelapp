const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { TRANSACTION_TYPES, DEFAULT_TRANSACTION_TYPE } = require("../../../constants/transactions");

// Create Wallet Transactions Schema

const walletTransactionsSchema = new mongoose.Schema({
    user: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "User is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid User Id"
        }
    },
    type: {
        type: String,
        enum: {
            values: TRANSACTION_TYPES,
            message: "Invalid transaction type"
        },
        required: [true, "Transaction type is required"],
        default: DEFAULT_TRANSACTION_TYPE,
        trim: true
    },
    transaction: {
        type: mongoose.Types.ObjectId,
        refPath: "type",
        required: [true, "Transaction reference is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid transaction Id"
        }
    },
}, { timestamps: true });

walletTransactionsSchema.index({ user: 1 });

walletTransactionsSchema.index({ type: 1 });

walletTransactionsSchema.index({ transaction: 1 });

walletTransactionsSchema.index({ createdAt: -1 });

// Create Wallet Transactions Model From Wallet Transactions Schema

const walletTransactionsModel = clientDB.model("wallet_transaction", walletTransactionsSchema);

module.exports = walletTransactionsModel;