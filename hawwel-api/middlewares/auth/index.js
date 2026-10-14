const { getResponseObject } = require("../../helpers/responses");

const { verify } = require("jsonwebtoken");

const { adminModel } = require("../../models/dashboard");

const { emailValidator, passwordValidator, codeValidator, mobilePhoneValidator } = require("../../validators/auth");

const { TYPES_OF_USE_VERIFICATION_CODE, ALLOWED_CHANNELS } = require("../../constants/verification_code");

function getJwtSecrets() {
    const primarySecret = process.env.JWT_SECRET_KEY;
    const fallbackSecret = process.env.SECRET_KEY;
    return { primarySecret, fallbackSecret };
}

function verifyWithKnownSecrets(token, done) {
    const { primarySecret, fallbackSecret } = getJwtSecrets();
    if (!primarySecret && !fallbackSecret) {
        return done(new Error("JWT secrets are not configured"));
    }
    const firstSecret = primarySecret || fallbackSecret;
    verify(token, firstSecret, (primaryErr, primaryDecode) => {
        if (!primaryErr) {
            return done(null, primaryDecode, false);
        }
        if (
            fallbackSecret &&
            fallbackSecret !== firstSecret
        ) {
            return verify(token, fallbackSecret, (fallbackErr, fallbackDecode) => {
                if (!fallbackErr) {
                    return done(null, fallbackDecode, true);
                }
                return done(primaryErr, null, false);
            });
        }
        return done(primaryErr, null, false);
    });
}

function validateJWT(req, res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
        return res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
    }
    if (!authHeader.startsWith("Bearer ")) {
        return res.status(401).json(getResponseObject("Please Send Bearer Token !!", true, {}));
    }
    const token = authHeader.split(" ")[1]?.trim();
    if (!token) {
        return res.status(401).json(getResponseObject("Please Send Bearer Token !!", true, {}));
    }
    verifyWithKnownSecrets(token, async (err, decode, usedFallbackSecret) => {
        if (err) {
            console.warn(
                `[AUTH] JWT verify failed (${err.name || "UnknownError"}): ${err.message || "No message"}`
            );
            res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
            return;
        }
        if (usedFallbackSecret) {
            console.warn(
                "[AUTH] JWT validated with SECRET_KEY fallback; align JWT_SECRET_KEY and SECRET_KEY."
            );
        }
        req.data = decode;
        next();
    });
}

// hawwel-admin-api signs admin tokens with the same secret pool as
// this repo's customer tokens (confirmed identical env values in
// production) - so the signature alone can't tell a customer token from an
// admin one. This resolves the decoded _id against the admin collection
// (used only for the chat feature, where a browser dashboard client talks
// to this repo directly) before trusting the request as an admin's.
function validateAdminJWT(req, res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
        return res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
    }
    if (!authHeader.startsWith("Bearer ")) {
        return res.status(401).json(getResponseObject("Please Send Bearer Token !!", true, {}));
    }
    const token = authHeader.split(" ")[1]?.trim();
    if (!token) {
        return res.status(401).json(getResponseObject("Please Send Bearer Token !!", true, {}));
    }
    verifyWithKnownSecrets(token, async (err, decode) => {
        if (err) {
            return res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
        }
        const admin = await adminModel.findById(decode?._id, { status: 1 });
        if (!admin || admin.status === "blocked") {
            return res.status(401).json(getResponseObject("Unauthorized Error !!", true, {}));
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
    validateAdminJWT,
    validateMobilePhone,
    validateChannel,
    validateEmail,
    validatePassword,
    validateCode,
    validateTypeOfUseForCode,
}