const areasRouter = require("express").Router();

const areasController = require("../../controllers/areas");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

areasRouter.get("/city/:cityId",
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "City Id", fieldValue: req.params.cityId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    areasController.getAreasInCity
);

module.exports = areasRouter;