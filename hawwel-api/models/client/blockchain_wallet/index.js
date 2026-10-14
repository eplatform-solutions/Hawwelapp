const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { SUPPORTED_NETWORKS, CUSTODIANS, DEFAULT_CUSTODIAN } = require("../../../constants/blockchain");

const { WITHDRAW_STATUES, DEFAULT_WITHDRAW_STATUES, WITHDRAW_FAILED_REASONS } = require("../../../constants/transactions");

const { decryptWalletPrivateKey } = require("../../../helpers/wallet_encryption");

// Create Blockchain Wallet Schema

const blockchainWalletSchema = new mongoose.Schema({
    user: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "User Id Is Required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid User Id"
        },
    },
    network: {
        type: String,
        required: [true, "Network Is Required"],
        enum: {
            values: SUPPORTED_NETWORKS,
            message: "Unsupported Network"
        },
        uppercase: true,
        trim: true,
    },
    address: {
        type: String,
        required: [true, "Wallet Address Is Required"],
        trim: true,
        lowercase: true,
        validate: {
            validator: function (v) {
                if (this.network === "TRON") {
                    return /^T[a-zA-Z0-9]{33}$/.test(v);
                }
                return /^0x[a-fA-F0-9]{40}$/.test(v);
            },
            message: "Invalid Blockchain Address"
        },
    },
    // Who holds the keys for this address. "self" is the current arrangement:
    // the platform generates the key, so the platform has custody of the
    // funds - which is a licensed activity under MiCA. "partner" is the
    // arrangement we move to under a licensed custodian, where the address
    // belongs to the partner and we never see a private key.
    custodian: {
        type: String,
        enum: {
            values: CUSTODIANS,
            message: "Invalid Custodian"
        },
        default: DEFAULT_CUSTODIAN,
    },
    // Only present for self-custody wallets. A partner-custodied address has
    // no key on our side, which is the entire point of that arrangement.
    privateKey: {
        type: String,
        required: function () {
            return this.custodian === "self";
        },
    },
    // Identifier of the address inside the partner's system, so a deposit can
    // be reconciled against their ledger.
    partnerReference: {
        type: String,
        trim: true,
        required: function () {
            return this.custodian === "partner";
        },
    },
    transfer: {
        type: mongoose.Types.ObjectId,
        ref: "transfer",
        required: [true, "Transfer Id Is Required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid Transfer Id"
        },
    },
    withdrawStatus: {
        type: String,
        enum: {
            values: WITHDRAW_STATUES,
            message: "Invalid Withdraw Status"
        },
        default: DEFAULT_WITHDRAW_STATUES,
    },
    withdrawFailedReason: {
        type: String,
        enum: {
            values: WITHDRAW_FAILED_REASONS,
            message: "Invalid Withdraw Failed Reason"
        },
        required: function () {
            return this.withdrawStatus === "failed";
        }
    },
    withdrawServerError: {
        type: String,
    },
    // Bounds how many times the reconciliation cron job will re-attempt a
    // failed withdrawal before leaving it for manual review - a wallet
    // whose deposit never actually landed on-chain would otherwise be
    // re-checked forever.
    withdrawRetryCount: {
        type: Number,
        default: 0,
        min: [0, "Withdraw retry count cannot be negative"],
    },
}, {
    timestamps: true
});

blockchainWalletSchema.index({ createdAt: -1 });

blockchainWalletSchema.index({ network: 1 });

blockchainWalletSchema.index({ address: 1 });

blockchainWalletSchema.index({ transfer: 1 });

blockchainWalletSchema.index({ user: 1 });

blockchainWalletSchema.index({ withdrawStatus: 1 });

blockchainWalletSchema.index({ network: 1, address: 1 }, { unique: true });

blockchainWalletSchema.methods.decryptPrivateKey = function () {
    return decryptWalletPrivateKey(this.privateKey);
};

// Create Blockchain Wallet Model From Blockchain Wallet Schema

const blockchainWalletModel = clientDB.model("blockchain_wallet", blockchainWalletSchema);

module.exports = blockchainWalletModel;