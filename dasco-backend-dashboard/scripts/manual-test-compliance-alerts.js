// Manual regression test for the compliance alert review queue.
// Spins up an in-memory MongoDB replica set - no external services needed.
// Run with: npm run test:compliance-alerts
//
// Covers the admin compliance repository end to end: Exercises authorisation, pagination, filters, the
// resolve state machine, and the stats aggregation.
const { resolve } = require("path");

const ROOT = resolve(__dirname, "..");
const { MongoMemoryReplSet } = require("mongodb-memory-server");

let failures = 0;
function check(label, cond, extra = "") {
    if (cond) console.log(`  ok    ${label}`);
    else { console.error(`  FAIL  ${label} ${extra}`); failures++; }
}

(async () => {
    const replSet = await MongoMemoryReplSet.create({ replSet: { count: 1 } });
    process.env.NODE_ENV = "development";
    process.env.DB_URL = replSet.getUri("client");
    process.env.DASH_DB_URL = replSet.getUri("dash");

    const { clientDB, dashboardDB } = require(ROOT + "/database/connections");
    await clientDB.openUri(process.env.DB_URL);
    await dashboardDB.openUri(process.env.DASH_DB_URL);

    const mongoose = require("mongoose");
    const { adminModel, roleModel, permissionModel } = require(ROOT + "/models/dashboard");
    const { complianceAlertModel, userModel } = require(ROOT + "/models/client");
    const repo = require(ROOT + "/repositories/compliance");

    // --- fixtures -------------------------------------------------------
    const superAdmin = await adminModel.create({
        fullName: "Super Admin", userName: "super", email: "super@test.com",
        mobilePhone: "+491700000001", password: "TestPass123#", isSuperAdmin: true,
    });

    const compliancePerm = await permissionModel.create({
        codeName: "compliance_managment", name: "Compliance Managment", appLabel: "compliance",
    });
    const otherPerm = await permissionModel.create({
        codeName: "users_managment", name: "Users Managment", appLabel: "users",
    });

    const complianceRole = await roleModel.create({
        name: "Compliance Officer", description: "reviews alerts", permissions: [compliancePerm._id],
    });
    const unrelatedRole = await roleModel.create({
        name: "Support", description: "no compliance", permissions: [otherPerm._id],
    });

    const officer = await adminModel.create({
        fullName: "Officer", userName: "officer", email: "officer@test.com",
        mobilePhone: "+491700000002", password: "TestPass123#", role: complianceRole._id,
    });
    const outsider = await adminModel.create({
        fullName: "Outsider", userName: "outsider", email: "outsider@test.com",
        mobilePhone: "+491700000003", password: "TestPass123#", role: unrelatedRole._id,
    });

    const customer = await userModel.create({
        name: "Ahmad Alhamwi", nickname: "ahmad", country: "DE",
        mobilePhone: "+491700000009", email: "ahmad@test.com", password: "TestPass123#",
        accountNumber: 100001, status: "active",
    });

    const mk = (over = {}) => ({
        type: "sanctions-review", severity: "medium", user: customer._id,
        partyType: "sender", screenedName: "ahmad alhamwi", matchScore: 0.66,
        matches: [{ entityId: "NK-1", caption: "Ahmad Al Hamwi", datasets: ["eu_fsf"], score: 0.66 }],
        details: "test alert", blockedTransfer: true, ...over,
    });

    const a1 = await complianceAlertModel.create(mk());
    const a2 = await complianceAlertModel.create(mk({ type: "velocity-breach", severity: "medium", matchScore: undefined, matches: [] }));
    const a3 = await complianceAlertModel.create(mk({ type: "sanctions-hit", severity: "high", matchScore: 0.91 }));
    const a4 = await complianceAlertModel.create(mk({ type: "edd-required", severity: "low", blockedTransfer: false }));
    // An alert whose user no longer exists must still be listed.
    const orphan = await complianceAlertModel.create(mk({ user: new mongoose.Types.ObjectId(), type: "screening-unavailable", severity: "high" }));

    console.log("\n-- authorisation --");
    let r = await repo.getAllComplianceAlertsInsideThePage(outsider._id, 1, 10, {}, "en");
    check("admin without the permission is denied", r.error && r.code === "PERMISSION_DENIED", JSON.stringify(r.code));

    r = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 10, {}, "en");
    check("admin with compliance_managment is allowed", !r.error, r.msg);

    r = await repo.getAllComplianceAlertsInsideThePage(superAdmin._id, 1, 10, {}, "en");
    check("super admin is allowed without the permission", !r.error, r.msg);

    r = await repo.getAllComplianceAlertsInsideThePage(new mongoose.Types.ObjectId(), 1, 10, {}, "en");
    check("unknown admin id is rejected", r.error && r.code === "ADMIN_NOT_FOUND");

    console.log("\n-- listing --");
    r = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 10, {}, "en");
    check("all five alerts are returned", r.data.alertsCount === 5, `got ${r.data.alertsCount}`);
    check("the orphaned alert is not dropped",
        r.data.alerts.some((a) => String(a._id) === String(orphan._id)));
    const withUser = r.data.alerts.find((a) => String(a._id) === String(a1._id));
    check("customer details are joined", withUser?.user?.name === "Ahmad Alhamwi", JSON.stringify(withUser?.user));
    check("match details are returned", withUser?.matches?.[0]?.entityId === "NK-1");

    console.log("\n-- pagination --");
    const p1 = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 2, {}, "en");
    const p2 = await repo.getAllComplianceAlertsInsideThePage(officer._id, 2, 2, {}, "en");
    check("page size is honoured", p1.data.alerts.length === 2, `got ${p1.data.alerts.length}`);
    check("count is the total, not the page", p1.data.alertsCount === 5, `got ${p1.data.alertsCount}`);
    const ids1 = p1.data.alerts.map((a) => String(a._id));
    const ids2 = p2.data.alerts.map((a) => String(a._id));
    check("pages do not overlap", !ids1.some((id) => ids2.includes(id)));

    console.log("\n-- filters --");
    r = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 10, { type: "sanctions-hit" }, "en");
    check("type filter works", r.data.alertsCount === 1 && String(r.data.alerts[0]._id) === String(a3._id));
    r = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 10, { severity: "high" }, "en");
    check("severity filter works", r.data.alertsCount === 2, `got ${r.data.alertsCount}`);
    r = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 10, { status: "cleared" }, "en");
    check("filtering on an empty status returns an empty list, not an error shape with data",
        r.data.alertsCount === 0 && Array.isArray(r.data.alerts) && r.data.alerts.length === 0);
    const tomorrow = new Date(Date.now() + 86400000).toISOString().slice(0, 10);
    r = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 10, { fromDate: tomorrow }, "en");
    check("future fromDate excludes everything", r.data.alertsCount === 0, `got ${r.data.alertsCount}`);
    const yesterday = new Date(Date.now() - 86400000).toISOString().slice(0, 10);
    r = await repo.getAllComplianceAlertsInsideThePage(officer._id, 1, 10, { fromDate: yesterday, toDate: tomorrow }, "en");
    check("date range covering today includes everything", r.data.alertsCount === 5, `got ${r.data.alertsCount}`);

    console.log("\n-- stats --");
    r = await repo.getComplianceAlertsStats(officer._id, "en");
    check("stats count open alerts", r.data.open === 5, JSON.stringify(r.data));
    check("stats count high-severity open alerts", r.data.openHighSeverity === 2, JSON.stringify(r.data));

    console.log("\n-- resolving --");
    r = await repo.resolveComplianceAlert(outsider._id, a1._id, "cleared", "note", "en");
    check("resolve is permission-gated", r.error && r.code === "PERMISSION_DENIED");

    r = await repo.resolveComplianceAlert(officer._id, a1._id, "open", "note", "en");
    check("'open' is rejected as a decision", r.error, r.msg);

    r = await repo.resolveComplianceAlert(officer._id, a1._id, "bogus", "note", "en");
    check("an invalid status is rejected", r.error, r.msg);

    r = await repo.resolveComplianceAlert(officer._id, new mongoose.Types.ObjectId(), "cleared", "note", "en");
    check("a missing alert is reported", r.error, r.msg);

    r = await repo.resolveComplianceAlert(officer._id, a1._id, "cleared", "false positive - different person", "en");
    check("clearing succeeds", !r.error, r.msg);
    const cleared = await complianceAlertModel.findById(a1._id);
    check("reviewer is recorded", String(cleared.reviewedBy) === String(officer._id));
    check("review time is recorded", Boolean(cleared.reviewedAt));
    check("review note is recorded", cleared.reviewNote === "false positive - different person");
    check("status is cleared", cleared.status === "cleared");

    r = await repo.resolveComplianceAlert(officer._id, a1._id, "confirmed", "changed my mind", "en");
    check("an already-reviewed alert cannot be re-decided", r.error, r.msg);
    const still = await complianceAlertModel.findById(a1._id);
    check("the original decision is not overwritten", still.status === "cleared" && still.reviewNote === "false positive - different person");

    r = await repo.resolveComplianceAlert(officer._id, a3._id, "confirmed", "true match", "en");
    check("confirming succeeds", !r.error, r.msg);

    r = await repo.getComplianceAlertsStats(officer._id, "en");
    check("stats reflect the decisions", r.data.open === 3 && r.data.cleared === 1 && r.data.confirmed === 1, JSON.stringify(r.data));

    console.log("\n-- nothing is deleted --");
    check("alert count is unchanged after reviews", (await complianceAlertModel.countDocuments()) === 5);

    console.log("");
    console.log(failures ? `${failures} FAILURE(S)` : "ALL ADMIN COMPLIANCE TESTS PASSED");

    await clientDB.close();
    await dashboardDB.close();
    await replSet.stop();
    process.exit(failures ? 1 : 0);
})().catch((err) => { console.error(err); process.exit(1); });
