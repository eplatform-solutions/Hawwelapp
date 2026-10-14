const receiversRouter = require("express").Router();

const receiversController = require("../../controllers/receivers");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    commonMiddlewares
} = require("../../middlewares");

const {
    validateJWT,
    validateMobilePhone,
} = authMiddlewares;

const {
    validateName,
} = commonMiddlewares;

receiversRouter.post("/add",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Full Name", fieldValue: bodyData?.fullName, dataTypes: ["string"], isRequiredValue: true },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: true },
        ], res, next);
    },
    (req, res, next) => validateMobilePhone(req.body.mobilePhone, undefined, res, next),
    receiversController.postAddReveiver
);

receiversRouter.get("/all-receivers",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Full Name", fieldValue: queryData?.fullName, dataTypes: ["string"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const fullName = req.query?.fullName;
        if (fullName) {
            return validateName(fullName, res, next);
        }
        next();
    },
    receiversController.getAllReceivers
);

receiversRouter.put("/update/:receiverId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Full Name", fieldValue: bodyData?.fullName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const mobilePhone = req.body?.mobilePhone;
        if (mobilePhone) {
            return validateMobilePhone(mobilePhone, undefined, res, next);
        }
        next();
    },
    receiversController.putUpdateReceiver
);

receiversRouter.delete("/delete/:receiverId", validateJWT, receiversController.deleteReceiver);

module.exports = receiversRouter;