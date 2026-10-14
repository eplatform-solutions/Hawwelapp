const { countries } = require("countries-list");

const COUNTRIES = Object.keys(countries);

const TWO_FACTOR_AUTH_METHODS = ["email", "mobile-phone"];

const STATUSES = ["active", "blocked"];

const DEFAULT_STATUS = STATUSES[0];

module.exports = {
    COUNTRIES,
    TWO_FACTOR_AUTH_METHODS,
    STATUSES,
    DEFAULT_STATUS
}