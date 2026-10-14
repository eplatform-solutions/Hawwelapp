// Import Required Models Object

const { adminModel, exchangeRateModel } = require("../../models/dashboard");

const { transferModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

async function getDailyRestrictions(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "accounting_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const exchangeRates = await exchangeRateModel.find({}, { __v: false });
            const startOfToday = new Date();
            startOfToday.setUTCHours(0, 0, 0, 0);
            const endOfToday = new Date();
            endOfToday.setUTCHours(23, 59, 59, 999);
            const result = await transferModel.aggregate([
                {
                    $match: {
                        status: { $in: ["full-paid", "under-paid", "over-paid"] },
                        createdAt: { $gte: startOfToday, $lte: endOfToday }
                    }
                },
                {
                    $addFields: {
                        commission: {
                            $multiply: ["$paid", { $divide: ["$fee", 100] }]
                        }
                    }
                },
                {
                    $facet: {
                        stats: [
                            {
                                $group: {
                                    _id: null,
                                    totalTransfersAmount: { $sum: "$paid" },
                                    totalCommissions: { $sum: "$commission" }
                                }
                            }
                        ],
                        transfers: [
                            { $sort: { createdAt: -1, _id: -1 } },
                            { $limit: 10 }
                        ],
                        transfersCount: [
                            { $count: "count" }
                        ]
                    }
                }
            ]);
            const stats = result[0].stats[0] || {
                totalTransfersAmount: 0,
                totalCommissions: 0
            };
            const transfers = result[0].transfers;
            const transfersCount = result[0].transfersCount[0]?.count || 0;
            return {
                msg: getSuitableTranslations("Get Daily Restrictions Process Has Been Successfully !!", language),
                error: false,
                data: {
                    exchangeRates,
                    stats,
                    transfers,
                    transfersCount,
                },
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getDailyRestrictionsTransfers(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "accounting_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const startOfToday = new Date();
            startOfToday.setUTCHours(0, 0, 0, 0);
            const endOfToday = new Date();
            endOfToday.setUTCHours(23, 59, 59, 999);
            filters.createdAt = { $gte: startOfToday, $lte: endOfToday };
            filters.status = { $in: ["full-paid", "under-paid", "over-paid"] };
            const transfers = await transferModel.find(filters, { __v: false }).sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize).populate("sender", { twoFA: false, password: false, __v: false }).populate("paymentMethod", { __v: false });
            if (transfers.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Daily Restrictions Transfers Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        transfers,
                        transfersCount: await transferModel.countDocuments(filters),
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Transfers Were Found !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getAccountingRestrictions(adminId, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "accounting_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (filters.fromDate && filters.toDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.fromDate;
                delete filters.toDate;
            } else if (filters.fromDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate) };
                delete filters.fromDate;
            } else if (filters.toDate) {
                filters.createdAt = { $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.toDate;
            }
            const result = await transferModel.aggregate([
                {
                    $match: {
                        status: { $in: ["full-paid", "under-paid", "over-paid"] },
                        ...filters
                    }
                },
                {
                    $addFields: {
                        commission: {
                            $multiply: ["$paid", { $divide: ["$fee", 100] }]
                        }
                    }
                },
                {
                    $facet: {
                        totals: [
                            {
                                $group: {
                                    _id: null,
                                    totalPaidAmount: { $sum: "$paid" },
                                    totalCommissions: { $sum: "$commission" }
                                }
                            }
                        ],
                        lastTransfer: [
                            { $sort: { createdAt: -1, _id: -1 } },
                            { $limit: 1 }
                        ]
                    }
                }
            ]);
            const totals = result[0].totals[0] || {
                totalPaidAmount: 0,
                totalCommissions: 0
            };
            const lastTransfer = result[0].lastTransfer[0] || null;
            return {
                msg: getSuitableTranslations("Get Accounting Restrictions Process Has Been Successfully !!", language),
                error: false,
                data: {
                    totals,
                    lastTransfer
                },
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getFinancialRestrictionsGlobalStats(adminId, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "accounting_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (filters.fromDate && filters.toDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.fromDate;
                delete filters.toDate;
            } else if (filters.fromDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate) };
                delete filters.fromDate;
            } else if (filters.toDate) {
                filters.createdAt = { $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.toDate;
            }
            const result = await transferModel.aggregate([
                {
                    $match: {
                        status: { $in: ["full-paid", "under-paid", "over-paid"] },
                        ...filters
                    }
                },
                {
                    $addFields: {
                        commission: {
                            $multiply: ["$paid", { $divide: ["$fee", 100] }]
                        }
                    }
                },
                {
                    $group: {
                        _id: null,
                        totalPaid: { $sum: "$paid" },
                        totalCommissions: { $sum: "$commission" },
                        totalSYP: {
                            $sum: {
                                $cond: [
                                    { $eq: ["$paymentMethod.symbol", "SYP"] },
                                    "$paid",
                                    0
                                ]
                            }
                        },
                        totalUSD: {
                            $sum: {
                                $cond: [
                                    { $eq: ["$paymentMethod.symbol", "USD"] },
                                    "$paid",
                                    0
                                ]
                            }
                        }
                    }
                },
                {
                    $project: {
                        _id: 0,
                        totalPaid: 1,
                        totalCommissions: 1,
                        sypPercentage: {
                            $cond: [
                                { $eq: ["$totalPaid", 0] },
                                0,
                                { $multiply: [{ $divide: ["$totalSYP", "$totalPaid"] }, 100] }
                            ]
                        },
                        usdPercentage: {
                            $cond: [
                                { $eq: ["$totalPaid", 0] },
                                0,
                                { $multiply: [{ $divide: ["$totalUSD", "$totalPaid"] }, 100] }
                            ]
                        }
                    }
                }
            ]);
            const stats = result[0] || {
                totalPaid: 0,
                totalCommissions: 0,
                sypPercentage: 0,
                usdPercentage: 0
            };
            return {
                msg: getSuitableTranslations("Get Financial Restrictions Global Stats Process Has Been Successfully !!", language),
                error: false,
                data: stats,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getFinancialRestrictionsUsersStats(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "accounting_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (filters.fromDate && filters.toDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.fromDate;
                delete filters.toDate;
            } else if (filters.fromDate) {
                filters.createdAt = { $gte: new Date(filters.fromDate) };
                delete filters.fromDate;
            } else if (filters.toDate) {
                filters.createdAt = { $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.toDate;
            }
            const result = await transferModel.aggregate([
                {
                    $match: {
                        status: { $in: ["full-paid", "under-paid", "over-paid"] },
                        ...filters
                    }
                },
                {
                    $lookup: {
                        from: "users",
                        localField: "sender",
                        foreignField: "_id",
                        as: "sender"
                    }
                },
                { $unwind: "$sender" },
                {
                    $group: {
                        _id: "$sender._id",
                        name: { $first: "$sender.name" },
                        fatherName: { $first: "$sender.fatherName" },
                        nickname: { $first: "$sender.nickname" },
                        transfersCount: { $sum: 1 },
                        totalPaid: { $sum: "$paid" }
                    }
                },
                { $sort: { transfersCount: -1, _id: -1 } },
                {
                    $setWindowFields: {
                        output: {
                            totalTransfersCount: { $sum: "$transfersCount", window: { documents: ["unbounded", "unbounded"] } },
                            usersCount: { $count: {}, window: { documents: ["unbounded", "unbounded"] } }
                        }
                    }
                },
                {
                    $addFields: {
                        activityRate: {
                            $cond: [
                                { $eq: ["$totalTransfersCount", 0] },
                                0,
                                { $multiply: [{ $divide: ["$transfersCount", "$totalTransfersCount"] }, 100] }
                            ]
                        },
                    }
                },
                { $skip: (pageNumber - 1) * pageSize },
                { $limit: pageSize },
                {
                    $group: {
                        _id: null,
                        users: { $push: "$$ROOT" }
                    }
                },
                {
                    $project: {
                        _id: 0,
                        users: {
                            _id: 1,
                            name: 1,
                            fatherName: 1,
                            nickname: 1,
                            transfersCount: 1,
                            totalPaid: 1,
                            activityRate: 1,
                        },
                        usersCount: { $first: "$users.usersCount" },
                        totalTransfersCount: { $first: "$users.totalTransfersCount" },
                    }
                }

            ]);
            if (result.length > 0) {
                return {
                    msg: getSuitableTranslations("Get Financial Restrictions Users Stats Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        users: result[0].users,
                        usersCount: result[0].usersCount,
                        totalTransfersCount: result[0].usersCount
                    },
                }
            }
            return {
                msg: getSuitableTranslations("No Data Found !!", language),
                error: false,
                data: [],
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getDailyRestrictions,
    getDailyRestrictionsTransfers,
    getAccountingRestrictions,
    getFinancialRestrictionsGlobalStats,
    getFinancialRestrictionsUsersStats
}