const citiesRouter = require("express").Router();

const citiesController = require("../../controllers/cities");

const { validateIsExistValueForFieldsAndDataTypes } = require("../../helpers/validate");

citiesRouter.get("/country/:countryId",
    (req, res, next) => {
        validateIsExistValueForFieldsAndDataTypes([
            { fieldName: "Country Id", fieldValue: req.params.countryId, dataTypes: ["ObjectId"], isRequiredValue: true },
        ], res, next);
    },
    citiesController.getCitiesInCountry
);

module.exports = citiesRouter;