const { getFirebaseAdmin } = require("../../config/notifications");

const { userModel } = require("../../models/client");

// FCM answers "registration-token-not-registered" once a token is dead
// (app reinstalled, uninstalled, token rotated). Keeping it means every
// later push fails the same way, so drop it - the app re-registers a
// fresh token on its next launch/resume.
async function forgetDeadToken(token) {
    try {
        await userModel.updateOne({ notificationsToken: token }, { $set: { notificationsToken: "" } });
    }
    catch (err) {
        console.error(`[notifications] failed to clear dead token: ${err?.message || err}`);
    }
}

function isDeadTokenError(err) {
    const code = String(err?.code || err?.errorInfo?.code || "");
    return code === "messaging/registration-token-not-registered"
        || /NotRegistered/i.test(String(err?.message || ""));
}

// The title/body a customer sees for an on-chain deposit, split by how the
// deposited amount compared to what was requested. Used by both the
// push-notification send (controllers/deposits) and the in-app record save
// (repositories/deposits) so the two never drift apart on wording - the
// body strings for under/over-paid are translation keys resolved client-
// side with {{amount}} (requested) and {{paid}} (actually received)
// substituted in, exactly like the existing full-paid message.
const DEPOSIT_STATUS_TITLES = {
    "under-paid": "Transfer Underpaid",
    "over-paid": "Transfer Overpaid",
};

const DEPOSIT_STATUS_BODIES = {
    "under-paid": "notification_underpaid_deposit",
    "over-paid": "notification_overpaid_deposit",
};

function getDepositNotificationContent(status, fallbackTitle, fallbackBody) {
    return {
        title: DEPOSIT_STATUS_TITLES[status] || fallbackTitle,
        body: DEPOSIT_STATUS_BODIES[status] || fallbackBody,
    };
}

async function sendNotification({ tokens, token, topic, title, body, data }) {
    try {
        const message = {
            notification: { title, body },
            data,
        };
        if (token) {
            // إرسال لتوكين واحد
            try {
                return await getFirebaseAdmin().messaging().send({ ...message, token });
            }
            catch (err) {
                if (isDeadTokenError(err)) await forgetDeadToken(token);
                throw err;
            }
        }
        if (tokens && tokens.length > 0) {
            // إرسال لمجموعة توكنات (multicast)
            return getFirebaseAdmin().messaging().sendEachForMulticast({ ...message, tokens });
        }
        if (topic) {
            // إرسال لتوبيك
            return getFirebaseAdmin().messaging().send({ ...message, topic });
        }
        throw new Error("No Valid Target Specified (token/tokens/topic) !!");
    }
    catch (err) {
        throw err;
    }
}

module.exports = {
    sendNotification,
    getDepositNotificationContent,
}