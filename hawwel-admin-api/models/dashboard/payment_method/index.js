const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const PAYMENT_LOGO_PATH_REGEX = /^assets\/images\/payment_methods(?:\/cards)?\/[a-f0-9-]{36}__[a-zA-Z0-9._()-]+\.(jpg|jpeg|png|webp)$/;

// Create Payment Method Schema

const paymentMethodSchema = new mongoose.Schema({
    name: {
        ar: {
            type: String,
            required: [true, "Payment method name (AR) is required"],
            trim: true
        },
        en: {
            type: String,
            required: [true, "Payment method name (EN) is required"],
            trim: true
        }
    },
    symbol: {
        type: String,
        required: [true, "Payment method symbol is required"],
        uppercase: true,
        trim: true,
        minlength: 2,
        maxlength: 10,
    },
    minAmount: {
        type: Number,
        required: [true, "Minimum amount is required"],
        min: [0.00000001, "minAmount must be greater than 0"]
    },
    maxAmount: {
        type: Number,
        required: [true, "Maximum amount is required"],
        min: [0.00000001, "maxAmount must be greater than 0"]
    },
    fee: {
        type: Number,
        required: [true, "Fee is required"],
        min: [0, "Fee cannot be negative"],
        max: [100, "Fee cannot be more than 100%"],
        validate: {
            validator: function (v) {
                return v >= 0 && v <= 100;
            },
            message: "Fee must be a fee between 0 and 100"
        }
    },
    isActivated: {
        type: Boolean,
        default: false
    },
    logoPath: {
        type: String,
        required: [true, "Logo path is required"],
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return false;
                return PAYMENT_LOGO_PATH_REGEX.test(v);
            },
            message: "logoPath must be in the format assets/images/payment_methods/{UUID}__{cleanedBaseName}.{jpg|jpeg|png|webp}"
        }
    },
    cardLogoPath: {
        type: String,
        default: "",
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return PAYMENT_LOGO_PATH_REGEX.test(v);
            },
            message: "cardLogoPath must be in the format assets/images/payment_methods/cards/{UUID}__{cleanedBaseName}.{jpg|jpeg|png|webp}"
        }
    },
    normalizedLogoPath: {
        type: String,
        default: "",
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return PAYMENT_LOGO_PATH_REGEX.test(v);
            },
            message: "normalizedLogoPath must be in the format assets/images/payment_methods/cards/{UUID}__{cleanedBaseName}.{jpg|jpeg|png|webp}"
        }
    }
}, { timestamps: true });

paymentMethodSchema.index({ name: 1 }, { unique: true });

paymentMethodSchema.index({ symbol: 1 });

paymentMethodSchema.index({ isActivated: 1 });

// Create Payment Method Model From Payment Method Schema

const paymentMethodModel = dashboardDB.model("payment_method", paymentMethodSchema);

module.exports = paymentMethodModel;