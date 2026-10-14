// Import Required Models Object

const { adminModel, roleModel, loginLogModel } = require("../../models/dashboard");

const { hash } = require("bcryptjs");

const { getSuitableTranslations } = require("../../helpers/translation");

const { authorizeAdmin, getPermissionCodeNames } = require("../../helpers/permissions");

const { populateRole } = require("../../helpers/roles");

const { dashboardDB } = require("../../database/connections");

async function createAdmin(adminId, adminInfo, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const adminDetails = await adminModel.findOne({ $or: [{ email: adminInfo.email }, { mobilePhone: adminInfo.mobilePhone }] });
            if (!adminDetails) {
                const role = await roleModel.findById(adminInfo.role);
                if (role) {
                    adminInfo.password = await hash(adminInfo.password, 10);
                    const newAdminInstance = new adminModel(adminInfo);
                    if (!dbSession) {
                        dbSession = await dashboardDB.startSession();
                        dbSession.startTransaction();
                        internalSession = true;
                    }
                    await newAdminInstance.save({ session: dbSession });
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    return {
                        msg: getSuitableTranslations("Creating New Admin Process Has Been Successfully !!", language),
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
                msg: getSuitableTranslations("Sorry, This Admin Is Already Exist !!", language),
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

async function getAdminInfo(filters, language) {
    try {
        const admin = await adminModel.findOne(filters, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            if (!populatedAdmin.isSuperAdmin) {
                populatedAdmin._doc.permissions = getPermissionCodeNames(populatedAdmin.role);
            }
            return {
                msg: getSuitableTranslations("Get Admin Info Process Has Been Successfully !!", language),
                error: false,
                data: populatedAdmin,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getAdminsCount(adminId, filters, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            return {
                msg: getSuitableTranslations("Get Admins Count Process Has Been Successfully !!", language),
                error: false,
                data: await adminModel.countDocuments(filters),
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
            error: true,
            code: "ADMIN_NOT_FOUND",
            data: {},
        }
    } catch (err) {
        throw Error(err);
    }
}

async function getAllAdminsInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const admins = await adminModel.find(filters, { __v: false, password: false }).sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize);
            if (admins.length > 0) {
                const adminIds = admins.map((item) => item._id);
                const latestLoginLogs = await loginLogModel.aggregate([
                    {
                        $match: {
                            user: { $in: adminIds }
                        }
                    },
                    { $sort: { createdAt: -1, _id: -1 } },
                    {
                        $group: {
                            _id: "$user",
                            lastActivity: { $first: "$createdAt" }
                        }
                    }
                ]);
                const activityByAdminId = new Map(
                    latestLoginLogs.map((entry) => [String(entry._id), entry.lastActivity])
                );
                admins.forEach((item) => {
                    item.lastActivity = activityByAdminId.get(String(item._id)) || null;
                });
                return {
                    msg: getSuitableTranslations("Get All Admins Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                    error: false,
                    data: {
                        admins: await populateRole(admins),
                        adminsCount: await adminModel.countDocuments(filters),
                    },
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, No Admins Were Found !!", language),
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
    } catch (err) {
        throw Error(err);
    }
}

async function updateAdminInfo(authorizationId, adminId, newAdminDetails, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(authorizationId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const adminDetails = await adminModel.findById(adminId);
            if (adminDetails) {
                if (!adminDetails.isSuperAdmin) {
                    if (newAdminDetails?.email && newAdminDetails?.mobilePhone) {
                        const existAdmin = await adminModel.findOne({ $or: [{ email: newAdminDetails.email }, { mobilePhone: newAdminDetails.mobilePhone }] });
                        if (existAdmin) {
                            return {
                                msg: getSuitableTranslations("Sorry, This Email Or Mobile Phone Is Already Exist !!", language),
                                error: true,
                                data: {},
                            }
                        }
                        adminDetails.email = newAdminDetails.email;
                        adminDetails.mobilePhone = newAdminDetails.mobilePhone;
                    }
                    else if (newAdminDetails?.email) {
                        const existAdmin = await adminModel.findOne({ email: newAdminDetails.email });
                        if (existAdmin) {
                            return {
                                msg: getSuitableTranslations("Sorry, This Email Is Already Exist !!", language),
                                error: true,
                                data: {},
                            }
                        }
                        adminDetails.email = newAdminDetails.email;
                    }
                    else if (newAdminDetails?.mobilePhone) {
                        const existAdmin = await adminModel.findOne({ mobilePhone: newAdminDetails.mobilePhone });
                        if (existAdmin) {
                            return {
                                msg: getSuitableTranslations("Sorry, This Mobile Phone Is Already Exist !!", language),
                                error: true,
                                data: {},
                            }
                        }
                        adminDetails.mobilePhone = newAdminDetails.mobilePhone;
                    }
                    if (newAdminDetails?.role) {
                        if (!populatedAdmin.isSuperAdmin && String(authorizationId) === String(adminId)) {
                            return {
                                msg: getSuitableTranslations("Sorry, You Cannot Change The Role Assigned To Your Own Account !!", language),
                                error: true,
                                code: "PERMISSION_DENIED",
                                data: {},
                            }
                        }
                        const existRole = await roleModel.findById(newAdminDetails.role);
                        if (!existRole) {
                            return {
                                msg: getSuitableTranslations("Sorry, This Role Is Not Exist !!", language),
                                error: true,
                                data: {},
                            }
                        }
                        adminDetails.role = newAdminDetails.role;
                    }
                    if (newAdminDetails?.password) {
                        delete newAdminDetails.password;
                    }
                    if (newAdminDetails?.status) {
                        const status = newAdminDetails?.status;
                        if (status === "blocked") {
                            adminDetails.blockingDate = Date.now();
                        }
                        else if (status === "suspended") {
                            adminDetails.suspendingDate = Date.now();
                        }
                        adminDetails.status = status;
                    }
                    const fullName = newAdminDetails?.fullName;
                    if (fullName) {
                        adminDetails.fullName = fullName;
                    }
                    const userName = newAdminDetails?.userName;
                    if (userName) {
                        adminDetails.userName = userName;
                    }
                    if (!dbSession) {
                        dbSession = await dashboardDB.startSession();
                        dbSession.startTransaction();
                        internalSession = true;
                    }
                    await adminDetails.save({ session: dbSession });
                    if (internalSession) {
                        await dbSession.commitTransaction();
                        await dbSession.endSession();
                    }
                    return {
                        msg: getSuitableTranslations("Updating Admin Details Process Has Been Successfully !!", language),
                        error: false,
                        data: {},
                    }
                }
                return {
                    msg: getSuitableTranslations("Sorry, Permission Denied !!", language),
                    error: true,
                    code: "PERMISSION_DENIED",
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
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

async function deleteAdmin(authorizationId, adminId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(authorizationId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "roles_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const adminDetails = await adminModel.findById(adminId);
            if (adminDetails) {
                if (adminDetails.isSuperAdmin) {
                    return {
                        msg: getSuitableTranslations("Sorry, Permission Denied !!", language),
                        error: true,
                        code: "PERMISSION_DENIED",
                        data: {},
                    }
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await adminDetails.deleteOne({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Deleting Admin Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
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
    createAdmin,
    getAdminInfo,
    getAdminsCount,
    getAllAdminsInsideThePage,
    updateAdminInfo,
    deleteAdmin
}