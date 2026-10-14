const { getResponseObject } = require("../../helpers/responses");

const { isValidIpAddress } = require("../../validators/network/ip");

function validateIpAddress(ipAddress, res, nextFunc, errorMsg = "Sorry, Please Send Valid IP Address !!") {
    if (!isValidIpAddress(ipAddress)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

module.exports = {
    validateIpAddress
};