const { getResponseObject } = require("../../helpers/responses");

const { getSuitableTranslations } = require("../../helpers/translation");

const { isValidLanguage } = require("../../validators/global/language");

const systemSettingsModel = require("../../models/dashboard/system_setting");

const { globalRateLimiter } = require("../../config/rate-limiters/global");

const { consumeOrRespond } = require("../../helpers/rate_limit");

function validateLanguage(language, res, nextFunc, errorMsg = "Sorry, Please Send Valid Language !!") {
    if (!isValidLanguage(language)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

async function validateFromMaintenanceMode(req, res, nextFunc) {
    try {
        const errorMsg = "Sorry, The System Is Currently Under Maintenance Mode !!";
        const systemSettings = await systemSettingsModel.findOne({});
        if (systemSettings?.isMaintenanceMode) {
            res.status(503).json(
                getResponseObject(
                    getSuitableTranslations(errorMsg, req.query?.language), true, {}
                )
            );
            return;
        }
    }
    catch (err) {
        console.error("Error checking maintenance mode:", err);
        res.status(500).json(
            getResponseObject(
                getSuitableTranslations("Internal Server Error !!", req.query?.language), true, {}
            )
        );
        return;
    }
    nextFunc();
}

const globalRateLimitMiddleware = async (req, res, next) => {
    const excludedRoutes = [
        "/deposits/external",
    ];
    if (excludedRoutes.includes(req.path)) {
        return next();
    }
    await consumeOrRespond(globalRateLimiter, req.ip, res, next);
};

module.exports = {
    validateLanguage,
    validateFromMaintenanceMode,
    globalRateLimitMiddleware
}