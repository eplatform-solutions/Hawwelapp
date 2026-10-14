const KYC_GATE_MESSAGES = {
    not_submitted: {
        en: "Identity verification is required before you can create a transfer. Please complete KYC.",
        ar: "يجب إكمال التحقق من الهوية قبل إنشاء طلب. يرجى إكمال KYC.",
    },
    pending: {
        en: "Your identity verification is under review. You can create transfers once it is approved.",
        ar: "طلب التحقق من هويتك قيد المراجعة. يمكنك إنشاء الطلبات بعد الموافقة.",
    },
    rejected: {
        en: "Your identity verification was not approved. Please resubmit your documents.",
        ar: "لم تتم الموافقة على التحقق من هويتك. يرجى إعادة تقديم المستندات.",
    },
    resubmission_required: {
        en: "Your identity verification block has been lifted. Please resubmit your documents to continue.",
        ar: "تم رفع الحظر عن التحقق من هويتك. يرجى إعادة رفع مستنداتك لمتابعة عملية التحقق.",
    },
    blocked: {
        en: "Your identity verification is blocked. Please contact support.",
        ar: "التحقق من هويتك محظور. يرجى التواصل مع الدعم.",
    },
};

function normalizeKycStatus(kyc) {
    if (!kyc) {
        return "not_submitted";
    }
    const status = typeof kyc === "object" ? kyc.status : kyc;
    switch (status) {
        case "verified":
            return "approved";
        case "under-review":
            return "pending";
        case "rejected":
        case "remove-verified":
            return "rejected";
        // Kept distinct from "rejected": a blocked user must not be invited
        // to resubmit, the server would reject the upload anyway.
        case "blocked":
            return "blocked";
        case "cancel-blocked":
            return "resubmission_required";
        default:
            return "not_submitted";
    }
}

function getKycGateMessage(normalizedStatus) {
    if (normalizedStatus === "approved") {
        return null;
    }
    return KYC_GATE_MESSAGES[normalizedStatus] || KYC_GATE_MESSAGES.not_submitted;
}

function resolveKycImagePaths(kyc) {
    if (!kyc) {
        return [];
    }
    const documentImages = Array.isArray(kyc.documentImages)
        ? kyc.documentImages.filter(Boolean)
        : [];
    if (documentImages.length > 0) {
        return documentImages;
    }
    if (kyc.filePath) {
        return [kyc.filePath];
    }
    return [];
}

module.exports = {
    normalizeKycStatus,
    getKycGateMessage,
    resolveKycImagePaths,
    KYC_GATE_MESSAGES,
};
