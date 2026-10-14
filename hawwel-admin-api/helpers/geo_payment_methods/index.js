// Shared logic for binding payment methods to countries/cities/regions.
// Used by repositories/countries, repositories/cities, and
// repositories/regions so the three levels stay consistent instead of
// each hand-rolling its own copy of the same upsert pattern.

const { paymentMethodModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../translation");

async function findExistingPaymentMethodsOrError(paymentMethodIds, language) {
    const uniquePaymentMethodIds = [...new Set(paymentMethodIds.map(String))];
    const existingPaymentMethods = await paymentMethodModel.find({ _id: { $in: uniquePaymentMethodIds } });
    if (existingPaymentMethods.length !== uniquePaymentMethodIds.length) {
        return {
            error: {
                msg: getSuitableTranslations("Sorry, Some Payment Methods Are Not Exist !!", language),
                error: true,
                data: {},
            },
        };
    }
    return { existingPaymentMethods };
}

// Upserts one join-table row per (entityId, paymentMethodId) pair - a no-op
// for pairs that already exist, so this is always safe to call as a
// "make sure these are enabled" operation.
async function upsertBindings(model, entityKey, entityId, paymentMethodIds, dbSession) {
    if (!paymentMethodIds || paymentMethodIds.length === 0) return;
    await model.bulkWrite(
        paymentMethodIds.map((paymentMethodId) => ({
            updateOne: {
                filter: { [entityKey]: entityId, paymentMethod: paymentMethodId },
                update: { $setOnInsert: { [entityKey]: entityId, paymentMethod: paymentMethodId } },
                upsert: true,
            },
        })),
        { session: dbSession }
    );
}

module.exports = {
    findExistingPaymentMethodsOrError,
    upsertBindings,
}
