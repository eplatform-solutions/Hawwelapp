const usersRouter = require("express").Router();

const usersController = require("../../controllers/users");

const { validateHelpers } = require("../../helpers");

const { validateIsExistValueForFieldsAndDataTypes } = validateHelpers;

const {
    authMiddlewares,
    commonMiddlewares,
    numbersMiddlewares,
    usersMiddlewares,
} = require("../../middlewares");

const {
    validateJWT,
    validateEmail,
    validateMobilePhone,
} = authMiddlewares;

const {
    validateName,
    validateCountry
} = commonMiddlewares;

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat,
} = numbersMiddlewares;

const {
    validateStatus
} = usersMiddlewares;

usersRouter.get("/info/:userId", validateJWT, usersController.getUserInfo);

usersRouter.get("/users-count", validateJWT, usersController.getUsersCount);

usersRouter.get("/all-users-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "User Id", fieldValue: queryData?._id, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Name", fieldValue: queryData?.name, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Nickname", fieldValue: queryData?.nickname, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Father Name", fieldValue: queryData?.fatherName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Country", fieldValue: queryData?.country, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Mobile Phone", fieldValue: queryData?.mobilePhone, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Email", fieldValue: queryData?.email, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Status", fieldValue: queryData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Account Number", fieldValue: queryData?.accountNumber, dataTypes: ["number"], isRequiredValue: false },
            { fieldName: "From Date", fieldValue: queryData?.fromDate, dataTypes: ["date"], isRequiredValue: false },
            { fieldName: "To Date", fieldValue: queryData?.toDate, dataTypes: ["date"], isRequiredValue: false },
        ], res, next);
    },
    (req, res, next) => {
        const queryData = req.query;
        validateNumbersIsGreaterThanZero([queryData.pageNumber, queryData.pageSize], res, next, ["Sorry, Please Send Valid Page Number ( Number Must Be Greater Than Zero ) !!", "Sorry, Please Send Valid Page Size ( Number Must Be Greater Than Zero ) !!"]);
    },
    (req, res, next) => {
        const queryData = req.query;
        validateNumbersIsNotFloat([queryData.pageNumber, queryData.pageSize], res, next, ["Sorry, Please Send Valid Page Number ( Number Must Be Not Float ) !!", "Sorry, Please Send Valid Page Size ( Number Must Be Not Float ) !!"]);
    },
    (req, res, next) => {
        const name = req.query?.name;
        if (name) {
            validateName(name, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const nickname = req.query?.nickname;
        if (nickname) {
            validateName(nickname, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const fatherName = req.query?.fatherName;
        if (fatherName) {
            validateName(fatherName, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const country = req.query?.country;
        if (country) {
            validateCountry(country, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const mobilePhone = req.query?.mobilePhone;
        if (mobilePhone) {
            validateMobilePhone(mobilePhone, undefined, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const email = req.query?.email;
        if (email) {
            validateEmail(email, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const status = req.query?.status;
        if (status) {
            validateStatus(status, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const accountNumber = req.query?.accountNumber;
        if (accountNumber) {
            return validateNumbersIsGreaterThanZero([accountNumber], res, next, ["Sorry, Please Send Valid Account Number ( Number Must Be Greater Than Zero ) !!"]);
        }
        next();
    },
    (req, res, next) => {
        const accountNumber = req.query?.accountNumber;
        if (accountNumber) {
            return validateNumbersIsNotFloat([accountNumber], res, next, ["Sorry, Please Send Valid Account Number ( Number Must Be Not Float ) !!"]);
        }
        next();
    },
    usersController.getAllUsersInsideThePage
);

usersRouter.put("/update/:userId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        console.log(bodyData);
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "User Id", fieldValue: req.params.userId, dataTypes: ["ObjectId"], isRequiredValue: false },
            { fieldName: "Name", fieldValue: bodyData?.name, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Nickname", fieldValue: bodyData?.nickname, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Father Name", fieldValue: bodyData?.fatherName, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Country", fieldValue: bodyData?.country, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Mobile Phone", fieldValue: bodyData?.mobilePhone, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Email", fieldValue: bodyData?.email, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Status", fieldValue: bodyData?.status, dataTypes: ["string"], isRequiredValue: false },
            { fieldName: "Blocking Reason", fieldValue: bodyData?.blockingReason, dataTypes: ["string"], isRequiredValue: bodyData?.status === "blocked" },
        ], res, next);
    },
    (req, res, next) => {
        const name = req.body?.name;
        if (name) {
            validateName(name, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const nickname = req.body?.nickname;
        if (nickname) {
            validateName(nickname, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const fatherName = req.body?.fatherName;
        if (fatherName) {
            validateName(fatherName, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const country = req.body?.country;
        if (country) {
            validateCountry(country, res, next);
            return;
        }
        next();
    },
    (req, res, next) => {
        const mobilePhone = req.body?.mobilePhone;
        if (mobilePhone) {
            validateMobilePhone(mobilePhone, undefined, res, next);
            return;
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
    (req, res, next) => {
        const status = req.body?.status;
        if (status) {
            validateStatus(status, res, next);
            return;
        }
        next();
    },
    usersController.putUserInfo
);

usersRouter.delete("/delete/:userId", validateJWT, usersController.deleteUser);

module.exports = usersRouter;