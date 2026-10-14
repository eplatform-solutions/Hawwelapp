const { WITHDRAW_STATUES } = require("../../constants/transactions");

const { getResponseObject } = require("../../helpers/responses");

function validateWithdrawStatus(status, res, next) {
    if (!WITHDRAW_STATUES.includes(status)) {
        return res.json(getResponseObject("Sorry, This Withdraw Status Is Not Exist !!", true, {}));
    }
    next();
}

module.exports = {
    validateWithdrawStatus
}