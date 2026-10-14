const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../../constants/currencies");

// Create Exchange Rate Schema

const exchangeRateSchema = new mongoose.Schema({
    baseSymbol: {
        type: String,
        required: [true, "Base symbol is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
            message: "Invalid base symbol"
        },
        trim: true,
        uppercase: true
    },
    quoteSymbol: {
        type: String,
        required: [true, "Quote symbol is required"],
        enum: {
            values: ["SYP"],
            message: "Quote symbol must be SYP"
        },
        trim: true,
        uppercase: true,
        default: "SYP"
    },
    rate: {
        type: Number,
        required: [true, "Exchange rate is required"],
        min: [0.0000000001, "Exchange rate must be greater than 0"]
    }
}, { timestamps: true });

exchangeRateSchema.index({ baseSymbol: 1, quoteSymbol: 1 }, { unique: true });

// Create Exchange Rate Model From Exchange Rate Schema

const exchangeRateModel = dashboardDB.model("exchange_rate", exchangeRateSchema);

module.exports = exchangeRateModel;