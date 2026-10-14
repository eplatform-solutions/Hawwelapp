// Import Required Models

const { adminModel } = require("../../models/dashboard");

const { userModel, transferModel, depositModel } = require("../../models/client");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

async function getStatistics(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "quick_control_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const startOfToday = new Date();
            startOfToday.setUTCHours(0, 0, 0, 0);
            const endOfToday = new Date();
            endOfToday.setUTCHours(23, 59, 59, 999);
            const totalUsers = await userModel.countDocuments();
            const activeUsers = await userModel.countDocuments({ status: "active" });
            const totalTransfers = await transferModel.countDocuments();
            const dailyTransfers = await transferModel.countDocuments({
                createdAt: { $gte: startOfToday, $lte: endOfToday }
            });
            const totalDepositsAmount = await depositModel.aggregate([
                {
                    $group: {
                        _id: null,
                        total: { $sum: "$amount" }
                    }
                }
            ]);
            const dailyDepositsAmount = await depositModel.aggregate([
                {
                    $match: {
                        createdAt: { $gte: startOfToday, $lte: endOfToday }
                    }
                },
                {
                    $group: {
                        _id: null,
                        total: { $sum: "$amount" }
                    }
                }
            ]);
            return {
                msg: getSuitableTranslations("Get Statistics Process Has Been Successfully !!", language),
                error: false,
                data: {
                    totalUsers,
                    activeUsers,
                    totalTransfers,
                    dailyTransfers,
                    totalDepositsAmount: totalDepositsAmount[0]?.total || 0,
                    dailyDepositsAmount: dailyDepositsAmount[0]?.total || 0
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

module.exports = {
    getStatistics,
}