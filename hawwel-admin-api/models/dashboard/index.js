const adminModel = require("./admin");
const employeeModel = require("./employee");
const regionModel = require("./region");
const regionPaymentMethodModel = require("./region_payment_method");
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
const loginLogModel = require("./login_log");
const minimumDepositLimitsModel = require("./minimum_deposit_limits");
const paymentMethodModel = require("./payment_method");
const permissionModel = require("./permission");
const roleModel = require("./role");
const sessionModel = require("./session");
const supportedCurrenciesByNetworksModel = require("./supported_currencies_by_networks");
const systemSettingsModel = require("./system_setting");
const verificationCodeModel = require("./verification_code");

module.exports = {
    adminModel,
    employeeModel,
    regionModel,
    regionPaymentMethodModel,
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
    loginLogModel,
    minimumDepositLimitsModel,
    paymentMethodModel,
    permissionModel,
    roleModel,
    sessionModel,
    supportedCurrenciesByNetworksModel,
    systemSettingsModel,
    verificationCodeModel,
}