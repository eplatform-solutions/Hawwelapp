const { isValidSubscriptionType, isValidContractAddressForTatumAPI } = require("../../../validators/tatum_api");

const { getResponseObject } = require("../../../helpers/responses");

const { SUPPORTED_NETWORKS_IN_TATUM } = require("../../../constants/blockchain");

function validateNetworkInTatum(network, res, nextFunc) {
    if (!SUPPORTED_NETWORKS_IN_TATUM.includes(network)) {
        res.status(400).json(getResponseObject("Please Send Valid Network Name !!", true, {}));
        return;
    }
    nextFunc();
}

function validateSubscriptionType(subscriptionType, res, nextFunc) {
    if (!isValidSubscriptionType(subscriptionType)) {
        res.status(200).json(getResponseObject("Please Send Valid Subscription Type For Tatum !!", true, {}));
        return;
    }
    nextFunc();
}

function validateContractAddressForTatumAPI(chain, contractAddress, res, nextFunc) {
    if (!isValidContractAddressForTatumAPI(chain, contractAddress)) {
        res.status(200).json(getResponseObject("Please Send Valid Contract Address For Tatum !!", true, {}));
        return;
    }
    nextFunc();
}

module.exports = {
    validateNetworkInTatum,
    validateSubscriptionType,
    validateContractAddressForTatumAPI
}