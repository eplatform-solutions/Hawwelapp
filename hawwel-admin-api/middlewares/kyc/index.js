const { KYC_STATUSES } = require("../../constants/kyc");

const { getResponseObject } = require("../../helpers/responses");

function validateStatus(status, res, next) {
    if (!KYC_STATUSES.includes(status)) {
        return res.json(getResponseObject("Sorry, Please Send Valid KYC Status ( any value in array: ['under-review', 'verified', 'rejected', 'remove-verified', 'expired', 'blocked'] ) !!", true, {}));
    }
    next();
}

module.exports = {
    validateStatus
}