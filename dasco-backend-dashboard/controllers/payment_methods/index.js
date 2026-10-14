// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for payment methods management
const paymentMethodsOperationsManagmentFunctions = require("../../repositories/payment_methods");

const { unlinkSync } = require("fs");
const path = require("path");
const sharp = require("sharp");
const { ensureUploadDir } = require("../../utils/files");

function buildCardLogoRelativePath(fileName) {
    const parsed = path.parse(fileName);
    const [uuidPart, ...rest] = parsed.name.split("__");
    const baseName = rest.join("__") || "logo";
    const cardFileName = `${uuidPart}__${baseName}-card.webp`;
    return `assets/images/payment_methods/cards/${cardFileName}`;
}

async function generatePaymentMethodCardLogoVariant(sourcePath, cardOutputPath) {
    const outputAbs = path.resolve(cardOutputPath);
    ensureUploadDir(path.dirname(outputAbs));

    await sharp(sourcePath, { failOn: "none" })
        .rotate()
        .trim()
        .resize({
            width: 512,
            height: 220,
            fit: "contain",
            background: { r: 0, g: 0, b: 0, alpha: 0 }
        })
        .webp({ quality: 95 })
        .toFile(outputAbs);
}

async function buildPaymentMethodLogoPaths(uploadedFile) {
    const logoPath = `assets/images/payment_methods/${uploadedFile.filename}`;
    const cardLogoPath = buildCardLogoRelativePath(uploadedFile.filename);
    await generatePaymentMethodCardLogoVariant(uploadedFile.path, cardLogoPath);
    return { logoPath, cardLogoPath };
}

async function postCreatePaymentMethod(req, res) {
    try {
        const logoPaths = await buildPaymentMethodLogoPaths(req.file);
        const paymentMethodInfo = {
            ...{ name, symbol, minAmount, maxAmount, fee } = Object.assign({}, req.body),
            logoPath: logoPaths.logoPath,
            cardLogoPath: logoPaths.cardLogoPath,
            normalizedLogoPath: logoPaths.cardLogoPath
        }
        paymentMethodInfo.name = JSON.parse(paymentMethodInfo.name);
        const result = await paymentMethodsOperationsManagmentFunctions.createPaymentMethod(req.data._id, paymentMethodInfo, req.query.language);
        if (result.error) {
            try {
                unlinkSync(logoPaths.logoPath);
                unlinkSync(logoPaths.cardLogoPath);
            }
            catch (err) {
                console.log(`error in delete payment method image file, path: ${logoPaths.logoPath}`);
            }
            return handleResponse(result, res);
        }
        res.json(result);
    }
    catch (err) {
        console.log(err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "name") {
            filtersObject["$or"] = [
                { "name.ar": { $regex: new RegExp(`^${filters[objectKey]}`, 'i') } },
                { "name.en": { $regex: new RegExp(`^${filters[objectKey]}`, 'i') } }
            ];
        }
        if (objectKey === "symbol") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "region") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "city") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "country") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllPaymentMethodsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await paymentMethodsOperationsManagmentFunctions.getAllPaymentMethodsInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putPaymentMethodInfo(req, res) {
    try {
        const result = await paymentMethodsOperationsManagmentFunctions.updatePaymentMethodInfo(req.data._id, req.params.paymentMethodId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function putPaymentMethodLogoImage(req, res) {
    try {
        const logoPaths = await buildPaymentMethodLogoPaths(req.file);
        const result = await paymentMethodsOperationsManagmentFunctions.changeLogoImage(
            req.data._id,
            req.params.paymentMethodId,
            logoPaths.logoPath,
            logoPaths.cardLogoPath,
            req.query.language
        );
        if (result.error) {
            try {
                unlinkSync(logoPaths.logoPath);
                unlinkSync(logoPaths.cardLogoPath);
            }
            catch (err) {
                console.log(`error in delete payment method image file, path: ${logoPaths.logoPath}`);
            }
            return handleResponse(result, res);
        }
        else {
            const oldLogoImagePath = result.data.logoPath;
            const oldCardLogoImagePath = result.data.cardLogoPath || result.data.normalizedLogoPath;
            delete result.data.logoPath;
            delete result.data.cardLogoPath;
            delete result.data.normalizedLogoPath;
            if (oldLogoImagePath) {
                try {
                    unlinkSync(oldLogoImagePath);
                }
                catch (err) {
                    console.log(`error in delete payment method image file, path: ${oldLogoImagePath}`);
                }
            }
            if (oldCardLogoImagePath) {
                try {
                    unlinkSync(oldCardLogoImagePath);
                }
                catch (err) {
                    console.log(`error in delete payment method image file, path: ${oldCardLogoImagePath}`);
                }
            }
            result.data.newLogoImagePath = logoPaths.logoPath;
            result.data.newCardLogoImagePath = logoPaths.cardLogoPath;
            res.json(result);
        }
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deletePaymentMethod(req, res) {
    try {
        const result = await paymentMethodsOperationsManagmentFunctions.deletePaymentMethod(req.data._id, req.params.paymentMethodId, req.query.language);
        handleResponse(result, res);
        const imagePath = result.data.logoPath;
        const cardImagePath = result.data.cardLogoPath || result.data.normalizedLogoPath;
        try {
            unlinkSync(imagePath);
        }
        catch (err) {
            console.log(`error in delete payment method image file, path: ${imagePath}`);
        }
        if (cardImagePath) {
            try {
                unlinkSync(cardImagePath);
            }
            catch (err) {
                console.log(`error in delete payment method image file, path: ${cardImagePath}`);
            }
        }
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

async function getPaymentMethodBindings(req, res) {
    try {
        const result = await paymentMethodsOperationsManagmentFunctions.getPaymentMethodBindings(req.data._id, req.params.paymentMethodId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deleteCountryPaymentMethodBinding(req, res) {
    try {
        const result = await paymentMethodsOperationsManagmentFunctions.unbindPaymentMethodFromCountry(req.data._id, req.params.paymentMethodId, req.params.countryId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deleteCityPaymentMethodBinding(req, res) {
    try {
        const result = await paymentMethodsOperationsManagmentFunctions.unbindPaymentMethodFromCity(req.data._id, req.params.paymentMethodId, req.params.cityId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function deleteRegionPaymentMethodBinding(req, res) {
    try {
        const result = await paymentMethodsOperationsManagmentFunctions.unbindPaymentMethodFromRegion(req.data._id, req.params.paymentMethodId, req.params.regionId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postCreatePaymentMethod,
    getAllPaymentMethodsInsideThePage,
    putPaymentMethodInfo,
    putPaymentMethodLogoImage,
    deletePaymentMethod,
    getPaymentMethodBindings,
    deleteCountryPaymentMethodBinding,
    deleteCityPaymentMethodBinding,
    deleteRegionPaymentMethodBinding,
}