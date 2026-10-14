const complianceAlertModel = require("../../models/client/compliance_alert");

const { getSuitableTranslations } = require("../translation");

const { screenParty, normalizeName, logCompliance } = require("./screening");
const { checkVelocityLimits, getUserTransferUsage } = require("./velocity");

const { EDD_AMOUNT_THRESHOLD, SCREENING_ENABLED } = require("../../constants/compliance");

// The single gate every transfer passes through before it is created.
//
// It answers one question - may this transfer proceed? - and leaves an audit
// record either way. Deliberately placed before any wallet is generated, so a
// blocked transfer never produces a deposit address.

async function recordAlert(fields) {
    try {
        return await complianceAlertModel.create(fields);
    }
    catch (err) {
        // An alert that cannot be written must never silently disappear: log
        // it so it is at least recoverable from the server logs.
        logCompliance("failed to persist alert", {
            type: fields?.type,
            user: String(fields?.user || ""),
            reason: err?.message || "unknown",
        });
        return null;
    }
}

// A reviewer who clears a false positive (common with transliterated Arabic
// names) should not have to clear it again on every later transfer.
async function hasClearedScreeningDecision(userId, partyType, screenedName) {
    const cleared = await complianceAlertModel.findOne({
        user: userId,
        partyType,
        screenedName: normalizeName(screenedName),
        type: { $in: ["sanctions-hit", "sanctions-review"] },
        status: "cleared",
    }).select({ _id: 1 }).lean();
    return Boolean(cleared);
}

async function screenAndRecord({ userId, partyType, name, countryCode }) {
    // Off until an operator has verified a reachable provider. The velocity
    // limits below still apply, so turning this off does not disable the whole
    // gate - it only skips list matching.
    if (!SCREENING_ENABLED) {
        return { blocked: false };
    }

    const normalized = normalizeName(name);
    const result = await screenParty(name, countryCode);

    if (result.decision === "pass") {
        return { blocked: false };
    }

    if (!result.available) {
        await recordAlert({
            type: "screening-unavailable",
            severity: "high",
            user: userId,
            partyType,
            screenedName: normalized,
            details: `Screening provider unavailable (${result.reason}). Transfer ${result.decision === "block" ? "blocked" : "allowed"} by COMPLIANCE_SCREENING_FAIL_OPEN policy.`,
            blockedTransfer: result.decision === "block",
        });
        return {
            blocked: result.decision === "block",
            message: "Sorry, Compliance Checks Are Temporarily Unavailable, Please Try Again Later !!",
        };
    }

    if (await hasClearedScreeningDecision(userId, partyType, name)) {
        logCompliance("screening hit skipped by earlier clearance", { user: String(userId), partyType });
        return { blocked: false };
    }

    await recordAlert({
        type: result.decision === "block" ? "sanctions-hit" : "sanctions-review",
        severity: result.decision === "block" ? "high" : "medium",
        user: userId,
        partyType,
        screenedName: normalized,
        matchScore: result.topScore,
        matches: result.matches,
        details: `${partyType} matched a screening list entry with score ${result.topScore.toFixed(2)}.`,
        blockedTransfer: true,
    });

    // Both "block" and "review" stop the transfer. The user-facing wording is
    // intentionally neutral: telling someone they matched a sanctions list is
    // a tipping-off risk, and the message is identical either way.
    return {
        blocked: true,
        message: "Sorry, This Transfer Could Not Be Approved. Please Contact Technical Support !!",
    };
}

/**
 * Run the full pre-transfer compliance gate.
 *
 * @returns {{ error: boolean, msg?: string, code?: string, data: object }}
 *   An error-shaped result matching the repository convention so callers can
 *   return it straight through, plus `data.eddRequired` when the transfer
 *   should be followed up for source of funds.
 */
async function assertTransferAllowed({ user, transfer, toCountryCode, language }) {
    const userId = user._id;

    // 1. Sender. Screened using the name held on the verified KYC record.
    const senderName = [user.name, user.fatherName].filter(Boolean).join(" ");
    const senderResult = await screenAndRecord({
        userId,
        partyType: "sender",
        name: senderName,
        countryCode: user.country,
    });
    if (senderResult.blocked) {
        return {
            msg: getSuitableTranslations(senderResult.message, language),
            error: true,
            code: "COMPLIANCE_BLOCKED",
            data: {},
        };
    }

    // 2. Receiver, screened against the destination country.
    const receiverResult = await screenAndRecord({
        userId,
        partyType: "receiver",
        name: transfer?.receiver?.fullName,
        countryCode: toCountryCode,
    });
    if (receiverResult.blocked) {
        return {
            msg: getSuitableTranslations(receiverResult.message, language),
            error: true,
            code: "COMPLIANCE_BLOCKED",
            data: {},
        };
    }

    // 3. Cumulative limits.
    const velocity = await checkVelocityLimits(
        userId,
        Number(transfer.amount) || 0,
        transfer?.receiver?.mobilePhone
    );

    if (velocity.breached) {
        const primary = velocity.breaches[0];
        await recordAlert({
            type: "velocity-breach",
            severity: "medium",
            user: userId,
            details: `Limits exceeded: ${velocity.breaches.map((b) => `${b.limit} (allowed ${b.allowed}, attempted ${Number(b.attempted).toFixed(2)})`).join("; ")}`,
            blockedTransfer: true,
        });
        const isCountLimit = primary.limit.endsWith("count") || primary.limit.endsWith("receivers");
        return {
            msg: getSuitableTranslations(
                isCountLimit
                    ? "Sorry, You Have Reached The Allowed Number Of Transfers For This Period !!"
                    : "Sorry, This Transfer Exceeds Your Allowed Limit Of {{allowed}} For This Period !!",
                language,
                { allowed: primary.allowed }
            ),
            error: true,
            code: "COMPLIANCE_LIMIT_EXCEEDED",
            data: {},
        };
    }

    // 4. Enhanced due diligence is recorded but never blocks on its own.
    if (velocity.eddRequired) {
        await recordAlert({
            type: "edd-required",
            severity: "low",
            user: userId,
            details: `Transfer amount ${transfer.amount} is at or above the EDD threshold of ${EDD_AMOUNT_THRESHOLD}; source-of-funds evidence should be requested.`,
            blockedTransfer: false,
        });
    }

    return { error: false, data: { eddRequired: velocity.eddRequired } };
}

module.exports = {
    assertTransferAllowed,
    getUserTransferUsage,
    recordAlert,
};
