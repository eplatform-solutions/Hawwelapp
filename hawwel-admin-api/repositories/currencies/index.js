const { adminModel, currencyRateModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { dashboardDB } = require("../../database/connections");
const { SUPPORTED_CRYPTO_CURRENCY_SYMBOLS } = require("../../constants/currencies");

function isCryptoSymbol(code) {
    return SUPPORTED_CRYPTO_CURRENCY_SYMBOLS.includes(String(code || "").trim().toUpperCase());
}

async function getAllCurrencies(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            };
        }
        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "currencies_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const currencies = await currencyRateModel.find({}, { __v: 0 }).sort({ createdAt: -1 });
        return {
            msg: getSuitableTranslations("Get All Currencies Data Process Has Been Successfully !!", language),
            error: false,
            data: currencies,
        };
    }
    catch (err) {
        throw Error(err);
    }
}

async function createCurrency(adminId, newCurrency, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            };
        }
        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "currencies_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const code = String(newCurrency?.code || "").trim().toUpperCase();
        if (isCryptoSymbol(code)) {
            return {
                msg: getSuitableTranslations("Sorry, Crypto Symbols Are Managed In Blockchain Configuration Only !!", language),
                error: true,
                data: {},
            };
        }
        const exists = await currencyRateModel.findOne({ code });
        if (exists) {
            return {
                msg: getSuitableTranslations("Sorry, This Currency Already Exist !!", language),
                error: true,
                data: {},
            };
        }
        const item = new currencyRateModel({
            code,
            name: String(newCurrency?.name || "").trim(),
            usdtRate: Number(newCurrency?.usdtRate),
            usdcRate: Number(newCurrency?.usdcRate),
        });
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        await item.save({ session: dbSession });
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Creating New Currency Process Has Been Successfully !!", language),
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

async function updateCurrency(adminId, currencyId, newData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            };
        }
        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "currencies_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const currency = await currencyRateModel.findById(currencyId);
        if (!currency) {
            return {
                msg: getSuitableTranslations("Sorry, This Currency Is Not Exist !!", language),
                error: true,
                data: {},
            };
        }
        if (newData?.code) {
            const normalizedCode = String(newData.code).trim().toUpperCase();
            if (isCryptoSymbol(normalizedCode)) {
                return {
                    msg: getSuitableTranslations("Sorry, Crypto Symbols Are Managed In Blockchain Configuration Only !!", language),
                    error: true,
                    data: {},
                };
            }
            const duplicate = await currencyRateModel.findOne({ code: normalizedCode, _id: { $ne: currencyId } });
            if (duplicate) {
                return {
                    msg: getSuitableTranslations("Sorry, This Currency Already Exist !!", language),
                    error: true,
                    data: {},
                };
            }
            currency.code = normalizedCode;
        }
        if (newData?.name !== undefined) {
            currency.name = String(newData.name || "").trim();
        }
        if (newData?.usdtRate !== undefined) {
            currency.usdtRate = Number(newData.usdtRate);
        }
        if (newData?.usdcRate !== undefined) {
            currency.usdcRate = Number(newData.usdcRate);
        }
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        await currency.save({ session: dbSession });
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Updating Currency Data Process Has Been Successfully !!", language),
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

async function deleteCurrency(adminId, currencyId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            };
        }
        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "currencies_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const currency = await currencyRateModel.findById(currencyId);
        if (!currency) {
            return {
                msg: getSuitableTranslations("Sorry, This Currency Is Not Exist !!", language),
                error: true,
                data: {},
            };
        }
        if (!dbSession) {
            dbSession = await dashboardDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        await currency.deleteOne({ session: dbSession });
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Deleting Currency Process Has Been Successfully !!", language),
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

module.exports = {
    getAllCurrencies,
    createCurrency,
    updateCurrency,
    deleteCurrency,
};
