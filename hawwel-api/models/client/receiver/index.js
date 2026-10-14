const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

// Create Receiver Schema

const receiverSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "UserId is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid User Id"
        }
    },
    fullName: {
        type: String,
        required: [true, "Full name is required"],
        trim: true,
        minlength: [2, "Full name must be at least 2 characters"],
        maxlength: [100, "Full name cannot exceed 100 characters"],
        validate: {
            validator: function (v) {
                return v && v.trim().length > 0;
            },
            message: "Full name cannot be empty"
        }
    },
    mobilePhone: {
        type: String,
        required: [true, "Mobile phone is required"],
        trim: true,
        maxlength: [20, "Mobile phone cannot exceed 20 characters"],
        validate: {
            validator: function (v) {
                // مثال على التحقق من رقم الهاتف: يبدأ بـ + أو رقم ويتكون من أرقام فقط
                return /^[+0-9]{6,20}$/.test(v);
            },
            message: "Invalid mobile phone format"
        }
    }
}, { timestamps: true });

receiverSchema.index({ userId: 1 });

receiverSchema.index({ fullName: 1 });

receiverSchema.index({ mobilePhone: 1 });

receiverSchema.index({ userId: 1, fullName: 1 });

// Create Receiver Model From Receiver Schema

const receiverModel = clientDB.model("receiver", receiverSchema);

module.exports = receiverModel;