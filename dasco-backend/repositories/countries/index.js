// Import Required Models

const mongoose = require("mongoose");

const { countryModel, cityModel, areaModel, countryPaymentMethodModel } = require("../../models/dashboard");

const { COUNTRIES } = require("../../constants/countries");

const { getSuitableTranslations } = require("../../helpers/translation");

function looksLikeObjectId(value) {
    return typeof value === "string" && value.length === 24 && mongoose.Types.ObjectId.isValid(value);
}

async function getCountry(id, language) {
    try {
        let country = null;
        if (looksLikeObjectId(id)) {
            country = await countryModel.findById(id);
        }
        if (!country && typeof id === "string") {
            country = await countryModel.findOne({ code: id.toUpperCase() });
        }
        if (country) {
            return {
                msg: getSuitableTranslations("Get Country Data Process Has Been Successfully !!", language),
                error: false,
                data: country,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Country Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getCountryByFilters(filters, language) {
    try {
        const country = await countryModel.findOne(filters);
        if (country) {
            return {
                msg: getSuitableTranslations("Get Country Data Process Has Been Successfully !!", language),
                error: false,
                data: country,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Country Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getAllCountries(language) {
    try {
        const countryIdsWithCities = await cityModel.distinct("country");
        const cityIdsWithAreas = await areaModel.distinct("city");
        const countriesWithAreas = await cityModel.distinct("country", {
            _id: { $in: cityIdsWithAreas }
        });
        // A country is also valid on its own when it has a payment method
        // bound directly to it (no city/region needed at all), regardless
        // of whether it has any cities/areas configured.
        const countriesWithPaymentMethods = await countryPaymentMethodModel.distinct("country");

        const allowedCountryIds = countriesWithAreas.length > 0
            ? countriesWithAreas
            : countryIdsWithCities;

        const allowedCountryIdSet = new Set([
            ...allowedCountryIds.map((id) => id.toString()),
            ...countriesWithPaymentMethods.map((id) => id.toString()),
        ]);

        const inDb = await countryModel
            .find({ _id: { $in: Array.from(allowedCountryIdSet) } }, { code: 1 })
            .lean();

        const data = inDb
            .sort((a, b) => a.code.localeCompare(b.code))
            .map((country) => ({
                _id: country._id.toString(),
                code: country.code,
            }));
        return {
            msg: getSuitableTranslations("Get All Countries Data Process Has Been Successfully !!", language),
            error: false,
            data,
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getCountry,
    getCountryByFilters,
    getAllCountries
}