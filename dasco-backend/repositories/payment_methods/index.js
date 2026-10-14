// Import Required Models

const { paymentMethodModel, areaPaymentMethodModel, countryPaymentMethodModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { getArea } = require("../areas");

const { getCountry } = require("../countries");

async function getPaymentMethod(id, language) {
    try {
        const paymentMethod = await paymentMethodModel.findById(id);
        if (paymentMethod) {
            const raw = paymentMethod.toObject ? paymentMethod.toObject() : paymentMethod;
            const normalizedLogoPath = raw.normalizedLogoPath || raw.cardLogoPath || "";
            return {
                msg: getSuitableTranslations("Get Payment Method Data Process Has Been Successfully !!", language),
                error: false,
                data: {
                    ...raw,
                    original_logo_url: raw.logoPath || "",
                    normalized_logo_url: normalizedLogoPath,
                },
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Payment Method Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getPaymentMethodsInArea(areaId, language) {
    try {
        const areaResult = await getArea(areaId, language);
        if (!areaResult.error) {
            const areaPaymentMethods = await areaPaymentMethodModel.find({ region: areaId }, { paymentMethod: 1 });
            if (areaPaymentMethods.length > 0) {
                const paymentMethods = await paymentMethodModel.find({ _id: { $in: areaPaymentMethods.map((areaPaymentMethod) => areaPaymentMethod.paymentMethod) } });
                const mapped = paymentMethods.map((method) => {
                    const raw = method.toObject ? method.toObject() : method;
                    const normalizedLogoPath = raw.normalizedLogoPath || raw.cardLogoPath || "";
                    return {
                        ...raw,
                        original_logo_url: raw.logoPath || "",
                        normalized_logo_url: normalizedLogoPath,
                    };
                });
                return {
                    msg: getSuitableTranslations("Get All Payment Methods Data In This Area Process Has Been Successfully !!", language),
                    error: false,
                    data: mapped,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, Can't Find Any Payment Method In This Area !!", language),
                error: true,
                data: {}
            }
        }
        return areaResult;
    }
    catch (err) {
        throw Error(err);
    }
}

async function getPaymentMethodsInCountry(countryId, language) {
    try {
        const countryResult = await getCountry(countryId, language);
        if (!countryResult.error) {
            const countryPaymentMethods = await countryPaymentMethodModel.find({ country: countryId }, { paymentMethod: 1 });
            if (countryPaymentMethods.length > 0) {
                const paymentMethods = await paymentMethodModel.find({ _id: { $in: countryPaymentMethods.map((countryPaymentMethod) => countryPaymentMethod.paymentMethod) } });
                const mapped = paymentMethods.map((method) => {
                    const raw = method.toObject ? method.toObject() : method;
                    const normalizedLogoPath = raw.normalizedLogoPath || raw.cardLogoPath || "";
                    return {
                        ...raw,
                        original_logo_url: raw.logoPath || "",
                        normalized_logo_url: normalizedLogoPath,
                    };
                });
                return {
                    msg: getSuitableTranslations("Get All Payment Methods Data In This Country Process Has Been Successfully !!", language),
                    error: false,
                    data: mapped,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, Can't Find Any Payment Method In This Country !!", language),
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
    getPaymentMethod,
    getPaymentMethodsInArea,
    getPaymentMethodsInCountry
}