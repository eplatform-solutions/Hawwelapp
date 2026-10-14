// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for quick control management
const quickControlOperationsManagmentFunctions = require("../../repositories/quick_control");

async function getSystemOverview(req, res) {
    try {
        const result = await quickControlOperationsManagmentFunctions.getSystemOverview(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        console.error(`[quick-control] getSystemOverview failed: ${err?.message || err}`);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getWalletBalances(req, res) {
    try {
        const result = await quickControlOperationsManagmentFunctions.getWalletBalances(req.data._id, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        console.error(`[quick-control] getWalletBalances failed: ${err?.message || err}`);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUpdateSystemSettings(req, res) {
    try {
        const result = await quickControlOperationsManagmentFunctions.updateSystemSettings(req.data._id, req.body, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUpdateAppLogo(req, res) {
    try {
        const imagePath = req.file ? `assets/images/app_identity/${req.file.filename}` : "";
        const result = await quickControlOperationsManagmentFunctions.updateAppVisualIdentityImage(
            req.data._id,
            imagePath,
            "logo",
            req.query.language
        );
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUpdateAppBackgroundImage(req, res) {
    try {
        const imagePath = req.file ? `assets/images/app_identity/${req.file.filename}` : "";
        const result = await quickControlOperationsManagmentFunctions.updateAppVisualIdentityImage(
            req.data._id,
            imagePath,
            "background",
            req.query.language
        );
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getSystemOverview,
    getWalletBalances,
    putUpdateSystemSettings,
    putUpdateAppLogo,
    putUpdateAppBackgroundImage,
}