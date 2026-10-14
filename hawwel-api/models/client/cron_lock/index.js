const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { CRON_JOB_NAMES } = require("../../../constants/cron")

const cronLockSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, "Cron job name is required"],
        trim: true,
        enum: {
            values: CRON_JOB_NAMES,
            message: "Invalid cron job name. Allowed: " + CRON_JOB_NAMES.join(", ")
        }
    },
    locked: {
        type: Boolean,
        default: false,
    },
    lockedAt: {
        type: Date,
        default: null
    },
    lockExpiresAt: {
        type: Date,
        default: null,
    }
}, { timestamps: true });

cronLockSchema.index({ name: 1 }, { unique: true });

cronLockSchema.index({ locked: 1 });

cronLockSchema.index({ lockExpiresAt: 1 });

cronLockSchema.index({ createdAt: -1 });

const cronLockModel = clientDB.model("cron_lock", cronLockSchema);

module.exports = cronLockModel;