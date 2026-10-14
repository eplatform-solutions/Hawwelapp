const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { COUNTRIES, TWO_FACTOR_AUTH_METHODS, DEFAULT_STATUS, STATUSES } = require("../../../constants/users");

const { isValidDateOrTimestamp } = require("../../../validators/common/date");

// Create User Schema

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, "Name is required"],
        trim: true,
        minlength: [2, "Name must be at least 2 characters"],
        maxlength: [100, "Name cannot exceed 100 characters"]
    },
    nickname: {
        type: String,
        required: [true, "Nickname is required"],
        trim: true,
        minlength: [2, "Nickname must be at least 2 characters"],
        maxlength: [50, "Nickname cannot exceed 50 characters"]
    },
    fatherName: {
        type: String,
        default: "",
        trim: true,
        maxlength: [100, "Father name cannot exceed 100 characters"]
    },
    country: {
        type: String,
        required: [true, "Country is required"],
        enum: {
            values: COUNTRIES,
            message: "Invalid country code"
        },
        trim: true,
        uppercase: true
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
    email: {
        type: String,
        required: false,
        trim: true,
        lowercase: true,
        validate: {
            validator: v => !v || /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v),
            message: "Invalid email format"
        }
    },
    password: {
        type: String,
        required: [true, "Password is required"],
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
    notificationsToken: {
        type: String,
        trim: true,
        default: "",
        validate: {
            validator: v => !v || /^[a-zA-Z0-9\-_:]{20,255}$/.test(v),
            message: "Invalid FCM notifications token"
        }
    },
    // "android" | "ios" - which platform registered notificationsToken;
    // makes push failures (e.g. missing APNs credential) attributable.
    notificationsPlatform: {
        type: String,
        trim: true,
        lowercase: true,
        default: "",
        maxlength: 20,
    },
    accountNumber: {
        type: Number,
        min: [1, "Account number must be positive"]
    },
    isVerified: {
        type: Boolean,
        default: false
    },
    verifiedAt: {
        type: Date,
        required: function () { return this.isVerified; },
        validate: {
            validator: v => !v || isValidDateOrTimestamp(v),
            message: "verifiedAt must be a valid date"
        }
    },
    imagePath: {
        type: String,
        default: "",
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return /^assets\/images\/users\/[a-f0-9-]{36}__[a-zA-Z0-9._()-]+\.(jpg|jpeg|png|webp)$/.test(v);
            },
            message: "imagePath must be in the format assets/images/users/{UUID}__{cleanedBaseName}.{jpg|jpeg|png|webp}"
        }
    },
    twoFA: {
        enabled: { type: Boolean, default: false },
        methods: {
            type: [String],
            enum: {
                values: TWO_FACTOR_AUTH_METHODS,
                message: "Invalid twoFA method"
            },
            default: []
        }
    },
    status: {
        type: String,
        enum: {
            values: STATUSES,
            message: "Invalid status"
        },
        default: DEFAULT_STATUS,
        trim: true
    },
    blockingReason: {
        type: String,
        trim: true,
        required: function () { return this.status === "blocked"; }
    },
    blockingDate: {
        type: Date,
        required: function () { return this.status === "blocked"; },
        validate: {
            validator: v => !v || isValidDateOrTimestamp(v),
            message: "blockingDate must be a valid date"
        }
    },
    dateOfCancelBlocking: {
        type: Date,
        validate: {
            validator: v => !v || isValidDateOrTimestamp(v),
            message: "dateOfCancelBlocking must be a valid date"
        }
    }
}, { timestamps: true });

userSchema.index({ email: 1 });

userSchema.index({ mobilePhone: 1 });

userSchema.index({ accountNumber: 1 });

userSchema.index({ status: 1 });

userSchema.index({ createdAt: -1 });

userSchema.virtual("kyc", {
    ref: "kyc",
    localField: "_id",
    foreignField: "user",
    justOne: true
});

userSchema.set("toJSON", { virtuals: true });

userSchema.set("toObject", { virtuals: true });

// Create User Model From User Schema

const userModel = clientDB.model("user", userSchema);

module.exports = userModel;