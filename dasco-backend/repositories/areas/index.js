// Import Required Models

const { areaModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { getCity } = require("../cities");

async function getArea(id, language) {
    try {
        const area = await areaModel.findById(id);
        if (area) {
            return {
                msg: getSuitableTranslations("Get Area Process Has Been Successfully !!", language),
                error: false,
                data: area,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Area Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getAreasInCity(cityId, language) {
    try {
        const cityResult = await getCity(cityId, language);
        if (!cityResult.error) {
            const areas = await areaModel.find({ city: cityId }, { name: 1 });
            if (areas.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Areas Data In This City Process Has Been Successfully !!", language),
                    error: false,
                    data: areas,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, Can't Find Any Area In This City !!", language),
                error: true,
                data: {}
            }
        }
        return cityResult;
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getArea,
    getAreasInCity
}