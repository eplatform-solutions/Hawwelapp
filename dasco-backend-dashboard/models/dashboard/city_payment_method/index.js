const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create City Payment Method Schema

const cityPaymentMethodSchema = new mongoose.Schema({
    city: {
        type: mongoose.Types.ObjectId,
        ref: "citie",
        required: [true, "City is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid City Id"
        }
    },
    paymentMethod: {
        type: mongoose.Types.ObjectId,
        ref: "payment_method",
        required: [true, "Payment method is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid Payment Method Id"
        }
    }
}, { timestamps: true });

cityPaymentMethodSchema.index({ city: 1 });

cityPaymentMethodSchema.index({ paymentMethod: 1 });

cityPaymentMethodSchema.index({ city: 1, paymentMethod: 1 }, { unique: true });

// Create City Payment Method Model From City Payment Method Schema

const cityPaymentMethodModel = dashboardDB.model("city_payment_method", cityPaymentMethodSchema);

module.exports = cityPaymentMethodModel;