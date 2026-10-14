const {
    ALERT_TYPES,
    ALERT_STATUSES,
    ALERT_SEVERITIES,
    RESOLVABLE_STATUSES,
} = require("../../constants/compliance");

const { getResponseObject } = require("../../helpers/responses");

function rejectWith(res, label, allowed) {
    return res.json(getResponseObject(
        `Sorry, Please Send Valid ${label} ( any value in array: ['${allowed.join("', '")}'] ) !!`,
        true,
        {}
    ));
}

// Filter value coming from the query string: any of the stored statuses.
function validateAlertStatusFilter(status, res, next) {
    if (!ALERT_STATUSES.includes(status)) {
        return rejectWith(res, "Compliance Alert Status", ALERT_STATUSES);
    }
    next();
}

// Target value for a review decision: "open" is the initial state, not a
// decision, so it is deliberately not accepted here.
function validateResolveStatus(status, res, next) {
    if (!RESOLVABLE_STATUSES.includes(status)) {
        return rejectWith(res, "Compliance Alert Review Status", RESOLVABLE_STATUSES);
    }
    next();
}

function validateAlertType(type, res, next) {
    if (!ALERT_TYPES.includes(type)) {
        return rejectWith(res, "Compliance Alert Type", ALERT_TYPES);
    }
    next();
}

function validateAlertSeverity(severity, res, next) {
    if (!ALERT_SEVERITIES.includes(severity)) {
        return rejectWith(res, "Compliance Alert Severity", ALERT_SEVERITIES);
    }
    next();
}

module.exports = {
    validateAlertStatusFilter,
    validateResolveStatus,
    validateAlertType,
    validateAlertSeverity,
}
