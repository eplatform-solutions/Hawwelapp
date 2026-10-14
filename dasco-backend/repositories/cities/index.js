// Import Reqquired Models

const { cityModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { getCountry } = require("../countries");

async function getCity(id, language) {
    try {
        const city = await cityModel.findById(id);
        if (city) {
            return {
                msg: getSuitableTranslations("Get City Data Process Has Been Successfully !!", language),
                error: false,
                data: city,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This City Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getCitiesInCountry(countryId, language) {
    try {
        const countryResult = await getCountry(countryId, language);
        if (!countryResult.error) {
            const resolvedCountryId = countryResult.data._id;
            const cities = await cityModel.find({ country: resolvedCountryId }, { name: 1 });
            if (cities.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Cities Data In This Country Process Has Been Successfully !!", language),
                    error: false,
                    data: cities,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, Can't Find Any Cities In This Country !!", language),
                error: true,
                data: {}
            }
        }
        return countryResult;
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getCity,
    getCitiesInCountry
}