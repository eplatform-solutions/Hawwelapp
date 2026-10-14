const { chatConversationModel, chatMessageModel, userModel } = require("../../models/client");

const { adminModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { MAX_MESSAGE_LENGTH } = require("../../constants/chat");

async function getOrCreateConversationForCustomer(customerId, language) {
    let conversation = await chatConversationModel.findOne({ customer: customerId });
    if (!conversation) {
        conversation = await chatConversationModel.create({ customer: customerId });
    }
    return {
        msg: getSuitableTranslations("Get Conversation Process Has Been Successfully !!", language),
        error: false,
        data: { conversation },
    };
}

async function getConversationById(conversationId) {
    return chatConversationModel.findById(conversationId);
}

// Every access path (socket connect, REST history, sending a message)
// funnels through this - a customer may only ever touch their own
// conversation, an admin may touch any of them. Getting this wrong is a
// data leak between customers, not a cosmetic bug.
function isAuthorizedForConversation(conversation, requesterType, requesterId) {
    if (!conversation) return false;
    if (requesterType === "admin") return true;
    return String(conversation.customer) === String(requesterId);
}

async function saveMessage({ conversation, senderType, senderId, body }, language) {
    const trimmedBody = String(body || "").trim();
    if (!trimmedBody) {
        return {
            msg: getSuitableTranslations("Sorry, Message Body Is Required !!", language),
            error: true,
            data: {},
        };
    }
    if (trimmedBody.length > MAX_MESSAGE_LENGTH) {
        return {
            msg: getSuitableTranslations("Sorry, Message Is Too Long !!", language),
            error: true,
            data: {},
        };
    }

    // Snapshotted once here (not resolved at display time) so the sender's
    // name in the log never changes retroactively and every reader (admin
    // inbox, customer app) needs zero extra lookups to show it.
    let senderName;
    if (senderType === "admin") {
        const admin = await adminModel.findById(senderId, { fullName: 1 });
        senderName = admin?.fullName;
    }

    const message = await chatMessageModel.create({
        conversation: conversation._id,
        senderType,
        senderId,
        senderName,
        body: trimmedBody,
    });

    conversation.lastMessageAt = message.createdAt;
    conversation.lastMessagePreview = trimmedBody.slice(0, 200);
    conversation.status = "open";
    if (senderType === "customer") {
        conversation.unreadByAdmin = true;
    } else {
        conversation.unreadByCustomer = true;
    }
    await conversation.save();

    return {
        msg: getSuitableTranslations("Send Message Process Has Been Successfully !!", language),
        error: false,
        data: { message, conversation },
    };
}

async function getConversationHistory(conversationId, pageNumber, pageSize, language) {
    const messages = await chatMessageModel
        .find({ conversation: conversationId })
        .sort({ createdAt: -1 })
        .skip((pageNumber - 1) * pageSize)
        .limit(pageSize);

    return {
        msg: getSuitableTranslations("Get Conversation History Process Has Been Successfully !!", language),
        error: false,
        data: {
            messages: messages.reverse(),
            messagesCount: await chatMessageModel.countDocuments({ conversation: conversationId }),
        },
    };
}

// [readUpTo] bounds the read receipt to messages the reader could actually
// have seen - a late or duplicated message:read must not swallow a message
// that arrived after the reader closed the screen.
async function markConversationRead(conversation, readerType, readUpTo = null) {
    if (readerType === "admin") {
        conversation.unreadByAdmin = false;
    } else {
        conversation.unreadByCustomer = false;
    }
    await conversation.save();
    const filter = { conversation: conversation._id, senderType: { $ne: readerType }, readAt: null };
    if (readUpTo instanceof Date && !Number.isNaN(readUpTo.getTime())) {
        filter.createdAt = { $lte: readUpTo };
    }
    await chatMessageModel.updateMany(filter, { $set: { readAt: new Date() } });
}

async function getConversationsForAdmin(pageNumber, pageSize, filters, language) {
    const query = {};
    if (filters.status) query.status = filters.status;
    if (filters.unreadOnly) query.unreadByAdmin = true;

    const conversations = await chatConversationModel
        .find(query)
        .sort({ lastMessageAt: -1 })
        .skip((pageNumber - 1) * pageSize)
        .limit(pageSize)
        .populate("customer", { name: 1, mobilePhone: 1 });

    return {
        msg: getSuitableTranslations("Get Conversations Process Has Been Successfully !!", language),
        error: false,
        data: {
            conversations,
            conversationsCount: await chatConversationModel.countDocuments(query),
        },
    };
}

async function verifyCustomerIdentity(customerId) {
    const user = await userModel.findById(customerId, { name: 1, status: 1, notificationsToken: 1 });
    if (!user || user.status === "blocked") return null;
    return user;
}

async function verifyAdminIdentity(adminId) {
    const admin = await adminModel.findById(adminId, { fullName: 1, status: 1 });
    if (!admin || admin.status === "blocked") return null;
    return admin;
}

// Derived from the messages themselves (not a separately-maintained
// counter) so it can never drift out of sync with reality - this is what
// the floating chat button's badge polls.
async function getUnreadCountForCustomer(customerId, language) {
    const conversation = await chatConversationModel.findOne({ customer: customerId });
    const count = conversation
        ? await chatMessageModel.countDocuments({
            conversation: conversation._id,
            senderType: "admin",
            readAt: null,
        })
        : 0;
    return {
        msg: getSuitableTranslations("Get Unread Count Process Has Been Successfully !!", language),
        error: false,
        data: { count },
    };
}

async function markMessagePushFailed(messageId, errorText) {
    await chatMessageModel.updateOne(
        { _id: messageId },
        { $set: { pushDeliveryFailed: true, pushDeliveryError: String(errorText || "").slice(0, 500) } },
    );
}

module.exports = {
    getOrCreateConversationForCustomer,
    getConversationById,
    isAuthorizedForConversation,
    saveMessage,
    getConversationHistory,
    markConversationRead,
    getConversationsForAdmin,
    verifyCustomerIdentity,
    verifyAdminIdentity,
    getUnreadCountForCustomer,
    markMessagePushFailed,
};
