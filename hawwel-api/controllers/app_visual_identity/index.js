const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject } = responsesHelpers;
const { getSuitableTranslations } = translationHelpers;

const appVisualIdentityOperations = require("../../repositories/app_visual_identity");

async function getPublicAppVisualIdentity(req, res) {
    try {
        const result = await appVisualIdentityOperations.getPublicAppVisualIdentity(req.query.language);
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getPublicAppVisualIdentity,
};
