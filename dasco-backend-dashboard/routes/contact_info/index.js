const contactInfoRouter = require("express").Router();

const contactInfoController = require("../../controllers/contact_info");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
    validateMobilePhones,
    validateEmail
} = authMiddlewares;

contactInfoRouter.put("/update",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Mobile Phones", fieldValue: bodyData?.mobilePhones, dataTypes: ["array"], isRequiredValue: false },
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const mobilePhones = req.body?.mobilePhones;
        if (mobilePhones?.length > 0) {
            let errorMsgs = [];
            for (let i = 0; i < mobilePhones.length; i++) {
                errorMsgs.push(`Sorry, Please Send Valid Mobile Phone At Index: ${i} !!`);
            }
            return validateMobilePhones(mobilePhones, undefined, res, next, errorMsgs);
        }
        next();
    },
    (req, res, next) => {
        const email = req.body?.email;
        if (email) {
            validateEmail(email, res, next);
            return;
        }
        next();
    },
    contactInfoController.putContactInfo
);

module.exports = contactInfoRouter;