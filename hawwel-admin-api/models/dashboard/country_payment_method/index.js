const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create Country Payment Method Schema

const countryPaymentMethodSchema = new mongoose.Schema({
    country: {
        type: mongoose.Types.ObjectId,
        ref: "countrie",
        required: [true, "Country is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid country Id"
        }
    },
    paymentMethod: {
        type: mongoose.Types.ObjectId,
        ref: "payment_method",
        required: [true, "Payment method is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid payment method Id"
        }
    }
}, { timestamps: true });

countryPaymentMethodSchema.index({ country: 1, paymentMethod: 1 }, { unique: true });

// Create Country Payment Method Model From Country Payment Method Schema

const countryPaymentMethodModel = dashboardDB.model("country_payment_method", countryPaymentMethodSchema);

module.exports = countryPaymentMethodModel;