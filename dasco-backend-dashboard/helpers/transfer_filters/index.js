const { UNRESOLVED_TRANSFER_STATUSES } = require("../../constants/transactions");

// Both transfer-listing endpoints (admin and employee) accept "active" and
// "unresolved" in place of a real status value, so the main list can leave
// out transfers nothing has happened to yet without either endpoint
// re-implementing the same $nin/$in translation. Any other value (a real
// status, or nothing) passes through untouched.
function resolveTransferStatusFilter(rawStatus) {
    if (rawStatus === "active") {
        return { $nin: UNRESOLVED_TRANSFER_STATUSES };
    }
    if (rawStatus === "unresolved") {
        return { $in: UNRESOLVED_TRANSFER_STATUSES };
    }
    return rawStatus;
}

module.exports = {
    resolveTransferStatusFilter,
}
