const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const kycOPerationsManagmentFunctions = require("../../repositories/kyc");

const { unlinkSync } = require("fs");

const { createReadStream } = require("fs");

const { resolveKycImagePaths, resolveClientKycAbsolutePath } = require("../../helpers/kyc_files");

// KYC files live under the client API's assets root, not this process's
// working directory - a relative unlink silently failed on every reject /
// unapprove and only ever targeted the first of the two documents.
function deleteStoredKycFiles(storedPaths) {
    for (const storedPath of storedPaths) {
        const absolutePath = resolveClientKycAbsolutePath(storedPath);
        if (!absolutePath) continue;
        try {
            unlinkSync(absolutePath);
        }
        catch (err) {
            console.log(`error in delete kyc file, path: ${absolutePath}`);
        }
    }
}

async function putApproveKYC(req, res) {
    try {
        const result = await kycOPerationsManagmentFunctions.approveKYC(req.data._id, req.params.kycId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putRejectKYC(req, res) {
    try {
        const result = await kycOPerationsManagmentFunctions.rejectKYC(req.data._id, req.params.kycId, req.body.rejectionReason, req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        const storedPaths = resolveKycImagePaths(result.data);
        delete result.data.filePath;
        delete result.data.documentImages;
        res.json(result);
        deleteStoredKycFiles(storedPaths);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putRemoveKycVerifying(req, res) {
    try {
        const result = await kycOPerationsManagmentFunctions.removeKycVerifying(req.data._id, req.params.kycId, req.body.removeVerifyingReason, req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        const storedPaths = resolveKycImagePaths(result.data);
        delete result.data.filePath;
        delete result.data.documentImages;
        res.json(result);
        deleteStoredKycFiles(storedPaths);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putBlockingKYC(req, res) {
    try {
        const result = await kycOPerationsManagmentFunctions.blockingKYC(req.data._id, req.params.kycId, req.body.blockingReason, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putCancelBlockingKYC(req, res) {
    try {
        const result = await kycOPerationsManagmentFunctions.cancelBlockingKYC(req.data._id, req.params.kycId, req.query.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "_id") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "fromDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "toDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "country") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllKYCsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await kycOPerationsManagmentFunctions.getAllKYCsInsideThePage(req.data._id, Number(filters.pageNumber), Number(filters.pageSize), getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function getKycFile(req, res) {
    try {
        const fileIndex = Number(req.params.fileIndex);
        if (!Number.isInteger(fileIndex) || fileIndex < 0 || fileIndex > 1) {
            return res.status(400).json(getResponseObject(getSuitableTranslations("Sorry, Invalid KYC File Index !!", req.query.language), true, {}));
        }
        const result = await kycOPerationsManagmentFunctions.getKycFileForAdmin(req.data._id, req.params.kycId, fileIndex, req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            if (result?.code === "ADMIN_NOT_FOUND") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.status(404).json(result);
        }
        const { absolutePath, contentType, fileName } = result.data;
        res.setHeader("Content-Type", contentType);
        res.setHeader("Content-Disposition", `inline; filename="${fileName}"`);
        createReadStream(absolutePath).pipe(res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getAllKYCsInsideThePage,
    getKycFile,
    putApproveKYC,
    putRejectKYC,
    putRemoveKycVerifying,
    putBlockingKYC,
    putCancelBlockingKYC,
}