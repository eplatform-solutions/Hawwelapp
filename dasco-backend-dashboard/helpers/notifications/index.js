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
    sendNotification
}
