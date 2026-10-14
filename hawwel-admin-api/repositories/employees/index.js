const { adminModel, employeeModel, cityModel } = require("../../models/dashboard");

const { transferModel } = require("../../models/client");

const { hash } = require("bcryptjs");

const { getSuitableTranslations } = require("../../helpers/translation");

const { authorizeAdmin } = require("../../helpers/permissions");

const { populateRole } = require("../../helpers/roles");

const { dashboardDB } = require("../../database/connections");

const { resolveTransferStatusFilter } = require("../../helpers/transfer_filters");

async function createEmployee(adminId, employeeInfo, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "employees_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const existEmployee = await employeeModel.findOne({ $or: [{ email: employeeInfo.email }, { mobilePhone: employeeInfo.mobilePhone }] });
            if (existEmployee) {
                return {
                    msg: getSuitableTranslations("Sorry, This Employee Is Already Exist !!", language),
                    error: true,
                    data: {},
                }
            }
            const city = await cityModel.findById(employeeInfo.city);
            if (!city) {
                return {
                    msg: getSuitableTranslations("Sorry, This City Is Not Exist !!", language),
                    error: true,
                    data: {},
                }
            }
            employeeInfo.password = await hash(employeeInfo.password, 10);
            const newEmployeeInstance = new employeeModel(employeeInfo);
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await newEmployeeInstance.save({ session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Creating New Employee Process Has Been Successfully !!", language),
                error: false,
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

async function getEmployeesCount(adminId, filters, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "employees_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            return {
                msg: getSuitableTranslations("Get Employees Count Process Has Been Successfully !!", language),
                error: false,
                data: await employeeModel.countDocuments(filters),
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

async function getAllEmployeesInsideThePage(adminId, pageNumber, pageSize, filters, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "employees_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const employees = await employeeModel.find(filters, { __v: false, password: false }).populate("city").sort({ createdAt: -1 }).skip((pageNumber - 1) * pageSize).limit(pageSize);
            return {
                msg: getSuitableTranslations("Get All Employees Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
                error: false,
                data: {
                    employees,
                    employeesCount: await employeeModel.countDocuments(filters),
                },
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

async function updateEmployeeInfo(adminId, employeeId, newEmployeeDetails, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "employees_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const employee = await employeeModel.findById(employeeId);
            if (employee) {
                if (newEmployeeDetails?.email) {
                    const existEmployee = await employeeModel.findOne({ email: newEmployeeDetails.email, _id: { $ne: employeeId } });
                    if (existEmployee) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Email Is Already Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    employee.email = newEmployeeDetails.email;
                }
                if (newEmployeeDetails?.mobilePhone) {
                    const existEmployee = await employeeModel.findOne({ mobilePhone: newEmployeeDetails.mobilePhone, _id: { $ne: employeeId } });
                    if (existEmployee) {
                        return {
                            msg: getSuitableTranslations("Sorry, This Mobile Phone Is Already Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    employee.mobilePhone = newEmployeeDetails.mobilePhone;
                }
                if (newEmployeeDetails?.city) {
                    const city = await cityModel.findById(newEmployeeDetails.city);
                    if (!city) {
                        return {
                            msg: getSuitableTranslations("Sorry, This City Is Not Exist !!", language),
                            error: true,
                            data: {},
                        }
                    }
                    employee.city = newEmployeeDetails.city;
                }
                if (newEmployeeDetails?.fullName) {
                    employee.fullName = newEmployeeDetails.fullName;
                }
                if (newEmployeeDetails?.status) {
                    if (newEmployeeDetails.status === "blocked") {
                        employee.blockingDate = Date.now();
                        employee.blockingReason = newEmployeeDetails.blockingReason || "Blocked by admin";
                    }
                    employee.status = newEmployeeDetails.status;
                }
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await employee.save({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Updating Employee Details Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Employee Is Not Exist !!", language),
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

async function deleteEmployee(adminId, employeeId, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "employees_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const employee = await employeeModel.findById(employeeId);
            if (employee) {
                if (!dbSession) {
                    dbSession = await dashboardDB.startSession();
                    dbSession.startTransaction();
                    internalSession = true;
                }
                await employee.deleteOne({ session: dbSession });
                if (internalSession) {
                    await dbSession.commitTransaction();
                    await dbSession.endSession();
                }
                return {
                    msg: getSuitableTranslations("Deleting Employee Process Has Been Successfully !!", language),
                    error: false,
                    data: {},
                }
            }
            return {
                msg: getSuitableTranslations("Sorry, This Employee Is Not Exist !!", language),
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

async function getEmployeeInfo(employeeId, language) {
    try {
        const employee = await employeeModel.findById(employeeId, { __v: false, password: false }).populate("city");
        if (employee) {
            return {
                msg: getSuitableTranslations("Get Employee Info Process Has Been Successfully !!", language),
                error: false,
                data: employee,
            }
        }
        return {
            msg: getSuitableTranslations("Sorry, This Employee Is Not Exist !!", language),
            error: true,
            data: {},
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function getTransfersForEmployeeCity(employeeId, pageNumber, pageSize, filters, language) {
    try {
        const employee = await employeeModel.findById(employeeId).populate("city");
        if (!employee) {
            return {
                msg: getSuitableTranslations("Sorry, This Employee Is Not Exist !!", language),
                error: true,
                data: {}
            }
        }
        if (employee.status === "blocked") {
            return {
                msg: getSuitableTranslations("Sorry, This Account Has Been Blocked !!", language),
                error: true,
                data: {}
            }
        }
        const cityName = employee.city.name;
        let mainFilters = {
            $or: [
                { "city.ar": cityName.ar },
                { "city.en": cityName.en }
            ]
        };
        if (filters.status) {
            mainFilters.status = resolveTransferStatusFilter(filters.status);
        }
        if (filters.today) {
            const today = new Date();
            mainFilters.createdAt = { $gte: new Date(today.setUTCHours(0, 0, 0, 0)), $lte: new Date(today.setUTCHours(23, 59, 59, 999)) };
        } else {
            if (filters.fromDate && filters.toDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate), $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
            } else if (filters.fromDate) {
                mainFilters.createdAt = { $gte: new Date(filters.fromDate) };
            } else if (filters.toDate) {
                mainFilters.createdAt = { $lte: new Date((new Date(filters.toDate)).setUTCHours(23, 59, 59, 999)) };
            }
        }
        const transfers = await transferModel.find(mainFilters, { __v: false })
            .sort({ createdAt: -1 })
            .skip((pageNumber - 1) * pageSize)
            .limit(pageSize)
            .populate("sender", { twoFA: false, password: false, __v: false });
        return {
            msg: getSuitableTranslations("Get All Transfers For This Employee Inside The Page: {{pageNumber}} Process Has Been Successfully !!", language, { pageNumber }),
            error: false,
            data: {
                transfers,
                transfersCount: await transferModel.countDocuments(mainFilters),
                city: cityName,
            }
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    createEmployee,
    getEmployeesCount,
    getAllEmployeesInsideThePage,
    updateEmployeeInfo,
    deleteEmployee,
    getEmployeeInfo,
    getTransfersForEmployeeCity,
}