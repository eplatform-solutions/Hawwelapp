// Import Required Models Object

const { paymentMethodModel, adminModel, countryPaymentMethodModel, cityPaymentMethodModel, regionPaymentMethodModel, cityModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { dashboardDB } = require("../../database/connections");

async function createPaymentMethod(adminId, paymentMethodInfo, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const paymentMethodDetails = await paymentMethodModel.findOne({ name: paymentMethodInfo.name });
            if (!paymentMethodDetails) {
                const newPaymentMethodInstance = new paymentMethodModel({
                    ...paymentMethodInfo,
                    normalizedLogoPath: paymentMethodInfo.normalizedLogoPath || paymentMethodInfo.cardLogoPath || ""
                });
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                const newPaymentMethod = await newPaymentMethodInstance.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Creating New Payment Method Process Has Been Successfully !!", language),
                    error: false,
                    data: { _id: newPaymentMethod._id },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Payment Method Already Exist !!", language),
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

async function getAllPaymentMethodsInsideThePage(
    adminId,
    pageNumber,
    pageSize,
    filters,
    language
) {
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
        const authorizationResult = authorizeAdmin(
            populatedAdmin,
            "payment_methods_managment",
            language
        );
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const query = {};
        if (filters?.name) {
            query.name = filters.name;
        }
        if (filters?.symbol) {
            query.symbol = filters.symbol;
        }
        let paymentMethodIds = [];
        if (filters?.region) {
            const regionPM = await regionPaymentMethodModel.find(
                { region: filters.region },
                { paymentMethod: 1 }
            );
            paymentMethodIds = regionPM.map(r => r.paymentMethod);
            if (paymentMethodIds.length === 0) {
                return {
                    msg: getSuitableTranslations("Sorry, No Payment Methods Were Found !!", language),
                    error: true,
                    data: {},
                };
            }
        }
        else if (filters?.city) {
            const cityPM = await cityPaymentMethodModel.find(
                { city: filters.city },
                { paymentMethod: 1 }
            );
            paymentMethodIds = cityPM.map(r => r.paymentMethod);
            if (paymentMethodIds.length === 0) {
                return {
                    msg: getSuitableTranslations("Sorry, No Payment Methods Were Found !!", language),
                    error: true,
                    data: {},
                };
            }
        }
        else if (filters?.country) {
            const countryPM = await countryPaymentMethodModel.find(
                { country: filters.country },
                { paymentMethod: 1 }
            );
            paymentMethodIds = countryPM.map(r => r.paymentMethod);
            if (paymentMethodIds.length === 0) {
                return {
                    msg: getSuitableTranslations("Sorry, No Payment Methods Were Found !!", language),
                    error: true,
                    data: {},
                };
            }
        }
        if (paymentMethodIds.length > 0) {
            query._id = { $in: paymentMethodIds };
        }
        const paymentMethods = await paymentMethodModel
            .find(query, { __v: false })
            .sort({ createdAt: -1 })
            .skip((pageNumber - 1) * pageSize)
            .limit(pageSize);
        const paymentMethodsCount =
            await paymentMethodModel.countDocuments(query);
        if (paymentMethods.length === 0) {
            return {
                msg: getSuitableTranslations("Sorry, No Payment Methods Were Found !!", language),
                error: true,
                data: {},
            };
        }
        const paymentMethodsWithAliases = paymentMethods.map((method) => {
            const raw = method.toObject ? method.toObject() : method;
            const normalizedLogoPath = raw.normalizedLogoPath || raw.cardLogoPath || "";
            return {
                ...raw,
                original_logo_url: raw.logoPath || "",
                normalized_logo_url: normalizedLogoPath,
            };
        });
        return {
            msg: getSuitableTranslations(
                "Get All Payment Methods Inside The Page: {{pageNumber}} Process Has Been Successfully !!",
                language,
                { pageNumber }
            ),
            error: false,
            data: {
                paymentMethods: paymentMethodsWithAliases,
                paymentMethodsCount,
            },
        }
    } catch (err) {
        throw Error(err);
    }
}

async function updatePaymentMethodInfo(adminId, paymentMethodId, newPaymentMethodData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const paymentMethodInfo = await paymentMethodModel.findById(paymentMethodId);
            if (paymentMethodInfo) {
                if (newPaymentMethodData?.name) {
                    const existPaymentMethod = await paymentMethodModel.findOne({ name: newPaymentMethodData.name });
                    if (existPaymentMethod) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Payment Method Already Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    paymentMethodInfo.name = newPaymentMethodData.name;
                }
                const symbol = newPaymentMethodData?.symbol;
                if (symbol) {
                    paymentMethodInfo.symbol = symbol;
                }
                const minAmount = newPaymentMethodData?.minAmount;
                if (minAmount) {
                    paymentMethodInfo.minAmount = minAmount;
                }
                const maxAmount = newPaymentMethodData?.maxAmount;
                if (maxAmount) {
                    paymentMethodInfo.maxAmount = maxAmount;
                }
                const fee = newPaymentMethodData?.fee;
                if (fee) {
                    paymentMethodInfo.fee = fee;
                }
                const isActivated = newPaymentMethodData?.isActivated;
                if (typeof isActivated === "boolean") {
                    paymentMethodInfo.isActivated = isActivated;
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await paymentMethodInfo.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Updating Payment Method Data Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Payment Method Is Not Exist !!", language),
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

async function changeLogoImage(adminId, paymentMethodId, newLogoImagePath, newCardLogoImagePath, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            const paymentMethodInfo = await paymentMethodModel.findByIdAndUpdate(
                paymentMethodId,
                {
                    logoPath: newLogoImagePath,
                    cardLogoPath: newCardLogoImagePath || "",
                    normalizedLogoPath: newCardLogoImagePath || ""
                },
                { returnOriginal: true, session: dbSession }
            );
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            if (paymentMethodInfo) {
                return {
                    msg: getSuitableTranslations("Changing Payment Method Logo Image Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        logoPath: paymentMethodInfo.logoPath,
                        cardLogoPath: paymentMethodInfo.cardLogoPath || "",
                        normalizedLogoPath: paymentMethodInfo.normalizedLogoPath || ""
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Payment Method Is Not Exist !!", language),
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

async function deletePaymentMethod(adminId, paymentMethodId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const paymentMethodDetails = await paymentMethodModel.findById(paymentMethodId);
            if (paymentMethodDetails) {
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await countryPaymentMethodModel.deleteMany({ paymentMethod: paymentMethodId }, { session: dbSession });
                await cityPaymentMethodModel.deleteMany({ paymentMethod: paymentMethodId }, { session: dbSession });
                await regionPaymentMethodModel.deleteMany({ paymentMethod: paymentMethodId }, { session: dbSession });
                await paymentMethodDetails.deleteOne({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Deleting Payment Method Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        logoPath: paymentMethodDetails.logoPath,
                        cardLogoPath: paymentMethodDetails.cardLogoPath || "",
                        normalizedLogoPath: paymentMethodDetails.normalizedLogoPath || ""
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Payment Method Is Not Exist !!", language),
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

async function getPaymentMethodBindings(adminId, paymentMethodId, language) {
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
        const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const paymentMethodDetails = await paymentMethodModel.findById(paymentMethodId);
        if (!paymentMethodDetails) {
            return {
                msg: getSuitableTranslations("Sorry, This Payment Method Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }

        const [countryBindings, cityBindings, regionBindings] = await Promise.all([
            countryPaymentMethodModel
                .find({ paymentMethod: paymentMethodId })
                .populate({ path: "country", select: "code" }),
            cityPaymentMethodModel
                .find({ paymentMethod: paymentMethodId })
                .populate({
                    path: "city",
                    select: "name country",
                    populate: { path: "country", select: "code" }
                }),
            regionPaymentMethodModel
                .find({ paymentMethod: paymentMethodId })
                .populate({
                    path: "region",
                    select: "name city",
                    populate: {
                        path: "city",
                        select: "name country",
                        populate: { path: "country", select: "code" }
                    }
                }),
        ]);

        return {
            msg: getSuitableTranslations("Get Payment Method Bindings Process Has Been Successfully !!", language),
            error: false,
            data: {
                countries: countryBindings
                    .filter((binding) => binding.country)
                    .map((binding) => ({ _id: binding.country._id, code: binding.country.code })),
                cities: cityBindings
                    .filter((binding) => binding.city && binding.city.country)
                    .map((binding) => ({
                        _id: binding.city._id,
                        name: binding.city.name,
                        country: { _id: binding.city.country._id, code: binding.city.country.code },
                    })),
                regions: regionBindings
                    .filter((binding) => binding.region && binding.region.city && binding.region.city.country)
                    .map((binding) => ({
                        _id: binding.region._id,
                        name: binding.region.name,
                        city: { _id: binding.region.city._id, name: binding.region.city.name },
                        country: { _id: binding.region.city.country._id, code: binding.region.city.country.code },
                    })),
            },
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function unbindPaymentMethodFromCountry(adminId, paymentMethodId, countryId, language, dbSession = null) {
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
        const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const deleted = await countryPaymentMethodModel.findOneAndDelete(
            { country: countryId, paymentMethod: paymentMethodId },
            { session: dbSession }
        );
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        if (!deleted) {
            return {
                msg: getSuitableTranslations("Sorry, This Binding Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Unbinding Payment Method From This Country Process Has Been Successfully !!", language),
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

async function unbindPaymentMethodFromCity(adminId, paymentMethodId, cityId, language, dbSession = null) {
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
        const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const deleted = await cityPaymentMethodModel.findOneAndDelete(
            { city: cityId, paymentMethod: paymentMethodId },
            { session: dbSession }
        );
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        if (!deleted) {
            return {
                msg: getSuitableTranslations("Sorry, This Binding Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Unbinding Payment Method From This City Process Has Been Successfully !!", language),
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

async function unbindPaymentMethodFromRegion(adminId, paymentMethodId, regionId, language, dbSession = null) {
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
        const authorizationResult = authorizeAdmin(populatedAdmin, "payment_methods_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const deleted = await regionPaymentMethodModel.findOneAndDelete(
            { region: regionId, paymentMethod: paymentMethodId },
            { session: dbSession }
        );
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        if (!deleted) {
            return {
                msg: getSuitableTranslations("Sorry, This Binding Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Unbinding Payment Method From This Region Process Has Been Successfully !!", language),
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
    createPaymentMethod,
    getAllPaymentMethodsInsideThePage,
    updatePaymentMethodInfo,
    changeLogoImage,
    deletePaymentMethod,
    getPaymentMethodBindings,
    unbindPaymentMethodFromCountry,
    unbindPaymentMethodFromCity,
    unbindPaymentMethodFromRegion,
}