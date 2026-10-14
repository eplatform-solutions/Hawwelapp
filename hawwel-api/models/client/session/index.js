const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { TYPES_OF_USE_VERIFICATION_CODE, DEFAULT_TYPES_OF_USE_VERIFICATION_CODE } = require("../../../constants/verification_code");

// Create Session Schema

const sessionSchema = new mongoose.Schema({
    typeOfUse: {
        type: String,
        enum: {
            values: TYPES_OF_USE_VERIFICATION_CODE,
            message: "Invalid typeOfUse, must be one of " + TYPES_OF_USE_VERIFICATION_CODE.join(", ")
        },
        default: DEFAULT_TYPES_OF_USE_VERIFICATION_CODE,
        trim: true
    },
    email: {
        type: String,
        required: [function () { return !this.mobilePhone; }, "Email is required if mobilePhone is not provided"],
        trim: true,
        lowercase: true,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
            },
            message: "Invalid email format"
        }
    },
    mobilePhone: {
        type: String,
        required: [function () { return !this.email; }, "Mobile phone is required if email is not provided"],
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return /^[+0-9]{6,20}$/.test(v);
            },
            message: "Invalid mobile phone format"
        }
    }
}, { timestamps: true });

sessionSchema.index({ email: 1 });

sessionSchema.index({ mobilePhone: 1 });

sessionSchema.index({ typeOfUse: 1 });

sessionSchema.index({ createdAt: -1 });

// Create Session Model From Session Schema

const sessionModel = clientDB.model("session", sessionSchema);

module.exports = sessionModel;