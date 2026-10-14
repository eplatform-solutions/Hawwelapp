// Import Required Models

const { adminModel } = require("../../models/dashboard");

const { complianceAlertModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { RESOLVABLE_STATUSES } = require("../../constants/compliance");

// Review queue for the compliance alerts the client API raises when it stops a
// transfer. Alerts are never deleted - an auditor asks for the decision trail,
// so resolving one records who decided, when, and why.

async function getAllComplianceAlertsInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "compliance_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            let mainFilters = {};
            if (filters.status) {
                mainFilters.status = filters.status;
            }
            if (filters.type) {
                mainFilters.type = filters.type;
            }
            if (filters.severity) {
                mainFilters.severity = filters.severity;
            }
            if (filters.fromDate && filters.toDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
            } else if (filters.fromDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate) };
            } else if (filters.toDate) {
                mainFilters.createdAt = { $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
            }
            const paginatedPipeline = [
                { $match: mainFilters },
                {
                    $lookup: {
                        from: "users",
                        localField: "user",
                        foreignField: "_id",
                        as: "user"
                    }
                },
                // A user that was hard-deleted must not make its alerts vanish
                // from the audit trail, so the join is preserving.
                { $unwind: { path: "$user", preserveNullAndEmptyArrays: true } },
                {
                    $lookup: {
                        from: "transfers",
                        localField: "transfer",
                        foreignField: "_id",
                        as: "transfer"
                    }
                },
                { $unwind: { path: "$transfer", preserveNullAndEmptyArrays: true } },
                {
                    $project: {
                        _id: 1,
                        type: 1,
                        severity: 1,
                        status: 1,
                        partyType: 1,
                        screenedName: 1,
                        matchScore: 1,
                        matches: 1,
                        details: 1,
                        blockedTransfer: 1,
                        reviewedAt: 1,
                        reviewNote: 1,
                        createdAt: 1,
                        user: {
                            _id: "$user._id",
                            name: "$user.name",
                            nickname: "$user.nickname",
                            fatherName: "$user.fatherName",
                            country: "$user.country",
                            mobilePhone: "$user.mobilePhone",
                            email: "$user.email",
                            status: "$user.status",
                        },
                        transfer: {
                            _id: "$transfer._id",
                            transferNumber: "$transfer.transferNumber",
                            amount: "$transfer.amount",
                            currencyName: "$transfer.currencyName",
                            status: "$transfer.status",
                        },
                        reviewedBy: 1,
                    }
                },
                {
                    $facet: {
                        alerts: [
                            // Unreviewed and most severe first: this is a work
                            // queue, not a log viewer.
                            //
                            // _id breaks ties. One transfer can raise several
                            // alerts in the same millisecond (sender and
                            // receiver, or velocity and EDD), and a sort on
                            // createdAt alone is not stable across queries -
                            // so paging could show one alert twice and skip
                            // another entirely, which in a review queue means
                            // an alert nobody ever looks at.
                            { $sort: { status: 1, createdAt: -1, _id: -1 } },
                            { $skip: (pageNumber - 1) * pageSize },
                            { $limit: pageSize },
                        ],
                        alertsCount: [
                            { $count: "count" }
                        ]
                    }
                },
                {
                    $project: {
                        alerts: 1,
                        alertsCount: {
                            $ifNull: [
                                { $arrayElemAt: ["$alertsCount.count", 0] },
                                0
                            ]
                        }
                    }
                }
            ];
            const alertsResult = await complianceAlertModel.aggregate(paginatedPipeline);
            const alerts = alertsResult.length > 0 ? alertsResult[0].alerts : [];
            const alertsCount = alertsResult.length > 0 ? alertsResult[0].alertsCount : 0;
            if (alerts.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Compliance Alerts Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        alerts,
                        alertsCount,
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Page Is Not Found !!", language),
                error: true,
                data: {
                    alerts: [],
                    alertsCount,
                },
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

/**
 * Counts per status, so the dashboard can show an "open alerts" badge without
 * pulling the whole list.
 */
async function getComplianceAlertsStats(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "compliance_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const rows = await complianceAlertModel.aggregate([
                { $group: { _id: { status: "$status", severity: "$severity" }, count: { $sum: 1 } } },
            ]);
            const stats = { open: 0, cleared: 0, confirmed: 0, openHighSeverity: 0 };
            for (const row of rows) {
                const status = row?._id?.status;
                if (status && stats[status] !== undefined) {
                    stats[status] += row.count;
                }
                if (status === "open" && row?._id?.severity === "high") {
                    stats.openHighSeverity += row.count;
                }
            }
            return {
                msg: getSuitableTranslations("Get Compliance Alerts Stats Process Has Been Successfully !!", language),
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
    }
    catch (err) {
        throw Error(err);
    }
}

/**
 * Record a decision on an alert.
 *
 * "cleared"   - a false positive. For a screening alert this also stops the
 *               same name being re-raised for that user on later transfers,
 *               because the client API looks for exactly this record.
 * "confirmed" - a real hit. Recorded only; blocking the customer stays a
 *               separate, deliberate action on the users screen so that one
 *               click here cannot lock an account out by accident.
 */
async function resolveComplianceAlert(adminId, alertId, status, reviewNote, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "compliance_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (!RESOLVABLE_STATUSES.includes(status)) {
                return {
                    msg: getSuitableTranslations("Sorry, Invalid Compliance Alert Status !!", language),
                    error: true,
                    data: {},
                }
            }
            const alert = await complianceAlertModel.findById(alertId);
            if (alert) {
                if (alert.status !== "open") {
                    return {
                        msg: getSuitableTranslations("Sorry, This Compliance Alert Is Already Reviewed !!", language),
                        error: true,
                        data: {},
                    }
                }
                alert.status = status;
                alert.reviewedBy = admin._id;
                alert.reviewedAt = Date.now();
                if (reviewNote) {
                    alert.reviewNote = reviewNote;
                }
                await alert.save();
                return {
                    msg: getSuitableTranslations("Reviewing This Compliance Alert Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        _id: alert._id,
                        status: alert.status,
                        reviewedAt: alert.reviewedAt,
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Compliance Alert Is Not Exist !!", language),
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
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getAllComplianceAlertsInsideThePage,
    getComplianceAlertsStats,
    resolveComplianceAlert,
}
