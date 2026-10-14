// Import Required Models Object

const { adminModel, roleModel, permissionModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { authorizeAdmin, validateRolePermissionChange, getPermissionCodeNames } = require("../../helpers/permissions");

const { SUPER_ADMIN_ONLY_PERMISSIONS } = require("../../constants/permissions");

const { populateRole } = require("../../helpers/roles");

const { dashboardDB } = require("../../database/connections");

async function createRole(adminId, name, description, permissions, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const existingRole = await roleModel.findOne({ name }, { __v: 0 })
                .populate("permissions", { codeName: 1, name: 1, appLabel: 1 });
            if (existingRole) {
                return {
                    msg: getSuitableTranslations("Sorry, This Role Already Exist !!", language),
                    error: true,
                    data: existingRole,
                }
            }
            const existingPermissions = await permissionModel.find(
                { _id: { $in: permissions } },
                { codeName: 1, name: 1, appLabel: 1 }
            );
            const existingIds = existingPermissions.map((p) =>
                p._id.toString()
            );
            const missingPermissions = (permissions || []).filter(
                (id) => !existingIds.includes(id)
            );
            if (missingPermissions.length > 0) {
                return {
                    msg: getSuitableTranslations("Sorry, Permission Not Found: {{permissionId}} !!", language, { permissionId: missingPermissions.join(", ") }),
                    error: true,
                    data: {},
                }
            }
            const permissionChangeResult = validateRolePermissionChange(
                populatedAdmin,
                null,
                existingPermissions.map((p) => p.codeName),
                language
            );
            if (permissionChangeResult.error) {
                return permissionChangeResult;
            }
            const newRoleInstance = new roleModel({
                name,
                description,
                permissions,
            });
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            const newRole = await newRoleInstance.save({ session: dbSession });
            newRole.permissions = existingPermissions;
            delete newRole.__v;
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Create New Role Process Has Been Successfully !!", language),
                error: false,
                data: newRole,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function getRole(adminId, roleId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const role = await roleModel.findById(roleId)
                .populate("permissions", { codeName: 1, name: 1, appLabel: 1 });
            if (role) {
                return {
                    msg: getSuitableTranslations("Get Role Data Process Has Been Successfully !!", language),
                    error: false,
                    data: role,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Role Is Not Exist !!", language),
                error: true,
                data: {}
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getAllRoles(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const roles = await roleModel.find({}, { name: 1, description: 1, permissions: 1 })
                .populate("permissions", { codeName: 1, name: 1, appLabel: 1 });
            if (roles.length > 0) {
                return {
                    msg: getSuitableTranslations("Get All Roles Data Process Has Been Successfully !!", language),
                    error: false,
                    data: roles,
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, Can't Find And Roles !!", language),
                error: true,
                data: {}
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function updateRoleInfo(adminId, roleId, newRoleData, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const roleInfo = await roleModel.findById(roleId);
            if (roleInfo) {
                // A non-super-admin may never touch the role assigned to their own
                // account, regardless of which fields are being changed.
                const selfEditResult = validateRolePermissionChange(populatedAdmin, roleId, [], language);
                if (selfEditResult.error) {
                    return selfEditResult;
                }
                const name = newRoleData?.name;
                if (name) {
                    roleInfo.name = name;
                }
                const description = newRoleData?.description;
                if (description) {
                    roleInfo.description = description;
                }
                if (newRoleData?.permissions) {
                    if (newRoleData?.permissions?.length > 0) {
                        const existingPermissions = await permissionModel.find({ _id: { $in: newRoleData.permissions } });
                        const existingIds = existingPermissions.map((p) => p._id.toString());
                        const missingPermissions = newRoleData.permissions.filter(
                            (id) => !existingIds.includes(id)
                        );
                        if (missingPermissions.length > 0) {
                            return {
                                msg: getSuitableTranslations("Sorry, Permission Not Found: {{permissionId}} !!", language, { permissionId: missingPermissions.join(", ") }),
                                error: true,
                                data: {},
                            }
                        }
                        const permissionChangeResult = validateRolePermissionChange(
                            populatedAdmin,
                            roleId,
                            existingPermissions.map((p) => p.codeName),
                            language
                        );
                        if (permissionChangeResult.error) {
                            return permissionChangeResult;
                        }
                        roleInfo.permissions = existingPermissions.map((p) => p._id);
                    } else {
                        roleInfo.permissions = [];
                    }
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await roleInfo.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Updating Role Data Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Role Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

async function deleteRole(adminId, roleId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const roleDetails = await roleModel.findById(roleId).populate("permissions", { codeName: 1 });
            if (roleDetails) {
                if (!populatedAdmin.isSuperAdmin) {
                    if (populatedAdmin.role?._id && String(populatedAdmin.role._id) === String(roleId)) {
                        return {
                            msg: getSuitableTranslations("Sorry, You Cannot Delete The Role Assigned To Your Own Account !!", language),
                            error: true,
                            code: "PERMISSION_DENIED",
                            data: {},
                        }
                    }
                    const rolePermissionCodeNames = getPermissionCodeNames(roleDetails);
                    const hasRestrictedPermission = rolePermissionCodeNames.some((codeName) =>
                        SUPER_ADMIN_ONLY_PERMISSIONS.includes(codeName)
                    );
                    if (hasRestrictedPermission) {
                        return {
                            msg: getSuitableTranslations("Sorry, Only A Super Admin Can Delete This Role !!", language),
                            error: true,
                            code: "PERMISSION_DENIED",
                            data: {},
                        }
                    }
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await roleDetails.deleteOne({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Deleting Role Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Role Is Not Exist !!", language),
                error: true,
                data: {},
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    }
}

module.exports = {
    createRole,
    getRole,
    getAllRoles,
    updateRoleInfo,
    deleteRole
}
