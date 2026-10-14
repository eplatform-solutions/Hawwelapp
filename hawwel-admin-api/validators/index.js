const authValidators = require("./auth");
const commonValidators = require("./common");
const globalValidators = require("./global");
const tatumAPIValidators = require("./tatum_api");

module.exports = {
    authValidators,
    commonValidators,
    globalValidators,
    tatumAPIValidators
}