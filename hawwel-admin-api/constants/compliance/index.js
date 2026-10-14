// Enum values for compliance alerts. These mirror the client API's
// constants/compliance - the client API owns the thresholds and the screening
// configuration; the dashboard only ever reads and resolves the records, so
// only the shared vocabulary is duplicated here.

const ALERT_TYPES = [
    "sanctions-hit",
    "sanctions-review",
    "screening-unavailable",
    "velocity-breach",
    "edd-required",
];

const ALERT_STATUSES = ["open", "cleared", "confirmed"];

const ALERT_SEVERITIES = ["low", "medium", "high"];

const PARTY_TYPES = ["sender", "receiver"];

// Statuses an admin may move an alert to. "open" is the initial state and is
// not a decision, so it is not a valid target.
const RESOLVABLE_STATUSES = ["cleared", "confirmed"];

module.exports = {
    ALERT_TYPES,
    ALERT_STATUSES,
    ALERT_SEVERITIES,
    PARTY_TYPES,
    RESOLVABLE_STATUSES,
};
