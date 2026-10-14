// Import Required Models

const { adminModel } = require("../../models/dashboard");

const { transferModel, notificationModel, userModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { calculateNetAmount } = require("../../helpers/money");

const { sendNotification } = require("../../helpers/notifications");

const { resolveTransferStatusFilter } = require("../../helpers/transfer_filters");

// Push/in-app copy for the transfer statuses that the customer needs to
// hear about as soon as staff set them - the title/body are translation
// keys looked up client-side (see dasco-mobile-new AppTranslations), not
// literal text, matching the convention already used for deposit and
// payment-proof notifications.
const CUSTOMER_FACING_STATUS_NOTIFICATIONS = {
    "preparing-address": {
        title: "Order Process",
        body: "notification_preparing_address",
    },
    "can-receive": {
        title: "Transfer Ready",
        body: "notification_can_receive",
    },
    "received": {
        title: "Transfer Received",
        body: "notification_received",
    },
    "cancelled": {
        title: "Transfer Cancelled",
        body: "notification_cancelled",
    },
    "dispute": {
        title: "Transfer Disputed",
        body: "notification_dispute",
    },
};

async function notifyCustomerOfStatusChange(transfer) {
    const notice = CUSTOMER_FACING_STATUS_NOTIFICATIONS[transfer.status];
    if (!notice) return;
    try {
        const data = {
            transferId: String(transfer._id),
            transferNumber: String(transfer.transferNumber || ""),
            status: String(transfer.status || ""),
            amount: String(transfer.amount || 0),
            symbol: String(transfer.symbol || ""),
        };
        const savedNotification = await new notificationModel({
            userId: transfer.sender,
            title: notice.title,
            body: notice.body,
            data,
        }).save();

        const sender = await userModel.findById(transfer.sender, { notificationsToken: 1 });
        if (sender?.notificationsToken) {
            try {
                await sendNotification({
                    title: notice.title,
                    body: notice.body,
                    data,
                    token: sender.notificationsToken,
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
        console.log("Send Transfer Status Notification Failed:", err);
    }
}

async function getAllTransfersInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "transfers_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            if (filters.status) {
                filters.status = resolveTransferStatusFilter(filters.status);
            }
            if (filters.today) {
                const today = new Date();
                filters.createdAt = { $gte: new Date(today.setUTCHours(0, 0, 0, 0)), $lte: new Date(today.setUTCHours(23, 59, 59, 999)) };
                delete filters.today;
            } else {
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
            }
            const transfers = await transferModel.find(filters, { __v: false }).sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize).populate("sender", { twoFA: false, password: false, __v: false }).populate("paymentMethod", { __v: false });
            if (transfers.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Transfers For This User Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
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

// Statuses where money has moved, or a decision needs a documented reason
// (payment received in, handed out to the recipient, a transfer cancelled
// after money may already be involved, or a transfer flagged as disputed)
// - these require a note explaining the basis for the change, attributed
// to the admin who made it. Everything else (pending, preparing-address,
// can-receive, expired) is just workflow state and doesn't need one.
const MONEY_AFFECTING_STATUSES = ["full-paid", "under-paid", "over-paid", "received", "cancelled", "dispute"];

async function updateTransferStatus(adminId, transferId, status, statusChangeNote, language) {
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
        const authorizationResult = authorizeAdmin(populatedAdmin, "transfers_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }

        const transfer = await transferModel.findById(transferId);
        if (!transfer) {
            return {
                msg: getSuitableTranslations("Sorry, This Transfer Is Not Exist !!", language),
                error: true,
                data: {},
            };
        }

        if (MONEY_AFFECTING_STATUSES.includes(status) && !String(statusChangeNote || "").trim()) {
            return {
                msg: getSuitableTranslations("Sorry, A Note Explaining This Status Change Is Required For Money-Affecting Statuses !!", language),
                error: true,
                data: {},
            };
        }

        transfer.status = status;
        if (["full-paid", "under-paid", "over-paid"].includes(status)) {
            if (!transfer.paid) {
                transfer.paid = transfer.amount;
            }
            if (!transfer.netAmount) {
                transfer.netAmount = calculateNetAmount(transfer.paid, transfer.fee);
            }
            if (!transfer.paidAt) {
                transfer.paidAt = new Date();
            }
        } else {
            transfer.paidAt = undefined;
        }

        if (MONEY_AFFECTING_STATUSES.includes(status)) {
            transfer.lastStatusChange = {
                adminId: admin._id,
                note: String(statusChangeNote).trim(),
                at: new Date(),
            };
        }

        await transfer.save();

        await notifyCustomerOfStatusChange(transfer);

        return {
            msg: getSuitableTranslations("Updating Transfer Status Process Has Been Successfully !!", language),
            error: false,
            data: {
                transfer,
            },
        };
    } catch (err) {
        throw Error(err);
    }
}

// The two uploads share one multer pipeline and one note field but must
// land in different fields: the receiving-place photo is attached while the
// transfer is still on its way (so the customer knows where to go), the
// payment proof is the handover evidence at the end. Writing both to the
// same field made the second upload delete the first from disk.
const TRANSFER_IMAGE_KINDS = {
    "payment-proof": {
        field: "paymentProofImagePath",
        allowedStatuses: ["full-paid", "preparing-address", "can-receive", "received"],
        notAllowedMsg: "Sorry, Payment Proof Is Allowed For Full-Paid Or Delivery Transfers Only !!",
        successMsg: "Updating Transfer Payment Proof Process Has Been Successfully !!",
        notificationTitle: "Order Payment Proof",
        notificationBody: "Payment proof was added to your order by admin.",
    },
    "receiving-place": {
        field: "receivingPlaceImagePath",
        allowedStatuses: ["full-paid", "preparing-address", "can-receive"],
        notAllowedMsg: "Sorry, Receiving Place Image Is Allowed Before The Transfer Is Received Only !!",
        successMsg: "Updating Transfer Receiving Place Process Has Been Successfully !!",
        notificationTitle: "Order Receiving Place",
        notificationBody: "Receiving place image was added to your order by admin.",
    },
};

async function updateTransferImage(adminId, transferId, paymentProofNote, newImagePath, imageKind, language) {
    const kind = TRANSFER_IMAGE_KINDS[imageKind];
    if (!kind) {
        return {
            msg: getSuitableTranslations("Sorry, This Image Kind Is Not Exist !!", language),
            error: true,
            data: {},
        };
    }
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
        const authorizationResult = authorizeAdmin(populatedAdmin, "transfers_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }

        const transfer = await transferModel.findById(transferId);
        if (!transfer) {
            return {
                msg: getSuitableTranslations("Sorry, This Transfer Is Not Exist !!", language),
                error: true,
                data: {},
            };
        }

        if (!kind.allowedStatuses.includes(transfer.status)) {
            return {
                msg: getSuitableTranslations(kind.notAllowedMsg, language),
                error: true,
                data: {},
            };
        }

        const oldImagePath = transfer[kind.field] || "";
        transfer.paymentProofNote = paymentProofNote;
        transfer[kind.field] = newImagePath;
        await transfer.save();

        await new notificationModel({
            userId: transfer.sender,
            title: kind.notificationTitle,
            body: kind.notificationBody,
            data: {
                transferId: String(transfer._id),
                transferNumber: String(transfer.transferNumber || ""),
                status: String(transfer.status || ""),
                amount: String(transfer.amount || 0),
                paid: String(transfer.paid || 0),
                netAmount: String(transfer.netAmount || 0),
                symbol: String(transfer.symbol || ""),
                paymentProofNote: String(transfer.paymentProofNote || ""),
                paymentProofImagePath: String(transfer.paymentProofImagePath || ""),
                receivingPlaceImagePath: String(transfer.receivingPlaceImagePath || ""),
                receiverFullName: String(transfer.receiver?.fullName || ""),
                receiverMobilePhone: String(transfer.receiver?.mobilePhone || ""),
            },
        }).save();

        return {
            msg: getSuitableTranslations(kind.successMsg, language),
            error: false,
            data: {
                oldImagePath,
                transfer,
            },
        };
    } catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getAllTransfersInsideThePage,
    updateTransferStatus,
    updateTransferImage,
}