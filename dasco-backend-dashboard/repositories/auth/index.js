// Import Admin Model Object

const { adminModel, employeeModel } = require("../../models/dashboard");

// require bcryptjs module for password encrypting

const { compare } = require("bcryptjs");

// Define Create New User Function

const { getSuitableTranslations } = require("../../helpers/translation");

const { checkOrCreateVerificationCode } = require("../verification_codes");

const { dashboardDB } = require("../../database/connections");

const { loginLogModel } = require("../../models/dashboard");

const { sign } = require("jsonwebtoken");

const { ACCESS_TOKEN_EXPIRE } = require("../../constants/tokens");

const { isValidIpAddress } = require("../../validators/network/ip");

/** يحوّل localhost / IPv6-mapped إلى IPv4 يقبله مخطط login_log */
function normalizeLoginLogIp(ipAddress) {
    if (!ipAddress) return "192.168.1.1";
    if (ipAddress === "::1" || ipAddress === "127.0.0.1") return "192.168.1.1";
    const mapped = /^::ffff:(\d{1,3}(?:\.\d{1,3}){3})$/i.exec(String(ipAddress).trim());
    if (mapped) return mapped[1];
    if (isValidIpAddress(ipAddress)) return ipAddress;
    return "192.168.1.1";
}

async function login(email, mobilePhone, password, language, ipAddress = null, dbSession = null) {
    let internalSession = false;
    try {
        const user = await adminModel.findOne(email ? { email } : { mobilePhone });
        if (user) {
            if (await compare(password, user.password)) {
                if (process.env.SKIP_LOGIN_OTP === "true") {
                    const ip = normalizeLoginLogIp(ipAddress);
                    await new loginLogModel({ user: user._id, ipAddress: ip }).save();
                    return {
                        msg: getSuitableTranslations("Logging In Has Been Completed Successfully !!", language),
                        error: false,
                        data: {
                            token: sign({ _id: user._id }, process.env.JWT_SECRET_KEY, {
                                expiresIn: ACCESS_TOKEN_EXPIRE,
                            }),
                        },
                    };
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                const checkOrCreateVerificationCodeResult = await checkOrCreateVerificationCode(email, mobilePhone, "login", language, dbSession);
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                if (!checkOrCreateVerificationCodeResult.error) {
                    checkOrCreateVerificationCodeResult.data.twoFA = user.twoFA;
                    return {
                        msg: getSuitableTranslations("Sorry, Can't Login Now, Beacause You Activate 2FA !!", language),
                        error: true,
                        data: checkOrCreateVerificationCodeResult.data,
                        status: 401,
                    }
                }
                return checkOrCreateVerificationCodeResult;
            }
            return {
                msg: getSuitableTranslations("Sorry, Email Or Password Incorrect !!", language),
                error: true,
                data: {},
            }
        }
        const employee = await employeeModel.findOne(email ? { email } : { mobilePhone });
        if (employee) {
            if (await compare(password, employee.password)) {
                if (employee.status === "blocked") {
                    return {
                        msg: getSuitableTranslations("Sorry, This Account Has Been Blocked !!", language),
                        error: true,
                        data: {},
                    }
                }
                const ip = normalizeLoginLogIp(ipAddress);
                await new loginLogModel({ user: employee._id, ipAddress: ip }).save();
                return {
                    msg: getSuitableTranslations("Logging In Has Been Completed Successfully !!", language),
                    error: false,
                    data: {
                        token: sign({
                            _id: employee._id,
                            isEmployee: true,
                            city: employee.city,
                        }, process.env.JWT_SECRET_KEY, {
                            expiresIn: ACCESS_TOKEN_EXPIRE,
                        }),
                    },
                };
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, Email Or Password Incorrect !!", language),
            error: true,
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
    login,
}