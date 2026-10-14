// Import Required Models

const { userModel } = require("../../models/client");

const { contactInfoModel, faqModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

async function getContent(userId, language) {
    try {
        const user = await userModel.findById(userId);
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const faqs = await faqModel.find({}, { _id: false, __v: false }).sort({ createdAt: -1 }).limit(10);
            const faqsCount = await faqModel.countDocuments();
            const contactInfo = await contactInfoModel.findOne({}, { _id: false, __v: false });
            return {
                msg: getSuitableTranslations("Get Technical Support Page Content Process Has Been Successfully !!", language),
                error: false,
                data: {
                    faqs,
                    faqsCount,
                    contactInfo,
                },
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
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