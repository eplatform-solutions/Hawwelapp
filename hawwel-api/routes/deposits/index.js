const depositsRouter = require("express").Router();

const depositsController = require("../../controllers/deposits");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    webhooksMiddlewares,
    blockchainMiddlewares,
} = require("../../middlewares");

const {
    validateTatumIpMiddleware,
    verifyTatumWebhookSignature
} = webhooksMiddlewares;

const {
    validateAddress,
    validateTransactionHash,
    tatumAPIMiddlewares,
} = blockchainMiddlewares;

const {
    validateNetworkInTatum,
    validateSubscriptionType,
    validateContractAddressForTatumAPI
} = tatumAPIMiddlewares;

depositsRouter.post("/external",
    validateTatumIpMiddleware,
    verifyTatumWebhookSignature,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Receiver Address", fieldValue: bodyData?.address, dataTypes: ["string"], isRequiredValue: true, isReturnStatusCode: true, status: 200 },
            { fieldName: "Transaction Hash", fieldValue: bodyData?.txId, dataTypes: ["string"], isRequiredValue: true, isReturnStatusCode: true, status: 200 },
            { fieldName: "Network Name", fieldValue: bodyData?.chain, dataTypes: ["string"], isRequiredValue: true, isReturnStatusCode: true, status: 200 },
            { fieldName: "Subscription Type", fieldValue: bodyData?.subscriptionType, dataTypes: ["string"], isRequiredValue: true, isReturnStatusCode: true, status: 200 },
            { fieldName: "Amount", fieldValue: Number(bodyData?.amount), dataTypes: ["number"], isRequiredValue: true, isReturnStatusCode: true, status: 200 },
            { fieldName: "Contract Address", fieldValue: bodyData?.contractAddress, dataTypes: ["string"], isRequiredValue: bodyData?.subscriptionType === "INCOMING_FUNGIBLE_TX", isReturnStatusCode: true, status: 200 },
        ], res, next);
    },
    (req, res, next) => {
        const bodyData = req.body;
        validateAddress(bodyData.address, bodyData.chain, res, next);
    },
    (req, res, next) => {
        const bodyData = req.body;
        validateTransactionHash(bodyData.txId, bodyData.chain, res, next);
    },
    (req, res, next) => validateNetworkInTatum(req.body.chain, res, next),
    (req, res, next) => validateSubscriptionType(req.body.subscriptionType, res, next),
    (req, res, next) => {
        const bodyData = req.body;
        validateContractAddressForTatumAPI(bodyData.chain, bodyData.contractAddress, res, next);
    },
    depositsController.postExternalDeposit
);

module.exports = depositsRouter;