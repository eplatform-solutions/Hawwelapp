const areasTranslations = require("./areas");
const authTranslations = require("./auth");
const blockchainWalletsTranslations = require("./blockchain_wallets");
const citiesTranslations = require("./cities");
const countriesTranslations = require("./countries");
const depositsTranslations = require("./deposits");
const exchangeRatesTranslations = require("./exchange_rates");
const globalPasswordsTranslations = require("./global_passwords");
const kycTranslations = require("./kyc");
const minimumDepositLimitsTranslations = require("./minimum_deposit_limits");
const notificationsTranslations = require("./notifications");
const paymentMethodsTranslations = require("./payment_methods");
const receiversTranslations = require("./receivers");
const sessionsTranslations = require("./sessions");
const tatumSubscriptionsTranslations = require("./tatum_subscriptions");
const technicalSupportTranslations = require("./technical_support");
const transfersTranslations = require("./transfers");
const usersTranslations = require("./users");
const verificationCodesTranslations = require("./verification_codes");

module.exports = {
    ...areasTranslations,
    ...authTranslations,
    ...blockchainWalletsTranslations,
    ...citiesTranslations,
    ...countriesTranslations,
    ...depositsTranslations,
    ...exchangeRatesTranslations,
    ...globalPasswordsTranslations,
    ...kycTranslations,
    ...minimumDepositLimitsTranslations,
    ...notificationsTranslations,
    ...paymentMethodsTranslations,
    ...receiversTranslations,
    ...sessionsTranslations,
    ...tatumSubscriptionsTranslations,
    ...technicalSupportTranslations,
    ...transfersTranslations,
    ...usersTranslations,
    ...verificationCodesTranslations
}