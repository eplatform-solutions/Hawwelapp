const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const chatOperationsManagmentFunctions = require("../../repositories/chat");

async function getMyConversation(req, res) {
    try {
        const conversationResult = await chatOperationsManagmentFunctions.getOrCreateConversationForCustomer(req.data._id, req.query.language);
        const conversation = conversationResult.data.conversation;
        const historyResult = await chatOperationsManagmentFunctions.getConversationHistory(
            conversation._id,
            Number(req.query.pageNumber) || 1,
            Number(req.query.pageSize) || 30,
            req.query.language,
        );
        res.json({
            msg: conversationResult.msg,
            error: false,
            data: {
                conversation,
                ...historyResult.data,
            },
        });
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getMyUnreadCount(req, res) {
    try {
        const result = await chatOperationsManagmentFunctions.getUnreadCountForCustomer(req.data._id, req.query.language);
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getConversationsForAdmin(req, res) {
    try {
        const filters = req.query;
        const result = await chatOperationsManagmentFunctions.getConversationsForAdmin(
            Number(filters.pageNumber) || 1,
            Number(filters.pageSize) || 20,
            { status: filters.status, unreadOnly: filters.unreadOnly === "true" },
            filters.language,
        );
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getConversationMessagesForAdmin(req, res) {
    try {
        const conversation = await chatOperationsManagmentFunctions.getConversationById(req.params.conversationId);
        if (!chatOperationsManagmentFunctions.isAuthorizedForConversation(conversation, "admin", req.data._id)) {
            return res.status(404).json(getResponseObject(getSuitableTranslations("Sorry, This Conversation Is Not Exist !!", req.query.language), true, {}));
        }
        const result = await chatOperationsManagmentFunctions.getConversationHistory(
            conversation._id,
            Number(req.query.pageNumber) || 1,
            Number(req.query.pageSize) || 30,
            req.query.language,
        );
        res.json({
            msg: result.msg,
            error: false,
            data: {
                conversation,
                ...result.data,
            },
        });
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getMyConversation,
    getMyUnreadCount,
    getConversationsForAdmin,
    getConversationMessagesForAdmin,
};
