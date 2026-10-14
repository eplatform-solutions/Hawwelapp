const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { TRANSFER_STATUSES, DEFAULT_TRANSFER_STATUS } = require("../../../constants/transactions");

const { SUPPORTED_CRYPTO_CURRENCIES, SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../../constants/currencies");

const { SUPPORTED_NETWORKS } = require("../../../constants/blockchain");

const { isValidDateOrTimestamp } = require("../../../validators/common/date");

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
    // Optional: a transfer using a payment method bound directly at the
    // country level (see repositories/payment_methods getPaymentMethodsInCountry)
    // has no city/region to record - see transferByParameter.
    city: {
        ar: { type: String, trim: true },
        en: { type: String, trim: true }
    },
    area: {
        ar: { type: String, trim: true },
        en: { type: String, trim: true }
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
    // the handover proof attached at the received step.
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
    // Originator and beneficiary information required to travel with every
    // crypto transfer under the EU Transfer of Funds Regulation (2023/1113).
    // There is no minimum amount for this - it applies to every transfer.
    //
    // Filled in when the deposit lands, because the originator's wallet
    // address is only knowable from the transaction itself; the webhook tells
    // us our own address, not where the money came from. Left loosely typed so
    // a gap is recorded as a gap: an incomplete record has to be visible to a
    // reviewer rather than silently completed with a guess.
    travelRule: {
        originator: {
            name: { type: String, trim: true, default: "" },
            country: { type: String, trim: true, default: "" },
            customerNumber: { type: String, trim: true, default: "" },
            walletAddress: { type: String, trim: true, lowercase: true, default: "" },
            walletType: {
                type: String,
                enum: {
                    values: ["unknown", "self-hosted", "hosted"],
                    message: "Invalid originator wallet type"
                },
                default: "unknown",
            },
        },
        beneficiary: {
            name: { type: String, trim: true, default: "" },
            mobilePhone: { type: String, trim: true, default: "" },
            country: { type: String, trim: true, default: "" },
            city: { type: String, trim: true, default: "" },
            area: { type: String, trim: true, default: "" },
        },
        amount: { type: Number, min: 0 },
        currency: { type: String, trim: true, default: "" },
        network: { type: String, trim: true, default: "" },
        transactionId: { type: String, trim: true, default: "" },
        // Above the threshold, a transfer from a self-hosted wallet needs
        // proof the customer controls that wallet.
        selfHostedVerificationRequired: { type: Boolean, default: false },
        originatorAddressResolved: { type: Boolean, default: false },
        complete: { type: Boolean, default: false },
        collectedAt: { type: Date },
    }
}, { timestamps: true });

transferSchema.index({ sender: 1 });

transferSchema.index({ receiver: 1 });

transferSchema.index({ fromCountry: 1 });

transferSchema.index({ toCountry: 1 });

transferSchema.index({ status: 1 });

transferSchema.index({ createdAt: -1 });

transferSchema.index({ transferNumber: 1 });

// A compliance officer's first question is "which transfers are missing their
// travel-rule data?", so that lookup gets an index of its own.
transferSchema.index({ "travelRule.complete": 1, createdAt: -1 });

transferSchema.index({ sender: 1, status: 1, createdAt: -1, "paymentMethod.symbol": 1 });

// Create Transfer Model From Transfer Schema

const transferModel = clientDB.model("transfer", transferSchema);

module.exports = transferModel;