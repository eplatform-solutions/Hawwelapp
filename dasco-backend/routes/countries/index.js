const countriesRouter = require("express").Router();

const countriesController = require("../../controllers/countries");

countriesRouter.get("/all", countriesController.getAllCountries);

module.exports = countriesRouter;