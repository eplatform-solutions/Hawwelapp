const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { KYC_STATUSES, DEFAULT_KYC_STATUS } = require("../../../constants/kyc");

const { isValidDateOrTimestamp } = require("../../../validators/common/date");

// Create KYC Schema

const kycSchema = new mongoose.Schema({
    user: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "User is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid User Id"
        }
    },
    filePath: {
        type: String,
        required: [true, "File path is required"],
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return false;
                return /^assets\/images\/kyc\/[a-f0-9-]{36}__[a-zA-Z0-9._()-]+\.(jpg|jpeg|png|webp|pdf)$/.test(v);
            },
            message: "logoPath must be in the format assets/images/kyc/{UUID}__{cleanedBaseName}.{jpg|jpeg|png|webp||pdf}",
        }
    },
    documentImages: {
        type: [String],
        default: undefined,
        validate: {
            validator: function (values) {
                if (!values || values.length === 0) {
                    return true;
                }
                if (values.length > 2) {
                    return false;
                }
                return values.every((v) => /^assets\/images\/kyc\/[a-f0-9-]{36}__[a-zA-Z0-9._()-]+\.(jpg|jpeg|png|webp|pdf)$/.test(v));
            },
            message: "documentImages must contain up to two valid KYC image paths",
        },
    },
    status: {
        type: String,
        enum: {
            values: KYC_STATUSES,
            message: "Invalid KYC status"
        },
        default: DEFAULT_KYC_STATUS,
        trim: true
    },
    verifiedAt: {
        type: Date,
        required: [
            function () { return this.status === "verified"; },
            "verifiedAt is required when status is verified"
        ],
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "verifiedAt must be a valid date"
        }
    },
    rejectedAt: {
        type: Date,
        required: [
            function () { return this.status === "rejected"; },
            "rejectedAt is required when status is rejected"
        ],
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "rejectedAt must be a valid date"
        }
    },
    rejectionReason: {
        type: String,
        required: [
            function () { return this.status === "rejected"; },
            "rejectionReason is required when status is rejected"
        ],
        trim: true
    },
    blockedAt: {
        type: Date,
        required: [
            function () { return this.status === "blocked"; },
            "blockedAt is required when status is blocked"
        ],
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "blockedAt must be a valid date"
        }
    },
    blockingReason: {
        type: String,
        required: [
            function () { return this.status === "blocked"; },
            "blockingReason is required when status is blocked"
        ],
        trim: true
    },
    cancelBlockedAt: {
        type: Date,
        required: [
            function () { return this.status === "cancel-blocked"; },
            "cancelBlockedAt is required when status is cancel-blocked"
        ],
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "cancelBlockedAt must be a valid date"
        }
    },
    removeVerifiedAt: {
        type: Date,
        required: [
            function () { return this.status === "remove-verified"; },
            "removeVerifiedAt is required when status is remove-verified"
        ],
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "removeVerifiedAt must be a valid date"
        }
    },
    removeVerifyingReason: {
        type: String,
        required: [
            function () { return this.status === "remove-verified"; },
            "removeVerifyingReason is required when status is remove-verified"
        ],
        trim: true
    }
}, { timestamps: true });

kycSchema.index({ user: 1 });

kycSchema.index({ status: 1 });

kycSchema.index({ createdAt: -1 });

kycSchema.index({ user: 1, status: 1 });

kycSchema.index({ user: 1, createdAt: -1 });

// Create KYC Model From KYC Schema

const kycModel = clientDB.model("kyc", kycSchema);

module.exports = kycModel;