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

function validateNetwork(network, res, nextFunc) {
    if (!SUPPORTED_NETWORKS.includes(network)) {
        res.status(400).json(getResponseObject("Please Send Valid Network Name !!", true, {}));
        return;
    }
    nextFunc();
}

function validatePrivateKey(privateKey, network, res, nextFunc) {
    if (network !== "TRON") {
        const key = privateKey.startsWith("0x") ? privateKey : "0x" + privateKey;
        try {
            const account = web3.eth.accounts.privateKeyToAccount(key);
            if (!!!account.address) {
                res.status(400).json(getResponseObject("Please Send Valid Private Key !!", true, {}));
                return;
            }
        }
        catch (err) {
            res.status(400).json(getResponseObject("Please Send Valid Private Key !!", true, {}));
            return;
        }
    }
    nextFunc();
}

module.exports = {
    tatumAPIMiddlewares,
    validateAddress,
    validateNetwork,
    validatePrivateKey
}