const mongoose = require("mongoose");
const { resolve } = require("path");
const { config } = require("dotenv");

config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const DASH_DB_URL = process.env.DASH_DB_URL;

if (!DASH_DB_URL) {
    console.error("[mongo:rs:init] DASH_DB_URL is missing.");
    process.exit(1);
}

function parseReplicaHost(uri) {
    try {
        const parsed = new URL(uri);
        const directHost = parsed.host || "127.0.0.1:27017";
        return directHost.includes(",") ? directHost.split(",")[0] : directHost;
    } catch (_) {
        return "127.0.0.1:27017";
    }
}

async function main() {
    const conn = await mongoose.createConnection(DASH_DB_URL).asPromise();
    try {
        const cmd = await conn.db.admin().command({ getCmdLineOpts: 1 });
        const replSetInConfig = cmd?.parsed?.replication?.replSetName;
        if (!replSetInConfig) {
            throw new Error(
                "MongoDB is not configured with replication.replSetName. Add it to mongod.conf and restart mongod first."
            );
        }

        try {
            const admin = conn.db.admin();
            const status = await admin.command({ replSetGetStatus: 1 });
            if (status?.ok === 1) {
                const primary = status.members?.find((m) => m.stateStr === "PRIMARY");
                console.log(`[mongo:rs:init] Replica set already enabled. primary=${primary?.name || "unknown"}`);
                return;
            }
        } catch (err) {
            const message = err?.message || "";
            const notYetInitialized = message.includes("not yet initialized");
            if (!notYetInitialized) {
                throw err;
            }
        }

        const host = parseReplicaHost(DASH_DB_URL);
        const replSetName = process.env.MONGO_RS_NAME || "rs0";
        const result = await conn.db.admin().command({
            replSetInitiate: {
                _id: replSetName,
                members: [{ _id: 0, host }],
            },
        });
        console.log(`[mongo:rs:init] replSetInitiate result: ${JSON.stringify(result)}`);
    } finally {
        await conn.close();
    }
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(`[mongo:rs:init] failed: ${err?.message || err}`);
        process.exit(1);
    });
