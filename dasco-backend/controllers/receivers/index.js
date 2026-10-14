const { responsesHelpers, translationHelpers } = require("../../helpers");

const { getResponseObject } = responsesHelpers;

const { getSuitableTranslations } = translationHelpers;

const receiversOPerationsManagmentFunctions = require("../../repositories/receivers");

function getFiltersObject(filters) {
    let filtersObject = {};
    for (let objectKey in filters) {
        if (objectKey === "fullName") filtersObject[objectKey] = { $regex: new RegExp(`^${filters[objectKey]}`, 'i') };
    }
    return filtersObject;
}

async function postAddReveiver(req, res) {
    try {
        const { fullName, mobilePhone } = req.body;
        const result = await receiversOPerationsManagmentFunctions.addReceiver(req.data._id, fullName, mobilePhone, req.query.language);
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

async function getAllReceivers(req, res) {
    try {
        const filters = req.query;
        const result = await receiversOPerationsManagmentFunctions.getAllReceivers(req.data._id, getFiltersObject(filters), filters.language);
        if (result.error) {
            delete result.code;
            return res.status(401).json(result);
        }
        res.json(result);
    }
    catch (err) {
        res.status(500).json(getResponseObject(getSuitableTranslations("Internal Server Error !!", req.query.language), true, {}));
    }
}

async function putUpdateReceiver(req, res) {
    try {
        const result = await receiversOPerationsManagmentFunctions.updateReceiverInfo(req.data._id, req.params.receiverId, req.body, req.query.language);
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

async function deleteReceiver(req, res) {
    try {
        const result = await receiversOPerationsManagmentFunctions.deleteReceiver(req.data._id, req.params.receiverId, req.body, req.query.language);
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
    postAddReveiver,
    getAllReceivers,
    putUpdateReceiver,
    deleteReceiver
}