const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const permissionModel = require("../../../models/dashboard/permission");

const { INITIAL_PERMISSIONS } = require("../../../constants/permissions");

async function create_initial_permissions() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        await permissionModel.bulkWrite(
            INITIAL_PERMISSIONS.map((perm) => ({
                updateOne: {
                    filter: { codeName: perm.codeName },
                    update: { $setOnInsert: perm },
                    upsert: true,
                },
            }))
        );
        await dashboardDB.close();
        return "Create Initial Permissions Process Has Been Successfuly !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_permissions()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err?.message || err); process.exit(1); });