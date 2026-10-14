// Human-readable text for the FCM `notification` payload of KYC / account
// status pushes. The stored in-app notification keeps the translation KEY
// (rendered by the mobile app with its own dictionary), but the OS shows
// `notification.body` verbatim on the lock screen when the app is in the
// background - sending the key there displayed literal strings such as
// "notification_kyc_blocked" to the customer. Arabic is the product's
// primary language and the user model stores no language preference.
const KYC_PUSH_TEXT = {
    "verified": {
        title: "تم قبول التحقق من الهوية",
        body: "تم قبول التحقق من هويتك (KYC).",
    },
    "rejected": {
        title: "تم رفض التحقق من الهوية",
        body: "تم رفض التحقق من هويتك (KYC).",
    },
    "blocked": {
        title: "تم حظر التحقق من الهوية",
        body: "تم حظر التحقق من هويتك (KYC).",
    },
    "cancel-blocked": {
        title: "تم رفع الحظر عن التحقق من الهوية",
        body: "تم رفع الحظر عن التحقق من هويتك (KYC). يرجى إعادة رفع مستنداتك لمتابعة عملية التحقق.",
    },
    "remove-verified": {
        title: "تم سحب التحقق من الهوية",
        body: "تم سحب موافقة التحقق من هويتك (KYC).",
    },
};

const USER_PUSH_TEXT = {
    "blocked": {
        title: "تم حظر الحساب",
        body: "تم حظر حسابك.",
    },
    "active": {
        title: "تم رفع الحظر عن الحساب",
        body: "تم رفع الحظر عن حسابك. يمكنك الآن استخدام التطبيق بشكل طبيعي.",
    },
};

function buildCustomerStatusPushText(kind, status, data = {}) {
    const table = kind === "kyc" ? KYC_PUSH_TEXT : USER_PUSH_TEXT;
    const text = table[status];
    if (!text) return null;
    // Every KYC decision stores its reason under its own key; the lock-screen
    // text used to include it for blocks only, leaving rejected users with
    // "review the reason" and no reason.
    const reason = String(
        data.blockingReason || data.rejectionReason || data.removeVerifyingReason || "",
    ).trim();
    const suffix = reason ? ` السبب: ${reason}.` : "";
    let followUp = "";
    if (kind === "kyc" && (status === "rejected" || status === "remove-verified")) {
        followUp = " يرجى إعادة رفع مستنداتك.";
    }
    else if (status === "blocked") {
        followUp = " تواصل مع الدعم لمزيد من التفاصيل.";
    }
    return {
        title: text.title,
        body: `${text.body}${suffix}${followUp}`,
    };
}

module.exports = {
    buildCustomerStatusPushText,
};
