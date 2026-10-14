const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { CONVERSATION_STATUSES, DEFAULT_CONVERSATION_STATUS } = require("../../../constants/chat");

// One conversation per customer - v1 keeps support unforked into topics, so
// a customer always resumes the same thread rather than starting a new one.

const chatConversationSchema = new mongoose.Schema({
    customer: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "Customer is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid customer Id",
        },
    },
    assignedAdmin: {
        type: mongoose.Types.ObjectId,
        ref: "admin",
        validate: {
            validator: function (v) {
                if (!v) return true;
                return mongoose.Types.ObjectId.isValid(v);
            },
            message: "Invalid admin Id",
        },
    },
    status: {
        type: String,
        enum: {
            values: CONVERSATION_STATUSES,
            message: "Invalid conversation status",
        },
        default: DEFAULT_CONVERSATION_STATUS,
    },
    lastMessageAt: {
        type: Date,
    },
    lastMessagePreview: {
        type: String,
        trim: true,
        maxlength: 200,
    },
    unreadByAdmin: {
        type: Boolean,
        default: false,
    },
    unreadByCustomer: {
        type: Boolean,
        default: false,
    },
}, { timestamps: true });

chatConversationSchema.index({ customer: 1 }, { unique: true });

chatConversationSchema.index({ status: 1, lastMessageAt: -1 });

chatConversationSchema.index({ unreadByAdmin: 1 });

const chatConversationModel = clientDB.model("chat_conversation", chatConversationSchema);

module.exports = chatConversationModel;
