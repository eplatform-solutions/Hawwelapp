// Import Required Models

const { adminModel, contactInfoModel, faqModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

async function getContent(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "technical_support_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const contactInfo = await contactInfoModel.findOne({}, { __v: false });
            const faqs = await faqModel.find({}, { __v: false }).sort({ createdAt: -1 }).limit(10);
            const faqsCount = await faqModel.countDocuments();
            return {
                msg: getSuitableTranslations("Get Technical Support Page Content Process Has Been Successfully !!", language),
                error: false,
                data: {
                    contactInfo,
                    faqs,
                    faqsCount,
                },
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
    getContent,
}