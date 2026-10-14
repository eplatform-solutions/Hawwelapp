const { TRANSFER_STATUSES } = require("../../constants/transactions");

const { getResponseObject } = require("../../helpers/responses");
const multer = require("multer");
const { generateSafeFileName, ensureUploadDir } = require("../../utils/files");
const { UPLOAD_MAX_FILE_SIZE } = require("../../constants/files");

function validateStatus(status, res, next) {
    if (!TRANSFER_STATUSES.includes(status)) {
        return res.json(getResponseObject("Sorry, This Status Is Not Exist !!", true, {}));
    }
    next();
}

const transferProofStorage = multer.diskStorage({
    destination: (req, file, cb) => {
        const dir = "./assets/images/transfers";
        ensureUploadDir(dir);
        cb(null, dir);
    },
    filename: (req, file, cb) => {
        cb(null, generateSafeFileName(file.originalname));
    },
});

const uploadTransferProof = multer({
    storage: transferProofStorage,
    limits: {
        fileSize: UPLOAD_MAX_FILE_SIZE,
    },
    fileFilter: (req, file, cb) => {
        const allowedTypes = ["image/jpeg", "image/png", "image/webp"];
        if (!allowedTypes.includes(file.mimetype)) {
            req.uploadError = "Sorry, Invalid File Mimetype, Only JPEG, PNG, Webp Files Are Allowed !!";
            return cb(null, false);
        }
        req.allowedMimeTypes = allowedTypes;
        cb(null, true);
    },
});

function uploadTransferImageSingleFile(fieldName) {
    return function (req, res, next) {
        uploadTransferProof.single(fieldName)(req, res, function (err) {
            if (err instanceof multer.MulterError && err.code === "LIMIT_FILE_SIZE") {
                req.uploadError = "Sorry, File Size Must Not Exceed 5 MB !!";
                return next();
            }
            next(err);
        });
    };
}

const uploadTransferProofSingleFile = uploadTransferImageSingleFile("paymentProofImage");
const uploadReceivingPlaceSingleFile = uploadTransferImageSingleFile("receivingPlaceImage");

module.exports = {
    validateStatus,
    uploadTransferProofSingleFile,
    uploadReceivingPlaceSingleFile,
}