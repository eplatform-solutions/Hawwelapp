const { getResponseObject } = require("../../helpers/responses");

const { unlinkSync } = require("fs");

let fileTypeFromFileFunc;

(async () => {
    const { fileTypeFromFile } = await import("file-type");
    fileTypeFromFileFunc = fileTypeFromFile;
})();

function validateIsExistErrorInFiles(req, res, next) {
    const uploadError = req.uploadError;
    if (uploadError) {
        res.status(400).json(getResponseObject(uploadError, true, {}));
        return;
    }
    if (!req.file) {
        return res.status(400).json(
            getResponseObject("Sorry, No Files Uploaded, Please Upload The Files !!", true, {})
        );
    }
    next();
}

async function verifyRealFileType(req, res, next) {
    try {
        if (!req.file) {
            return res.status(400).json(
                getResponseObject("Sorry, File is required !!", true, {})
            );
        }
        const fileType = await fileTypeFromFileFunc(req.file.path);
        if (!fileType || !req.allowedMimeTypes.includes(fileType.mime)) {
            unlinkSync(req.file.path);
            return res.status(400).json(
                getResponseObject("Sorry, Invalid Real File Type !!", true, {})
            );
        }
        next();
    }
    catch (err) {
        return res.status(500).json(
            getResponseObject("Internal Server Error When Verify Real File Type !!", true, {})
        );
    }
}

module.exports = {
    validateIsExistErrorInFiles,
    verifyRealFileType
}