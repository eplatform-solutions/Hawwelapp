const {
    TATUM_SUBSCRIPTION_TYPES,
    CONTRACTS
} = require("../../constants/blockchain");

const { ADDRESSES } = CONTRACTS;

const { CONTRACT_ADDRESSES_ON_POLYGON, CONTRACT_ADDRESSES_ON_BSC } = ADDRESSES;

function isValidSubscriptionType(subscription) {
    return TATUM_SUBSCRIPTION_TYPES.includes(subscription);
}

function isValidContractAddressForTatumAPI(chain, contractAddress) {
    switch (chain) {
        case "polygon-mainnet": {
            return CONTRACT_ADDRESSES_ON_POLYGON.includes(contractAddress.toLowerCase());
        }
        case "bsc-mainnet": {
            return CONTRACT_ADDRESSES_ON_BSC.includes(contractAddress.toLowerCase());
        }
        default: return false;
    }
}

module.exports = {
    isValidSubscriptionType,
    isValidContractAddressForTatumAPI
}