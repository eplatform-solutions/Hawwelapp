const { TWO_FACTOR_AUTH_METHODS, STATUSES } = require("../../constants/users");

const { getResponseObject } = require("../../helpers/responses");

function validate2FAMethods(methods, res, next) {
    for (let method of methods) {
        if (!TWO_FACTOR_AUTH_METHODS.includes(method)) {
            return res.json(getResponseObject(`Sorry, ${method} 2FA Method Is Not Exist !!`, true, {}));
        }
    }
    next();
}

function validateStatus(status, res, next) {
    if (!STATUSES.includes(status)) {
        return res.json(getResponseObject("Sorry, Please Send Valid User Status ( 'active' or 'blocked' ) !!", true, {}));
    }
    next();
}

module.exports = {
    validate2FAMethods,
    validateStatus
}