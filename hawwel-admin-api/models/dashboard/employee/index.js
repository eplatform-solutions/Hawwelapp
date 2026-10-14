const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { STATUSES, DEFAULT_STATUS } = require("../../../constants/admins");

const { isValidDateOrTimestamp } = require("../../../validators/common/date");

// Create Employee Schema

const employeeSchema = new mongoose.Schema({
    fullName: {
        type: String,
        required: [true, "Full name is required"],
        trim: true
    },
    email: {
        type: String,
        required: [true, "Email is required"],
        trim: true,
        lowercase: true,
        validate: {
            validator: v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v),
            message: "Invalid email format"
        }
    },
    mobilePhone: {
        type: String,
        required: [true, "Mobile phone is required"],
        trim: true,
        validate: {
            validator: v => /^[+0-9]{6,20}$/.test(v),
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
    city: {
        type: mongoose.Types.ObjectId,
        ref: "citie",
        required: [true, "City is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid City Id"
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
    blockingReason: {
        type: String,
        trim: true,
        required: [function () { return this.status === "blocked"; }, "blockingReason is required when status is blocked"]
    },
    blockingDate: {
        type: Date,
        required: [function () { return this.status === "blocked"; }, "blockingDate is required when status is blocked"],
        validate: {
            validator: v => !v || isValidDateOrTimestamp(v),
            message: "blockingDate must be a valid date"
        }
    }
}, { timestamps: true });

employeeSchema.index({ email: 1 }, { unique: true });

employeeSchema.index({ mobilePhone: 1 }, { unique: true });

employeeSchema.index({ city: 1 });

employeeSchema.index({ status: 1 });

// Create Employee Model From Employee Schema

const employeeModel = dashboardDB.model("employee", employeeSchema);

module.exports = employeeModel;