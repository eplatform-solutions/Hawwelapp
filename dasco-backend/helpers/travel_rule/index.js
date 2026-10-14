const { Web3 } = require("web3");

const { ADDRESSES } = require("../../constants/blockchain/contracts");

// Travel Rule (EU Transfer of Funds Regulation 2023/1113).
//
// Every crypto transfer must carry originator and beneficiary information,
// with NO minimum amount - the €1,000 threshold that exists in the old wire
// rules does not apply to crypto. The one place the threshold does appear is
// transfers from a self-hosted wallet, where above €1,000 the receiving
// provider must additionally verify that the customer controls that wallet.
//
// We sit on the receiving side: the sender pays in from their own wallet or
// exchange account to an address we issued. So the originator data we must be
// able to produce is (a) who our customer is, which KYC already gives us, and
// (b) which address the funds actually came from, which nothing recorded
// before this - the deposit webhook only tells us our own address.

// keccak256("Transfer(address,address,uint256)") - the ERC-20 Transfer event.
// Decoding the log directly rather than going through an ABI means this keeps
// working for any token contract, and reads the token movement itself rather
// than tx.from, which is the relayer's address when one is used.
const ERC20_TRANSFER_TOPIC =
    "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef";

// Above this, a transfer from a self-hosted wallet needs proof the customer
// controls the wallet. Amounts are USDC/USDT, both tracking the dollar closely
// enough for a EUR threshold at this precision.
const SELF_HOSTED_VERIFICATION_THRESHOLD = Number(
    process.env.TRAVEL_RULE_SELF_HOSTED_THRESHOLD || 1000
);

function logTravelRule(event, payload = {}) {
    console.log(`[TRAVEL_RULE] ${event} ${JSON.stringify(payload)}`);
}

function getNodeForNetwork(network) {
    if (network === "MATIC") {
        return new Web3(`${process.env.POLYGON_NODE_BASE_API_URL}/${process.env.POLYGON_NODE_API_KEY}`);
    }
    if (network === "BSC") {
        return new Web3(`${process.env.BINANCE_SMART_CHAIN_NODE_BASE_API_URL}`);
    }
    throw new Error("Sorry, Invalid Network Name !!");
}

// A 32-byte log topic holds a 20-byte address right-aligned.
function addressFromTopic(topic) {
    if (typeof topic !== "string" || topic.length < 42) return null;
    return `0x${topic.slice(-40)}`.toLowerCase();
}

function knownTokenContracts() {
    return new Set(
        [
            ADDRESSES.USDT_CONTRACT_ADDRESS_ON_POLYGON,
            ADDRESSES.USDT_CONTRACT_ADDRESS_ON_BSC,
            ADDRESSES.USDC_CONTRACT_ADDRESS_ON_POLYGON,
            ADDRESSES.USDC_CONTRACT_ADDRESS_ON_BSC,
        ]
            .filter(Boolean)
            .map((address) => String(address).toLowerCase())
    );
}

/**
 * Resolve which address actually sent the tokens into one of our deposit
 * addresses.
 *
 * Returns { address, resolved } - `resolved` false means the lookup did not
 * produce an answer, which must be recorded rather than guessed: an originator
 * address invented by falling back to tx.from would be worse than an honest
 * gap in the record.
 */
async function resolveOriginatorAddress(network, txId, depositAddress) {
    try {
        const web3 = getNodeForNetwork(network);
        const receipt = await web3.eth.getTransactionReceipt(txId);
        if (!receipt || !Array.isArray(receipt.logs)) {
            return { address: null, resolved: false, reason: "no receipt" };
        }

        const target = String(depositAddress || "").toLowerCase();
        const tokens = knownTokenContracts();

        for (const log of receipt.logs) {
            const topics = log?.topics || [];
            if (String(topics[0] || "").toLowerCase() !== ERC20_TRANSFER_TOPIC) continue;
            // Only trust a movement of a token we actually accept.
            if (tokens.size > 0 && !tokens.has(String(log.address || "").toLowerCase())) continue;
            const to = addressFromTopic(topics[2]);
            if (target && to !== target) continue;
            const from = addressFromTopic(topics[1]);
            if (from) {
                return { address: from, resolved: true };
            }
        }

        return { address: null, resolved: false, reason: "no matching transfer log" };
    }
    catch (err) {
        logTravelRule("originator address lookup failed", {
            network,
            txId,
            reason: err?.message || "unknown",
        });
        return { address: null, resolved: false, reason: err?.message || "lookup error" };
    }
}

/**
 * Assemble the originator/beneficiary record for one transfer.
 *
 * `user` must carry the verified KYC identity, not anything the sender typed
 * for this transaction - the whole point of the rule is that the originator is
 * the identified customer.
 */
function buildTravelRuleRecord({ user, transfer, network, txId, originator }) {
    const amount = Number(transfer?.amount) || 0;
    return {
        originator: {
            name: [user?.name, user?.fatherName].filter(Boolean).join(" ").trim(),
            country: user?.country || "",
            customerNumber: user?.accountNumber ? String(user.accountNumber) : "",
            walletAddress: originator?.address || "",
            // Left "unknown" until either the sender declares it or a partner's
            // counterparty-discovery tells us. Recording a guess here would put
            // a false statement into a regulatory record.
            walletType: originator?.walletType || "unknown",
        },
        beneficiary: {
            name: transfer?.receiver?.fullName || "",
            mobilePhone: transfer?.receiver?.mobilePhone || "",
            country: transfer?.toCountry || "",
            city: transfer?.city || "",
            area: transfer?.area || "",
        },
        amount,
        currency: transfer?.currencyName || "",
        network: network || "",
        transactionId: txId || "",
        selfHostedVerificationRequired: amount >= SELF_HOSTED_VERIFICATION_THRESHOLD,
        originatorAddressResolved: Boolean(originator?.resolved),
        collectedAt: new Date(),
    };
}

/**
 * True when the record has everything the regulation expects to travel with
 * the transfer. Used to flag gaps for a reviewer rather than to block a
 * payout that has already been funded.
 */
function isTravelRuleRecordComplete(record) {
    if (!record) return false;
    return Boolean(
        record.originator?.name &&
        record.originator?.walletAddress &&
        record.beneficiary?.name &&
        record.beneficiary?.country
    );
}

module.exports = {
    resolveOriginatorAddress,
    buildTravelRuleRecord,
    isTravelRuleRecordComplete,
    logTravelRule,
    SELF_HOSTED_VERIFICATION_THRESHOLD,
};
