const { resolve } = require("path");
const { config } = require("dotenv");

const {
    dashboardDB,
} = require("../database/connections");

config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const APPLY_FLAG = process.argv.includes("--apply");

function toIdString(id) {
    return id.toString();
}

async function buildGroupPermissionsMap(groupsCollection) {
    const groups = await groupsCollection.find({}, { projection: { permissions: 1 } }).toArray();
    const map = new Map();
    groups.forEach((group) => {
        map.set(toIdString(group._id), group.permissions || []);
    });
    return map;
}

function mergePermissionIds(groupIds, groupPermissionsMap) {
    const merged = new Map();
    (groupIds || []).forEach((groupId) => {
        const permissions = groupPermissionsMap.get(toIdString(groupId)) || [];
        permissions.forEach((permissionId) => {
            merged.set(toIdString(permissionId), permissionId);
        });
    });
    return [...merged.values()];
}

async function main() {
    await dashboardDB.openUri(process.env.DASH_DB_URL);
    try {
        const rolesCollection = dashboardDB.collection("roles");
        const groupsCollection = dashboardDB.collection("groups");

        const groupPermissionsMap = await buildGroupPermissionsMap(groupsCollection);
        const roles = await rolesCollection.find({}, { projection: { name: 1, groups: 1, permissions: 1 } }).toArray();

        const plan = roles
            .filter((role) => Array.isArray(role.groups) && role.groups.length > 0)
            .map((role) => ({
                roleId: role._id,
                roleName: role.name,
                permissionIds: mergePermissionIds(role.groups, groupPermissionsMap),
            }));

        console.log(`[migrate:groups-to-role-permissions] roles to update: ${plan.length}`);
        plan.forEach((entry) => {
            console.log(`  - ${entry.roleName} (${entry.roleId}) -> ${entry.permissionIds.length} permission(s)`);
        });

        if (!APPLY_FLAG) {
            console.log("[migrate:groups-to-role-permissions] Dry-run mode. Re-run with --apply to execute.");
            return;
        }

        const session = await dashboardDB.startSession();
        try {
            session.startTransaction();
            for (const entry of plan) {
                await rolesCollection.updateOne(
                    { _id: entry.roleId },
                    {
                        $set: { permissions: entry.permissionIds },
                        $unset: { groups: "" },
                    },
                    { session }
                );
            }
            await session.commitTransaction();
        } catch (err) {
            if (session.inTransaction()) {
                await session.abortTransaction();
            }
            throw err;
        } finally {
            await session.endSession();
        }

        console.log("[migrate:groups-to-role-permissions] Done. The old `groups` collection was left untouched as a safety net — drop it manually once you've confirmed roles behave correctly.");
    } finally {
        await dashboardDB.close();
    }
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(`[migrate:groups-to-role-permissions] failed: ${err?.message || err}`);
        process.exit(1);
    });
