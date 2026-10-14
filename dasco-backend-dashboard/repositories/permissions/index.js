// Import Required Models Object

const { adminModel, permissionModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

async function getPermission(adminId, permissionId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const permission = await permissionModel.findById(permissionId);
            if (permission) {
                delete permission._doc.__v;
                return {
                    msg: getSuitableTranslations("Get Permission Data Process Has Been Successfully !!", language),
                    error: false,
                    data: permission,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Permission Is Not Exist !!", language),
                error: true,
                data: {}
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getAllPermissions(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const permissions = await permissionModel.find({}, { codeName: 1, name: 1, appLabel: 1 });
            if (permissions.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Permissions Data Process Has Been Successfully !!", language),
                    error: false,
                    data: permissions,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, Can't Find And Permissions !!", language),
                error: true,
                data: {}
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getPermission,
    getAllPermissions,
}