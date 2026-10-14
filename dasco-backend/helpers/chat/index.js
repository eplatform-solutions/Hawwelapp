const { Server } = require("socket.io");

const { verify } = require("jsonwebtoken");

const {
    getOrCreateConversationForCustomer,
    getConversationById,
    isAuthorizedForConversation,
    saveMessage,
    markConversationRead,
    verifyCustomerIdentity,
    verifyAdminIdentity,
    markMessagePushFailed,
} = require("../../repositories/chat");

const { sendNotification } = require("../notifications");

const { createRedisRateLimiter } = require("../rate_limit");

const { errorMessage } = require("../../utils/safe_log");

// Same allow-list as the REST API's CORS config (middlewares/core) - kept
// separate because Socket.IO doesn't share Express's cors() middleware.
const DEFAULT_ALLOWED_ORIGINS = [
    "https://admin.7awalaty.com",
    "https://admin-api.7awalaty.com",
    "https://api.7awalaty.com",
];

function getAllowedOrigins() {
    const fromEnv = String(process.env.CORS_ALLOWED_ORIGINS || "")
        .split(",")
        .map((item) => item.trim())
        .filter(Boolean);
    return fromEnv.length > 0 ? fromEnv : DEFAULT_ALLOWED_ORIGINS;
}

function getJwtSecret() {
    return process.env.JWT_SECRET_KEY || process.env.SECRET_KEY;
}

function verifyToken(token) {
    return new Promise((resolve, reject) => {
        verify(token, getJwtSecret(), (err, decoded) => {
            if (err) return reject(err);
            resolve(decoded);
        });
    });
}

function conversationRoom(conversationId) {
    return `conversation:${conversationId}`;
}

