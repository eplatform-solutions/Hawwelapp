// Import Minimum Deposit Limits Model Object
const { minimumDepositLimitsModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

// Define the function for get minimum deposit limits by currency name from database
async function getMinimumDepositLimits(filters, language) {
    try {
        const minimumDepositLimits = await minimumDepositLimitsModel.find(filters);
        if (minimumDepositLimits.length > 0) {
            return {
                msg: getSuitableTranslations("Get Minimum Deposit Limits By Filters Process Has Been Successfully !!", language),
                error: false,
                data: minimumDepositLimits,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry Can't Find Any Limits By This Filters !!", language),
            error: true,
            data: [],
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getMinimumDepositLimits,
}