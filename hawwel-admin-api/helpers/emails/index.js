const { join } = require("path");

const { readFileSync } = require("fs");

// Import EJS template processing function
const { compile } = require("ejs");

const { getPasswordForBussinessEmail } = require("../../repositories/global_passwords");

const { emailsUtils } = require("../../utils");

const { getDateTimeFormated } = require("../common");

const { logEmailCredentialsMissing } = require("../delivery_log");

const { CODE_EXPIRY_MINUTES } = require("../../constants/verification_code");

const EMAIL_FROM_NAME = process.env.EMAIL_FROM_NAME || "Hawwel";

async function sendVerificationCodeToUserEmail(email, code, language) {
    const result = await getPasswordForBussinessEmail(process.env.BUSSINESS_EMAIL, language);
    if (!result.error) {
        const templateContent = readFileSync(join(__dirname, "..", "..", "assets", "email_templates", "email_template.ejs"), "utf-8");
        const compiledTemplate = compile(templateContent);
        const htmlContentAfterCompilingEjsTemplateFile = compiledTemplate({ generatedCode: code, language, expiryMinutes: CODE_EXPIRY_MINUTES });
        const mailConfigurations = {
            from: `${EMAIL_FROM_NAME} <${process.env.BUSSINESS_EMAIL}>`,
            to: email,
            subject: language === "en" ? "Your Hawwel verification code" : "رمز التحقق - حوّل",
            html: htmlContentAfterCompilingEjsTemplateFile,
        };
        return new Promise((resolve, reject) => {
            emailsUtils.getTransporter(result.data).sendMail(mailConfigurations, function (error, info) {
                if (error) return reject(error);
                resolve({
                    msg: "Sending Confirmation Code Process Has Been Successfully !!",
                    error: false,
                    data: {},
                });
            });
        });
    }
    logEmailCredentialsMissing("sendVerificationCodeToUserEmail", process.env.BUSSINESS_EMAIL, result.msg);
    return result;
}

async function sendCongratulationsOnCreatingNewAccountEmail(email, language) {
    const result = await getPasswordForBussinessEmail(process.env.BUSSINESS_EMAIL);
    if (!result.error) {
        const templateContent = readFileSync(join(__dirname, "..", "..", "assets", "email_templates", "congratulations_creating_new_account.ejs"), "utf-8");
        const compiledTemplate = compile(templateContent);
        const htmlContentAfterCompilingEjsTemplateFile = compiledTemplate({ email, language });
        return new Promise((resolve, reject) => {
            emailsUtils.getTransporter(result.data).sendMail({
                from: `${EMAIL_FROM_NAME} <${process.env.BUSSINESS_EMAIL}>`,
                to: email,
                subject: language === "en" ? "Welcome to Hawwel" : "أهلاً بك في حوّل",
                html: htmlContentAfterCompilingEjsTemplateFile,
            }, function (error, info) {
                if (error) return reject(error);
                resolve({
                    msg: "Sending Congratulations Email To User Process Has Been Successfully !!",
                    error: false,
                    data: {},
                });
            });
        });
    }
    logEmailCredentialsMissing("sendCongratulationsOnCreatingNewAccountEmail", process.env.BUSSINESS_EMAIL, result.msg);
    return result;
}

async function sendChangePasswordEmail(info, language) {
    const result = await getPasswordForBussinessEmail(process.env.BUSSINESS_EMAIL);
    if (!result.error) {
        const templateContent = readFileSync(join(__dirname, "..", "..", "assets", "email_templates", "change_password.ejs"), "utf-8");
        const compiledTemplate = compile(templateContent);
        const htmlContentAfterCompilingEjsTemplateFile = compiledTemplate({ language, name: info.name, updatedAt: getDateTimeFormated(info.updatedAt) });
        return new Promise((resolve, reject) => {
            emailsUtils.getTransporter(result.data).sendMail({
                from: `${EMAIL_FROM_NAME} <${process.env.BUSSINESS_EMAIL}>`,
                to: info.email,
                subject: language === "en" ? "Your Hawwel password was changed" : "تم تغيير كلمة المرور - حوّل",
                html: htmlContentAfterCompilingEjsTemplateFile,
            }, function (error, info) {
                if (error) return reject(error);
                resolve({
                    msg: "Sending Change The User Password Email Process Has Been Successfully !!",
                    error: false,
                    data: {},
                });
            });
        });
    }
    logEmailCredentialsMissing("sendChangePasswordEmail", process.env.BUSSINESS_EMAIL, result.msg);
    return result;
}

module.exports = {
    sendVerificationCodeToUserEmail,
    sendCongratulationsOnCreatingNewAccountEmail,
    sendChangePasswordEmail
}