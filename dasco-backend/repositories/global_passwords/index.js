// Import Required Models

const { globalPasswordModel } = require("../../models/dashboard");

// require cryptoJs module for password encrypting

const { AES, enc } = require("crypto-js");

const { getSuitableTranslations } = require("../../helpers/translation");

async function getPasswordForBussinessEmail(email, language) {
    try {
        // Prefer the password from the environment so SECRET_KEY can be rotated without
        // breaking email; the copy stored in the database is encrypted with SECRET_KEY.
        if (process.env.BUSSINESS_EMAIL_PASSWORD && email === process.env.BUSSINESS_EMAIL) {
            return {
                msg: getSuitableTranslations("Get Password For Bussiness Email Process Has Been Successfully !!", language),
                error: false,
                data: process.env.BUSSINESS_EMAIL_PASSWORD,
            }
        }
        const user = await globalPasswordModel.findOne({ email });
        if (user) {
            return {
                msg: getSuitableTranslations("Get Password For Bussiness Email Process Has Been Successfully !!", language),
                error: false,
                data: AES.decrypt(user.password, process.env.SECRET_KEY).toString(enc.Utf8),
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, Email Incorrect !!", language),
            error: true,
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getPasswordForBussinessEmail,
}