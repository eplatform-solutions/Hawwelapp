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

const { areaModel, cityModel } = require("../../models/dashboard");

const INITIAL_AREAS = [
    {
        name: "Alzeraa",
        _id: new mongoose.Types.ObjectId("69e249f7db9b4f9cfe1c497d"),
    },
    {
        name: "Alkornish",
    },
    {
        name: "Alared",
    },
    {
        name: "Baniyas",
    },
    {
        name: "Alhamraa",
    },
    {
        name: "Alzaytona",
    },
    {
        name: "Bab Altebana",
    },
    {
        name: "Alzaheria",
    },
];

async function create_initial_area_list() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        for (let area of INITIAL_AREAS) {
            if (["Alzeraa", "Alkornish"].includes(area.name)) {
                area.city = (await cityModel.findOne({ name: "Lattakia" }))._id;
            }
            else if (["Alared", "Baniyas"].includes(area.name)) {
                area.city = (await cityModel.findOne({ name: "Tartus" }))._id;
            }
            else if (["Alhamraa", "Alzaytona"].includes(area.name)) {
                area.city = (await cityModel.findOne({ name: "Beirut" }))._id;
            } else {
                area.city = (await cityModel.findOne({ name: "Trablus" }))._id;
            }
        }
        await areaModel.bulkWrite(
            INITIAL_AREAS.map((area) => ({
                updateOne: {
                    filter: { name: area.name },
                    update: { $setOnInsert: area },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Initial Area List Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_area_list()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); });