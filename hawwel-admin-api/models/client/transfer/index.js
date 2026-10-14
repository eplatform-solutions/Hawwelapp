const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { TRANSFER_STATUSES, DEFAULT_TRANSFER_STATUS } = require("../../../constants/transactions");

const { SUPPORTED_CRYPTO_CURRENCIES, SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../../constants/currencies");

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

const { isValidDateOrTimestamp } = require("../../../validators/common/date");

const counterModel = require("../counter");

// Create Transfer Schema

const transferSchema = new mongoose.Schema({
    sender: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "Sender is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid sender Id"
        }
    },
    fromCountry: {
        type: String,
        required: [true, "From country is required"],
        trim: true,
        uppercase: true,
        minlength: [2, "Country code must be 2 letters"],
        maxlength: [2, "Country code must be 2 letters"],
        validate: {
            validator: v => /^[A-Z]{2}$/.test(v),
            message: "fromCountry must be a 2-letter country code, e.g., SY"
        }
    },
    toCountry: {
        type: String,
        required: [true, "To country is required"],
        trim: true,
        uppercase: true,
        minlength: [2, "Country code must be 2 letters"],
        maxlength: [2, "Country code must be 2 letters"],
        validate: {
            validator: v => /^[A-Z]{2}$/.test(v),
            message: "toCountry must be a 2-letter country code, e.g., SY"
        }
    },
    amount: {
        type: Number,
        required: [true, "Amount is required"],
        min: [0, "Amount must be greater than 0"]
    },
    paid: {
        type: Number,
        default: 0,
        min: [0, "Paid amount cannot be negative"]
    },
    netAmount: {
        type: Number,
        default: 0,
        min: [0, "Net amount cannot be negative"]
    },
    rate: {
        type: Number,
        required: [true, "Rate is required"],
        min: [0, "Rate must be positive"]
    },
    fee: {
        type: Number,
        required: [true, "Fee is required"],
        min: [0, "Fee must be positive"],
        max: [100, "Fee cannot be more than 100%"],
    },
    network: {
        type: String,
        enum: {
            values: [...SUPPORTED_NETWORKS, ""],
            message: "Unsupported network"
        },
        default: "",
        trim: true
    },
    currencyName: {
        type: String,
        required: [true, "Currency name is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCIES,
            message: "Unsupported currency name"
        },
        trim: true
    },
    symbol: {
        type: String,
        required: [true, "Currency symbol is required"],
        enum: {
            values: SUPPORTED_CRYPTO_CURRENCY_SYMBOLS,
            message: "Unsupported currency symbol"
        },
        uppercase: true,
        trim: true
    },
    city: {
        ar: { type: String, required: [true, "City AR is required"], trim: true },
        en: { type: String, required: [true, "City EN is required"], trim: true }
    },
    area: {
        ar: { type: String, required: [true, "Area AR is required"], trim: true },
        en: { type: String, required: [true, "Area EN is required"], trim: true }
    },
    paymentMethod: {
        name: {
            ar: { type: String, required: [true, "Payment method name AR is required"], trim: true },
            en: { type: String, required: [true, "Payment method name EN is required"], trim: true }
        },
        symbol: { type: String, required: [true, "Payment method symbol is required"], trim: true },
        logoPath: { type: String, required: [true, "Payment method logoPath is required"], trim: true }
    },
    status: {
        type: String,
        enum: {
            values: TRANSFER_STATUSES,
            message: "Invalid transfer status"
        },
        default: DEFAULT_TRANSFER_STATUS,
        trim: true
    },
    transferNumber: {
        type: Number,
        min: [1, "Transfer number must be greater than 0"]
    },
    receiver: {
        fullName: { type: String, required: [true, "Receiver fullName is required"], trim: true },
        mobilePhone: {
            type: String,
            required: [true, "Receiver mobilePhone is required"],
            trim: true,
            validate: {
                validator: v => /^[+0-9]{6,20}$/.test(v),
                message: "Invalid mobile phone format"
            }
        }
    },
    expirationAt: {
        type: Date,
        required: [true, "Expiration date is required"],
        validate: {
            validator: v => !v || isValidDateOrTimestamp(v),
            message: "Invalid expiration date"
        }
    },
    paidAt: {
        type: Date,
        required: function () {
            return ["full-paid", "under-paid", "over-paid"].includes(this.status);
        },
        validate: {
            validator: v => !v || isValidDateOrTimestamp(v),
            message: "paidAt must be a valid date"
        }
    },
    paymentProofNote: {
        type: String,
        default: "",
        trim: true,
        maxlength: [1000, "Payment proof note cannot exceed 1000 characters"]
    },
    paymentProofImagePath: {
        type: String,
        default: "",
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return /^assets\/images\/transfers\/[a-f0-9-]{36}__[a-zA-Z0-9._()-]+\.(jpg|jpeg|png|webp)$/.test(v);
            },
            message: "paymentProofImagePath must be in the format assets/images/transfers/{UUID}__{cleanedBaseName}.{jpg|jpeg|png|webp}"
        }
    },
    // Photo of WHERE the receiver picks the money up (attached at the
    // can-receive step) - kept separate from paymentProofImagePath, which is
    // the handover proof attached at the received step, so the second upload
    // no longer overwrites and deletes the first.
    receivingPlaceImagePath: {
        type: String,
        default: "",
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return true;
                return /^assets\/images\/transfers\/[a-f0-9-]{36}__[a-zA-Z0-9._()-]+\.(jpg|jpeg|png|webp)$/.test(v);
            },
            message: "receivingPlaceImagePath must be in the format assets/images/transfers/{UUID}__{cleanedBaseName}.{jpg|jpeg|png|webp}"
        }
    },
    // Who last moved this transfer into a money-affecting status
    // (full-paid/under-paid/over-paid/received) and why - required
    // alongside the transition itself, not attached as an optional
    // afterthought. adminModel lives in a separate DB connection so this
    // is a plain id, not a populate()-able ref.
    lastStatusChange: {
        adminId: {
            type: mongoose.Types.ObjectId,
            validate: {
                validator: v => !v || mongoose.Types.ObjectId.isValid(v),
                message: "Invalid admin Id"
            }
        },
        note: {
            type: String,
            trim: true,
            maxlength: [1000, "Status change note cannot exceed 1000 characters"]
        },
        at: {
            type: Date,
            validate: {
                validator: v => !v || isValidDateOrTimestamp(v),
                message: "lastStatusChange.at must be a valid date"
            }
        }
    }
}, { timestamps: true });

transferSchema.index({ sender: 1 });

transferSchema.index({ receiver: 1 });

transferSchema.index({ fromCountry: 1 });

transferSchema.index({ toCountry: 1 });

transferSchema.index({ status: 1 });

transferSchema.index({ createdAt: -1 });

transferSchema.index({ transferNumber: 1 });

transferSchema.index({ sender: 1, status: 1, createdAt: -1, "paymentMethod.symbol": 1 });

transferSchema.pre("save", async function (next) {
    if (!this.isNew) return next();
    const counter = await counterModel.findOneAndUpdate(
        { name: "transferNumber" },
        { $inc: { seq: 1 } },
        { new: true, upsert: true }
    );
    this.transferNumber = counter.seq;
    next();
});

// Create Transfer Model From Transfer Schema

const transferModel = clientDB.model("transfer", transferSchema);

module.exports = transferModel;