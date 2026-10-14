const { getSuitableTranslations } = require("../translation");

const { SUPER_ADMIN_ONLY_PERMISSIONS } = require("../../constants/permissions");

function getPermissions(role) {
    if (!role || !role?.permissions) {
        return [];
    }
    const permissionsMap = new Map();
    role.permissions.forEach(permission => {
        permissionsMap.set(permission.codeName, {
            codeName: permission.codeName,
            name: permission.name,
            appLabel: permission.appLabel,
        });
    });

    return Array.from(permissionsMap.values());
}

function getPermissionCodeNames(role) {
    if (!role || !role?.permissions) {
        return [];
    }
    const permissionsSet = new Set();
    role.permissions.forEach(permission => {
        permissionsSet.add(permission.codeName);
    });
    return [...permissionsSet];
}

function getPermissionNames(role) {
    if (!role || !role?.permissions) {
        return [];
    }
    const permissionsSet = new Set();
    role.permissions.forEach(permission => {
        permissionsSet.add(permission.name);
    });
    return [...permissionsSet];
}

function checkPermission(requiredPermission, permissions = []) {
    for (let permission of permissions) {
        if (
            permission?.codeName === requiredPermission ||
            permission?.name === requiredPermission ||
            permission === requiredPermission
        ) return true;
    }
    return false;
}

function authorizeAdmin(admin, requiredPermission, language) {
    if (!admin.isSuperAdmin) {
        if (admin.status === "blocked") {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Has Been Blocked !!", language),
                error: true,
                code: "ACCOUNT_BLOCKED",
                data: {
                    blockingDate: admin.blockingDate,
                    blockingReason: admin.blockingReason,
                },
            }
        }
        const permissions = getPermissionCodeNames(admin.role);
        const hasPermission = checkPermission(requiredPermission, permissions);
        if (!hasPermission) {
            return {
                msg: getSuitableTranslations("Sorry, Permission Denied !!", language),
                error: true,
                code: "PERMISSION_DENIED",
                data: permissions,
            }
        }
    }
    return {
        msg: getSuitableTranslations("Permission Granted !!", language),
        error: false,
        data: {},
    }
}

// Guards against a non-super-admin using "roles_managment" to escalate their own
// privileges: they may not touch the role currently assigned to them, may not
// grant/keep a super-admin-only permission (e.g. "roles_managment" itself) on a
// role, and may not grant any permission they do not themselves already hold.
function validateRolePermissionChange(populatedAdmin, targetRoleId, newPermissionCodeNames, language) {
    if (populatedAdmin.isSuperAdmin) {
        return { error: false };
    }

    if (targetRoleId && populatedAdmin.role?._id && String(populatedAdmin.role._id) === String(targetRoleId)) {
        return {
            msg: getSuitableTranslations("Sorry, You Cannot Modify The Role Assigned To Your Own Account !!", language),
            error: true,
            code: "PERMISSION_DENIED",
            data: {},
        };
    }

    const restrictedRequested = (newPermissionCodeNames || []).filter((codeName) =>
        SUPER_ADMIN_ONLY_PERMISSIONS.includes(codeName)
    );
    if (restrictedRequested.length > 0) {
        return {
            msg: getSuitableTranslations("Sorry, Only A Super Admin Can Grant This Permission: {{permissionId}} !!", language, { permissionId: restrictedRequested.join(", ") }),
            error: true,
            code: "PERMISSION_DENIED",
            data: {},
        };
    }

    const ownPermissions = getPermissionCodeNames(populatedAdmin.role);
    const beyondCeiling = (newPermissionCodeNames || []).filter(
        (codeName) => !ownPermissions.includes(codeName)
    );
    if (beyondCeiling.length > 0) {
        return {
            msg: getSuitableTranslations("Sorry, You Cannot Grant A Permission You Do Not Have Yourself: {{permissionId}} !!", language, { permissionId: beyondCeiling.join(", ") }),
            error: true,
            code: "PERMISSION_DENIED",
            data: {},
        };
    }

    return { error: false };
}

module.exports = {
    getPermissions,
    getPermissionCodeNames,
    getPermissionNames,
    checkPermission,
    authorizeAdmin,
    validateRolePermissionChange
}