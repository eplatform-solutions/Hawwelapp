// Import Required Models

const { countryModel, adminModel, cityModel, regionModel, regionPaymentMethodModel, cityPaymentMethodModel, countryPaymentMethodModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { findExistingPaymentMethodsOrError, upsertBindings } = require("../../helpers/geo_payment_methods");

const { dashboardDB } = require("../../database/connections");

async function createCountry(adminId, code, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const countryDetails = await countryModel.findOne({ code });
            if (!countryDetails) {
                const newCountryInstance = new countryModel({ code });
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                const newCountry = await newCountryInstance.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Creating New Country Process Has Been Successfully !!", language),
                    error: false,
                    data: { _id: newCountry._id },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Country Already Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function getAllCountries(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const countries = await countryModel.find({}, { code: 1 });
            if (countries.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Countries Data Process Has Been Successfully !!", language),
                    error: false,
                    data: countries,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Countries Were Found !!", language),
                error: true,
                data: {}
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function deleteCountry(adminId, countryId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const countryDetails = await countryModel.findById(countryId);
            if (countryDetails) {
                const cities = await cityModel.find({ country: countryId });
                const cityIds = cities.map(c => c._id);
                const regions = await regionModel.find({ city: { $in: cityIds } });
                const regionIds = regions.map(a => a._id);
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await regionPaymentMethodModel.deleteMany({
                    region: { $in: regionIds }
                }, { session: dbSession });
                await cityPaymentMethodModel.deleteMany({
                    city: { $in: cityIds }
                }, { session: dbSession });
                await countryPaymentMethodModel.deleteMany({
                    country: countryId
                }, { session: dbSession });
                await regionModel.deleteMany({
                    city: { $in: cityIds }
                }, { session: dbSession });
                await cityModel.deleteMany({
                    country: countryId
                }, { session: dbSession });
                await countryDetails.deleteOne({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Deleting Country Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Country Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function bindPaymentMethodsToCountry(adminId, countryId, paymentMethodIds, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            }
        }
        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const countryDetails = await countryModel.findById(countryId);
        if (!countryDetails) {
            return {
                msg: getSuitableTranslations("Sorry, This Country Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        if (!Array.isArray(paymentMethodIds) || paymentMethodIds.length === 0) {
            return {
                msg: getSuitableTranslations("Sorry, Please Send Valid Payment Methods Data !!", language),
                error: true,
                data: {},
            }
        }
        const { error } = await findExistingPaymentMethodsOrError(paymentMethodIds, language);
        if (error) return error;

        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        // Deliberately no downward cascade to cities/regions: a payment method
        // enabled at the country level does not imply it is available at every
        // city/region underneath - each level's availability is managed
        // independently (mirrors the "no upward cascade" behavior elsewhere).
        await upsertBindings(countryPaymentMethodModel, "country", countryId, paymentMethodIds, dbSession);
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Enabling Payment Methods For This Country Process Has Been Successfully !!", language),
            error: false,
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

module.exports = {
    createCountry,
    getAllCountries,
    deleteCountry,
    bindPaymentMethodsToCountry
}