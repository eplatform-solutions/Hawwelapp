const multer = require("multer");

const { generateSafeFileName, ensureUploadDir } = require("../../utils/files");

const { UPLOAD_MAX_FILE_SIZE } = require("../../constants/files");

const storage = multer.diskStorage({
    destination: (_req, _file, cb) => {
        const dir = "./assets/images/app_identity";
        ensureUploadDir(dir);
        cb(null, dir);
    },
    filename: (_req, file, cb) => {
        const uniqueName = generateSafeFileName(file.originalname);
        cb(null, uniqueName);
    },
});

const uploadAppIdentityFile = multer({
    storage,
    limits: {
        fileSize: UPLOAD_MAX_FILE_SIZE
    },
    fileFilter: (req, file, cb) => {
        const allowedTypes = [
            "image/jpeg",
            "image/png",
            "image/webp",
        ];
        if (!allowedTypes.includes(file.mimetype)) {
            req.uploadError = "Sorry, Invalid File Mimetype, Only JPEG, PNG, Webp Files Are Allowed !!";
            return cb(null, false);
        }
        req.allowedMimeTypes = allowedTypes;
        cb(null, true);
    }
});

function uploadAppIdentitySingleFile(fieldName) {
    return function uploadSingle(req, res, next) {
        uploadAppIdentityFile.single(fieldName)(req, res, function (err) {
            if (err instanceof multer.MulterError && err.code === "LIMIT_FILE_SIZE") {
                req.uploadError = "Sorry, File Size Must Not Exceed 5 MB !!";
                return next();
            }
            next(err);
        });
    }
}

module.exports = {
    uploadAppIdentitySingleFile
};
