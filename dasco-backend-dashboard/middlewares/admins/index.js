const { STATUSES } = require("../../constants/admins");

const { getResponseObject } = require("../../helpers/responses");

function validateStatus(status, res, next) {
    if (!STATUSES.includes(status)) {
        return res.json(getResponseObject("Sorry, Please Send Valid Admin Status ( 'active' or 'suspended' or 'blocked' ) !!", true, {}));
    }
    next();
}

module.exports = {
    validateStatus
}