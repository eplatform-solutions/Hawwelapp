// Import Required Models

const { kycModel } = require("../../models/client");

const { getUserInfo } = require("../../repositories/users");

const { getSuitableTranslations } = require("../../helpers/translation");

const { normalizeKycStatus, getKycGateMessage } = require("../../helpers/kyc_status");

const { clientDB } = require("../../database/connections");

async function assertKycApprovedForTransfer(userId, language) {
    try {
        const kycResult = await getKYC({ user: userId }, language);
        const normalizedStatus = normalizeKycStatus(kycResult.error ? null : kycResult.data);
        if (normalizedStatus === "approved") {
            return {
                msg: getSuitableTranslations("Check From Transfer Limits Process Has Been Successfully !!", language),
                error: false,
                data: {},
            };
        }
        return {
            msg: getKycGateMessage(normalizedStatus),
            error: true,
            code: "KYC_REQUIRED",
            data: {
                kycStatus: normalizedStatus,
            },
        };
    }
    catch (err) {
        throw Error(err);
    }
}

const { unlinkSync } = require("fs");

const KYC_DECISION_FIELDS = [
    "verifiedAt",
    "rejectedAt",
    "rejectionReason",
    "blockedAt",
    "blockingReason",
    "cancelBlockedAt",
    "removeVerifiedAt",
    "removeVerifyingReason",
];

// Old documents used to stay on disk forever after a resubmission.
function unlinkStoredKycFiles(storedPaths) {
    for (const storedPath of storedPaths) {
        try {
            unlinkSync(storedPath);
        }
        catch (err) {
            console.log(`error in delete previous kyc file, path: ${storedPath}`);
        }
    }
}

async function createKYC(authorizationId, filePaths, language) {
    let internalSession = false;
    let dbSession = null;
    try {
        const userResult = await getUserInfo({ _id: authorizationId }, language);
        if (!userResult.error) {
            if (userResult.data.status === "blocked") {
                return {
                    msg: getSuitableTranslations("Sorry, You Have Been Blocked. Please Contact Technical Support !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            const kycResult = await getKYC({ user: authorizationId }, language);
            const normalizedPaths = Array.isArray(filePaths) ? filePaths : [filePaths];
            const primaryPath = normalizedPaths[0];
            const documentImages = normalizedPaths.length > 1 ? normalizedPaths : undefined;

            if (kycResult.error) {
                const newKycInstance = new kycModel({
                    user: userResult.data._id,
                    filePath: primaryPath,
                    ...(documentImages ? { documentImages } : {}),
                });
                if (!dbSession) {
                    dbSession = await clientDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                const newKyc = await newKycInstance.save({ session: dbSession });
                delete newKyc._doc.__v;
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Creating New KYC Request Process Has Been Successfully !!", language),
                    error: false,
                    data: newKyc
                }
            } else {
                if (kycResult.data.status === "verified") {
                    return {
                        msg: getSuitableTranslations("Sorry, Can't Create New KYC Request Because Exist Previous Request And Status Is: Verified !!", language),
                        error: true,
                        data: kycResult.data
                    }
                }
                else if (kycResult.data.status === "under-review") {
                    return {
                        msg: getSuitableTranslations("Sorry, Can't Create New KYC Request Because Exist Previous Request And Status Is: Under Review !!", language),
                        error: true,
                        data: kycResult.data
                    }
                }
                else if (kycResult.data.status === "blocked") {
                    return {
                        msg: getSuitableTranslations("Sorry, Can't Create New KYC Request Because Exist Previous Request And Status Is: Blocked !!", language),
                        error: true,
                        data: kycResult.data
                    }
                } else {
                    const previousPaths = [
                        ...(Array.isArray(kycResult.data.documentImages) ? kycResult.data.documentImages : []),
                        kycResult.data.filePath,
                    ].filter(Boolean);
                    kycResult.data.filePath = primaryPath;
                    kycResult.data.documentImages = documentImages || [];
                    kycResult.data.status = "under-review";
                    // A fresh request must not carry the previous decision -
                    // reviewers were seeing last time's rejection reason on a
                    // brand-new submission.
                    for (const field of KYC_DECISION_FIELDS) {
                        kycResult.data[field] = undefined;
                    }
                    if (!dbSession) {
                        dbSession = await clientDB.startSession();
                        dbSession.startTransaction();
                        internalSession = true;
                    }
                    const kycAfterUpdate = await kycResult.data.save({ session: dbSession });
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    unlinkStoredKycFiles(previousPaths.filter((p) => !normalizedPaths.includes(p)));
                    return {
                        msg: getSuitableTranslations("Creating New KYC Request Process Has Been Successfully !!", language),
                        error: false,
                        data: kycAfterUpdate
                    }
                }
            }
        }
        return userResult;
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
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

module.exports = {
    createKYC,
    getKYC,
    assertKycApprovedForTransfer,
    normalizeKycStatus,
    getKycGateMessage,
}