const { resolve } = require("path");
const { config } = require("dotenv");

const {
    dashboardDB,
} = require("../database/connections");

const {
    countryModel,
    cityModel,
    regionModel,
    paymentMethodModel,
    countryPaymentMethodModel,
    cityPaymentMethodModel,
    regionPaymentMethodModel,
} = require("../models/dashboard");

config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const APPLY_FLAG = process.argv.includes("--apply");

async function readCounts() {
    const [
        countries,
        cities,
        regions,
        paymentMethods,
        countryLinks,
        cityLinks,
        regionLinks,
    ] = await Promise.all([
        countryModel.countDocuments({}),
        cityModel.countDocuments({}),
        regionModel.countDocuments({}),
        paymentMethodModel.countDocuments({}),
        countryPaymentMethodModel.countDocuments({}),
        cityPaymentMethodModel.countDocuments({}),
        regionPaymentMethodModel.countDocuments({}),
    ]);

    return {
        countries,
        cities,
        regions,
        paymentMethods,
        countryLinks,
        cityLinks,
        regionLinks,
    };
}

async function main() {
    await dashboardDB.openUri(process.env.DASH_DB_URL);
    try {
        const before = await readCounts();
        console.log("[cleanup:operational-bootstrap] before:", before);

        if (!APPLY_FLAG) {
            console.log(
                "[cleanup:operational-bootstrap] Dry-run mode. Re-run with --apply to execute deletion."
            );
            return;
        }

        const session = await dashboardDB.startSession();
        try {
            session.startTransaction();

            await regionPaymentMethodModel.deleteMany({}, { session });
            await cityPaymentMethodModel.deleteMany({}, { session });
            await countryPaymentMethodModel.deleteMany({}, { session });

            await regionModel.deleteMany({}, { session });
            await cityModel.deleteMany({}, { session });
            await paymentMethodModel.deleteMany({}, { session });
            await countryModel.deleteMany({}, { session });

            await session.commitTransaction();
        } catch (err) {
            if (session.inTransaction()) {
                await session.abortTransaction();
            }
            throw err;
        } finally {
            await session.endSession();
        }

        const after = await readCounts();
        console.log("[cleanup:operational-bootstrap] after:", after);
    } finally {
        await dashboardDB.close();
    }
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(`[cleanup:operational-bootstrap] failed: ${err?.message || err}`);
        process.exit(1);
    });
