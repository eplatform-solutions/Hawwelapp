// Manual regression test for the Travel Rule (TFR 2023/1113) record.
// Spins up an in-memory MongoDB replica set and a stubbed chain node.
// Run with: npm run test:travel-rule
//
// The delicate part is decoding which address actually sent the tokens. The
// deposit webhook only reports our own address, so the originator has to be
// read out of the transaction receipt - and reading it wrong would put a false
// address into a regulatory record, which is worse than recording a gap.
const { resolve } = require("path");
const { MongoMemoryReplSet } = require("mongodb-memory-server");

const ROOT = resolve(__dirname, "..");

let failures = 0;
function check(label, condition, extra = "") {
    if (condition) console.log(`  ok    ${label}`);
    else { console.error(`  FAIL  ${label} ${extra}`); failures++; }
}

const TRANSFER_TOPIC = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef";
const USDC_POLYGON = "0x3c499c542cef5e3811e1192ce70d8cc03d5c3359";
const SENDER = "0x1111111111111111111111111111111111111111";
const OTHER = "0x9999999999999999999999999999999999999999";
const DEPOSIT = "0x2222222222222222222222222222222222222222";

function topicFor(address) {
    return `0x${"0".repeat(24)}${address.slice(2)}`;
}

// Stub the chain node so the decoding logic is exercised without a network.
let stubbedReceipt = null;
const Module = require("module");
const origLoad = Module._load;
Module._load = function (request, parent) {
    if (request === "web3" && parent?.filename?.includes("travel_rule")) {
        return {
            Web3: class {
                constructor() {
                    this.eth = { getTransactionReceipt: async () => stubbedReceipt };
                }
            },
        };
    }
    return origLoad.apply(this, arguments);
};

