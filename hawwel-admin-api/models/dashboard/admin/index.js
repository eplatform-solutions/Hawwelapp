const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { STATUSES, DEFAULT_STATUS } = require("../../../constants/admins");

const { isValidDateOrTimestamp } = require("../../../validators/common/date");

// Create Admin Schema

const adminSchema = new mongoose.Schema({
    fullName: {
        type: String,
        required: [true, "Full name is required"],
        trim: true
    },
    userName: {
        type: String,
        required: [true, "User name is required"],
        trim: true
    },
    email: {
        type: String,
        required: [true, "Email is required"],
        trim: true,
        lowercase: true,
        validate: {
            validator: function (v) {
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
            },
            message: "Invalid email format"
        }
    },
    mobilePhone: {
        type: String,
        required: [true, "Mobile phone is required"],
        trim: true,
        validate: {
            validator: function (v) {
                return /^[+0-9]{6,20}$/.test(v);
            },
            message: "Invalid mobile phone format"
        }
    },
    password: {
        type: String,
        required: [true, "Password is required"],
        trim: true,
        minlength: [8, "Password must be at least 8 characters"],
        maxlength: [128, "Password cannot exceed 128 characters"],
        validate: {
            validator: function (v) {
                if (/^\$2[aby]\$/.test(v)) return true;
                return /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/.test(v);
            },
            message: function (props) {
                const val = props.value || "";
                const errors = [];
                if (val.length < 8) errors.push("at least 8 characters");
                if (!/[A-Z]/.test(val)) errors.push("one uppercase letter");
                if (!/[a-z]/.test(val)) errors.push("one lowercase letter");
                if (!/\d/.test(val)) errors.push("one number");
                return "Password must contain " + errors.join(", ");
            }
        }
    },
    status: {
        type: String,
        enum: {
            values: STATUSES,
            message: `Invalid status. Allowed values: ${STATUSES.join(", ")}`
        },
        default: DEFAULT_STATUS,
        trim: true
    },
    isSuperAdmin: {
        type: Boolean,
        default: false
    },
    role: {
        type: mongoose.Types.ObjectId,
        ref: "role",
        required: [function () { return !this.isSuperAdmin; }, "Role is required for non-super admins"],
        validate: {
            validator: function (v) {
                if (!v) return true;
                return mongoose.Types.ObjectId.isValid(v);
            },
            message: "Invalid Role Id"
        }
    },
    lastActivity: {
        type: Date,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "lastActivity must be a valid date"
        }
    },
    blockingReason: {
        type: String,
        trim: true,
        required: [function () { return this.status === "blocked"; }, "blockingReason is required when status is blocked"]
    },
    blockingDate: {
        type: Date,
        required: [function () { return this.status === "blocked"; }, "blockingDate is required when status is blocked"],
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "blockingDate must be a valid date"
        }
    },
    dateOfCancelBlocking: {
        type: Date,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return isValidDateOrTimestamp(v);
            },
            message: "dateOfCancelBlocking must be a valid date"
        }
    }
}, {
    timestamps: true
});

adminSchema.index({ userName: 1 });

adminSchema.index({ email: 1 }, { unique: true });

adminSchema.index({ mobilePhone: 1 }, { unique: true });

adminSchema.index({ status: 1 });

// Create Admin Model From Admin Schema

const adminModel = dashboardDB.model("admin", adminSchema);

module.exports = adminModel;