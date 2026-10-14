const { transferModel, userModel } = require("../../models/client");

const {
    resolveOriginatorAddress,
    buildTravelRuleRecord,
    isTravelRuleRecordComplete,
    logTravelRule,
} = require("../../helpers/travel_rule");

/**
 * Capture the Transfer of Funds Regulation record for a transfer whose deposit
 * has just landed.
 *
 * Runs once per deposit and is safe to re-run: re-recording overwrites with
 * the same facts, and a later run can fill in an address an earlier one failed
 * to resolve (a node that was briefly unreachable, for example).
 */
async function recordTravelRuleForDeposit({ transferId, network, txId, depositAddress }) {
    const transfer = await transferModel.findById(transferId);
    if (!transfer) {
        logTravelRule("transfer not found", { transferId: String(transferId) });
        return { error: true, data: {} };
    }

    // Already captured with a resolved address: nothing to improve.
    if (transfer.travelRule?.originatorAddressResolved && transfer.travelRule?.complete) {
        return { error: false, data: transfer.travelRule };
    }

    const user = await userModel.findById(transfer.sender, {
        name: 1, fatherName: 1, country: 1, accountNumber: 1,
    });

    const originator = await resolveOriginatorAddress(network, txId, depositAddress);

    const record = buildTravelRuleRecord({
        user,
        transfer,
        network,
        txId,
        originator,
    });
    record.complete = isTravelRuleRecordComplete(record);

    transfer.travelRule = record;
    await transfer.save();

    logTravelRule(record.complete ? "record captured" : "record incomplete", {
        transferId: String(transferId),
        originatorResolved: record.originatorAddressResolved,
        selfHostedVerificationRequired: record.selfHostedVerificationRequired,
    });

    return { error: false, data: record };
}

module.exports = {
    recordTravelRuleForDeposit,
};
