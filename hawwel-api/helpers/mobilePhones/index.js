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

function normalizePhoneForCompare(phone) {
    return String(phone || "").replace(/[\s\-()]/g, "").trim();
}

// Numbers the SMS provider cannot reach (Twilio has no Syrian coverage -
// error 21408) but whose accounts are staff accounts the business wants to
// keep working. They skip every OTP step instead of waiting for a code that
// never arrives. Comma-separated E.164 list, e.g. "+963930261806,+9639...".
function getSmsExemptPhones() {
    return String(process.env.SMS_EXEMPT_PHONES || "")
        .split(",")
        .map(normalizePhoneForCompare)
        .filter(Boolean);
}

function isSmsExemptPhone(phone) {
    const normalized = normalizePhoneForCompare(phone);
    return normalized !== "" && getSmsExemptPhones().includes(normalized);
}

// Destinations the provider rejects outright; enabling phone 2FA for them
// would lock the account out at the next login.
const SMS_UNSUPPORTED_PREFIXES = ["+963"];

function isSmsUnsupportedPhone(phone) {
    const normalized = normalizePhoneForCompare(phone);
    return SMS_UNSUPPORTED_PREFIXES.some((prefix) => normalized.startsWith(prefix));
}

module.exports = {
    sendVerificationCodeToUserMobilePhone,
    isSmsExemptPhone,
    isSmsUnsupportedPhone,
}