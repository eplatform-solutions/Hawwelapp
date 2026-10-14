// Import Required Models

const { adminModel, loginLogModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const mongoose = require("mongoose");

async function getAllLogsInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "login_logs_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            let mainFilters = {};
            if (filters._id) {
                mainFilters._id = new mongoose.Types.ObjectId(filters._id);
            }
            if (filters.userId) {
                mainFilters.user = new mongoose.Types.ObjectId(filters.userId);
            }
            if (filters.ipAddress) {
                mainFilters.ipAddress = filters.ipAddress;
            }
            if (filters.fromDate && filters.toDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.fromDate;
                delete filters.toDate;
            } else if (filters.fromDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate) };
                delete filters.fromDate;
            } else if (filters.toDate) {
                mainFilters.createdAt = { $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
                delete filters.toDate;
            }
            const basePipeline = [
                { $match: mainFilters },
            ];
            const paginatedPipeline = [
                ...basePipeline,
                {
                    $lookup: {
                        from: "admins",
                        localField: "user",
                        foreignField: "_id",
                        as: "admin"
                    }
                },
                { $unwind: "$admin" },
                {
                    $project: {
                        _id: 1,
                        ipAddress: 1,
                        user: {
                            _id: "$admin._id",
                            userName: "$admin.userName",
                        },
                        createdAt: 1
                    }
                },
                ...(filters.userName ? [{
                    $match: {
                        "user.userName": filters.userName
                    }
                }] : []),
                {
                    $facet: {
                        logs: [
                            { $sort: { createdAt: -1, _id: -1 } },
                            { $skip: (pageNumber - 1) * pageSize },
                            { $limit: pageSize },
                        ],
                        logsCount: [
                            { $count: "count" }
                        ]
                    }
                },
                {
                    $project: {
                        logs: 1,
                        logsCount: {
                            $ifNull: [
                                { $arrayElemAt: ["$logsCount.count", 0] },
                                0
                            ]
                        }
                    }
                }
            ];
            const logsResult = await loginLogModel.aggregate(paginatedPipeline);
            if (logsResult.length > 0 && logsResult[0]?.logs.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Login Logs Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        logs: logsResult[0].logs,
                        logsCount: logsResult[0].logsCount,
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Login Logs Were Found !!", language),
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

module.exports = {
    getAllLogsInsideThePage,
}