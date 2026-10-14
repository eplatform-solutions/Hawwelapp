const chatRouter = require("express").Router();

const chatController = require("../../controllers/chat");

const { authMiddlewares } = require("../../middlewares");

const {
    validateJWT,
    validateAdminJWT,
} = authMiddlewares;

// Customer: bootstrap their single conversation + first page of history.
chatRouter.get("/conversation", validateJWT, chatController.getMyConversation);

// Customer: unread count for the floating chat button's badge.
chatRouter.get("/unread-count", validateJWT, chatController.getMyUnreadCount);

// Admin: the support inbox list.
chatRouter.get("/conversations", validateAdminJWT, chatController.getConversationsForAdmin);

// Admin: message history for one conversation.
chatRouter.get("/conversations/:conversationId/messages", validateAdminJWT, chatController.getConversationMessagesForAdmin);

module.exports = chatRouter;
