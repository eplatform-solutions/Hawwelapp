const { resolve } = require("path");
const { config } = require("dotenv");

const {
    dashboardDB,
} = require("../database/connections");

config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const APPLY_FLAG = process.argv.includes("--apply");

async function collectionExists(db, name) {
    const collections = await db.listCollections({ name }).toArray();
    return collections.length > 0;
}

async function main() {
    await dashboardDB.openUri(process.env.DASH_DB_URL);
    try {
        const db = dashboardDB.db;

        const hasAreas = await collectionExists(db, "areas");
        const hasAreaPaymentMethods = await collectionExists(db, "area_payment_methods");
        const hasRegions = await collectionExists(db, "regions");
        const hasRegionPaymentMethods = await collectionExists(db, "region_payment_methods");

        console.log("[migrate:areas-to-regions] current state:");
        console.log(`  areas collection exists: ${hasAreas}`);
        console.log(`  area_payment_methods collection exists: ${hasAreaPaymentMethods}`);
        console.log(`  regions collection exists (already migrated?): ${hasRegions}`);
        console.log(`  region_payment_methods collection exists (already migrated?): ${hasRegionPaymentMethods}`);

        const permission = await db.collection("permissions").findOne({ codeName: "areas_managment" });
        console.log(`  permission with codeName "areas_managment" found: ${!!permission}`);

        if (!APPLY_FLAG) {
            console.log("[migrate:areas-to-regions] Dry-run mode. Re-run with --apply to execute.");
            return;
        }

        if (hasAreas && !hasRegions) {
            await db.collection("areas").rename("regions");
            console.log("[migrate:areas-to-regions] renamed collection areas -> regions");
        }

        if (hasAreaPaymentMethods && !hasRegionPaymentMethods) {
            await db.collection("area_payment_methods").rename("region_payment_methods");
            console.log("[migrate:areas-to-regions] renamed collection area_payment_methods -> region_payment_methods");
        }

        const renameFieldResult = await db.collection("region_payment_methods").updateMany(
            { area: { $exists: true } },
            { $rename: { area: "region" } }
        );
        console.log(`[migrate:areas-to-regions] renamed field area -> region on ${renameFieldResult.modifiedCount} region_payment_methods document(s)`);

        if (permission) {
            await db.collection("permissions").updateOne(
                { _id: permission._id },
                { $set: { codeName: "regions_managment", name: "Regions Managment", appLabel: "regions" } }
            );
            console.log("[migrate:areas-to-regions] updated permission codeName areas_managment -> regions_managment");
        }

        console.log("[migrate:areas-to-regions] Done.");
    } finally {
        await dashboardDB.close();
    }
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(`[migrate:areas-to-regions] failed: ${err?.message || err}`);
        process.exit(1);
    });
