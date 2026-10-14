const adminModel = require("./admin");
const areaModel = require("./area");
const areaPaymentMethodModel = require("./area_payment_method");
const blockchainWalletModel = require("./blockchain_wallet");
const cityModel = require("./city");
const cityPaymentMethodModel = require("./city_payment_method");
const contactInfoModel = require("./contact_info");
const counterModel = require("./counter");
const countryModel = require("./country");
const countryPaymentMethodModel = require("./country_payment_method");
const currencyRateModel = require("./currency_rate");
const exchangeRateModel = require("./exchange_rate");
const faqModel = require("./faq");
const globalPasswordModel = require("./global_password");
const minimumDepositLimitsModel = require("./minimum_deposit_limits");
const paymentMethodModel = require("./payment_method");
const supportedCurrenciesByNetworksModel = require("./supported_currencies_by_networks");
const systemSettingsModel = require("./system_setting");

module.exports = {
    adminModel,
    areaModel,
    areaPaymentMethodModel,
    blockchainWalletModel,
    cityModel,
    cityPaymentMethodModel,
    contactInfoModel,
    counterModel,
    countryModel,
    countryPaymentMethodModel,
    currencyRateModel,
    exchangeRateModel,
    faqModel,
    globalPasswordModel,
    minimumDepositLimitsModel,
    paymentMethodModel,
    supportedCurrenciesByNetworksModel,
    systemSettingsModel,
}