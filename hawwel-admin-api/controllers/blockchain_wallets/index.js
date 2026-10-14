// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for blockchain wallets management
const blockchainWalletsOperationsManagmentFunctions = require("../../repositories/blockchain_wallets");

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "symbol") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "network") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "address") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "amount") filtersObject[objectKey] = Number(filters[objectKey]);
        if (objectKey === "paid") filtersObject[objectKey] = Number(filters[objectKey]);
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "transferNumber") filtersObject[objectKey] = Number(filters[objectKey]);
        if (objectKey === "withdrawStatus") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllClientsWalletsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await blockchainWalletsOperationsManagmentFunctions.getAllClientsWalletsInsideThePage(req.data._id, Number(filters.pageNumber), Number(filters.pageSize), getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putWalletInfo(req, res) {
    try {
        const result = await blockchainWalletsOperationsManagmentFunctions.updateWalletInfo(req.data._id, req.params.walletId, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        console.log(err);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}), true, {});
    }
}

module.exports = {
    getAllClientsWalletsInsideThePage,
    putWalletInfo
}