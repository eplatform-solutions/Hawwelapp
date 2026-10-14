const { responsesHelpers, translationHelpers, processingHelpers } = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const { imagesHelpers } = processingHelpers;

const { handleResizeImagesAndConvertFormatToWebp } = imagesHelpers;

const usersOPerationsManagmentFunctions = require("../../repositories/users");

const { unlinkSync } = require("fs");

const { generateSafeFileName, ensureUploadDir } = require("../../utils/files");

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        const v = filters[objectKey];
        if (v === undefined || v === null || v === "") {
            continue;
        }
        if (objectKey === "_id" || objectKey === "email" || objectKey === "mobilePhone") {
            filtersObject[objectKey] = v;
        }
    }
    return filtersObject;
}

async function getUserInfo(req, res) {
    try {
        const result = await usersOPerationsManagmentFunctions.getUserInfo({ _id: req.data._id }, req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUserInfo(req, res) {
    try {
        const { email, mobilePhone, emailCode, mobilePhoneCode, sessionForEmail, sessionForMobilePhone } = req.body;
        const result = await usersOPerationsManagmentFunctions.updateUserInfo(req.data._id,
            {
                user: getFiltersObject({ email, mobilePhone }),
                codes: {
                    forEmail: {
                        code: emailCode,
                        session: sessionForEmail
                    },
                    forMobilePhone: {
                        code: mobilePhoneCode,
                        session: sessionForMobilePhone
                    }
                }
            },
            req.query.language
        );
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putProfileImage(req, res) {
    try {
        ensureUploadDir("assets/images/users");
        const uniqueName = generateSafeFileName(req.file.originalname);
        const outputImageFilePath = `assets/images/users/${uniqueName}`;
        await handleResizeImagesAndConvertFormatToWebp([req.file.buffer], [outputImageFilePath]);
        const result = await usersOPerationsManagmentFunctions.changeProfileImage(req.data._id, outputImageFilePath, req.query.language);
        if (!result.error) {
            const oldUserImagePath = result.data.deletedProfileImagePath;
            if (oldUserImagePath) {
                unlinkSync(oldUserImagePath);
            }
            res.json({
                ...result,
                data: {
                    newImagePath: outputImageFilePath,
                }
            });
        } else {
            unlinkSync(outputImageFilePath);
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putChangePassword(req, res) {
    try {
        const { password, newPassword } = req.body;
        const result = await usersOPerationsManagmentFunctions.changePassword(req.data._id, password, newPassword);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!"), true, {}));
    }
}

async function putChange2FAStatus(req, res) {
    try {
        const { enabled, methods } = req.body;
        const result = await usersOPerationsManagmentFunctions.change2FAStatus(req.data._id, enabled, methods, req.query.language);
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!"), true, {}));
    }
}

async function postAccountDeletionRequest(req, res) {
    try {
        const note = req.body?.note;
        const result = await usersOPerationsManagmentFunctions.createAccountDeletionRequest(
            req.data._id,
            note,
            req.query.language
        );
        if (result.error) {
            if (result?.code === "PERMISSION_DENIED") {
                delete result.code;
                return res.status(401).json(result);
            }
            return res.json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

module.exports = {
    getUserInfo,
    putUserInfo,
    putProfileImage,
    putChangePassword,
    putChange2FAStatus,
    postAccountDeletionRequest,
}