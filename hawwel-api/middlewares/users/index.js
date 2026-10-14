const { TWO_FACTOR_AUTH_METHODS } = require("../../constants/users");

const { getResponseObject } = require("../../helpers/responses");

const multer = require("multer");

const { UPLOAD_MAX_FILE_SIZE } = require("../../constants/files");

function validate2FAMethods(methods, res, next) {
    for (let method of methods) {
        if (!TWO_FACTOR_AUTH_METHODS.includes(method)) {
            return res.json(getResponseObject(`Sorry, ${method} 2FA Method Is Not Exist !!`, true, {}));
        }
    }
    next();
}

const uploadProfileImageFile = multer({
    storage: multer.memoryStorage(),
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
        req.storageType = "memory";
        cb(null, true);
    }
});

function uploadUserProfileImageFileSingle(req, res, next) {
    uploadProfileImageFile.single("profileImage")(req, res, function (err) {
        if (err instanceof multer.MulterError) {
            if (err.code === "LIMIT_FILE_SIZE") {
                req.uploadError = "Sorry, File Size Must Not Exceed 5 MB !!";
                return next();
            }
        }
        next(err);
    });
}

module.exports = {
    validate2FAMethods,
    uploadUserProfileImageFileSingle,
}