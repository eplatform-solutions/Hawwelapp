// Import Required Models

const { regionModel, adminModel, cityModel, regionPaymentMethodModel } = require("../../models/dashboard");

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

async function createRegion(adminId, regionInfo, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "regions_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const cityDetails = await cityModel.findById(regionInfo.city);
            if (cityDetails) {
                const normalizedName = normalizeBilingualName(regionInfo.name);
                if (!normalizedName) {
                    return {
                        msg: getSuitableTranslations("Sorry, Please Send Valid Region Name Data !!", language),
                        error: true,
                        data: {},
                    }
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                // Deliberately no payment-method inheritance from the city:
                // a method being available somewhere in the city does not
                // mean this specific region has that service, so a region
                // starts with none unless the admin explicitly picks some.
                // Just as deliberately, no cascade the other way either: a
                // region-scoped pick must stay scoped to this region and
                // must NOT also widen the city's or country's binding -
                // doing so would make the method appear immediately for
                // the whole country, skipping city/region selection
                // entirely, which defeats the point of a region-scoped pick.
                let paymentMethodIds = [];
                if (Array.isArray(regionInfo?.paymentMethods) && regionInfo.paymentMethods.length > 0) {
                    const { error, existingPaymentMethods } = await findExistingPaymentMethodsOrError(regionInfo.paymentMethods, language);
                    if (error) return error;
                    paymentMethodIds = existingPaymentMethods.map((paymentMethod) => paymentMethod._id);
                }
                const newRegionInstance = new regionModel({ city: regionInfo.city, name: normalizedName });
                const newRegion = await newRegionInstance.save({ session: dbSession });
                await upsertBindings(regionPaymentMethodModel, "region", newRegion._id, paymentMethodIds, dbSession);
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Creating New Region Process Has Been Successfully !!", language),
                    error: false,
                    data: { _id: newRegion._id },
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

async function getAllRegionsInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "regions_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const regions = await regionModel.find(filters, { __v: false }).sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize)
                .populate(
                    {
                        path: "city",
                        select: "name country",
                        populate: {
                            path: "country",
                            select: "code",
                        }
                    }
                )
            if (regions.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Regions Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        regions,
                        regionsCount: await regionModel.countDocuments(filters),
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Regions Were Found !!", language),
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

async function updateRegionInfo(adminId, regionId, newRegionData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            }
        }
        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "regions_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const regionInfo = await regionModel
            .findById(regionId);
        if (!regionInfo) {
            return {
                msg: getSuitableTranslations("Sorry, This Region Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        if (newRegionData?.city) {
            const existCity = await cityModel
                .findById(newRegionData.city);
            if (!existCity) {
                return {
                    msg: getSuitableTranslations("Sorry, This City Is Not Exist !!", language),
                    error: true,
                    data: {},
                }
            }
            regionInfo.city = existCity._id;
        }
        if (newRegionData?.name) {
            const normalizedName = normalizeBilingualName(newRegionData.name);
            if (!normalizedName) {
                return {
                    msg: getSuitableTranslations("Sorry, Please Send Valid Region Name Data !!", language),
                    error: true,
                    data: {},
                }
            }
            regionInfo.name = normalizedName;
        }
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        if (Array.isArray(newRegionData?.paymentMethods)) {
            const { error, existingPaymentMethods } = await findExistingPaymentMethodsOrError(newRegionData.paymentMethods, language);
            if (error) return error;
            const paymentMethodIds = existingPaymentMethods.map((paymentMethod) => paymentMethod._id);

            // No cascade up to the city or country here either (see the
            // matching note in createRegion) - a region's payment methods
            // stay scoped to that region only.

            await regionPaymentMethodModel
                .deleteMany({ region: regionId }, { session: dbSession });
            await upsertBindings(regionPaymentMethodModel, "region", regionId, paymentMethodIds, dbSession);
        }
        await regionInfo.save({ session: dbSession });
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations(
                "Updating Region Data Process Has Been Successfully !!",
                language
            ),
            error: false,
            data: {},
        };
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function deleteRegion(adminId, regionId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "regions_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const regionDetails = await regionModel.findById(regionId);
            if (regionDetails) {
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await regionPaymentMethodModel.deleteMany({
                    region: regionId
                }, { session: dbSession });
                await regionDetails.deleteOne({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Deleting Region Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Region Is Not Exist !!", language),
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

module.exports = {
    createRegion,
    getAllRegionsInsideThePage,
    updateRegionInfo,
    deleteRegion
}
