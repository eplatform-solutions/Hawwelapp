const { spawnSync } = require("child_process");
const { resolve } = require("path");

const seeders = [
    "seeders/permissions/create_initial_permissions/index.js",
    "seeders/system_settings/create_initial_settings/index.js",
    "seeders/admins/create_initial_admin_account/index.js",
    "seeders/exchange_rates/create_initial_exchange_rates/index.js",
    "seeders/deposits/create_initial_minimum_deposit_limits/index.js",
    "seeders/blockchain/create_initial_supported_currencies_by_network/index.js",
    "seeders/blockchain/create_initial_central_blockchain_wallets/index.js",
    "seeders/blockchain/create_initial_network_fee_funding_blockchain_wallets/index.js",
    "seeders/blockchain/migrate_blockchain_wallet_unique_index/index.js",
];

function run(file) {
    const abs = resolve(__dirname, "..", file);
    console.log(`[seed:prod:baseline] running: ${file}`);
    const result = spawnSync(process.execPath, [abs], {
        stdio: "inherit",
        env: {
            ...process.env,
            NODE_ENV: process.env.NODE_ENV || "production",
        },
    });
    if (result.status !== 0) {
        throw new Error(`Seeder failed: ${file}`);
    }
}

function main() {
    if ((process.env.NODE_ENV || "production") !== "production") {
        throw new Error("This script is intended for production baseline only.");
    }
    for (const file of seeders) {
        run(file);
    }
    console.log("[seed:prod:baseline] Done.");
    console.log(
        "[seed:prod:baseline] Geographic and payment-method defaults are intentionally excluded. Manage them via dashboard UI."
    );
}

try {
    main();
    process.exit(0);
} catch (err) {
    console.error(`[seed:prod:baseline] failed: ${err?.message || err}`);
    process.exit(1);
}
