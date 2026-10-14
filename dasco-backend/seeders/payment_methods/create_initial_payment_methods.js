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
        "Legacy payment-method defaults are disabled in production. Set ALLOW_LEGACY_GEO_DEFAULT_SEEDERS=true only for explicit one-time migration."
    );
    process.exit(1);
}

const { countryModel, cityModel, areaModel, paymentMethodModel, countryPaymentMethodModel, cityPaymentMethodModel, areaPaymentMethodModel } = require("../../models/dashboard");

const INITIAL_PAYMENT_METHODS = [
    {
        _id: new mongoose.Types.ObjectId("69e249eadb9b4f9cfe1c4965"),
        name: {
            ar: "الهرم",
            en: "Alharam"
        },
        symbol: "USD",
        minAmount: 10,
        maxAmount: 1000,
        fee: 5,
        isActivated: true,
        logoPath: "assets/images/payment_methods/69e249ea-db9b-4f9c-fe1c-496500000001__alharam.png"
    },
    {
        name: {
            ar: "الفؤاد",
            en: "Alfouad"
        },
        symbol: "USD",
        minAmount: 15,
        maxAmount: 1500,
        fee: 2,
        isActivated: true,
        logoPath: "assets/images/payment_methods/a1f0aad1-db9b-4f9c-fe1c-496500000002__alfouad.png"
    },
    {
        name: {
            ar: "OMT",
            en: "OMT"
        },
        symbol: "USD",
        minAmount: 5,
        maxAmount: 5000,
        fee: 1,
        isActivated: true,
        logoPath: "assets/images/payment_methods/b2f0aad1-db9b-4f9c-fe1c-496500000003__omt.png"
    },
    {
        name: {
            ar: "MTM",
            en: "MTM"
        },
        symbol: "USD",
        minAmount: 7,
        maxAmount: 2000,
        fee: 3,
        isActivated: true,
        logoPath: "assets/images/payment_methods/c3f0aad1-db9b-4f9c-fe1c-496500000004__mtm.png"
    },
];

async function create_initial_payment_methods_list() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        for (let paymentMethod of INITIAL_PAYMENT_METHODS) {
            let country = {};
            if (["Alharam", "Alfouad"].includes(paymentMethod.name.en)) {
                country = await countryModel.findOne({ code: "SY" });
            } else {
                country = await countryModel.findOne({ code: "LB" });
            }
            const newPaymentMethod = await paymentMethodModel.findOneAndUpdate(
                { "name.en": paymentMethod.name.en },
                { $setOnInsert: paymentMethod },
                { upsert: true, new: true }
            );
            await countryPaymentMethodModel.updateOne(
                { country: country._id, paymentMethod: newPaymentMethod._id },
                { $setOnInsert: { country: country._id, paymentMethod: newPaymentMethod._id } },
                { upsert: true }
            );
            const cities = await cityModel.find({ country: country._id });
            for (let city of cities) {
                await cityPaymentMethodModel.updateOne(
                    { city: city._id, paymentMethod: newPaymentMethod._id },
                    { $setOnInsert: { city: city._id, paymentMethod: newPaymentMethod._id } },
                    { upsert: true }
                );
                const areas = await areaModel.find({ city: city._id });
                await areaPaymentMethodModel.bulkWrite(
                    areas.map((area) => ({
                        updateOne: {
                            filter: { region: area._id, paymentMethod: newPaymentMethod._id },
                            update: { $setOnInsert: { region: area._id, paymentMethod: newPaymentMethod._id } },
                            upsert: true,
                        },
                    }))
                );
            }
        }
        await dashboardDB.close();
        return "Create Initial Payment Methods List Process Has Been Successfully !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_payment_methods_list()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); })