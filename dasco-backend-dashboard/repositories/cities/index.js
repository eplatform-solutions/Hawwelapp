// Import Required Models

const { cityModel, countryModel, adminModel, regionModel, regionPaymentMethodModel, cityPaymentMethodModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { findExistingPaymentMethodsOrError, upsertBindings } = require("../../helpers/geo_payment_methods");

const { dashboardDB } = require("../../database/connections");

function normalizeBilingualName(rawName) {
    if (!rawName || typeof rawName !== "object") {
        return null;
    }
    const ar = String(rawName.ar || "").trim();
    const en = String(rawName.en || "").trim();
    if (!ar || !en) {
        return null;
    }
    return { ar, en };
}

async function createCity(adminId, cityInfo, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const countryDetails = await countryModel.findById(cityInfo.country);
            if (countryDetails) {
                const normalizedName = normalizeBilingualName(cityInfo.name);
                if (!normalizedName) {
                    return {
                        msg: getSuitableTranslations("Sorry, Please Send Valid City Name Data !!", language),
                        error: true,
                        data: {},
                    }
                }
                const newCityInstance = new cityModel({ country: cityInfo.country, name: normalizedName });
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                const newCity = await newCityInstance.save({ session: dbSession });
                // Deliberately no payment-method inheritance here: a method
                // being enabled for the country (e.g. a cash agent network)
                // does not mean every city actually has that service - each
                // city's payment methods must be configured explicitly.
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Creating New City Process Has Been Successfully !!", language),
                    error: false,
                    data: { _id: newCity._id },
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

async function getAllCitiesInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const cities = await cityModel.find(filters, { __v: false }).sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize).populate("country", { code: 1 });
            if (cities.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Cities Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        cities,
                        citiesCount: await cityModel.countDocuments(filters),
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Cities Were Found !!", language),
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
    } catch (err) {
        throw Error(err);
    }
}

async function updateCityInfo(adminId, cityId, newCityData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const cityInfo = await cityModel.findById(cityId);
            if (cityInfo) {
                if (newCityData?.country) {
                    const existCountry = await countryModel.findById(newCityData.country);
                    if (!existCountry) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Country Is Not Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    cityInfo.country = newCityData.country;
                }
                const name = newCityData?.name;
                if (name) {
                    const normalizedName = normalizeBilingualName(name);
                    if (!normalizedName) {
                        return {
                            msg: getSuitableTranslations("Sorry, Please Send Valid City Name Data !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    cityInfo.name = normalizedName;
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await cityInfo.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Updating City Data Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This City Is Not Exist !!", language),
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

async function deleteCity(adminId, cityId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "countries_and_cities_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const cityDetails = await cityModel.findById(cityId);
            if (cityDetails) {
                const regions = await regionModel
                    .find({ city: cityId });
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
                    city: cityId
                }, { session: dbSession });
                await regionModel.deleteMany({
                    city: cityId
                }, { session: dbSession });
                await cityDetails.deleteOne({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Deleting City Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This City Is Not Exist !!", language),
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

async function bindPaymentMethodsToCity(adminId, cityId, paymentMethodIds, language, dbSession = null) {
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
        const cityDetails = await cityModel.findById(cityId);
        if (!cityDetails) {
            return {
                msg: getSuitableTranslations("Sorry, This City Is Not Exist !!", language),
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
        // Deliberately no cascade in either direction: binding a payment
        // method at city level must stay scoped to this city - widening the
        // country binding here would make the method appear immediately
        // for the whole country, skipping city/region selection entirely,
        // which defeats the point of a city-scoped binding. Same reasoning
        // blocks cascading down to this city's regions - a method available
        // in a city is not automatically available in every region of it.
        await upsertBindings(cityPaymentMethodModel, "city", cityId, paymentMethodIds, dbSession);
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Enabling Payment Methods For This City Process Has Been Successfully !!", language),
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
    createCity,
    getAllCitiesInsideThePage,
    updateCityInfo,
    deleteCity,
    bindPaymentMethodsToCity
}