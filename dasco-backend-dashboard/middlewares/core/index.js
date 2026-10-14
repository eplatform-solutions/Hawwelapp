const { Router, static } = require("express");

const { json } = require("body-parser");

const cors = require("cors");

const { validateLanguage, globalRateLimitMiddleware } = require("../global");

const path = require("path");

const { sendLanding, sendHealth } = require("../../helpers/root-page");
const { getResponseObject } = require("../../helpers/responses");

// ==================================================================

const app = Router();
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

const corsOptions = {
    origin(origin, callback) {
        if (!origin) {
            return callback(null, true);
        }
        const allowedOrigins = getAllowedOrigins();
        if (allowedOrigins.includes(origin)) {
            return callback(null, true);
        }
        return callback(new Error("Not allowed by CORS"));
    },
    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Authorization", "Content-Type", "app-version"],
};

app.get("/", (_req, res) => sendLanding(res));
app.get("/health", (_req, res) => sendHealth(res));

app.use(cors(corsOptions));
app.options(/.*/, cors(corsOptions));

app.use((req, res, next) => {
    res.setHeader("X-Content-Type-Options", "nosniff");
    res.setHeader("X-Frame-Options", "DENY");
    res.setHeader("Referrer-Policy", "no-referrer");
    res.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
    if (req.secure || req.headers["x-forwarded-proto"] === "https") {
        res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
    }
    next();
});

app.use("/assets", static(path.join(__dirname, "..", "..", "assets")));

app.use(globalRateLimitMiddleware);

app.use(json({ limit: "2mb" }));

app.use((req, res, next) => {
    const language = req.query.language;
    if (language) {
        return validateLanguage(language, res, next);
    }
    next();
});

app.use((err, _req, res, next) => {
    if (err?.message === "Not allowed by CORS") {
        return res.status(403).json(
            getResponseObject("CORS policy blocked this origin !!", true, {})
        );
    }
    return next(err);
});

module.exports = app;