const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const kycOPerationsManagmentFunctions = require("../../repositories/kyc");

const { unlinkSync } = require("fs");

function getUploadedKycPaths(req) {
    const firstFile = req.files?.kycFile1?.[0];
    const secondFile = req.files?.kycFile2?.[0];
    if (!firstFile || !secondFile) {
        return [];
    }
    return [
        `assets/images/kyc/${firstFile.filename}`,
        `assets/images/kyc/${secondFile.filename}`,
    ];
}

function cleanupUploadedKycPaths(paths) {
    for (const storedPath of paths) {
        try {
            unlinkSync(storedPath);
        }
        catch (err) {
            // ignore cleanup errors
        }
    }
}

async function postCreate(req, res) {
    const uploadedPaths = getUploadedKycPaths(req);
    try {
        const result = await kycOPerationsManagmentFunctions.createKYC(req.data._id, uploadedPaths, req.query.language);
        if (!result.error) {
            res.json(result);
        } else {
            cleanupUploadedKycPaths(uploadedPaths);
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
    }
    catch (err) {
        cleanupUploadedKycPaths(uploadedPaths);
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    postCreate,
};
