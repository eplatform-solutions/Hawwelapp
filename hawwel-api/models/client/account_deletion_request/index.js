const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const STATUSES = ["pending", "reviewed", "processed", "rejected", "cancelled"];

const SOURCES = ["mobile_app", "web", "admin"];

const accountDeletionRequestSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "UserId is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid User Id"
        }
    },
    email: {
        type: String,
        default: "",
        trim: true,
        lowercase: true
    },
    mobilePhone: {
        type: String,
        default: "",
        trim: true
    },
    note: {
        type: String,
        default: "",
        trim: true,
        maxlength: [500, "Note cannot exceed 500 characters"]
    },
    status: {
        type: String,
        enum: {
            values: STATUSES,
            message: "Invalid deletion request status"
        },
        default: "pending",
        trim: true
    },
    source: {
        type: String,
        enum: {
            values: SOURCES,
            message: "Invalid deletion request source"
        },
        default: "mobile_app",
        trim: true
    },
    reviewedAt: {
        type: Date
    },
    processedAt: {
        type: Date
    }
}, { timestamps: true });

accountDeletionRequestSchema.index({ userId: 1, status: 1 });

accountDeletionRequestSchema.index({ status: 1, createdAt: -1 });

const accountDeletionRequestModel = clientDB.model(
    "account_deletion_request",
    accountDeletionRequestSchema
);

module.exports = accountDeletionRequestModel;
