const { resolve } = require("path");
const { existsSync } = require("fs");
const { config } = require("dotenv");

const { dashboardDB } = require("../database/connections");
const paymentMethodModel = require("../models/dashboard/payment_method");

config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const shouldApply = process.argv.includes("--clear-missing");

async function main() {
    await dashboardDB.openUri(process.env.DASH_DB_URL);
    try {
        const paymentMethods = await paymentMethodModel.find({}, { name: 1, symbol: 1, logoPath: 1 });
        const missing = [];

        for (const method of paymentMethods) {
            const logoPath = String(method.logoPath || "").trim();
            const abs = resolve(__dirname, "..", logoPath);
            if (!logoPath || !existsSync(abs)) {
                missing.push({
                    id: method._id.toString(),
                    symbol: method.symbol,
                    logoPath,
                    nameAr: method?.name?.ar || "",
                    nameEn: method?.name?.en || "",
                });
            }
        }

        console.log(`[audit:payment-logos] total=${paymentMethods.length}, missing=${missing.length}`);
        if (missing.length > 0) {
            console.log("[audit:payment-logos] missing entries:");
            for (const item of missing) {
                console.log(
                    `- id=${item.id} symbol=${item.symbol} logoPath="${item.logoPath}" nameAr="${item.nameAr}" nameEn="${item.nameEn}"`
                );
            }
        }

        if (shouldApply && missing.length > 0) {
            for (const item of missing) {
                await paymentMethodModel.updateOne({ _id: item.id }, { $set: { logoPath: "" } });
            }
            console.log(`[audit:payment-logos] cleared logoPath for ${missing.length} missing entries.`);
        } else if (missing.length > 0) {
            console.log("[audit:payment-logos] run with --clear-missing to blank broken logoPath values.");
        }
    } finally {
        await dashboardDB.close();
    }
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(`[audit:payment-logos] failed: ${err?.message || err}`);
        process.exit(1);
    });
