const mongoose = require("mongoose");
const { resolve } = require("path");
const { config } = require("dotenv");

config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const DASH_DB_URL = process.env.DASH_DB_URL;

if (!DASH_DB_URL) {
    console.error("[mongo:tx:verify] DASH_DB_URL is missing.");
    process.exit(1);
}

async function main() {
    const conn = await mongoose.createConnection(DASH_DB_URL).asPromise();
    const session = await conn.startSession();
    try {
        session.startTransaction();
        await conn.db.collection("__tx_probe").insertOne(
            {
                probe: true,
                createdAt: new Date(),
            },
            { session }
        );
        await conn.db.collection("__tx_probe").deleteMany({ probe: true }, { session });
        await session.commitTransaction();
        console.log("[mongo:tx:verify] Transaction support: OK");
    } catch (err) {
        if (session.inTransaction()) {
            await session.abortTransaction();
        }
        throw err;
    } finally {
        await session.endSession();
        await conn.close();
    }
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(`[mongo:tx:verify] failed: ${err?.message || err}`);
        process.exit(1);
    });
