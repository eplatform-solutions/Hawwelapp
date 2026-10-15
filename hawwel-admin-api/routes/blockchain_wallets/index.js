const blockchainWalletsRouter = require("express").Router();

const blockchainWalletsController = require("../../controllers/blockchain_wallets");

const { getResponseObject } = require("../../helpers/responses");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    numbersMiddlewares,
    currenciesMiddlewares,
    blockchainMiddlewares,
    transfersMiddlewares,
    withdrawalsMiddlewares
} = require("../../middlewares");

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat
} = numbersMiddlewares;

const {
    validateJWT,
} = authMiddlewares;

const {
    validateCryptoCurrencySymbol,
} = currenciesMiddlewares;

const {
    validateAddress,
    validateNetwork,
    validatePrivateKey
} = blockchainMiddlewares;

const {
    validateStatus,
} = transfersMiddlewares;

const {
    validateWithdrawStatus,
} = withdrawalsMiddlewares;

blockchainWalletsRouter.get("/clients/all-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Symbol", fieldValue: queryData?.symbol, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Network", fieldValue: queryData?.network, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Address", fieldValue: queryData?.address, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Amount", fieldValue: queryData?.amount, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "Paid", fieldValue: queryData?.paid, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "Status", fieldValue: queryData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Transfer Number", fieldValue: queryData?.transferNumber, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "Withdraw Status", fieldValue: queryData?.withdrawStatus, dataTypes: ["string"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const queryData = req.query;
        validateNumbersIsGreaterThanZero([queryData.pageNumber, queryData.pageSize], res, next, ["Sorry, Please Send Valid Page Number ( Number Must Be Greater Than Zero ) !!", "Sorry, Please Send Valid Page Size ( Number Must Be Greater Than Zero ) !!"]);
    },
    (req, res, next) => {
        const queryData = req.query;
        validateNumbersIsNotFloat([queryData.pageNumber, queryData.pageSize], res, next, ["Sorry, Please Send Valid Page Number ( Number Must Be Not Float ) !!", "Sorry, Please Send Valid Page Size ( Number Must Be Not Float ) !!"]);
    },
    (req, res, next) => {
        const symbol = req.query?.symbol;
        if (symbol) {
            return validateCryptoCurrencySymbol(symbol, res, next);
        }
        next();
    },
    (req, res, next) => {
        const network = req.query?.network;
        if (network) {
            return validateNetwork(network, res, next);
        }
        next();
    },
    (req, res, next) => {
        const queryData = req.query;
        if (queryData?.address) {
            return validateAddress(queryData?.address, queryData?.network, res, next);
        }
        next();
    },
    (req, res, next) => {
        const amount = req.query?.amount;
        if (amount) {
            return validateNumbersIsGreaterThanZero([amount], res, next, ["Sorry, Please Send Valid Amount ( Number Must Be Greater Than Zero ) !!"]);
        }
        next();
    },
    (req, res, next) => {
        const paid = req.query?.paid;
        if (paid) {
            if (Number(paid) < 0) {
                return res.status(400).json(getResponseObject("Sorry, Please Send Valid Paid Value ( Number Must Be Greater Than Or Equal Zero ) !!", true, {}));
            }
        }
        next();
    },
    (req, res, next) => {
        const status = req.query?.status;
        if (status) {
            return validateStatus(status, res, next);
        }
        next();
    },
    (req, res, next) => {
        const transferNumber = req.query?.transferNumber;
        if (transferNumber) {
            return validateNumbersIsGreaterThanZero([transferNumber], res, next, ["Sorry, Please Send Valid Transfer Number ( Number Must Be Greater Than Zero ) !!"]);
        }
        next();
    },
    (req, res, next) => {
        const transferNumber = req.query?.transferNumber;
        if (transferNumber) {
            return validateNumbersIsNotFloat([transferNumber], res, next, ["Sorry, Please Send Valid Transfer Number ( Number Must Be Not Float ) !!"]);
        }
        next();
    },
    (req, res, next) => {
        const withdrawStatus = req.query?.withdrawStatus;
        if (withdrawStatus) {
            return validateWithdrawStatus(withdrawStatus, res, next);
        }
        next();
    },
    blockchainWalletsController.getAllClientsWalletsInsideThePage
);

blockchainWalletsRouter.put("/update/:walletId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Wallet Id", fieldValue: req.params.walletId, dataTypes: ["ObjectId"], isRequiredValue: true },
            { fieldName: "Address", fieldValue: bodyData?.address, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Address", fieldValue: bodyData?.privateKey, dataTypes: ["string"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const bodyData = req.body;
        if (bodyData?.address) {
            return validateAddress(bodyData.address, undefined, res, next);
        }
        else if (bodyData?.privateKey) {
            return validatePrivateKey(bodyData.privateKey, undefined, res, next);
        }
        next();
    },
    blockchainWalletsController.putWalletInfo
);

blockchainWalletsRouter.post("/create-system-wallets",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Type", fieldValue: bodyData?.type, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Address", fieldValue: bodyData?.address, dataTypes: ["string"], isRequiredValue: bodyData?.type === "central" },
            { fieldName: "Private Key", fieldValue: bodyData?.privateKey, dataTypes: ["string"], isRequiredValue: bodyData?.type === "network-fee-funding" },
        ], res, next);
    },
    (req, res, next) => {
        const bodyData = req.body;
        if (bodyData.type === "central") {
            return validateAddress(bodyData.address, undefined, res, next);
        }
        if (bodyData.type === "network-fee-funding") {
            return validatePrivateKey(bodyData.privateKey, undefined, res, next);
        }
        res.status(400).json(getResponseObject("Sorry, Please Send Valid Wallet Type ( central Or network-fee-funding ) !!", true, {}));
    },
    blockchainWalletsController.postCreateSystemWallets
);

module.exports = blockchainWalletsRouter;