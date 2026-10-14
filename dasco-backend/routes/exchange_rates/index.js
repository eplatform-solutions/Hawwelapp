const exchangeRatesRouter = require("express").Router();

const exchangeRatesController = require("../../controllers/exchange_rates");

exchangeRatesRouter.get("/all", exchangeRatesController.getAllExchangeRates);

module.exports = exchangeRatesRouter;