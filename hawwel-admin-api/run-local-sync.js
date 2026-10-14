/**
 * يشغّل Dashboard API و Mobile API معاً على نفس MongoDB in-memory replica set
 * للحصول على تزامن حقيقي في وضع التطوير.
 *
 * Dashboard API: http://127.0.0.1:3033
 * Mobile API:    http://127.0.0.1:3030
 */
const { spawn } = require("child_process");
const path = require("path");

const processes = [];

function startProcess(label, commandPath, env, cwd) {
    const child = spawn(process.execPath, [commandPath], {
        env,
        cwd,
        stdio: "inherit",
    });
    child.on("exit", (code, signal) => {
        console.log(`[${label}] exited (code=${code ?? "null"}, signal=${signal ?? "null"})`);
    });
    processes.push(child);
    return child;
}

function runOneOffProcess(label, commandPath, env, cwd) {
    return new Promise((resolve, reject) => {
        const child = spawn(process.execPath, [commandPath], {
            env,
            cwd,
            stdio: "inherit",
        });

        child.on("exit", (code) => {
            if (code === 0) {
                return resolve();
            }
            reject(new Error(`[${label}] failed with exit code ${code}`));
        });
    });
}

(async () => {
    const { MongoMemoryReplSet } = require("mongodb-memory-server");
    const replSet = await MongoMemoryReplSet.create({
        replSet: { count: 1 },
    });

    const sharedEnv = {
        ...process.env,
        NODE_ENV: process.env.NODE_ENV || "development",
        DB_URL: replSet.getUri("hawwel-orders-development"),
        DASH_DB_URL: replSet.getUri("hawwel-orders-admin-dashboard-development"),
    };

    process.env.NODE_ENV = sharedEnv.NODE_ENV;
    process.env.DB_URL = sharedEnv.DB_URL;
    process.env.DASH_DB_URL = sharedEnv.DASH_DB_URL;

    try {
        await require("./scripts/seed-dev-admin-if-missing.js").main();
    } catch (e) {
        console.error("[seed-dev-admin]", e.message);
    }

    const dashboardDir = __dirname;
    const backendDir = path.resolve(__dirname, "../../../backend/hawwel/server-side");

    const dashboardEnv = {
        ...sharedEnv,
        PORT: process.env.DASHBOARD_PORT || "3033",
    };
    const backendEnv = {
        ...sharedEnv,
        PORT: process.env.MOBILE_API_PORT || "3030",
        SKIP_LOGIN_OTP: process.env.SKIP_LOGIN_OTP || "true",
    };

    try {
        await runOneOffProcess(
            "seed-users",
            path.join(backendDir, "scripts/seed-users.js"),
            backendEnv,
            backendDir
        );
    } catch (e) {
        console.error("[seed-users]", e.message);
    }

    const backendSeeders = [
        { label: "seed-countries", file: "seeders/countries/create_initial_countries.js" },
        { label: "seed-cities", file: "seeders/cities/create_initial_cities.js" },
        { label: "seed-areas", file: "seeders/areas/create_initial_areas.js" },
        { label: "seed-payment-methods", file: "seeders/payment_methods/create_initial_payment_methods.js" },
    ];

    for (const seeder of backendSeeders) {
        try {
            await runOneOffProcess(
                seeder.label,
                path.join(backendDir, seeder.file),
                backendEnv,
                backendDir
            );
        } catch (e) {
            console.error(`[${seeder.label}]`, e.message);
        }
    }

    startProcess("dashboard-api", path.join(dashboardDir, "index.js"), dashboardEnv, dashboardDir);
    startProcess("mobile-api", path.join(backendDir, "index.js"), backendEnv, backendDir);

    const shutdown = async () => {
        for (const child of processes) {
            if (!child.killed) {
                child.kill("SIGINT");
            }
        }
        try {
            await replSet.stop();
        } catch (_) {
            // ignore
        }
    };

    process.on("SIGINT", async () => {
        await shutdown();
        process.exit(0);
    });

    process.on("SIGTERM", async () => {
        await shutdown();
        process.exit(0);
    });
})().catch((err) => {
    console.error(err);
    process.exit(1);
});
