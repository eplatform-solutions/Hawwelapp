// Import some required functions
const {
    responsesHelpers,
    translationHelpers,
} = require("../../helpers");

const { getResponseObject, handleResponse } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

// Import functions for transfers management
const transfersOperationsManagmentFunctions = require("../../repositories/transfers");
const { unlinkSync } = require("fs");

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "_id") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "status") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "today") {
            if (filters[objectKey] === "true") filtersObject[objectKey] = true;
            else if (filters[objectKey] === "false") filtersObject[objectKey] = false;
        }
        if (objectKey === "fromDate") filtersObject[objectKey] = filters[objectKey];
        if (objectKey === "toDate") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function getAllTransfersInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await transfersOperationsManagmentFunctions.getAllTransfersInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function postUpdateTransferStatus(req, res) {
    try {
        const result = await transfersOperationsManagmentFunctions.updateTransferStatus(
            req.data._id,
            req.params.transferId,
            req.body.status,
            req.body.statusChangeNote,
            req.query.language
        );
        handleResponse(result, res);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function handleTransferImageUpload(req, res, imageKind) {
    const outputImageFilePath = `assets/images/transfers/${req.file.filename}`;
    try {
        const result = await transfersOperationsManagmentFunctions.updateTransferImage(
            req.data._id,
            req.params.transferId,
            String(req.body?.paymentProofNote || "").trim(),
            outputImageFilePath,
            imageKind,
            req.query.language
        );
        if (result.error) {
            try {
                unlinkSync(outputImageFilePath);
            } catch (_) {
                // ignore cleanup failures
            }
            return handleResponse(result, res);
        }

        const oldImagePath = result.data?.oldImagePath;
        if (oldImagePath) {
            try {
                unlinkSync(oldImagePath);
            } catch (_) {
                // ignore cleanup failures
            }
        }
        delete result.data.oldImagePath;
        handleResponse(result, res);
    }
    catch (err) {
        try {
            unlinkSync(outputImageFilePath);
        } catch (_) {
            // ignore cleanup failures
        }
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

function putTransferPaymentProof(req, res) {
    return handleTransferImageUpload(req, res, "payment-proof");
}

function putTransferReceivingPlace(req, res) {
    return handleTransferImageUpload(req, res, "receiving-place");
}

module.exports = {
    getAllTransfersInsideThePage,
    postUpdateTransferStatus,
    putTransferPaymentProof,
    putTransferReceivingPlace,
}