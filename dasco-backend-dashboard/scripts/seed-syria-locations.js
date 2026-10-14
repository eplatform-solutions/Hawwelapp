const { resolve } = require("path");
const { dashboardDB } = require("../database/connections");
const {
    countryModel,
    cityModel,
    regionModel,
    paymentMethodModel,
    countryPaymentMethodModel,
    cityPaymentMethodModel,
    regionPaymentMethodModel,
} = require("../models/dashboard");

require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const SYRIA_COUNTRY_CODE = "SY";

const SYRIA_CITIES = [
    { ar: "دمشق", en: "Damascus" },
    { ar: "حلب", en: "Aleppo" },
    { ar: "حمص", en: "Homs" },
    { ar: "حماة", en: "Hama" },
    { ar: "اللاذقية", en: "Latakia" },
    { ar: "طرطوس", en: "Tartus" },
];

const SYRIA_REGIONS_BY_CITY = {
    Damascus: [
        { ar: "المزة", en: "Al Mezzeh" },
        { ar: "ركن الدين", en: "Rukn al-Din" },
        { ar: "الميدان", en: "Al Midan" },
    ],
    Aleppo: [
        { ar: "الجميلية", en: "Al Jamiliyah" },
        { ar: "السريان الجديدة", en: "New Syriac" },
        { ar: "صلاح الدين", en: "Salah al-Din" },
    ],
    Homs: [
        { ar: "الوعر", en: "Al Waer" },
        { ar: "الإنشاءات", en: "Al Inshaat" },
        { ar: "بابا عمرو", en: "Baba Amr" },
    ],
    Hama: [
        { ar: "القصور", en: "Al Qusour" },
        { ar: "الحميدية", en: "Al Hamidiyah" },
        { ar: "طريق حلب", en: "Aleppo Road" },
    ],
    Latakia: [
        { ar: "الزراعة", en: "Al Ziraa" },
        { ar: "الصليبة", en: "Al Salibah" },
        { ar: "مشروع الصليبة", en: "Mashrou Al Salibah" },
    ],
    Tartus: [
        { ar: "الكرامة", en: "Al Karama" },
        { ar: "الرمل", en: "Al Raml" },
        { ar: "الإنشاءات", en: "Al Inshaat" },
    ],
};

async function upsertCountry() {
    await countryModel.updateOne(
        { code: SYRIA_COUNTRY_CODE },
        { $setOnInsert: { code: SYRIA_COUNTRY_CODE } },
        { upsert: true }
    );

    return countryModel.findOne({ code: SYRIA_COUNTRY_CODE });
}

async function upsertCities(countryId) {
    const cityIdByEnglishName = {};

    for (const city of SYRIA_CITIES) {
        await cityModel.updateOne(
            { country: countryId, "name.en": city.en },
            {
                $setOnInsert: {
                    country: countryId,
                    name: {
                        ar: city.ar,
                        en: city.en,
                    },
                },
            },
            { upsert: true }
        );

        const cityDoc = await cityModel.findOne(
            { country: countryId, "name.en": city.en },
            { _id: 1, "name.en": 1 }
        );
        cityIdByEnglishName[city.en] = cityDoc._id;
    }

    return cityIdByEnglishName;
}

async function upsertRegions(cityIdByEnglishName) {
    const regionIdsByCityEnglishName = {};

    for (const [cityEnglishName, regions] of Object.entries(SYRIA_REGIONS_BY_CITY)) {
        const cityId = cityIdByEnglishName[cityEnglishName];
        if (!cityId) continue;
        regionIdsByCityEnglishName[cityEnglishName] = [];

        for (const region of regions) {
            await regionModel.updateOne(
                { city: cityId, "name.en": region.en },
                {
                    $setOnInsert: {
                        city: cityId,
                        name: {
                            ar: region.ar,
                            en: region.en,
                        },
                    },
                },
                { upsert: true }
            );

            const regionDoc = await regionModel.findOne(
                { city: cityId, "name.en": region.en },
                { _id: 1 }
            );
            if (regionDoc) {
                regionIdsByCityEnglishName[cityEnglishName].push(regionDoc._id);
            }
        }
    }

    return regionIdsByCityEnglishName;
}

async function upsertPaymentMethodLinks({ countryId, cityIdByEnglishName, regionIdsByCityEnglishName }) {
    const activePaymentMethods = await paymentMethodModel.find(
        { isActivated: true },
        { _id: 1 }
    );
    const fallbackPaymentMethods = activePaymentMethods.length > 0
        ? activePaymentMethods
        : await paymentMethodModel.find({}, { _id: 1 });

    if (fallbackPaymentMethods.length === 0) {
        console.log("[seed-syria-locations] No payment methods found, skipping links.");
        return;
    }

    for (const paymentMethod of fallbackPaymentMethods) {
        await countryPaymentMethodModel.updateOne(
            { country: countryId, paymentMethod: paymentMethod._id },
            { $setOnInsert: { country: countryId, paymentMethod: paymentMethod._id } },
            { upsert: true }
        );
    }

    for (const cityId of Object.values(cityIdByEnglishName)) {
        for (const paymentMethod of fallbackPaymentMethods) {
            await cityPaymentMethodModel.updateOne(
                { city: cityId, paymentMethod: paymentMethod._id },
                { $setOnInsert: { city: cityId, paymentMethod: paymentMethod._id } },
                { upsert: true }
            );
        }
    }

    for (const regionIds of Object.values(regionIdsByCityEnglishName)) {
        for (const regionId of regionIds) {
            for (const paymentMethod of fallbackPaymentMethods) {
                await regionPaymentMethodModel.updateOne(
                    { region: regionId, paymentMethod: paymentMethod._id },
                    { $setOnInsert: { region: regionId, paymentMethod: paymentMethod._id } },
                    { upsert: true }
                );
            }
        }
    }
}

async function main() {
    try {
        if (!process.env.DASH_DB_URL) {
            throw new Error("DASH_DB_URL is missing in environment variables.");
        }

        await dashboardDB.openUri(process.env.DASH_DB_URL);
        const country = await upsertCountry();
        const cityIdByEnglishName = await upsertCities(country._id);
        const regionIdsByCityEnglishName = await upsertRegions(cityIdByEnglishName);
        await upsertPaymentMethodLinks({
            countryId: country._id,
            cityIdByEnglishName,
            regionIdsByCityEnglishName,
        });

        console.log("[seed-syria-locations] Syria locations and payment-method links seeded successfully.");
        await dashboardDB.close();
    } catch (error) {
        console.error("[seed-syria-locations]", error.message || error);
        await dashboardDB.close();
        process.exit(1);
    }
}

main();
