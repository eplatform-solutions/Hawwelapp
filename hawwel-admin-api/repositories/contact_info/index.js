// Import Required Models Object

const { adminModel, contactInfoModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { dashboardDB } = require("../../database/connections");

async function updateContactInfo(adminId, newContactInfoData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "technical_support_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (newContactInfoData?.mobilePhones.length > 2) {
                return {
                    msg: getSuitableTranslations("Sorry, Can't Adding Greater Than Two Mobile Phones !!", language),
                    error: true,
                    data: {},
                }
            }
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await contactInfoModel.updateOne({}, {
                $set: {
                    ...newContactInfoData?.mobilePhones && { mobilePhones: newContactInfoData.mobilePhones },
                    ...newContactInfoData?.email && { email: newContactInfoData.email },
                }
            }, { upsert: true, session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Updating Contact Info Data Process Has Been Successfully !!", language),
                error: false,
                data: {},
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
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

module.exports = {
    updateContactInfo,
}