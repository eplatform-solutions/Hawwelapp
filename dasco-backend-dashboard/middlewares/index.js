const adminsMiddlewares = require("./admins");
const appIdentityMiddlewares = require("./app_identity");
const authMiddlewares = require("./auth");
const blockchainMiddlewares = require("./blockchain");
const commonMiddlewares = require("./common");
const complianceMiddlewares = require("./compliance");
const currenciesMiddlewares = require("./currencies");
const filesMiddlewares = require("./files");
const globalMiddlewares = require("./global");
const kycMiddlewares = require("./kyc");
const networkMiddlewares = require("./network");
const numbersMiddlewares = require("./numbers");
const paymentMethodsMiddlewares = require("./payment_methods");
const rateLimitsMiddlewares = require("./rate-limiters");
const sortMiddlewares = require("./sort");
const transfersMiddlewares = require("./transfers");
const usersMiddlewares = require("./users");
const withdrawalsMiddlewares = require("./withdrawals");

module.exports = {
    adminsMiddlewares,
    appIdentityMiddlewares,
    authMiddlewares,
    blockchainMiddlewares,
    commonMiddlewares,
    complianceMiddlewares,
    currenciesMiddlewares,
    filesMiddlewares,
    globalMiddlewares,
    kycMiddlewares,
    networkMiddlewares,
    numbersMiddlewares,
    paymentMethodsMiddlewares,
    rateLimitsMiddlewares,
    sortMiddlewares,
    transfersMiddlewares,
    usersMiddlewares,
    withdrawalsMiddlewares
}