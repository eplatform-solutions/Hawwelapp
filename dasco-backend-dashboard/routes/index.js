const accountingRouter = require("./accounting");
const adminsRouter = require("./admins");
const regionsRouter = require("./regions");
const authRouter = require("./auth");
const blockchainWalletsRouter = require("./blockchain_wallets");
const citiesRouter = require("./cities");
const complianceRouter = require("./compliance");
const contactInfoRouter = require("./contact_info");
const countriesRouter = require("./countries");
const currenciesRouter = require("./currencies");
const employeesRouter = require("./employees");
const exchangeRatesRouter = require("./exchange_rates");
const faqRouter = require("./faq");
const kycRouter = require("./kyc");
const loginLogsRouter = require("./login_logs");
const overviewRouter = require("./overview");
const paymentMethodsRouter = require("./payment_methods");
const permissionsRouter = require("./permissions");
const quickControlRouter = require("./quick_control");
const rolesRouter = require("./roles");
const technicalSupportRouter = require("./technical_support");
const transfersRouter = require("./transfers");
const usersRouter = require("./users");
const verificationCodesRouter = require("./verification_codes");

const { Router } = require("express");

const routes = Router();

routes.use("/accounting", accountingRouter);

routes.use("/admins", adminsRouter);

routes.use("/regions", regionsRouter);

routes.use("/auth", authRouter);

routes.use("/blockchain-wallets", blockchainWalletsRouter);

routes.use("/cities", citiesRouter);

routes.use("/compliance", complianceRouter);

routes.use("/contact-info", contactInfoRouter);

routes.use("/countries", countriesRouter);

routes.use("/currencies", currenciesRouter);

routes.use("/employees", employeesRouter);

routes.use("/exchange-rates", exchangeRatesRouter);

routes.use("/faqs", faqRouter);

routes.use("/kycs", kycRouter);

routes.use("/login-logs", loginLogsRouter);

routes.use("/overview", overviewRouter);

routes.use("/payment-methods", paymentMethodsRouter);

routes.use("/permissions", permissionsRouter);

routes.use("/quick-control", quickControlRouter);

routes.use("/roles", rolesRouter);

routes.use("/technical-support", technicalSupportRouter);

routes.use("/transfers", transfersRouter);

routes.use("/users", usersRouter);

routes.use("/verification-codes", verificationCodesRouter);

module.exports = routes;