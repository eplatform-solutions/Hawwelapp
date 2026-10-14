const tatumAPIMiddlewares = require("./tatum_api");

const { getResponseObject } = require("../../helpers/responses");

const web3 = require("web3");

const { SUPPORTED_NETWORKS } = require("../../constants/blockchain");

function validateAddress(address, network, res, nextFunc) {
    if (network !== "TRON") {
        if (!web3.utils.isAddress(address)) {
            res.status(400).json(getResponseObject("Please Send Valid Receiver Address !!", true, {}));
            return;
        }
    }
    nextFunc();
}

function validateTransactionHash(txHash, network, res, nextFunc) {
    if (!txHash || typeof txHash !== "string") {
        return res.status(400).json(
            getResponseObject("Please Send Valid Transaction Hash !!", true, {})
        );
    }
    let isValid = false;
    if (network !== "TRON") {
        isValid = /^0x([A-Fa-f0-9]{64})$/.test(txHash);
    }
    if (!isValid) {
        return res.status(400).json(
            getResponseObject("Invalid Transaction Hash Format !!", true, {})
        );
    }

    nextFunc();
}

function validateNetwork(network, res, nextFunc) {
    if (!SUPPORTED_NETWORKS.includes(network)) {
        res.status(400).json(getResponseObject("Please Send Valid Network Name !!", true, {}));
        return;
    }
    nextFunc();
}

module.exports = {
    tatumAPIMiddlewares,
    validateAddress,
    validateTransactionHash,
    validateNetwork
}