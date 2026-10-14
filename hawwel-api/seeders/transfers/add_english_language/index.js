const { dashboardDB, clientDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../.env.${process.env.NODE_ENV || "development"}`),
});

const { cityModel, areaModel, paymentMethodModel } = require("../../../models/dashboard");

const { transferModel } = require("../../../models/client");

const CITIES = {
    "Lattakia": {
        ar: "اللاذقية",
        en: "Lattakia"
    },
    "Tartus": {
        ar: "طرطوس",
        en: "Tartus",
    },
    "Beirut": {
        ar: "بيروت",
        en: "Beirut",
    },
    "Trablus": {
        ar: "طرابلس",
        en: "Trablus",
    },
}

const AREAS = {
    "Alzeraa": {
        ar: "الزراعة",
        en: "Alzeraa",
    },
    "Alkornish": {
        ar: "الكورنيش",
        en: "Alkornish",
    },
    "Alared": {
        ar: "العريض",
        en: "Alared",
    },
    "Baniyas": {
        ar: "بانياس",
        en: "Baniyas",
    },
    "Alhamraa": {
        ar: "الحمرا",
        en: "Alhamraa",
    },
    "Alzaytona": {
        ar: "الزيتونة",
        en: "Alzaytona",
    },
    "Bab Altebana": {
        ar: "باب التبانة",
        en: "Bab Altebana",
    },
    "Alzaheria": {
        ar: "الزاهرة",
        en: "Alzahera",
    },
}

const PAYMENT_METHODS = {
    "Alharam": {
        ar: "الهرم",
        en: "Alharam"
    },
    "Alfouad": {
        ar: "الفؤاد",
        en: "Alfouad"
    },
    "OMT": {
        ar: "OMT",
        en: "OMT"
    },
    "MTM": {
        ar: "MTM",
        en: "MTM"
    },
};

async function add_english_language() {
    try {
        await clientDB.openUri(process.env.DB_URL);
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        const cities = await cityModel.find();
        for (let city of cities) {
            city.name = CITIES[city.name];
            await city.save();
        }
        const areas = await areaModel.find();
        for (let area of areas) {
            area.name = AREAS[area.name];
            await area.save();
        }
        const paymentMethods = await paymentMethodModel.find();
        for (let paymentMethod of paymentMethods) {
            paymentMethod.name = PAYMENT_METHODS[paymentMethod.name];
            await paymentMethod.save();
        }
        const transfers = await transferModel.find();
        for (let transfer of transfers) {
            transfer.city = CITIES[transfer.city];
            transfer.area = AREAS[transfer.area];
            transfer.paymentMethod.name = PAYMENT_METHODS[transfer.paymentMethod.name];
            await transfer.save();
        }
        await dashboardDB.close();
        return "Add English Language To Old Data !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

add_english_language()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); });