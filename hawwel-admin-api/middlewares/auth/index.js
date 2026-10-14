const { getResponseObject } = require("../../helpers/responses");

const { verify } = require("jsonwebtoken");

const { emailValidator, passwordValidator, codeValidator, mobilePhoneValidator } = require("../../validators/auth");

const { TYPES_OF_USE_VERIFICATION_CODE, ALLOWED_CHANNELS } = require("../../constants/verification_code");

function validateJWT(req, res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
        return res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
    }
    if (!authHeader.startsWith("Bearer")) {
        return res.status(401).json(getResponseObject("Please Send Bearer Token !!", true, {}));
    }
    verify(authHeader.split(" ")[1], process.env.JWT_SECRET_KEY, async (err, decode) => {
        if (err) {
            res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
            return;
        }
        req.data = decode;
        next();
    });
}

function validateEmployeeJWT(req, res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
        return res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
    }
    if (!authHeader.startsWith("Bearer")) {
        return res.status(401).json(getResponseObject("Please Send Bearer Token !!", true, {}));
    }
    verify(authHeader.split(" ")[1], process.env.JWT_SECRET_KEY, async (err, decode) => {
        if (err) {
            return res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
        }
        if (!decode.isEmployee) {
            return res.status(403).json(getResponseObject("Access Denied, Employees Only !!", true, {}));
        }
        req.data = decode;
        next();
    });
}

function validateMobilePhone(mobilePhone, country, res, nextFunc, errorMsg = "Sorry, Please Send Valid Mobile Phone !!") {
    if (!mobilePhoneValidator.isValidMobilePhone(mobilePhone, country)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

function validateMobilePhones(mobilePhones, country, res, nextFunc, errorMsgs, defaultMsg = "Sorry, Please Send Valid Country !!") {
    for (let i = 0; i < mobilePhones.length; i++) {
        if (!mobilePhoneValidator.isValidMobilePhone(mobilePhones[i], country)) {
            res.status(400).json(getResponseObject(errorMsgs[i] ? errorMsgs[i] : defaultMsg, true, {}));
            return;
        }
    }
    nextFunc();
}

function validateChannel(channel, res, nextFunc, errorMsg = "Sorry, Please Send Valid Message Channel !!") {
    if (!ALLOWED_CHANNELS.includes(channel)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

function validateEmail(email, res, nextFunc, errorMsg = "Sorry, Please Send Valid Email !!") {
    if (!emailValidator.isValidEmail(email)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

function validatePassword(password, res, nextFunc, errorMsg = "Sorry, Please Send Valid Password !!") {
    if (!passwordValidator.isValidPassword(password)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

function validateCode(code, res, nextFunc, errorMsg = "Please Send Valid Code !!") {
    if (!codeValidator.isValidCode(code)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

function validateTypeOfUseForCode(typeOfUse, res, nextFunc, errorMsg = "Please Send Valid Type Of Use Code !!") {
    if (!TYPES_OF_USE_VERIFICATION_CODE.includes(typeOfUse)) {
        res.status(400).json(getResponseObject(errorMsg, true, {}));
        return;
    }
    nextFunc();
}

module.exports = {
    validateJWT,
    validateEmployeeJWT,
    validateMobilePhone,
    validateMobilePhones,
    validateChannel,
    validateEmail,
    validatePassword,
    validateCode,
    validateTypeOfUseForCode,
}