const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const notificationsOPerationsManagmentFunctions = require("../../repositories/notifications");

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "isRead") filtersObject[objectKey] = filters[objectKey];
    }
    return filtersObject;
}

async function postRegisterToken(req, res) {
    try {
        const result = await notificationsOPerationsManagmentFunctions.registerToken(req.data._id, req.body.token, req.query.language, null, req.body.platform);
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

async function getAllNotificationsInsideThePage(req, res) {
    try {
        const filters = req.query;
        const result = await notificationsOPerationsManagmentFunctions.getAllNotificationsInsideThePage(req.data._id, filters.pageNumber, filters.pageSize, getFiltersObject(filters), filters.language);
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

async function putMarkAllRead(req, res) {
    try {
        const result = await notificationsOPerationsManagmentFunctions.markAllRead(req.data._id, req.query.language);
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
    postRegisterToken,
    putMarkAllRead,
    getAllNotificationsInsideThePage
}