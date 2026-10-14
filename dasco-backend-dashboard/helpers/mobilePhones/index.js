const { post } = require("axios");

function getTwilioFromAddress(channel = "sms") {
    if (channel === "whatsapp") {
        return `whatsapp:${process.env.TWILIO_SENDER_PHONE_NUMBER}`;
    }
    const senderId = (process.env.TWILIO_SENDER_ID || "").trim();
    if (senderId) {
        return senderId;
    }
    return process.env.TWILIO_SENDER_PHONE_NUMBER;
}

function buildVerificationSmsBody(code, language) {
    const brand = (process.env.WEBSITE_NAME || "Hawwel").trim();
    if (language === "ar") {
        return `${brand}: رمز التحقق ${code}. صالح 10 دقائق. لا تشاركه.`;
    }
    return `${brand}: Your verification code is ${code}. Valid for 10 minutes. Do not share.`;
}

async function sendVerificationCodeToUserMobilePhone(mobilePhone, code, channel = "sms", language) {
    try {
        const url = `${process.env.TWILIO_BASE_API_URL}/2010-04-01/Accounts/${process.env.TWILIO_ACCOUNT_SID}/Messages.json`;
        const data = new URLSearchParams({
            From: getTwilioFromAddress(channel),
            To: mobilePhone,
            Body: buildVerificationSmsBody(code, language),
        });
        const auth = {
            username: process.env.TWILIO_API_KEY,
            password: process.env.TWILIO_API_SECRET,
        };
        const res = await post(url, data, {
            auth,
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
        });
        return res.data;
    }
    catch (err) {
        throw err;
    }
}

module.exports = {
    sendVerificationCodeToUserMobilePhone,
}