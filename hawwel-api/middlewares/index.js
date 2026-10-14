const authMiddlewares = require("./auth");
const blockchainMiddlewares = require("./blockchain");
const commonMiddlewares = require("./common");
const filesMiddlewares = require("./files");
const globalMiddlewares = require("./global");
const kycMiddlewares = require("./kyc");
const numbersMiddlewares = require("./numbers");
const rateLimitsMiddlewares = require("./rate-limiters");
const sortMiddlewares = require("./sort");
const usersMiddlewares = require("./users");
const webhooksMiddlewares = require("./webhooks");

module.exports = {
    authMiddlewares,
    blockchainMiddlewares,
    commonMiddlewares,
    filesMiddlewares,
    globalMiddlewares,
    kycMiddlewares,
    numbersMiddlewares,
    rateLimitsMiddlewares,
    sortMiddlewares,
    usersMiddlewares,
    webhooksMiddlewares
}