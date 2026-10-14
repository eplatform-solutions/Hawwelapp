const areasRouter = require("./areas");
const appVisualIdentityRouter = require("./app_visual_identity");
const authRouter = require("./auth");
const chatRouter = require("./chat");
const citiesRouter = require("./cities");
const countriesRouter = require("./countries");
const depositsRouter = require("./deposits");
const exchangeRatesRouter = require("./exchange_rates");
const kycRouter = require("./kyc");
const notificationsRouter = require("./notifications");
const paymentMethodsRouter = require("./payment_methods");
const receiversRouter = require("./receivers");
const technicalSupportRouter = require("./technical_support");
const transfersRouter = require("./transfers");
const usersRouter = require("./users");
const verificationCodesRouter = require("./verification_codes");

const { Router } = require("express")

const routes = Router();

routes.use("/areas", areasRouter);

routes.use("/app-visual-identity", appVisualIdentityRouter);

routes.use("/auth", authRouter);

routes.use("/chat", chatRouter);

routes.use("/cities", citiesRouter);

routes.use("/countries", countriesRouter);

routes.use("/deposits", depositsRouter);

routes.use("/exchange-rates", exchangeRatesRouter);

routes.use("/kyc", kycRouter);

routes.use("/notifications", notificationsRouter);

routes.use("/payment-methods", paymentMethodsRouter);

routes.use("/receivers", receiversRouter);

routes.use("/technical-support", technicalSupportRouter);

routes.use("/transfers", transfersRouter);

routes.use("/users", usersRouter);

routes.use("/verification-codes", verificationCodesRouter);

module.exports = routes;