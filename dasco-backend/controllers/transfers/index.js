// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for transfers management
const transfersOperationsManagmentFunctions = require("../../repositories/transfers");

async function postByParameter(req, res) {
    try {
        const result = await transfersOperationsManagmentFunctions.transferByParameter(req.data._id, { symbol, amount, toCountry, city, area, paymentMethod, receiver } = req.body, req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            if (result?.code === "KYC_REQUIRED") {
                delete result.code;
                return res.status(403).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "_id") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "currencyName") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "symbol") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "fromDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "toDate") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllTransfersInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await transfersOperationsManagmentFunctions.getAllTransfersInsideThePage(req.data._id, Number(filters.pageNumber), Number(filters.pageSize), getFiltersObject(filters), req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getMainTransferPageData(req, res) {
    try {
        const result = await transfersOperationsManagmentFunctions.getMainTransferPageData(req.data._id, req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postByParameter,
    getAllTransfersInsideThePage,
    getMainTransferPageData
};
