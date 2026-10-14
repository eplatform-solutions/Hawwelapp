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

const { countryModel, cityModel } = require("../../models/dashboard");

const INITIAL_CITIES = [
    {
        name: "Lattakia",
        _id: new mongoose.Types.ObjectId("69e249cedb9b4f9cfe1c4942"),
    },
    {
        name: "Tartus",
    },
    {
        name: "Beirut",
    },
    {
        name: "Trablus",
    },
];

async function create_initial_city_list() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        for (let city of INITIAL_CITIES) {
            if (["Lattakia", "Tartus"].includes(city.name)) {
                city.country = (await countryModel.findOne({ code: "SY" }))._id;
            } else {
                city.country = (await countryModel.findOne({ code: "LB" }))._id;
            }
        }
        await cityModel.bulkWrite(
            INITIAL_CITIES.map((city) => ({
                updateOne: {
                    filter: { name: city.name },
                    update: { $setOnInsert: city },
                    upsert: true,
                },
            }))
        );
        return "Create Initial City List Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_city_list()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); });