const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create Region Payment Method Schema
// (renamed from "Area Payment Method" - see scripts/migrate-areas-to-regions.js)

const regionPaymentMethodSchema = new mongoose.Schema({
    region: {
        type: mongoose.Types.ObjectId,
        ref: "region",
        required: [true, "Region is required"],
        validate: {
            validator: function (v) {
                return mongoose.Types.ObjectId.isValid(v);
            },
            message: "Invalid Region Id"
        }
    },
    paymentMethod: {
        type: mongoose.Types.ObjectId,
        ref: "payment_method",
        required: [true, "Payment method is required"],
        validate: {
            validator: function (v) {
                return mongoose.Types.ObjectId.isValid(v);
            },
            message: "Invalid Payment Method Id"
        }
    }
}, { timestamps: true });

regionPaymentMethodSchema.index({ region: 1 });

regionPaymentMethodSchema.index({ paymentMethod: 1 });

regionPaymentMethodSchema.index({ region: 1, paymentMethod: 1 }, { unique: true });

// Create Region Payment Method Model From Region Payment Method Schema

const regionPaymentMethodModel = dashboardDB.model("region_payment_method", regionPaymentMethodSchema);

module.exports = regionPaymentMethodModel;
