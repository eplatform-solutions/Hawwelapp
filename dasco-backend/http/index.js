const routes = require("../routes");
const coreMiddlewares = require("../middlewares/core");
const express = require("express");
const app = express();

if (
    process.env.JWT_SECRET_KEY &&
    process.env.SECRET_KEY &&
    process.env.JWT_SECRET_KEY !== process.env.SECRET_KEY
) {
    console.warn(
        "[AUTH] WARNING: JWT_SECRET_KEY and SECRET_KEY differ; issued tokens may fail validation."
    );
}

app.set("x-powered-by", false);

app.set("trust proxy", true);

// Handle Middlewares
app.use(coreMiddlewares);

// Handle Routes
app.use(routes);

// Terminal JSON error handler - without it a stray multipart field or any
// uncaught middleware error fell through to Express's default HTML page,
// which the mobile app cannot parse.
app.use((err, _req, res, _next) => {
    console.error(`[HTTP] unhandled error: ${err?.message || err}`);
    if (res.headersSent) return;
    const isUploadError = err?.name === "MulterError";
    res.status(isUploadError ? 400 : 500).json({
        msg: isUploadError ? "Sorry, Unexpected Upload Field Or Invalid Upload !!" : "Internal Server Error !!",
        error: true,
        data: {},
    });
});

module.exports = app;