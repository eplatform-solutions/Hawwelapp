// Import Required Models, Helpers, and Constants

const { transferModel, userModel, counterModel } = require("../../models/client");

const { countryModel, areaPaymentMethodModel, countryPaymentMethodModel, systemSettingsModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { getCountry } = require("../countries");

const { getCity } = require("../cities");

const { getArea } = require("../areas");

const { getPaymentMethod } = require("../payment_methods");

const { SUPPORTED_CRYPTO_CURRENCY_SYMBOLS, DEFAULT_SEND_CURRENCY_SYMBOL } = require("../../constants/currencies");

const { createNewTransaction } = require("../transactions");

const { createBlockchainWallets } = require("../blockchain_wallets");

const { getExchangeRateByBaseAndQuote } = require("../exchange_rates");

const { createTatumSubscriptions } = require("../tatum_subscriptions");

const { parsePhoneNumberFromString } = require("libphonenumber-js");

const { clientDB } = require("../../database/connections");

const mongoose = require("mongoose");
const { runInTransactionWithRetry } = require("../_utils/transaction_retry");

const { assertKycApprovedForTransfer } = require("../kyc");

const { assertTransferAllowed } = require("../../helpers/compliance");

async function getNextTransferNumber(dbSession) {
    const counter = await counterModel.findOneAndUpdate(
        { name: "transferNumber" },
        { $inc: { seq: 1 } },
        { new: true, upsert: true, session: dbSession }
    );
    return counter.seq;
}

function toWalletLite(wallet) {
    return { network: wallet.network, address: wallet.address, createdAt: wallet.createdAt };
}

async function createNewTransfer(transferDetails, language, dbSession = null) {
    let internalSession = false;
    try {
        const saveTransfer = async (session) => {
            const transferInstance = new transferModel(transferDetails);
            if (transferInstance.isNew && !transferInstance.transferNumber) {
                transferInstance.transferNumber = await getNextTransferNumber(session);
            }
            const newTransfer = await transferInstance.save({ session });
            return {
                msg: getSuitableTranslations("Creating New Transfer Process Has Been Successfully !!", language),
                error: false,
                data: newTransfer,
            };
        };

        if (dbSession) {
            return await saveTransfer(dbSession);
        }

        internalSession = true;
        return await runInTransactionWithRetry(
            clientDB,
            async (session) => saveTransfer(session),
            { maxRetries: 4, baseDelayMs: 120 }
        );
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

function checkFromTransferLimits(paymentMethod, amount, language) {
    try {
        const minAmount = paymentMethod.minAmount;
        if (amount < minAmount) {
            return {
                msg: getSuitableTranslations("Sorry, Please Send Amount Greater Than Or Equal {{minAmount}} !!", language, { minAmount }),
                error: true,
                data: {},
            }
        }
        const maxAmount = paymentMethod.maxAmount;
        if (amount > maxAmount) {
            return {
                msg: getSuitableTranslations("Sorry, Please Send Amount Less Than Or Equal {{maxAmount}} !!", language, { maxAmount }),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Check From Transfer Limits Process Has Been Successfully !!", language),
            error: false,
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function transferByParameter(userId, transfer, language, dbSession = null) {
    let internalSession = false;
    try {
        const systemSettings = await systemSettingsModel.findOne({}, { __v: 0, _id: 0, createdAt: 0 });
        if (systemSettings.isTransferDisabled) {
            return {
                msg: getSuitableTranslations("Sorry, Transfer Processes Is Not Available Now !!", language),
                error: true,
                data: {}
            }
        }
        const user = await userModel.findById(userId, { name: 1, fatherName: 1, nickname: 1, country: 1, mobilePhone: 1, email: 1, status: 1 });
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const kycGateResult = await assertKycApprovedForTransfer(userId, language);
            if (kycGateResult.error) {
                return kycGateResult;
            }
            const toCountryResult = await getCountry(transfer.toCountry, language);
            if (toCountryResult.error) {
                return {
                    msg: getSuitableTranslations("Sorry, Receiving Country Is Not Exist !!", language),
                    error: true,
                    data: {}
                }
            }
            const phoneNumber = parsePhoneNumberFromString(transfer.receiver.mobilePhone);
            if (phoneNumber.country !== toCountryResult.data.code) {
                return {
                    msg: getSuitableTranslations("Sorry, Mobile Phone For Receiver Is Not Valid !!", language),
                    error: true,
                    data: {}
                }
            }
            if (!SUPPORTED_CRYPTO_CURRENCY_SYMBOLS.includes(transfer.symbol)) {
                return {
                    msg: getSuitableTranslations("Sorry, Currency Symbol Is Not Exist !!", language),
                    error: true,
                    data: {}
                }
            }
            // Withdrawing a stablecoin has to bind here too, not only in the
            // app: an older build - or anything calling the API directly -
            // would otherwise keep creating transfers in a currency the
            // business can no longer settle.
            const allowedSendCurrencies = Array.isArray(systemSettings.allowedSendCurrencies) && systemSettings.allowedSendCurrencies.length > 0
                ? systemSettings.allowedSendCurrencies
                : [DEFAULT_SEND_CURRENCY_SYMBOL];
            if (!allowedSendCurrencies.includes(transfer.symbol)) {
                return {
                    msg: getSuitableTranslations("Sorry, This Currency Is Not Available For New Transfers, Please Choose {{allowed}} !!", language, { allowed: allowedSendCurrencies.join(", ") }),
                    error: true,
                    data: { allowedSendCurrencies }
                }
            }
            // City/area are optional together: either both are sent (the
            // payment method is scoped to a specific region, the original
            // flow) or neither is (the payment method is bound directly to
            // the whole country - see getPaymentMethodsInCountry).
            if (Boolean(transfer.city) !== Boolean(transfer.area)) {
                return {
                    msg: getSuitableTranslations("Sorry, Please Send Both City And Area, Or Neither !!", language),
                    error: true,
                    data: {}
                }
            }

            let cityResult = null;
            let areaResult = null;

            if (transfer.city && transfer.area) {
                cityResult = await getCity(transfer.city, language);
                if (cityResult.error) {
                    return cityResult;
                }
                if (!cityResult.data.country.equals(toCountryResult.data._id)) {
                    return {
                        msg: getSuitableTranslations("Sorry, This City Is Not Exist In Receiving Country !!", language),
                        error: true,
                        data: {}
                    }
                }
                areaResult = await getArea(transfer.area, language);
                if (areaResult.error) {
                    return areaResult;
                }
                if (!areaResult.data.city.equals(cityResult.data._id)) {
                    return {
                        msg: getSuitableTranslations("Sorry, This Area Is Not Exist In This City !!", language),
                        error: true,
                        data: {}
                    }
                }
            }

            const paymentMethodResult = await getPaymentMethod(transfer.paymentMethod, language);
            if (paymentMethodResult.error) {
                return paymentMethodResult;
            }
            if (!paymentMethodResult.data.isActivated) {
                return {
                    msg: getSuitableTranslations("Sorry, This Payment Method Is Not Activated !!", language),
                    error: true,
                    data: {}
                }
            }

            if (areaResult) {
                const paymentMethodInArea = await areaPaymentMethodModel.findOne({ region: areaResult.data._id, paymentMethod: paymentMethodResult.data._id });
                if (!paymentMethodInArea) {
                    return {
                        msg: getSuitableTranslations("Sorry, This Payment Method Is Not Exist In Area !!", language),
                        error: true,
                        data: {}
                    }
                }
            } else {
                const paymentMethodInCountry = await countryPaymentMethodModel.findOne({ country: toCountryResult.data._id, paymentMethod: paymentMethodResult.data._id });
                if (!paymentMethodInCountry) {
                    return {
                        msg: getSuitableTranslations("Sorry, This Payment Method Requires Selecting A City !!", language),
                        error: true,
                        data: {}
                    }
                }
            }
            const checkFromTransferLimitsResult = checkFromTransferLimits(paymentMethodResult.data, transfer.amount, language);
            if (checkFromTransferLimitsResult.error) {
                return checkFromTransferLimitsResult;
            }
            // Sanctions/PEP screening and cumulative limits. Runs before any
            // record is written so a blocked transfer never gets a deposit
            // address, and every decision leaves a compliance_alert behind.
            const complianceResult = await assertTransferAllowed({
                user,
                transfer,
                toCountryCode: toCountryResult.data.code,
                language,
            });
            if (complianceResult.error) {
                return complianceResult;
            }
            transfer.sender = userId;
            transfer.currencyName = transfer.symbol;
            const transferFee = paymentMethodResult.data.fee;
            const rateResult = await getExchangeRateByBaseAndQuote(
                transfer.symbol,
                paymentMethodResult.data.symbol,
                language
            );
            if (rateResult.error) {
                return rateResult;
            }
            transfer.rate = Number(rateResult.data.rate);
            transfer.fee = transferFee;
            transfer.fromCountry = user.country;
            transfer.toCountry = toCountryResult.data.code;
            if (cityResult && areaResult) {
                transfer.city = cityResult.data.name;
                transfer.area = areaResult.data.name;
            } else {
                delete transfer.city;
                delete transfer.area;
            }
            transfer.paymentMethod = {
                name: paymentMethodResult.data.name,
                symbol: paymentMethodResult.data.symbol,
                logoPath: paymentMethodResult.data.logoPath,
            };
            const now = Date.now();
            const expirationAt = now + 2 * 60 * 60 * 1000;
            transfer.expirationAt = expirationAt;
            const persistTransferRecords = async (session) => {
                const newTransfer = (await createNewTransfer(transfer, language, session)).data;
                await createNewTransaction({
                    user: userId,
                    transaction: newTransfer._id
                }, language, session);
                const blockchainWallets = (await createBlockchainWallets(user._id, newTransfer._id, language, session)).data;
                return { newTransfer, blockchainWallets };
            };

            let transferAndWallets;
            if (dbSession) {
                transferAndWallets = await persistTransferRecords(dbSession);
            }
            else {
                internalSession = true;
                transferAndWallets = await runInTransactionWithRetry(
                    clientDB,
                    async (session) => persistTransferRecords(session),
                    { maxRetries: 4, baseDelayMs: 150 }
                );
            }

            const newTransfer = transferAndWallets.newTransfer;
            const blockchainWallets = transferAndWallets.blockchainWallets;
            newTransfer.sender = user;

            let subscriptionsPending = false;
            let saveSubscriptionsResult = null;
            try {
                saveSubscriptionsResult = await createTatumSubscriptions(
                    userId,
                    newTransfer._id,
                    blockchainWallets,
                    language
                );
            }
            catch (subscriptionError) {
                saveSubscriptionsResult = {
                    error: true,
                    msg: subscriptionError?.message ?? String(subscriptionError),
                    data: {}
                };
            }

            if (saveSubscriptionsResult?.error) {
                subscriptionsPending = true;
                console.error(
                    `Failed to create tatum subscriptions for transfer ${newTransfer._id}: ${saveSubscriptionsResult.msg}`
                );
                setTimeout(async () => {
                    try {
                        await createTatumSubscriptions(userId, newTransfer._id, blockchainWallets, language);
                    }
                    catch (retryError) {
                        console.error(
                            `Retry createTatumSubscriptions failed for transfer ${newTransfer._id}: ${retryError?.message ?? retryError}`
                        );
                    }
                }, 2000);
            }

            const walletLite = blockchainWallets.map(toWalletLite);
            newTransfer._doc.blockchainWallets = walletLite;
            if (subscriptionsPending) {
                newTransfer._doc.subscriptionsPending = true;
            }
            delete newTransfer._doc.__v;
            return {
                msg: getSuitableTranslations("Creating New Transfer Process Has Been Successfully !!", language),
                error: false,
                data: newTransfer,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
            data: {},
        }
    }
    catch (err) {
        console.error("[transfers] transferByParameter failed:", err?.message ?? err);
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function getAllTransfersInsideThePage(userId, pageNumber, pageSize, filters, language) {
    try {
        const user = await userModel.findById(userId);
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            let mainFilters = {
                sender: new mongoose.Types.ObjectId(userId)
            };
            if (filters.fromDate && filters.toDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setHours(23, 59, 59, 999)) };
                delete filters.fromDate;
                delete filters.toDate;
            } else if (filters.fromDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate) };
                delete filters.fromDate;
            } else if (filters.toDate) {
                mainFilters.createdAt = { $lte: new Date((new Date(filters.toDate)).setHours(23, 59, 59, 999)) };
                delete filters.toDate;
            }
            const basePipeline = [
                { $match: mainFilters },
            ];
            const paginatedPipeline = [
                ...basePipeline,
                { $sort: { createdAt: -1 } },
                {
                    $addFields: {
                        day: {
                            $dateToString: {
                                format: "%Y-%m-%d",
                                date: "$createdAt"
                            }
                        }
                    }
                },
                {
                    $lookup: {
                        from: "users",
                        let: { senderId: "$sender" },
                        pipeline: [
                            {
                                $match: {
                                    $expr: { $eq: ["$_id", "$$senderId"] }
                                }
                            },
                            {
                                $project: {
                                    name: 1,
                                    fatherName: 1,
                                    nickname: 1,
                                    mobilePhone: 1,
                                    email: 1
                                }
                            }
                        ],
                        as: "sender"
                    }
                },
                {
                    $unwind: {
                        path: "$sender",
                        preserveNullAndEmptyArrays: true
                    }
                },
                {
                    $lookup: {
                        from: "blockchain_wallets",
                        let: { transferId: "$_id" },
                        pipeline: [
                            {
                                $match: {
                                    $expr: { $eq: ["$transfer", "$$transferId"] }
                                }
                            },
                            {
                                $project: {
                                    _id: 0,
                                    network: 1,
                                    address: 1,
                                    createdAt: 1
                                }
                            }
                        ],
                        as: "blockchainWallets"
                    }
                },
                {
                    $group: {
                        _id: "$day",
                        transfers: {
                            $push: {
                                _id: "$_id",
                                sender: "$sender",
                                fromCountry: "$fromCountry",
                                amount: "$amount",
                                total: "$total",
                                paid: "$paid",
                                rate: "$rate",
                                fee: "$fee",
                                network: "$network",
                                currencyName: "$currencyName",
                                symbol: "$symbol",
                                toCountry: "$toCountry",
                                city: "$city",
                                area: "$area",
                                paymentMethod: "$paymentMethod",
                                status: "$status",
                                transferNumber: "$transferNumber",
                                receiver: "$receiver",
                                createdAt: "$createdAt",
                                expirationAt: "$expirationAt",
                                paymentProofNote: "$paymentProofNote",
                                paymentProofImagePath: "$paymentProofImagePath",
                                receivingPlaceImagePath: "$receivingPlaceImagePath",
                                blockchainWallets: "$blockchainWallets",
                            }
                        }
                    }
                },
                {
                    $sort: { _id: -1 }
                },
                { $skip: (pageNumber - 1) * pageSize },
                { $limit: pageSize },
                {
                    $project: {
                        _id: 0,
                        date: "$_id",
                        transfers: 1
                    }
                }
            ];
            const countPipeline = [
                ...basePipeline,
                { $count: "total" }
            ];
            const [transfers, countResult] = await Promise.all([
                transferModel.aggregate(paginatedPipeline),
                transferModel.aggregate(countPipeline)
            ]);
            return {
                msg: getSuitableTranslations("Get All Transfers For This User Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                error: false,
                data: {
                    transfers,
                    count: countResult.length > 0 ? countResult[0].total : 0,
                },
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getMainTransferPageData(userId, language) {
    try {
        const user = await userModel.findById(userId);
        if (user) {
            if (user.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const result = await countryModel.aggregate([
                {
                    $lookup: {
                        from: "cities",
                        localField: "_id",
                        foreignField: "country",
                        as: "cities"
                    }
                },
                {
                    $lookup: {
                        from: "areas",
                        let: { cityIds: "$cities._id" },
                        pipeline: [
                            {
                                $match: {
                                    $expr: { $in: ["$city", "$$cityIds"] }
                                }
                            }
                        ],
                        as: "areas"
                    }
                },
                {
                    $lookup: {
                        from: "area_payment_methods",
                        let: { areaIds: "$areas._id" },
                        pipeline: [
                            {
                                $match: {
                                    $expr: { $in: ["$area", "$$areaIds"] }
                                }
                            }
                        ],
                        as: "areaPM"
                    }
                },
                {
                    $lookup: {
                        from: "payment_methods",
                        localField: "areaPM.paymentMethod",
                        foreignField: "_id",
                        as: "paymentMethods"
                    }
                },
                {
                    $addFields: {
                        cities: {
                            $map: {
                                input: "$cities",
                                as: "city",
                                in: {
                                    _id: "$$city._id",
                                    name: "$$city.name",

                                    areas: {
                                        $map: {
                                            input: {
                                                $filter: {
                                                    input: "$areas",
                                                    as: "area",
                                                    cond: { $eq: ["$$area.city", "$$city._id"] }
                                                }
                                            },
                                            as: "area",
                                            in: {
                                                _id: "$$area._id",
                                                name: "$$area.name",

                                                paymentMethods: {
                                                    $map: {
                                                        input: {
                                                            $filter: {
                                                                input: "$areaPM",
                                                                as: "pm",
                                                                cond: { $eq: ["$$pm.area", "$$area._id"] }
                                                            }
                                                        },
                                                        as: "pm",
                                                        in: {
                                                            $arrayElemAt: [
                                                                {
                                                                    $filter: {
                                                                        input: "$paymentMethods",
                                                                        as: "p",
                                                                        cond: {
                                                                            $eq: ["$$p._id", "$$pm.paymentMethod"]
                                                                        }
                                                                    }
                                                                },
                                                                0
                                                            ]
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                {
                    $project: {
                        areas: 0,
                        areaPM: 0,
                        paymentMethods: 0
                    }
                }
            ]);
            return {
                msg: getSuitableTranslations("Get Main Transfer Page Data Process Has Been Successfully !!", language),
                error: false,
                data: result,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This User Is Not Exist !!", language),
            error: true,
            code: "PERMISSION_DENIED",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getTransfer(id, language) {
    try {
        const transfer = await transferModel.findById(id).populate("sender");
        if (transfer) {
            return {
                msg: getSuitableTranslations("Get Transfer Data Process Has Been Successfully !!", language),
                error: false,
                data: transfer,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Transfer Is Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    createNewTransfer,
    transferByParameter,
    getAllTransfersInsideThePage,
    getMainTransferPageData,
    getTransfer
}