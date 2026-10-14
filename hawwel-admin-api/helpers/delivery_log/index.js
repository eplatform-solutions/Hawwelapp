function logSmtpSendError(context, toEmail, err) {
    console.error("[SMTP_SEND_ERROR]", {
        context,
        to: toEmail || null,
        message: err?.message,
        code: err?.code,
        errno: err?.errno,
        syscall: err?.syscall,
        address: err?.address,
        port: err?.port,
        responseCode: err?.responseCode,
        command: err?.command,
        response: typeof err?.response === "string" ? err.response : undefined,
    });
    if (err?.stack) console.error(err.stack);
}

function logEmailCredentialsMissing(context, businessEmailConfigured, msg) {
    console.error("[EMAIL_SKIPPED_NO_SMTP_CREDENTIALS]", {
        context,
        businessEmail: businessEmailConfigured || null,
        msg: msg || null,
    });
}

function logSmsProviderError(context, err) {
    console.error("[SMS_PROVIDER_ERROR]", {
        context,
        message: err?.message,
        responseStatus: err?.response?.status,
        responseData: err?.response?.data,
    });
    if (err?.stack) console.error(err.stack);
}

function logControllerError(context, err) {
    console.error("[CONTROLLER_ERROR]", {
        context,
        message: err?.message,
    });
    if (err?.stack) console.error(err.stack);
}

module.exports = {
    logSmtpSendError,
    logEmailCredentialsMissing,
    logSmsProviderError,
    logControllerError,
};
