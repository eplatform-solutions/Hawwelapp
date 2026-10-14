const { getResponseObject } = require("../../helpers/responses");

const { isValidLanguage } = require("../../validators/global/language");

const { globalRateLimiter } = require("../../config/rate-limiters/global");

const { consumeOrRespond } = require("../../helpers/rate_limit");

function validateLanguage(language, res, nextFunc, errorMsg = "Sorry, Please Send Valid Language !!") {
    if (!isValidLanguage(language)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

const globalRateLimitMiddleware = async (req, res, next) => {
    await consumeOrRespond(globalRateLimiter, req.ip, res, next);
};

module.exports = {
    validateLanguage,
    globalRateLimitMiddleware
}
