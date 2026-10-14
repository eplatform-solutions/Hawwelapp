const TRANSACTION_TYPES = ["deposit", "withdraw", "transfer-by-parameter"];

const TRANSACTION_TARGETS = ["external", "by-parameter"];

const TRANSACTION_STATUSES = ["pending", "failed", "completed", "cancelled"];

const TRANSFER_STATUSES = [
    "pending",
    "full-paid",
    "under-paid",
    "over-paid",
    "preparing-address",
    "can-receive",
    "received",
    "cancelled",
    "expired",
    "dispute"
];

const DEFAULT_TRANSACTION_TYPE = TRANSACTION_TYPES[2];

const DEFAULT_TRANSACTION_STATUS = TRANSACTION_STATUSES[0];

const DEFAULT_TRANSFER_STATUS = TRANSFER_STATUSES[0];

const WITHDRAW_STATUES = ["pending", "success", "failed"];

const DEFAULT_WITHDRAW_STATUES = WITHDRAW_STATUES[0];

const WITHDRAW_FAILED_REASONS = [
    "error in get suitable admin wallets for withdraw",
    "error in network fee funding for wallet",
    "error in withdraw from wallet to central wallet"
];

module.exports = {
    TRANSACTION_TYPES,
    TRANSACTION_TARGETS,
    TRANSACTION_STATUSES,
    TRANSFER_STATUSES,
    DEFAULT_TRANSACTION_TYPE,
    DEFAULT_TRANSACTION_STATUS,
    DEFAULT_TRANSFER_STATUS,
    WITHDRAW_STATUES,
    DEFAULT_WITHDRAW_STATUES,
    WITHDRAW_FAILED_REASONS
}