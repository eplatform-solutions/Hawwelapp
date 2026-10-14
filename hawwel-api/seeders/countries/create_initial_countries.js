const { dashboardDB } = require("../../database/connections");
const mongoose = require("mongoose");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../.env.${process.env.NODE_ENV || "development"}`),
});

if (
    process.env.NODE_ENV === "production" &&
    process.env.ALLOW_LEGACY_GEO_DEFAULT_SEEDERS !== "true"
) {
    console.error(
        "Legacy geographic seeders are disabled in production. Set ALLOW_LEGACY_GEO_DEFAULT_SEEDERS=true only for explicit one-time migration."
    );
    process.exit(1);
}

const countryModel = require("../../models/dashboard/country");

const INITIAL_COUNTRIES = [
    {
        _id: new mongoose.Types.ObjectId("69e2485db77e1351cf42cd93"),
        code: "SY",
    },
    {
        code: "LB",
    },
];

async function create_initial_country_list() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        await countryModel.bulkWrite(
            INITIAL_COUNTRIES.map((country) => ({
                updateOne: {
                    filter: { code: country.code },
                    update: { $setOnInsert: country },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Initial Country List Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_country_list()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); });