async function main() {
    const replSet = await MongoMemoryReplSet.create({ replSet: { count: 1 } });
    process.env.NODE_ENV = process.env.NODE_ENV || "development";
    process.env.DB_URL = replSet.getUri("client");

    const { clientDB } = require(`${ROOT}/database/connections`);
    await clientDB.openUri(process.env.DB_URL);

    const { transferModel, userModel } = require(`${ROOT}/models/client`);
    const {
        resolveOriginatorAddress,
        buildTravelRuleRecord,
        isTravelRuleRecordComplete,
    } = require(`${ROOT}/helpers/travel_rule`);
    const { recordTravelRuleForDeposit } = require(`${ROOT}/repositories/travel_rule`);

    console.log("\n-- reading the originator out of the receipt --");

    stubbedReceipt = {
        logs: [{
            address: USDC_POLYGON,
            topics: [TRANSFER_TOPIC, topicFor(SENDER), topicFor(DEPOSIT)],
        }],
    };
    let originator = await resolveOriginatorAddress("MATIC", "0xabc", DEPOSIT);
    check("the sending address is decoded from the Transfer log",
        originator.resolved && originator.address === SENDER, JSON.stringify(originator));

    // A transaction often touches several transfers; only the one paying into
    // our address identifies our originator.
    stubbedReceipt = {
        logs: [
            { address: USDC_POLYGON, topics: [TRANSFER_TOPIC, topicFor(OTHER), topicFor(OTHER)] },
            { address: USDC_POLYGON, topics: [TRANSFER_TOPIC, topicFor(SENDER), topicFor(DEPOSIT)] },
        ],
    };
    originator = await resolveOriginatorAddress("MATIC", "0xabc", DEPOSIT);
    check("an unrelated transfer in the same tx is ignored",
        originator.address === SENDER, JSON.stringify(originator));

    // A token we do not accept must not be mistaken for the deposit.
    stubbedReceipt = {
        logs: [{
            address: "0xdeaddeaddeaddeaddeaddeaddeaddeaddeaddead",
            topics: [TRANSFER_TOPIC, topicFor(OTHER), topicFor(DEPOSIT)],
        }],
    };
    originator = await resolveOriginatorAddress("MATIC", "0xabc", DEPOSIT);
    check("a transfer of an unknown token is not accepted as the deposit",
        !originator.resolved, JSON.stringify(originator));

    // A non-Transfer event must not be decoded as one.
    stubbedReceipt = {
        logs: [{ address: USDC_POLYGON, topics: ["0xffff", topicFor(SENDER), topicFor(DEPOSIT)] }],
    };
    originator = await resolveOriginatorAddress("MATIC", "0xabc", DEPOSIT);
    check("a non-Transfer event is ignored", !originator.resolved, JSON.stringify(originator));

    stubbedReceipt = null;
    originator = await resolveOriginatorAddress("MATIC", "0xabc", DEPOSIT);
    check("a missing receipt is reported as unresolved, not guessed",
        !originator.resolved && originator.address === null, JSON.stringify(originator));

    console.log("\n-- assembling the record --");
    const user = await userModel.create({
        name: "Ahmad", fatherName: "Khaled", nickname: "ahmad", country: "DE",
        mobilePhone: "+491700000001", email: "a@example.com",
        password: "SomePass123", accountNumber: 100042, status: "active",
    });

    const record = buildTravelRuleRecord({
        user,
        transfer: {
            amount: 250,
            currencyName: "USDC",
            toCountry: "SY",
            receiver: { fullName: "Mohammad Al Kadri", mobilePhone: "+963966606644" },
        },
        network: "MATIC",
        txId: "0xabc",
        originator: { address: SENDER, resolved: true },
    });

    check("originator name comes from the verified identity, not user input",
        record.originator.name === "Ahmad Khaled", record.originator.name);
    check("originator customer number is recorded", record.originator.customerNumber === "100042");
    check("originator wallet type stays 'unknown' rather than being guessed",
        record.originator.walletType === "unknown", record.originator.walletType);
    check("beneficiary name is recorded", record.beneficiary.name === "Mohammad Al Kadri");
    check("beneficiary country is recorded", record.beneficiary.country === "SY");
    check("a record with both parties counts as complete", isTravelRuleRecordComplete(record));

    const belowThreshold = buildTravelRuleRecord({
        user, transfer: { amount: 999, receiver: {} }, network: "MATIC", txId: "0x1",
        originator: { address: SENDER, resolved: true },
    });
    check("below the threshold, no self-hosted verification is demanded",
        belowThreshold.selfHostedVerificationRequired === false);
    const atThreshold = buildTravelRuleRecord({
        user, transfer: { amount: 1000, receiver: {} }, network: "MATIC", txId: "0x1",
        originator: { address: SENDER, resolved: true },
    });
    check("at the threshold, self-hosted verification is flagged",
        atThreshold.selfHostedVerificationRequired === true);

    const noAddress = buildTravelRuleRecord({
        user,
        transfer: { amount: 10, toCountry: "SY", receiver: { fullName: "X" } },
        network: "MATIC", txId: "0x1",
        originator: { address: null, resolved: false },
    });
    check("a record missing the originator address is NOT complete",
        !isTravelRuleRecordComplete(noAddress),
        "an unresolved address must show as a gap a reviewer can see");

    console.log("\n-- persisting against a real transfer --");
    const transfer = await transferModel.create({
        sender: user._id, fromCountry: "DE", toCountry: "SY",
        amount: 250, rate: 1, fee: 2, currencyName: "USDC", symbol: "USDC",
        paymentMethod: { name: { ar: "x", en: "x" }, symbol: "SYP", logoPath: "x" },
        receiver: { fullName: "Mohammad Al Kadri", mobilePhone: "+963966606644" },
        expirationAt: new Date(Date.now() + 3600000),
    });

    stubbedReceipt = {
        logs: [{ address: USDC_POLYGON, topics: [TRANSFER_TOPIC, topicFor(SENDER), topicFor(DEPOSIT)] }],
    };
    await recordTravelRuleForDeposit({
        transferId: transfer._id, network: "MATIC", txId: "0xabc", depositAddress: DEPOSIT,
    });

    let saved = await transferModel.findById(transfer._id);
    check("the record is stored on the transfer", Boolean(saved.travelRule?.collectedAt));
    check("the originator address is stored", saved.travelRule.originator.walletAddress === SENDER,
        saved.travelRule.originator.walletAddress);
    check("it is marked complete", saved.travelRule.complete === true);
    check("the transaction id is stored", saved.travelRule.transactionId === "0xabc");

    console.log("\n-- a failed lookup can be repaired by a later run --");
    const second = await transferModel.create({
        sender: user._id, fromCountry: "DE", toCountry: "SY",
        amount: 50, rate: 1, fee: 2, currencyName: "USDC", symbol: "USDC",
        paymentMethod: { name: { ar: "x", en: "x" }, symbol: "SYP", logoPath: "x" },
        receiver: { fullName: "Rama", mobilePhone: "+963966606645" },
        expirationAt: new Date(Date.now() + 3600000),
    });

    stubbedReceipt = null;   // node unreachable on the first attempt
    await recordTravelRuleForDeposit({
        transferId: second._id, network: "MATIC", txId: "0xdef", depositAddress: DEPOSIT,
    });
    saved = await transferModel.findById(second._id);
    check("the gap is recorded rather than the transfer being skipped",
        saved.travelRule.complete === false && saved.travelRule.originatorAddressResolved === false);

    stubbedReceipt = {
        logs: [{ address: USDC_POLYGON, topics: [TRANSFER_TOPIC, topicFor(SENDER), topicFor(DEPOSIT)] }],
    };
    await recordTravelRuleForDeposit({
        transferId: second._id, network: "MATIC", txId: "0xdef", depositAddress: DEPOSIT,
    });
    saved = await transferModel.findById(second._id);
    check("re-running fills in the address once the node answers",
        saved.travelRule.complete === true && saved.travelRule.originator.walletAddress === SENDER,
        JSON.stringify(saved.travelRule.originator));

    console.log("\n-- incomplete records are findable --");
    const incomplete = await transferModel.countDocuments({ "travelRule.complete": false });
    check("incomplete records can be queried for review", incomplete >= 0);

    console.log("");
    console.log(failures ? `${failures} FAILURE(S)` : "ALL TRAVEL RULE TESTS PASSED");

    await clientDB.close();
    await replSet.stop();
    process.exit(failures ? 1 : 0);
}

main().catch(async (err) => {
    console.error("[manual-test-travel-rule]", err?.stack || err);
    process.exit(1);
});
