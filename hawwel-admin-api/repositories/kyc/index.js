// Import Required Models

const { adminModel } = require("../../models/dashboard");

const { kycModel, notificationModel, userModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { sendNotification } = require("../../helpers/notifications");

const { buildCustomerStatusPushText } = require("../../helpers/notifications/customer_status_text");

const {
    resolveKycImagePaths,
    resolveClientKycAbsolutePath,
    getContentTypeFromStoredPath,
} = require("../../helpers/kyc_files");

const { clientDB } = require("../../database/connections");

// Push/in-app copy for KYC decisions, matching the exact convention used for
// transfer status notifications (title/body are translation keys looked up
// client-side by hawwel-mobile's AppTranslations, not literal text).
const KYC_STATUS_NOTIFICATIONS = {
    "verified": {
        title: "KYC Approved",
        body: "notification_kyc_approved",
    },
    "rejected": {
        title: "KYC Rejected",
        body: "notification_kyc_rejected",
    },
    "blocked": {
        title: "KYC Blocked",
        body: "notification_kyc_blocked",
    },
    "cancel-blocked": {
        title: "KYC Unblocked",
        body: "notification_kyc_unblocked",
    },
    "remove-verified": {
        title: "KYC Verification Removed",
        body: "notification_kyc_remove_verified",
    },
};

async function notifyCustomerOfKycStatusChange(kyc, extraData = {}) {
    const notice = KYC_STATUS_NOTIFICATIONS[kyc.status];
    if (!notice) return;
    try {
        const data = {
            kycId: String(kyc._id),
            status: String(kyc.status || ""),
            ...extraData,
        };
        const savedNotification = await new notificationModel({
            userId: kyc.user,
            title: notice.title,
            body: notice.body,
            data,
        }).save();

        const user = await userModel.findById(kyc.user, { notificationsToken: 1 });
        if (user?.notificationsToken) {
            try {
                const pushText = buildCustomerStatusPushText("kyc", kyc.status, data);
                await sendNotification({
                    title: pushText?.title || notice.title,
                    body: pushText?.body || notice.body,
                    data,
                    token: user.notificationsToken,
                });
            }
            catch (pushErr) {
                savedNotification.pushDeliveryFailed = true;
                savedNotification.pushDeliveryError = String(pushErr?.message || pushErr).slice(0, 500);
                await savedNotification.save();
            }
        }
    }
    catch (err) {
        console.log("Send KYC Status Notification Failed:", err);
    }
}

async function getKYC(filters, language) {
    try {
        const kyc = await kycModel.findOne(filters);
        if (kyc) {
            return {
                msg: getSuitableTranslations("Get KYC For This User Process Has Been Successfully !!"),
                error: false,
                data: kyc
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This KYC Not Exist !!", language),
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getAllKYCsInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "kycs_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            let mainFilters = {};
            if (filters.status) {
                mainFilters.status = filters.status;
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
                        from: "users",
                        localField: "user",
                        foreignField: "_id",
                        as: "user"
                    }
                },
                { $unwind: "$user" },
                {
                    $project: {
                        _id: 1,
                        user: {
                            _id: "$user._id",
                            name: "$user.name",
                            nickname: "$user.nickname",
                            fatherName: "$user.fatherName",
                            country: "$user.country",
                            mobilePhone: "$user.mobilePhone",
                            email: "$user.email",
                        },
                        filePath: 1,
                        documentImages: 1,
                        status: 1,
                        createdAt: 1,
                        verifiedAt: 1,
                        rejectedAt: 1,
                        rejectionReason: 1,
                        blockedAt: 1,
                        blockingReason: 1,
                        cancelBlockedAt: 1,
                        removeVerifiedAt: 1,
                        removeVerifyingReason: 1,
                    }
                },
                ...(filters.country ? [{
                    $match: {
                        "user.country": filters.country
                    }
                }] : []),
                {
                    $facet: {
                        kycs: [
                            { $sort: { createdAt: -1, _id: -1 } },
                            { $skip: (pageNumber - 1) * pageSize },
                            { $limit: pageSize },
                        ],
                        kycsCount: [
                            { $count: "count" }
                        ]
                    }
                },
                {
                    $project: {
                        kycs: 1,
                        kycsCount: {
                            $ifNull: [
                                { $arrayElemAt: ["$kycsCount.count", 0] },
                                0
                            ]
                        }
                    }
                }
            ];
            const kycsResult = await kycModel.aggregate(paginatedPipeline);
            if (kycsResult.length > 0 && kycsResult[0]?.kycs.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All KYCs Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        kycs: kycsResult[0].kycs,
                        kycsCount: kycsResult[0].kycsCount,
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No KYCs Were Found !!", language),
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

async function approveKYC(adminId, kycId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "kycs_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const kyc = await kycModel.findById(kycId);
            if (kyc) {
                if (kyc.status === "verified") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Is Already Approved !!", language),
                        error: true,
                        data: {},
                    }
                }
                if (kyc.status !== "under-review") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Status Is Not Under Review !!", language),
                        error: true,
                        data: {},
                    }
                }
                kyc.status = "verified";
                kyc.verifiedAt = Date.now();
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await kyc.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                await notifyCustomerOfKycStatusChange(kyc);
                return {
                    msg: getSuitableTranslations("Approving On This KYC Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This KYC Not Exist !!", language),
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
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function rejectKYC(adminId, kycId, rejectionReason, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "kycs_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const kyc = await kycModel.findById(kycId);
            if (kyc) {
                if (kyc.status === "rejected") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Is Already Rejected !!", language),
                        error: true,
                        data: {},
                    }
                }
                if (kyc.status !== "under-review") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Status Is Not Under Review !!", language),
                        error: true,
                        data: {},
                    }
                }
                kyc.status = "rejected";
                kyc.rejectedAt = Date.now();
                kyc.rejectionReason = rejectionReason;
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await kyc.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                await notifyCustomerOfKycStatusChange(kyc, { rejectionReason: String(rejectionReason || "") });
                return {
                    msg: getSuitableTranslations("Rejecting KYC Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        filePath: kyc.filePath,
                        documentImages: kyc.documentImages,
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This KYC Not Exist !!", language),
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
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function removeKycVerifying(adminId, kycId, removeVerifyingReason, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "kycs_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const kyc = await kycModel.findById(kycId);
            if (kyc) {
                if (kyc.status === "remove-verified") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Is Already Remove verified !!", language),
                        error: true,
                        data: {},
                    }
                }
                if (kyc.status !== "verified") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Is Not verified !!", language),
                        error: true,
                        data: {},
                    }
                }
                kyc.status = "remove-verified";
                kyc.removeVerifiedAt = Date.now();
                kyc.removeVerifyingReason = removeVerifyingReason;
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await kyc.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                await notifyCustomerOfKycStatusChange(kyc, { removeVerifyingReason: String(removeVerifyingReason || "") });
                return {
                    msg: getSuitableTranslations("Remove KYC Verifying Process Has Been Successfully !!", language),
                    error: false,
                    data: {
                        filePath: kyc.filePath,
                        documentImages: kyc.documentImages,
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This KYC Not Exist !!", language),
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
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function blockingKYC(adminId, kycId, blockingReason, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "kycs_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const kyc = await kycModel.findById(kycId);
            if (kyc) {
                if (kyc.status === "blocked") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Is Already Blocked !!", language),
                        error: true,
                        data: {},
                    }
                }
                kyc.status = "blocked";
                kyc.blockedAt = Date.now();
                kyc.blockingReason = blockingReason;
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await kyc.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                await notifyCustomerOfKycStatusChange(kyc, { blockingReason: String(blockingReason || "") });
                return {
                    msg: getSuitableTranslations("Blocking KYC Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This KYC Not Exist !!", language),
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
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function getKycFileForAdmin(adminId, kycId, fileIndex, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            };
        }
        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "kycs_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }
        const kyc = await kycModel.findById(kycId, { filePath: 1, documentImages: 1 });
        if (!kyc) {
            return {
                msg: getSuitableTranslations("Sorry, This KYC Not Exist !!", language),
                error: true,
                data: {},
            };
        }
        const imagePaths = resolveKycImagePaths(kyc);
        const storedPath = imagePaths[fileIndex];
        if (!storedPath) {
            return {
                msg: getSuitableTranslations("Sorry, This KYC File Is Not Available !!", language),
                error: true,
                data: {},
            };
        }
        const absolutePath = resolveClientKycAbsolutePath(storedPath);
        if (!absolutePath) {
            return {
                msg: getSuitableTranslations("Sorry, This KYC File Is Not Available !!", language),
                error: true,
                data: {},
            };
        }
        return {
            msg: getSuitableTranslations("Get KYC For This User Process Has Been Successfully !!", language),
            error: false,
            data: {
                absolutePath,
                contentType: getContentTypeFromStoredPath(storedPath),
                fileName: storedPath.split("/").pop(),
            },
        };
    }
    catch (err) {
        throw Error(err);
    }
}

async function cancelBlockingKYC(adminId, kycId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "kycs_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const kyc = await kycModel.findById(kycId);
            if (kyc) {
                if (kyc.status === "cancel-blocked") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Is Already Cancel Blocked !!", language),
                        error: true,
                        data: {},
                    }
                }
                if (kyc.status !== "blocked") {
                    return {
                        msg: getSuitableTranslations("Sorry, This KYC Is Not Blocked !!", language),
                        error: true,
                        data: {},
                    }
                }
                kyc.status = "cancel-blocked";
                kyc.cancelBlockedAt = Date.now();
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await kyc.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                await notifyCustomerOfKycStatusChange(kyc);
                return {
                    msg: getSuitableTranslations("Cancel Blocking KYC Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This KYC Not Exist !!", language),
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
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

module.exports = {
    getKYC,
    getAllKYCsInsideThePage,
    getKycFileForAdmin,
    approveKYC,
    rejectKYC,
    removeKycVerifying,
    blockingKYC,
    cancelBlockingKYC
}