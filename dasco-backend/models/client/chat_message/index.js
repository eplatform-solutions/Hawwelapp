const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const { SENDER_TYPES, MAX_MESSAGE_LENGTH } = require("../../../constants/chat");

const chatMessageSchema = new mongoose.Schema({
    conversation: {
        type: mongoose.Types.ObjectId,
        ref: "chat_conversation",
        required: [true, "Conversation is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid conversation Id",
        },
    },
    senderType: {
        type: String,
        enum: {
            values: SENDER_TYPES,
            message: "Invalid sender type",
        },
        required: [true, "Sender type is required"],
    },
    // Polymorphic on purpose (references either "user" or "admin" depending
    // on senderType) - a chat message only ever needs to display who sent
    // it, never to populate a typed relation.
    senderId: {
        type: mongoose.Types.ObjectId,
        required: [true, "Sender Id is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid sender Id",
        },
    },
    body: {
        type: String,
        required: [true, "Message body is required"],
        trim: true,
        maxlength: [MAX_MESSAGE_LENGTH, `Message cannot exceed ${MAX_MESSAGE_LENGTH} characters`],
    },
    // Snapshotted at send time (admin messages only) so the log stays
    // accurate even if that staff member's name changes later, and so
    // displaying it never needs a second lookup.
    senderName: {
        type: String,
        trim: true,
        maxlength: 120,
    },
    readAt: {
        type: Date,
    },
    // Mirrors the same fields already used for deposit/status
    // notifications - a delivery failure is a queryable fact, not just a
    // console log line.
    pushDeliveryFailed: {
        type: Boolean,
        default: false,
    },
    pushDeliveryError: {
        type: String,
        default: "",
        trim: true,
        maxlength: [500, "Push delivery error cannot exceed 500 characters"],
    },
}, { timestamps: true });

chatMessageSchema.index({ conversation: 1, createdAt: -1 });

chatMessageSchema.index({ conversation: 1, senderType: 1, readAt: 1 });

const chatMessageModel = clientDB.model("chat_message", chatMessageSchema);

module.exports = chatMessageModel;
