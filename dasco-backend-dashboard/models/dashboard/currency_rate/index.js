const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const currencyRateSchema = new mongoose.Schema({
    code: {
        type: String,
        required: [true, "Currency code is required"],
        trim: true,
        uppercase: true,
        minlength: 2,
        maxlength: 10,
    },
    name: {
        type: String,
        trim: true,
        default: "",
    },
    usdtRate: {
        type: Number,
        required: [true, "USDT rate is required"],
        min: [0.00000001, "USDT rate must be greater than 0"],
    },
    usdcRate: {
        type: Number,
        required: [true, "USDC rate is required"],
        min: [0.00000001, "USDC rate must be greater than 0"],
    },
}, { timestamps: true });

currencyRateSchema.index({ code: 1 }, { unique: true });

const currencyRateModel = dashboardDB.model("currency_rate", currencyRateSchema);

module.exports = currencyRateModel;
