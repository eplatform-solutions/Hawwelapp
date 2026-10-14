const { tatum_webhook_allowed_ips } = require("../../config/webhooks");

const crypto = require("crypto");

const validateTatumIpMiddleware = (req, res, next) => {
    if (process.env.NODE_ENV === "staging" || process.env.NODE_ENV === "production") {
        const ip = req.ip;
        if (!tatum_webhook_allowed_ips.includes(ip)) {
            return res.status(403).json({
                msg: "Webhook Source Not Allowed !!",
                error: true,
                data: {}
            });
        }
    }
    next();
};

const verifyTatumWebhookSignature = (req, res, next) => {
    try {
        if (process.env.NODE_ENV === "staging" || process.env.NODE_ENV === "production") {
            const signature = req.headers["x-payload-hash"];
            if (!signature) {
                return res.status(403).json({
                    msg: "Missing Tatum Webhook Signature !!",
                    error: true,
                    data: {}
                });
            }
            const hash = crypto
                .createHmac("sha512", process.env.TATUM_WEBHOOK_SECRET_KEY)
                .update(req.rawBody)
                .digest("base64");
            const isValid = crypto.timingSafeEqual(
                Buffer.from(signature),
                Buffer.from(hash)
            );
            if (!isValid) {
                return res.status(403).json({
                    msg: "Invalid Tatum Webhook Signature !!",
                    error: true,
                    data: {}
                });
            }
        }
        next();
    } catch (error) {
        console.error("Webhook Signature Verification Error: ", error);
        return res.status(500).json({
            msg: "Webhook Verification Failed !!",
            error: true,
            data: {}
        });
    }
};

module.exports = {
    validateTatumIpMiddleware,
    verifyTatumWebhookSignature
};