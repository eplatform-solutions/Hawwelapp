const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../../constants/currencies");

const { SUPPORTED_NETWORKS, BLOCKCHAIN_WALLET_TYPES, DEFAULT_BLOCKCHAIN_WALLET_TYPE } = require("../../../constants/blockchain");

const { encryptWalletPrivateKey, decryptWalletPrivateKey } = require("../../../helpers/wallet_encryption");

const web3 = require("web3");

// Create Blockchain Wallet Schema

const blockchainWalletSchema = new mongoose.Schema({
    symbol: {
        type: String,
        required: [true, "Symbol is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
            message: "Symbol must be one of supported symbols"
        },
        uppercase: true,
        trim: true
    },
    network: {
        type: String,
        required: [true, "Network is required"],
        enum: {
            values: SUPPORTED_NETWORKS,
            message: "Network must be one of supported networks"
        },
        uppercase: true,
        trim: true
    },
    address: {
        type: String,
        required: [true, "Wallet address is required"],
        trim: true,
        lowercase: true,
        validate: {
            validator: function (v) {
                if (!v) return false;
                if (this.network === "TRON") {
                    return /^T[a-zA-Z0-9]{33}$/.test(v);
                }
                return /^0x[a-fA-F0-9]{40}$/.test(v);
            },
            message: "Invalid blockchain address format"
        }
    },
    privateKey: {
        type: String,
        required: [function () { return this.type === BLOCKCHAIN_WALLET_TYPES[1]; }, "Private key is required for network-fee-funding wallet"],
    },
    type: {
        type: String,
        default: DEFAULT_BLOCKCHAIN_WALLET_TYPE,
        enum: {
            values: BLOCKCHAIN_WALLET_TYPES,
            message: "Invalid wallet type"
        },
        trim: true
    }
}, { timestamps: true });

blockchainWalletSchema.index(
    { symbol: 1, network: 1, type: 1 },
    { unique: true, name: "symbol_1_network_1_type_1" }
);

blockchainWalletSchema.pre("save", function (next) {
    if (!this.isModified("privateKey") || !this.privateKey) {
        return next();
    }
    if (this.type === "network-fee-funding") {
        if (!this.privateKey.startsWith("0x")) {
            this.privateKey = "0x" + this.privateKey;
        }
        const account = web3.eth.accounts.privateKeyToAccount(this.privateKey);
        this.address = account.address;
        this.privateKey = encryptWalletPrivateKey(this.privateKey);
    }
    next();
});

blockchainWalletSchema.methods.decryptPrivateKey = function () {
    return decryptWalletPrivateKey(this.privateKey);
};

// Create Blockchain Wallet Model From Blockchain Wallet Schema

const blockchainWalletModel = dashboardDB.model("blockchain_wallet", blockchainWalletSchema);

module.exports = blockchainWalletModel;