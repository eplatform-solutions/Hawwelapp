const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { TATUM_SUBSCRIPTION_TYPES, DEFAULT_TATUM_SUBSCRIPTION_TYPE } = require("../../../constants/blockchain");

const { MAX_RETRIES } = require("../../../constants/cron");

// Create Tatum Subscription Schema

const tatumSubscriptionSchema = new mongoose.Schema({
    user: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "User is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid User Id"
        }
    },
    transfer: {
        type: mongoose.Types.ObjectId,
        ref: "transfer",
        required: [true, "Transfer is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid Transfer Id"
        }
    },
    type: {
        type: String,
        enum: {
            values: TATUM_SUBSCRIPTION_TYPES,
            message: "Invalid subscription type"
        },
        default: DEFAULT_TATUM_SUBSCRIPTION_TYPE,
        trim: true
    },
    subscriptionId: {
        type: String,
        required: [true, "SubscriptionId is required"],
        trim: true,
        maxlength: [100, "SubscriptionId cannot exceed 100 characters"],
        validate: {
            validator: function (v) {
                return v && v.length > 0;
            },
            message: "SubscriptionId cannot be empty"
        }
    },
    isDeleted: {
        type: Boolean,
        default: false,
    },
    deleteRequested: {
        type: Boolean,
        default: false,
    },
    retryCount: {
        type: Number,
        default: 0,
        max: MAX_RETRIES
    },
    lastError: {
        type: String
    },
    deletedAt: {
        type: Date,
        required: [function () {
            return this.isDeleted;
        }, "Deleted At Required When isDeleted equal true"]
    }
}, { timestamps: true });

tatumSubscriptionSchema.index({ user: 1 });

tatumSubscriptionSchema.index({ transfer: 1 });

tatumSubscriptionSchema.index({ type: 1 });

tatumSubscriptionSchema.index({ subscriptionId: 1 });

tatumSubscriptionSchema.index({ createdAt: -1 });

tatumSubscriptionSchema.index({
    transfer: 1,
    isDeleted: 1,
    deleteRequested: 1,
});

tatumSubscriptionSchema.index({
    deleteRequested: 1,
    isDeleted: 1,
    retryCount: 1
});

// Create Tatum Subscription Model From Tatum Subscription Schema

const tatumSubscriptionModel = clientDB.model("tatum_subscription", tatumSubscriptionSchema);

module.exports = tatumSubscriptionModel;