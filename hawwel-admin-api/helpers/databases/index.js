const mongoose = require("mongoose");

mongoose.set({ runValidators: true });

let isShuttingDown = false;

function getConnectionState(conn) {
    const states = ["disconnected", "connected", "connecting", "disconnecting"];
    return states[conn.readyState] || "unknown";
}

function setDbShuttingDown(nextState = true) {
    isShuttingDown = Boolean(nextState);
}

const createConnection = (name) => {
    const conn = mongoose.createConnection();
    conn.on("connected", () => {
        console.log(`[DB:${name}] connected state=${getConnectionState(conn)} at=${new Date().toISOString()}`);
    });
    conn.on("disconnected", () => {
        const level = isShuttingDown ? "log" : "error";
        console[level](
            `[DB:${name}] disconnected state=${getConnectionState(conn)} shuttingDown=${isShuttingDown} at=${new Date().toISOString()}`
        );
    });
    conn.on("reconnected", () => {
        console.warn(`[DB:${name}] reconnected state=${getConnectionState(conn)} at=${new Date().toISOString()}`);
    });
    conn.on("error", (error) => {
        console.error(
            `[DB:${name}] error state=${getConnectionState(conn)} shuttingDown=${isShuttingDown} at=${new Date().toISOString()} message=${error?.message ?? error}`
        );
    });
    return conn;
};

module.exports = {
    createConnection,
    setDbShuttingDown
};