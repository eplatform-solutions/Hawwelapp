const KYC_STATUSES = ["under-review", "verified", "rejected", "remove-verified", "blocked", "cancel-blocked"];

const DEFAULT_KYC_STATUS = KYC_STATUSES[0];

module.exports = {
    KYC_STATUSES,
    DEFAULT_KYC_STATUS
}