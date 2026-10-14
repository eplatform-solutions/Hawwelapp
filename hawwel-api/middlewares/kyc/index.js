const multer = require("multer");

const { getResponseObject } = require("../../helpers/responses");

const { generateSafeFileName, ensureUploadDir } = require("../../utils/files");

const { UPLOAD_MAX_FILE_SIZE } = require("../../constants/files");

const { unlinkSync } = require("fs");

let fileTypeFromFileFunc;

(async () => {
    const { fileTypeFromFile } = await import("file-type");
    fileTypeFromFileFunc = fileTypeFromFile;
})();

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const dir = "./assets/images/kyc";
        ensureUploadDir(dir);
        cb(null, dir);
    },
    filename: (req, file, cb) => {
        const uniqueName = generateSafeFileName(file.originalname);
        cb(null, uniqueName);
    },
});

const uploadKycFile = multer({
    storage,
    limits: {
        fileSize: UPLOAD_MAX_FILE_SIZE
    },
    fileFilter: (req, file, cb) => {
        const allowedTypes = [
            "image/jpeg",
            "image/png",
            "image/webp",
            "application/pdf"
        ];
        if (!allowedTypes.includes(file.mimetype)) {
            req.uploadError = "Sorry, Invalid File Mimetype, Only JPEG, PNG, Webp And PDF Files Are Allowed !!";
            return cb(null, false);
        }
        req.allowedMimeTypes = allowedTypes;
        cb(null, true);
    }
});

function uploadKycFileSingle(req, res, next) {
    uploadKycFile.single("kycFile")(req, res, function (err) {
        if (err instanceof multer.MulterError) {
            if (err.code === "LIMIT_FILE_SIZE") {
                req.uploadError = "Sorry, File Size Must Not Exceed 5 MB !!";
                return next();
            }
        }
        next(err);
    });
}

function uploadKycFilesPair(req, res, next) {
    uploadKycFile.fields([
        { name: "kycFile1", maxCount: 1 },
        { name: "kycFile2", maxCount: 1 },
    ])(req, res, function (err) {
        if (err instanceof multer.MulterError) {
            if (err.code === "LIMIT_FILE_SIZE") {
                req.uploadError = "Sorry, File Size Must Not Exceed 5 MB !!";
                return next();
            }
        }
        next(err);
    });
}

function validateKycFilesPair(req, res, next) {
    const uploadError = req.uploadError;
    if (uploadError) {
        return res.status(400).json(getResponseObject(uploadError, true, {}));
    }
    const firstFile = req.files?.kycFile1?.[0];
    const secondFile = req.files?.kycFile2?.[0];
    if (!firstFile || !secondFile) {
        return res.status(400).json(
            getResponseObject("Sorry, Two KYC image files are required. Please upload both images !!", true, {})
        );
    }
    next();
}

async function verifyKycFilesPair(req, res, next) {
    try {
        const files = [req.files?.kycFile1?.[0], req.files?.kycFile2?.[0]].filter(Boolean);
        if (files.length !== 2) {
            return res.status(400).json(
                getResponseObject("Sorry, Two KYC image files are required. Please upload both images !!", true, {})
            );
        }
        for (const file of files) {
            const fileType = await fileTypeFromFileFunc(file.path);
            if (!fileType || !req.allowedMimeTypes.includes(fileType.mime)) {
                for (const uploadedFile of files) {
                    try {
                        unlinkSync(uploadedFile.path);
                    }
                    catch (unlinkErr) {
                        // ignore cleanup errors
                    }
                }
                return res.status(400).json(
                    getResponseObject("Sorry, Invalid Real File Type !!", true, {})
                );
            }
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
    uploadKycFileSingle,
    uploadKycFilesPair,
    validateKycFilesPair,
    verifyKycFilesPair,
};
