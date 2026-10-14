const { resolve, parse, dirname } = require("path");
const { existsSync } = require("fs");
const { config } = require("dotenv");
const sharp = require("sharp");

const { dashboardDB } = require("../database/connections");
const paymentMethodModel = require("../models/dashboard/payment_method");
const { ensureUploadDir } = require("../utils/files");

config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const dryRun = process.argv.includes("--dry-run");

function buildCardLogoRelativePathFromLogoPath(logoPath) {
    const parsed = parse(logoPath);
    const [uuidPart, ...rest] = parsed.name.split("__");
    const baseName = rest.join("__") || "logo";
    const cardFileName = `${uuidPart}__${baseName}-card.webp`;
    return `assets/images/payment_methods/cards/${cardFileName}`;
}

async function generateCardLogo(sourceAbsPath, targetAbsPath) {
    ensureUploadDir(dirname(targetAbsPath));
    await sharp(sourceAbsPath, { failOn: "none" })
        .rotate()
        .trim()
        .resize({
            width: 512,
            height: 220,
            fit: "contain",
            background: { r: 0, g: 0, b: 0, alpha: 0 }
        })
        .webp({ quality: 95 })
        .toFile(targetAbsPath);
}

async function main() {
    const dbUrl = process.env.DASH_DB_URL;
    if (!dbUrl) {
        throw new Error("DASH_DB_URL is missing.");
    }

    await dashboardDB.openUri(dbUrl);
    try {
        const methods = await paymentMethodModel.find({}, { name: 1, symbol: 1, logoPath: 1, cardLogoPath: 1 });
        let missing = 0;
        let normalized = 0;
        let cardUpdated = 0;
        let failed = 0;

        for (const method of methods) {
            const logoPath = String(method.logoPath || "").trim();
            if (!logoPath) {
                continue;
            }

            const abs = resolve(__dirname, "..", logoPath);
            if (!existsSync(abs)) {
                missing += 1;
                console.log(`[normalize:payment-logos] missing: id=${method._id} logoPath="${logoPath}"`);
                continue;
            }

            try {
                const cardLogoPath = buildCardLogoRelativePathFromLogoPath(logoPath);
                const cardAbs = resolve(__dirname, "..", cardLogoPath);

                if (!dryRun) {
                    await generateCardLogo(abs, cardAbs);
                    await paymentMethodModel.updateOne(
                        { _id: method._id },
                        { $set: { cardLogoPath, normalizedLogoPath: cardLogoPath } }
                    );
                }

                normalized += 1;
                if ((method.cardLogoPath || "") !== cardLogoPath) {
                    cardUpdated += 1;
                }
            } catch (err) {
                failed += 1;
                console.log(`[normalize:payment-logos] failed: id=${method._id} logoPath="${logoPath}" reason="${err?.message || err}"`);
            }
        }

        console.log(
            `[normalize:payment-logos] total=${methods.length}, normalized=${normalized}, cardUpdated=${cardUpdated}, missing=${missing}, failed=${failed}, dryRun=${dryRun}`
        );
    } finally {
        await dashboardDB.close();
    }
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(`[normalize:payment-logos] failed: ${err?.message || err}`);
        process.exit(1);
    });
