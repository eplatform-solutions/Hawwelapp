const { clientDB, dashboardDB } = require("./database/connections");
const server = require("./http");
const { config } = require("dotenv");
const { initializeFirebase } = require("./config/notifications");
const { ensureUploadDirs } = require("./utils/files");
const { setDbShuttingDown } = require("./helpers/databases");

config({
    path: `.env.${process.env.NODE_ENV || "development"}`
});

const PORT = process.env.PORT || 5300;
const DB_OPEN_OPTIONS = {
    serverSelectionTimeoutMS: 10000,
    socketTimeoutMS: 45000,
    maxIdleTimeMS: 30000,
    heartbeatFrequencyMS: 10000,
};

async function startServer() {
    try {
        ensureUploadDirs();
        const [clientDBConnect, dashboardDBConnect] = await Promise.all([
            clientDB.openUri(process.env.DB_URL, DB_OPEN_OPTIONS),
            dashboardDB.openUri(process.env.DASH_DB_URL, DB_OPEN_OPTIONS),
        ]);
        const Server = server.listen(PORT, () => {
            console.log(`Server Listening On Port ${PORT}`);
            initializeFirebase();
        });
        let shuttingDown = false;
        const gracefulShutdown = async (signal) => {
            if (shuttingDown) return;
            shuttingDown = true;
            setDbShuttingDown(true);
            console.log(`Received ${signal}. Starting graceful shutdown.`);
            try {
                if (clientDBConnect.readyState) {
                    await clientDBConnect.close();
                }
                if (dashboardDBConnect.readyState) {
                    await dashboardDBConnect.close();
                }
            }
            catch (closeError) {
                console.error(`DB close error on ${signal}: ${closeError?.message ?? closeError}`);
            }
            Server.close((err) => {
                if (err) {
                    console.log(`Error On Close Server: ${err?.message ?? err}`);
                }
                process.exit(err ? 1 : 0);
            });
        };
        process.once("SIGINT", () => gracefulShutdown("SIGINT"));
        process.once("SIGTERM", () => gracefulShutdown("SIGTERM"));
        Server.on("error", (err) => {
            console.log(`Http Server Error: ${err?.message ?? err}`);
        });
    }
    catch (err) {
        console.error("Failed to start server:", err);
        process.exit(1);
    }
}

startServer();