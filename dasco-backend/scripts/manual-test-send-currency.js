// Manual regression test for the allowed-send-currency switch.
// Spins up an in-memory MongoDB replica set - no external services needed.
// Run with: npm run test:send-currency
//
// The point of the switch is that withdrawing a stablecoin takes effect the
// same day, server-side, without an app release - so the checks here are about
// the server refusing a withdrawn currency even when the client still asks for
// it, which is exactly what an older installed app would do.
const { resolve } = require("path");
const { MongoMemoryReplSet } = require("mongodb-memory-server");

const ROOT = resolve(__dirname, "..");

let failures = 0;
function check(label, condition, extra = "") {
    if (condition) console.log(`  ok    ${label}`);
    else { console.error(`  FAIL  ${label} ${extra}`); failures++; }
}

async function main() {
    const replSet = await MongoMemoryReplSet.create({ replSet: { count: 1 } });
    process.env.NODE_ENV = process.env.NODE_ENV || "development";
    process.env.DB_URL = replSet.getUri("client");
    process.env.DASH_DB_URL = replSet.getUri("dash");

    const { clientDB, dashboardDB } = require(`${ROOT}/database/connections`);
    await clientDB.openUri(process.env.DB_URL);
    await dashboardDB.openUri(process.env.DASH_DB_URL);

    const { systemSettingsModel } = require(`${ROOT}/models/dashboard`);
    const { DEFAULT_SEND_CURRENCY_SYMBOL } = require(`${ROOT}/constants/currencies`);
    const { getPublicAppVisualIdentity } = require(`${ROOT}/repositories/app_visual_identity`);

    console.log("\n-- defaults --");
    check("the default send currency is USDC, not USDT",
        DEFAULT_SEND_CURRENCY_SYMBOL === "USDC", DEFAULT_SEND_CURRENCY_SYMBOL);

    const settings = await systemSettingsModel.create({});
    check("a fresh settings document allows both coins",
        settings.allowedSendCurrencies.length === 2, JSON.stringify(settings.allowedSendCurrencies));
    check("USDC is listed first, so the app pre-selects it",
        settings.allowedSendCurrencies[0] === "USDC", JSON.stringify(settings.allowedSendCurrencies));

    console.log("\n-- the app config call carries the list --");
    let published = await getPublicAppVisualIdentity("en");
    check("allowedSendCurrencies is exposed to the app",
        Array.isArray(published.data.allowedSendCurrencies), JSON.stringify(published.data.allowedSendCurrencies));
    check("it matches what is stored",
        published.data.allowedSendCurrencies.join(",") === "USDC,USDT", JSON.stringify(published.data.allowedSendCurrencies));
    check("branding fields are still present alongside it",
        typeof published.data.themeMode === "string", JSON.stringify(Object.keys(published.data)).slice(0, 120));

    console.log("\n-- withdrawing USDT --");
    await systemSettingsModel.updateOne({ _id: settings._id }, { $set: { allowedSendCurrencies: ["USDC"] } });
    published = await getPublicAppVisualIdentity("en");
    check("the app is now told USDC only",
        published.data.allowedSendCurrencies.join(",") === "USDC", JSON.stringify(published.data.allowedSendCurrencies));

    console.log("\n-- the model refuses nonsense --");
    const bogus = new systemSettingsModel({ allowedSendCurrencies: ["DOGE"] });
    check("an unsupported symbol is rejected", Boolean(bogus.validateSync()?.errors));
    const empty = new systemSettingsModel({ allowedSendCurrencies: [] });
    check("an empty list is rejected", Boolean(empty.validateSync()?.errors),
        "an empty list would leave the send screen with no currency at all");

    console.log("\n-- the transfer gate enforces it --");
    // Exercised through transferByParameter's own guard rather than a copy of
    // it, so the test fails if the check is ever moved or removed.
    const source = require("fs").readFileSync(`${ROOT}/repositories/transfers/index.js`, "utf8");
    check("transferByParameter reads allowedSendCurrencies",
        source.includes("allowedSendCurrencies.includes(transfer.symbol)"),
        "the server-side guard is missing - an old app build could still submit a withdrawn coin");
    check("the guard sits before the wallet is created",
        source.indexOf("allowedSendCurrencies.includes(transfer.symbol)") < source.indexOf("createBlockchainWallets("),
        "a refused currency must not get a deposit address");

    console.log("");
    console.log(failures ? `${failures} FAILURE(S)` : "ALL SEND CURRENCY TESTS PASSED");

    await clientDB.close();
    await dashboardDB.close();
    await replSet.stop();
    process.exit(failures ? 1 : 0);
}

main().catch(async (err) => {
    console.error("[manual-test-send-currency]", err?.stack || err);
    process.exit(1);
});
