/**
 * Regression check for two critical fixes:
 *  1) Role/admin self-privilege-escalation guards
 *  2) Country/city payment-method binding no longer cascading to children
 *
 * Spins up its own in-memory MongoDB replica set (does not touch any real
 * database), seeds minimal fixtures, and calls the repository functions
 * directly (no HTTP/JWT/OTP layer involved). Re-run after touching
 * repositories/roles, repositories/admins, repositories/countries,
 * repositories/cities, or helpers/permissions. Run with:
 *   npm run test:security-fixes
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
    const uri = replSet.getUri("hawwel-security-fix-test");

    const { dashboardDB } = require("../database/connections");
    await dashboardDB.openUri(uri);

    const {
        adminModel,
        roleModel,
        permissionModel,
        countryModel,
        cityModel,
        regionModel,
        paymentMethodModel,
        countryPaymentMethodModel,
        cityPaymentMethodModel,
        regionPaymentMethodModel,
    } = require("../models/dashboard");

    const rolesRepo = require("../repositories/roles");
    const adminsRepo = require("../repositories/admins");
    const countriesRepo = require("../repositories/countries");
    const citiesRepo = require("../repositories/cities");

    try {
        // ---- Seed permissions ----
        const [rolesPerm, paymentMethodsPerm, countriesPerm] = await permissionModel.insertMany([
            { codeName: "roles_managment", name: "Roles Managment", appLabel: "roles" },
            { codeName: "payment_methods_managment", name: "Payment Methods Managment", appLabel: "payment methods" },
            { codeName: "countries_and_cities_managment", name: "Countries And Cities Managment", appLabel: "countries and cities" },
        ]);

        // ---- Seed roles ----
        const limitedRole = await roleModel.create({
            name: "Limited Role (roles_managment only)",
            description: "test description",
            permissions: [rolesPerm._id],
        });
        const emptyRole = await roleModel.create({
            name: "Empty Role",
            description: "test description",
            permissions: [],
        });

        // ---- Seed admins ----
        const superAdmin = await adminModel.create({
            fullName: "Super Admin",
            userName: "superadmin",
            email: "super@test.local",
            mobilePhone: "+10000000001",
            password: "TestPass123",
            isSuperAdmin: true,
        });
        const limitedAdmin = await adminModel.create({
            fullName: "Limited Admin",
            userName: "limitedadmin",
            email: "limited@test.local",
            mobilePhone: "+10000000002",
            password: "TestPass123",
            isSuperAdmin: false,
            role: limitedRole._id,
        });

        console.log("\n=== 1) Privilege escalation guards ===");

        // (a) limited admin edits their OWN role to add a permission they don't have
        const r1 = await rolesRepo.updateRoleInfo(
            limitedAdmin._id.toString(),
            limitedRole._id.toString(),
            { permissions: [rolesPerm._id.toString(), paymentMethodsPerm._id.toString()] },
            "en"
        );
        check("(a) blocks editing own role", r1.error === true);

        // (b) limited admin creates a NEW role granting a permission they don't have (ceiling)
        const r2 = await rolesRepo.createRole(
            limitedAdmin._id.toString(),
            "Escalated Role",
            "test description",
            [paymentMethodsPerm._id.toString()],
            "en"
        );
        check("(b) blocks granting a permission you don't have", r2.error === true);

        // (c) limited admin creates a NEW role granting roles_managment (which they DO have, but it's super-admin-only)
        const r3 = await rolesRepo.createRole(
            limitedAdmin._id.toString(),
            "Spread Role",
            "test description",
            [rolesPerm._id.toString()],
            "en"
        );
        check("(c) blocks granting roles_managment itself", r3.error === true);

        // (d) limited admin reassigns THEIR OWN account to a different role
        const r4 = await adminsRepo.updateAdminInfo(
            limitedAdmin._id.toString(),
            limitedAdmin._id.toString(),
            { role: emptyRole._id.toString() },
            "en"
        );
        check("(d) blocks self role reassignment", r4.error === true);

        // (e) sanity: super admin CAN still create a role with roles_managment
        const r5 = await rolesRepo.createRole(
            superAdmin._id.toString(),
            "Legit Admin Role",
            "test description",
            [rolesPerm._id.toString()],
            "en"
        );
        check("(e) super admin unaffected (can still grant roles_managment)", r5.error === false);

        console.log("\n=== 2) Payment-method binding no longer cascades ===");

        const country = await countryModel.create({
            code: "SY",
        });
        const city = await cityModel.create({
            name: { ar: "مدينة اختبار", en: "Test City" },
            country: country._id,
        });
        const region = await regionModel.create({
            name: { ar: "منطقة اختبار", en: "Test Region" },
            city: city._id,
        });
        const paymentMethod = await paymentMethodModel.create({
            name: { ar: "طريقة اختبار", en: "Test Method" },
            symbol: "TST",
            minAmount: 1,
            maxAmount: 100,
            fee: 1,
            logoPath: "assets/images/payment_methods/11111111-1111-1111-1111-111111111111__test.png",
        });

        const bindResult = await countriesRepo.bindPaymentMethodsToCountry(
            superAdmin._id.toString(),
            country._id.toString(),
            [paymentMethod._id.toString()],
            "en"
        );
        check("bind-to-country call succeeds", bindResult.error === false);

        const countryRows = await countryPaymentMethodModel.countDocuments({ country: country._id });
        const cityRows = await cityPaymentMethodModel.countDocuments({ city: city._id });
        const regionRows = await regionPaymentMethodModel.countDocuments({ region: region._id });

        check("country-level binding row was created", countryRows === 1);
        check("city-level binding was NOT cascaded (0 rows)", cityRows === 0);
        check("region-level binding was NOT cascaded (0 rows)", regionRows === 0);

        // duplicate-id fix: sending the same payment method id twice must not
        // falsely report "not exist"
        const dupResult = await countriesRepo.bindPaymentMethodsToCountry(
            superAdmin._id.toString(),
            country._id.toString(),
            [paymentMethod._id.toString(), paymentMethod._id.toString()],
            "en"
        );
        check("duplicate payment-method id in request no longer falsely rejected", dupResult.error === false);

        // city-level bind must also not cascade to its region
        const cityBindResult = await citiesRepo.bindPaymentMethodsToCity(
            superAdmin._id.toString(),
            city._id.toString(),
            [paymentMethod._id.toString()],
            "en"
        );
        check("bind-to-city call succeeds", cityBindResult.error === false);
        const regionRowsAfterCityBind = await regionPaymentMethodModel.countDocuments({ region: region._id });
        check("city-level binding was NOT cascaded to region (0 rows)", regionRowsAfterCityBind === 0);

    } catch (err) {
        console.error("UNEXPECTED ERROR:", err);
        failCount++;
    } finally {
        await dashboardDB.close();
        await replSet.stop();
    }

    console.log(`\n=== RESULT: ${passCount} passed, ${failCount} failed ===`);
    process.exit(failCount > 0 ? 1 : 0);
})();
