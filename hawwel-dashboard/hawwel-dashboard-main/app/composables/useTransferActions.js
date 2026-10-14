// Shared status logic and status-change actions for transfer tables.
// Both employee-transfers.vue and remittances.vue render the same transfer
// data with the same set of possible actions - keeping this in one place
// means a future status/action change only needs to happen once instead of
// being copied (and inevitably drifting) across both pages.

const STATUS_COLORS = {
    "pending": "#83887E",
    "under-paid": "#C1622A",
    "over-paid": "#2E6E9E",
    "full-paid": "#2F8F5B",
    "preparing-address": "#5B57B8",
    "can-receive": "#1B8C96",
    "received": "#097F6E",
    "cancelled": "#B23A2E",
    "expired": "#8C6A4E",
    "dispute": "#7C3AED",
};

export function useTransferActions({ axios, store, t, locale, BASE_URL, handelErrorType }) {
    function statusColor(status) {
        return STATUS_COLORS[status] || STATUS_COLORS.pending;
    }

    // A transfer is eligible for delivery once real money has arrived,
    // regardless of whether it matched the requested amount exactly. Money
    // that arrived under or over the request is never relabeled "full-paid"
    // to unblock delivery - the deliverable value (netAmount) is already
    // computed from the amount actually received (see repositories/deposits
    // on the backend), so the status can stay honest all the way through.
    // A disputed transfer becomes eligible again once the dispute is
    // resolved in the customer's favor.
    const canSetPreparingAddress = (status) => ["full-paid", "under-paid", "over-paid", "dispute"].includes(status);
    const canSetCanReceive = (status) => ["full-paid", "under-paid", "over-paid", "dispute", "preparing-address"].includes(status);
    const canSetReceived = (status) => status === "can-receive";
    // Cancellation is only offered before the delivery workflow starts; once an
    // address has been prepared or shared, cancelling needs the delivery flow
    // itself, not this shortcut. A disputed transfer can also be cancelled
    // directly if that's how it gets resolved.
    const canCancelTransfer = (status) => ["pending", "under-paid", "over-paid", "full-paid", "dispute"].includes(status);
    // A dispute can be opened on any transfer that hasn't already reached a
    // terminal state or isn't already disputed.
    const canOpenDispute = (status) => ["pending", "under-paid", "over-paid", "full-paid", "preparing-address", "can-receive"].includes(status);

    // The single most useful next step for a row, used to pick which action
    // (if any) gets a full-width primary button instead of living in the
    // overflow menu.
    function primaryAction(status) {
        if (canSetPreparingAddress(status)) return "preparing-address";
        if (canSetCanReceive(status)) return "can-receive";
        if (canSetReceived(status)) return "received";
        return null;
    }

    async function updateTransferStatus(item, newStatus, statusChangeNote) {
        const token = store.getToken;
        if (!newStatus || newStatus === item.status) return;
        try {
            const apiUrl = `${BASE_URL}/transfers/update-status/${item._id}`;
            const response = await axios.post(
                apiUrl,
                statusChangeNote ? { status: newStatus, statusChangeNote } : { status: newStatus },
                { headers: { Authorization: `Bearer ${token}` } }
            );

            if (response.data?.error) {
                alert(locale.value == "ar" ? (response.data.msg?.ar ?? response.data.msg) : (response.data.msg?.en ?? response.data.msg));
                return;
            }

            item.status = newStatus;
            if (response.data?.data?.transfer) {
                item.paid = response.data.data.transfer.paid;
                item.netAmount = response.data.data.transfer.netAmount;
                item.paidAt = response.data.data.transfer.paidAt;
            }
        } catch (error) {
            alert(handelErrorType(error));
        }
    }

    async function cancelTransfer(item) {
        const note = window.prompt(t("Enter a reason for cancelling this transfer"));
        if (note === null) return;
        if (!String(note).trim()) {
            alert(locale.value == "ar" ? "يجب إدخال سبب الإلغاء" : "A cancellation reason is required");
            return;
        }
        if (!confirm(t("Are you sure you want to cancel this transfer?"))) return;
        await updateTransferStatus(item, "cancelled", note.trim());
    }

    async function openDispute(item) {
        const note = window.prompt(t("Enter a reason for disputing this transfer"));
        if (note === null) return;
        if (!String(note).trim()) {
            alert(locale.value == "ar" ? "يجب إدخال سبب الخلاف" : "A dispute reason is required");
            return;
        }
        await updateTransferStatus(item, "dispute", note.trim());
    }

    return {
        statusColor,
        primaryAction,
        canCancelTransfer,
        canOpenDispute,
        updateTransferStatus,
        cancelTransfer,
        openDispute,
    };
}
