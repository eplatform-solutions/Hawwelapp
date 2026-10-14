const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create Area Payment Method Schema

const areaPaymentMethodSchema = new mongoose.Schema({
    region: {
        type: mongoose.Types.ObjectId,
        ref: "area",
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

areaPaymentMethodSchema.index({ region: 1 });

areaPaymentMethodSchema.index({ paymentMethod: 1 });

areaPaymentMethodSchema.index({ region: 1, paymentMethod: 1 }, { unique: true });

// Create Area Payment Method Model From Area Payment Method Schema
//
// Same underlying issue as the area model: the join collection was
// renamed to "region_payment_methods" and its `area` field renamed to
// `region` by the admin dashboard's migration - this model was never
// updated to match, so it was reading/writing a stale, empty collection.
const areaPaymentMethodModel = dashboardDB.model("area_payment_method", areaPaymentMethodSchema, "region_payment_methods");

module.exports = areaPaymentMethodModel;