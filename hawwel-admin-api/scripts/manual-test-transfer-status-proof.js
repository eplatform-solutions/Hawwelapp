/**
 * Regression check: moving a transfer into a money-affecting status
 * (full-paid/under-paid/over-paid/received) must require a note explaining
 * why, attributed to the admin who did it - not a silent, unattributed
 * status flip. Spins up its own in-memory MongoDB (does not touch any real
 * database). Run with: npm run test:transfer-status-proof
 */

process.env.NODE_ENV = "test";

let passCount = 0;
let failCount = 0;

function check(label, condition) {
    if (condition) {
        passCount++;
        console.log(`  PASS: ${label}`);
    } else {
        failCount++;
        console.log(`  FAIL: ${label}`);
    }
}

(async () => {
    const { MongoMemoryReplSet } = require("mongodb-memory-server");
    const replSet = await MongoMemoryReplSet.create({ replSet: { count: 1 } });

    const { dashboardDB, clientDB } = require("../database/connections");
    await dashboardDB.openUri(replSet.getUri("hawwel-transfer-proof-test-dashboard"));
    await clientDB.openUri(replSet.getUri("hawwel-transfer-proof-test-client"));

    const { adminModel, roleModel, permissionModel } = require("../models/dashboard");
    const { transferModel, userModel } = require("../models/client");

    const transfersRepo = require("../repositories/transfers");

    try {
        const perm = await permissionModel.create({
            codeName: "transfers_managment",
            name: "Transfers Managment",
            appLabel: "transfers",
        });
        const role = await roleModel.create({
            name: "Transfers Admin",
            description: "test description",
            permissions: [perm._id],
        });
        const admin = await adminModel.create({
            fullName: "Transfers Admin",
            userName: "transfersadmin",
            email: "transfers@test.local",
            mobilePhone: "+10000000003",
            password: "TestPass123",
            isSuperAdmin: false,
            role: role._id,
        });
        const sender = await userModel.create({
            name: "Test Sender",
            nickname: "Sender",
            country: "SY",
            email: "sender@test.local",
            mobilePhone: "+10000000004",
            password: "TestPass123",
        });

        const baseTransfer = {
            sender: sender._id,
            fromCountry: "SY",
            toCountry: "SY",
            amount: 100,
            rate: 1,
            fee: 1,
            currencyName: "USDT",
            symbol: "USDT",
            city: { ar: "مدينة", en: "City" },
            area: { ar: "منطقة", en: "Area" },
            paymentMethod: {
                name: { ar: "طريقة", en: "Method" },
                symbol: "TST",
                logoPath: "assets/images/payment_methods/11111111-1111-1111-1111-111111111111__test.png",
            },
            receiver: { fullName: "Test Receiver", mobilePhone: "+10000000005" },
            expirationAt: new Date(Date.now() + 86400000),
        };

        // (a) no note -> rejected
        const t1 = await transferModel.create(baseTransfer);
        const r1 = await transfersRepo.updateTransferStatus(
            admin._id.toString(), t1._id.toString(), "full-paid", "", "en"
        );
        check("(a) rejects full-paid with no note", r1.error === true);

        // (b) blank/whitespace-only note -> rejected
        const r1b = await transfersRepo.updateTransferStatus(
            admin._id.toString(), t1._id.toString(), "full-paid", "   ", "en"
        );
        check("(b) rejects full-paid with whitespace-only note", r1b.error === true);

        // (c) real note -> succeeds and records who/when/why
        const r2 = await transfersRepo.updateTransferStatus(
            admin._id.toString(), t1._id.toString(), "full-paid", "Confirmed on-chain via txid abc123", "en"
        );
        check("(c) accepts full-paid with a real note", r2.error === false);
        const savedT1 = await transferModel.findById(t1._id);
        check("(c) lastStatusChange.adminId recorded", String(savedT1.lastStatusChange?.adminId) === String(admin._id));
        check("(c) lastStatusChange.note recorded", savedT1.lastStatusChange?.note === "Confirmed on-chain via txid abc123");
        check("(c) lastStatusChange.at recorded", savedT1.lastStatusChange?.at instanceof Date);

        // (d) "received" also requires a note
        const t2 = await transferModel.create(baseTransfer);
        const r3 = await transfersRepo.updateTransferStatus(
            admin._id.toString(), t2._id.toString(), "received", "", "en"
        );
        check("(d) rejects received with no note", r3.error === true);

        // (e) non-money statuses don't require a note
        const t3 = await transferModel.create(baseTransfer);
        const r4 = await transfersRepo.updateTransferStatus(
            admin._id.toString(), t3._id.toString(), "cancelled", "", "en"
        );
        check("(e) allows cancelled with no note", r4.error === false);

    } catch (err) {
        console.error("UNEXPECTED ERROR:", err);
        failCount++;
    } finally {
        await dashboardDB.close();
        await clientDB.close();
        await replSet.stop();
    }

    console.log(`\n=== RESULT: ${passCount} passed, ${failCount} failed ===`);
    process.exit(failCount > 0 ? 1 : 0);
})();
