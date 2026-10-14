const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { SUPPORTED_CRYPTO_CURRENCIES, SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../../constants/currencies");

// Create Supported Currencies By Networks Schema

const supportedCurrenciesByNetworksSchema = new mongoose.Schema({
    networks: {
        type: [String],
        required: [true, "Networks array is required"],
        validate: {
            validator: function (v) {
                if (!v || v.length === 0) return false; // يجب أن تحتوي على عناصر
                return v.every(net => SUPPORTED_NETWORKS.includes(net));
            },
            message: props => `Invalid networks: ${props.value}. Allowed networks: ${SUPPORTED_NETWORKS.join(", ")}`
        }
    },
    currencyName: {
        type: String,
        required: [true, "Currency name is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCIES,
            message: props => `Invalid currency name: ${props.value}. Allowed: ${SUPPORTED_CRYPTO_CURRENCIES.join(", ")}`
        }
    },
    symbol: {
        type: String,
        required: [true, "Currency symbol is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
            message: props => `Invalid currency symbol: ${props.value}. Allowed: ${SUPPORTED_CRYPTO_CURRENCY_SYMBOLS.join(", ")}`
        }
    }
}, { timestamps: true });

supportedCurrenciesByNetworksSchema.index(
    { currencyName: 1, symbol: 1, networks: 1 },
    { unique: true }
);

// Create Supported Currencies By Networks Model From Supported Currencies By Networks Schema

const supportedCurrenciesByNetworksModel = dashboardDB.model("supported_currencies_by_networks", supportedCurrenciesByNetworksSchema);

module.exports = supportedCurrenciesByNetworksModel;