const mongoose = require("mongoose");

const { clientDB } = require("../../../database/connections");

const notificationSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "UserId is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid User Id",
        },
    },
    title: {
        type: String,
        required: [true, "Notification title is required"],
        trim: true,
        maxlength: [200, "Title cannot exceed 200 characters"],
    },
    body: {
        type: String,
        required: [true, "Notification body is required"],
        trim: true,
        maxlength: [1000, "Body cannot exceed 1000 characters"],
    },
    data: {
        type: Map,
        required: [true, "Notification data is required"],
    },
    isRead: {
        type: Boolean,
        default: false,
    },
    // The in-app record above always gets written; these track whether the
    // push notification itself actually reached the device, so a delivery
    // failure is a queryable fact instead of a line in a server console
    // log nobody is watching.
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

notificationSchema.index({ userId: 1 });
notificationSchema.index({ isRead: 1 });
notificationSchema.index({ createdAt: -1 });
notificationSchema.index({ userId: 1, isRead: 1 });
notificationSchema.index({ pushDeliveryFailed: 1 });

const notificationModel = clientDB.model("notification", notificationSchema);

module.exports = notificationModel;
