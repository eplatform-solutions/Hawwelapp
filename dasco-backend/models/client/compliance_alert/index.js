const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const {
    ALERT_TYPES,
    ALERT_STATUSES,
    ALERT_SEVERITIES,
    PARTY_TYPES,
} = require("../../../constants/compliance");

// An auditable record of every compliance decision the platform took on a
// transfer attempt: sanctions hits, screening outages, and limit breaches.
// Regulators and partner auditors ask to see the trail, not just the control,
// so nothing here is ever deleted - alerts are resolved, not removed.

const complianceAlertSchema = new mongoose.Schema({
    type: {
        type: String,
        required: [true, "Alert type is required"],
        enum: {
            values: ALERT_TYPES,
            message: "Invalid alert type"
        },
    },
    severity: {
        type: String,
        required: [true, "Severity is required"],
        enum: {
            values: ALERT_SEVERITIES,
            message: "Invalid severity"
        },
    },
    status: {
        type: String,
        enum: {
            values: ALERT_STATUSES,
            message: "Invalid status"
        },
        default: "open",
    },
    user: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "User is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid user id"
        }
    },
    // Absent when the alert stopped the transfer before it was ever persisted.
    transfer: {
        type: mongoose.Types.ObjectId,
        ref: "transfer",
    },
    partyType: {
        type: String,
        enum: {
            values: PARTY_TYPES,
            message: "Invalid party type"
        },
    },
    // The name as it was screened, kept verbatim so a reviewer can see exactly
    // what was sent to the provider.
    screenedName: {
        type: String,
        trim: true,
        maxlength: [200, "Screened name cannot exceed 200 characters"],
    },
    matchScore: {
        type: Number,
        min: [0, "Match score cannot be negative"],
        max: [1, "Match score cannot exceed 1"],
    },
    // Provider payload trimmed to what a reviewer needs: list entry ids,
    // captions and the datasets that matched.
    matches: {
        type: [
            new mongoose.Schema({
                entityId: { type: String, trim: true },
                caption: { type: String, trim: true },
                datasets: { type: [String], default: [] },
                score: { type: Number, min: 0, max: 1 },
            }, { _id: false })
        ],
        default: [],
    },
    details: {
        type: String,
        trim: true,
        maxlength: [1000, "Details cannot exceed 1000 characters"],
    },
    // Whether this alert stopped the transfer from being created.
    blockedTransfer: {
        type: Boolean,
        default: false,
    },
    reviewedBy: {
        type: mongoose.Types.ObjectId,
        ref: "admin",
    },
    reviewedAt: {
        type: Date,
    },
    reviewNote: {
        type: String,
        trim: true,
        maxlength: [1000, "Review note cannot exceed 1000 characters"],
    },
}, { timestamps: true });

complianceAlertSchema.index({ status: 1, createdAt: -1 });
complianceAlertSchema.index({ user: 1, status: 1 });
complianceAlertSchema.index({ transfer: 1 });
complianceAlertSchema.index({ type: 1, status: 1 });

module.exports = clientDB.model("compliance_alert", complianceAlertSchema);
