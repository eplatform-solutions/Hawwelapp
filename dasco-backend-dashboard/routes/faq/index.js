const faqRouter = require("express").Router();

const faqController = require("../../controllers/faq");

const { LANGUAGES } = require("../../constants/languages");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

const {
    authMiddlewares,
    numbersMiddlewares
} = require("../../middlewares");

const {
    validateJWT,
} = authMiddlewares;

const {
    validateNumbersIsGreaterThanZero,
    validateNumbersIsNotFloat,
} = numbersMiddlewares;

faqRouter.post("/create",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Question", fieldValue: bodyData?.question, dataTypes: ["object"], isRequiredValue: true },
            { fieldName: "Answer", fieldValue: bodyData?.answer, dataTypes: ["object"], isRequiredValue: true },
            ...LANGUAGES.map((language) => (
                { fieldName: `Question In ${language.toUpperCase()}`, fieldValue: bodyData.question[language], dataTypes: ["string"], isRequiredValue: true }
            )),
            ...LANGUAGES.map((language) => (
                { fieldName: `Answer In ${language.toUpperCase()}`, fieldValue: bodyData.answer[language], dataTypes: ["string"], isRequiredValue: true }
            ))
        ], res, next);
    },
    faqController.postCreateFAQ
);

faqRouter.get("/all-faqs-inside-the-page",
    validateJWT,
    (req, res, next) => {
        const queryData = req.query;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Page Number", fieldValue: queryData?.pageNumber, dataTypes: ["number"], isRequiredValue: true },
            { fieldName: "Page Size", fieldValue: queryData?.pageSize, dataTypes: ["number"], isRequiredValue: true },
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
    faqController.getAllFAQSInsideThePage
);

faqRouter.put("/update/:faqId",
    validateJWT,
    (req, res, next) => {
        const bodyData = req.body;
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Question", fieldValue: bodyData?.question, dataTypes: ["object"], isRequiredValue: false },
            { fieldName: "Answer", fieldValue: bodyData?.answer, dataTypes: ["object"], isRequiredValue: false },
            ...bodyData?.question ? LANGUAGES.map((language) => (
                { fieldName: `Question In ${language.toUpperCase()}`, fieldValue: bodyData.question[language], dataTypes: ["string"], isRequiredValue: true }
            )) : [],
            ...bodyData?.answer ? LANGUAGES.map((language) => (
                { fieldName: `Answer In ${language.toUpperCase()}`, fieldValue: bodyData.answer[language], dataTypes: ["string"], isRequiredValue: true }
            )) : [],
        ], res, next);
    },
    faqController.putFAQInfo
);

faqRouter.delete("/delete/:faqId",
    validateJWT,
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "FAQ Id", fieldValue: req.params.faqId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    faqController.deleteFAQ
);

module.exports = faqRouter;