function attachChatServer(httpServer) {
    const io = new Server(httpServer, {
        cors: {
            origin: getAllowedOrigins(),
            credentials: true,
        },
    });

    // Generous but real limit: a customer or admin typing normally never
    // gets near this - it exists to stop a runaway client from flooding
    // the DB and every other participant's socket.
    const messageLimiter = createRedisRateLimiter({
        keyPrefix: "chat_message",
        points: 20,
        duration: 60,
        blockDuration: 60,
    });

    const customerNs = io.of("/chat/customer");
    const adminNs = io.of("/chat/admin");

    // Always sends the push, regardless of whether a socket for this
    // customer is currently registered in `customerNs.sockets` - that map
    // only reflects whether a connection handshake happened at some point,
    // not whether this specific message will actually reach the client
    // over it (the OS can silently kill the transport while backgrounded,
    // long before Engine.IO's ping/pong timeout notices and removes the
    // entry). Treating "registered" as "will receive it live" was why a
    // customer stopped getting notified after their first chat visit.
    async function notifyCustomerOfNewMessage(customer, message) {
        if (!customer?.notificationsToken) {
            await markMessagePushFailed(message._id, "No notificationsToken registered for this customer");
            return;
        }
        try {
            await sendNotification({
                token: customer.notificationsToken,
                title: "Hawwel Support",
                body: message.body.slice(0, 180),
                data: {
                    type: "chat_message",
                    conversationId: String(message.conversation),
                },
            });
        } catch (err) {
            console.error(`[chat] customer push notification failed: ${errorMessage(err)}`);
            try {
                await markMessagePushFailed(message._id, errorMessage(err));
            } catch (markErr) {
                console.error(`[chat] failed to record push failure: ${errorMessage(markErr)}`);
            }
        }
    }

    // ── Customer namespace ──────────────────────────────────────────
    customerNs.use(async (socket, next) => {
        try {
            const token = socket.handshake.auth?.token;
            if (!token) return next(new Error("Unauthorized"));
            const decoded = await verifyToken(token);
            const user = await verifyCustomerIdentity(decoded._id);
            if (!user) return next(new Error("Unauthorized"));
            socket.data.userId = String(decoded._id);
            next();
        } catch (err) {
            next(new Error("Unauthorized"));
        }
    });

    customerNs.on("connection", async (socket) => {
        let conversation;
        try {
            const result = await getOrCreateConversationForCustomer(socket.data.userId, "en");
            conversation = result.data.conversation;
        } catch (err) {
            console.error(`[chat] failed to open customer conversation: ${errorMessage(err)}`);
            socket.disconnect(true);
            return;
        }
        socket.data.conversationId = String(conversation._id);
        socket.join(conversationRoom(conversation._id));
        socket.emit("conversation:ready", { conversationId: socket.data.conversationId });

        socket.on("message:send", async (payload, ack) => {
            try {
                await messageLimiter.consume(socket.data.userId);
            } catch {
                return ack?.({ error: true, msg: "Too many messages, slow down." });
            }
            try {
                const conv = await getConversationById(socket.data.conversationId);
                const result = await saveMessage(
                    { conversation: conv, senderType: "customer", senderId: socket.data.userId, body: payload?.body },
                    "en",
                );
                if (result.error) return ack?.({ error: true, msg: result.msg });
                const room = conversationRoom(conv._id);
                customerNs.to(room).emit("message:new", result.data.message);
                adminNs.to(room).emit("message:new", result.data.message);
                adminNs.emit("conversation:updated", { conversationId: String(conv._id) });
                ack?.({ error: false, data: result.data.message });
            } catch (err) {
                console.error(`[chat] customer message:send failed: ${errorMessage(err)}`);
                ack?.({ error: true, msg: "Internal Server Error !!" });
            }
        });

        socket.on("message:read", async (payload) => {
            try {
                const conv = await getConversationById(socket.data.conversationId);
                // Clamp to server time so a fast client clock can't widen the
                // window past "now".
                let readUpTo = null;
                const raw = payload?.readUpTo ? new Date(payload.readUpTo) : null;
                if (raw && !Number.isNaN(raw.getTime())) {
                    readUpTo = raw.getTime() > Date.now() ? new Date() : raw;
                }
                await markConversationRead(conv, "customer", readUpTo);
                adminNs.to(conversationRoom(conv._id)).emit("conversation:read", {
                    by: "customer",
                    conversationId: String(conv._id),
                });
            } catch (err) {
                console.error(`[chat] customer message:read failed: ${errorMessage(err)}`);
            }
        });
    });

    // ── Admin namespace ──────────────────────────────────────────────
    adminNs.use(async (socket, next) => {
        try {
            const token = socket.handshake.auth?.token;
            if (!token) return next(new Error("Unauthorized"));
            const decoded = await verifyToken(token);
            const admin = await verifyAdminIdentity(decoded._id);
            if (!admin) return next(new Error("Unauthorized"));
            socket.data.adminId = String(decoded._id);
            socket.data.adminName = admin.fullName;
            next();
        } catch (err) {
            next(new Error("Unauthorized"));
        }
    });

    adminNs.on("connection", (socket) => {
        socket.on("conversation:join", async (payload, ack) => {
            try {
                const conv = await getConversationById(payload?.conversationId);
                if (!isAuthorizedForConversation(conv, "admin", socket.data.adminId)) {
                    return ack?.({ error: true, msg: "Sorry, This Conversation Is Not Exist !!" });
                }
                socket.join(conversationRoom(conv._id));
                ack?.({ error: false });
            } catch (err) {
                console.error(`[chat] admin conversation:join failed: ${errorMessage(err)}`);
                ack?.({ error: true, msg: "Internal Server Error !!" });
            }
        });

        socket.on("message:send", async (payload, ack) => {
            try {
                await messageLimiter.consume(socket.data.adminId);
            } catch {
                return ack?.({ error: true, msg: "Too many messages, slow down." });
            }
            try {
                const conv = await getConversationById(payload?.conversationId);
                if (!isAuthorizedForConversation(conv, "admin", socket.data.adminId)) {
                    return ack?.({ error: true, msg: "Sorry, This Conversation Is Not Exist !!" });
                }
                const result = await saveMessage(
                    { conversation: conv, senderType: "admin", senderId: socket.data.adminId, body: payload?.body },
                    "en",
                );
                if (result.error) return ack?.({ error: true, msg: result.msg });
                const room = conversationRoom(conv._id);
                customerNs.to(room).emit("message:new", result.data.message);
                adminNs.to(room).emit("message:new", result.data.message);

                const customer = await verifyCustomerIdentity(conv.customer);
                if (customer) await notifyCustomerOfNewMessage(customer, result.data.message);

                ack?.({ error: false, data: result.data.message });
            } catch (err) {
                console.error(`[chat] admin message:send failed: ${errorMessage(err)}`);
                ack?.({ error: true, msg: "Internal Server Error !!" });
            }
        });

        socket.on("message:read", async (payload) => {
            try {
                const conv = await getConversationById(payload?.conversationId);
                if (!isAuthorizedForConversation(conv, "admin", socket.data.adminId)) return;
                await markConversationRead(conv, "admin");
                customerNs.to(conversationRoom(conv._id)).emit("conversation:read", {
                    by: "admin",
                    conversationId: String(conv._id),
                });
            } catch (err) {
                console.error(`[chat] admin message:read failed: ${errorMessage(err)}`);
            }
        });
    });

    return io;
}

module.exports = { attachChatServer };
