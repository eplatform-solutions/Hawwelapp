/**
 * تشغيل API لوحة التحكم مع MongoDB في الذاكرة (بدون تثبيت MongoDB).
 * يتطلب Redis على 127.0.0.1:6379 — ثم: npm run dev:memory
 */
const { spawn } = require("child_process");
const path = require("path");

(async () => {
    // Replica set مطلوب لمعاملات Mongoose (startSession/startTransaction) — الخادم العادي في الذاكرة لا يدعمها.
    const { MongoMemoryReplSet } = require("mongodb-memory-server");
    const replSet = await MongoMemoryReplSet.create({
        replSet: { count: 1 },
    });
    const env = {
        ...process.env,
        NODE_ENV: process.env.NODE_ENV || "development",
        DB_URL: replSet.getUri("hawwel-orders-development"),
        DASH_DB_URL: replSet.getUri("hawwel-orders-admin-dashboard-development"),
    };
    process.env.NODE_ENV = env.NODE_ENV;
    process.env.DB_URL = env.DB_URL;
    process.env.DASH_DB_URL = env.DASH_DB_URL;
    try {
        await require("./scripts/seed-dev-admin-if-missing.js").main();
    } catch (e) {
        console.error("[seed-dev-admin]", e.message);
    }
    const child = spawn(process.execPath, [path.join(__dirname, "index.js")], {
        env,
        stdio: "inherit",
        cwd: __dirname,
    });
    const shutdown = async () => {
        try {
            await replSet.stop();
        } catch (_) {
            /* ignore */
        }
    };
    child.on("exit", async (code) => {
        await shutdown();
        process.exit(code ?? 0);
    });
    process.on("SIGINT", () => {
        child.kill("SIGINT");
    });
})().catch((err) => {
    console.error(err);
    process.exit(1);
});
