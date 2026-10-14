// Import Withdraw Model Object

const withdrawModel = require("../../models/dashboard/withdraw");

const { getSuitableTranslations } = require("../../helpers/translation");

const { clientDB } = require("../../database/connections");

async function createNewWithdraw(withdrawDetails, language, dbSession = null) {
    let internalSession = false;
    try {
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const newWithdraw = await (new withdrawModel(withdrawDetails)).save({ session: dbSession });
        if (internalSession) {
            await dbSession.commitTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Creating New Withdraw Process Has Been Successfully !!", language),
            error: false,
            data: newWithdraw,
        };
    }
    catch (err) {
        throw Error(err);
    }
}

async function updateWithdrawInfo(withdrawId, newWithdrawInfo, language, dbSession = null) {
    let internalSession = false;
    try {
        if (!dbSession) {
            dbSession = await clientDB.startSession();
            dbSession.startTransaction();
            internalSession = true;
        }
        const withdrawInfo = await withdrawModel.findOneAndUpdate({ _id: withdrawId }, newWithdrawInfo, { session: dbSession });
        if (withdrawInfo) {
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Updating This Withdraw Info Process Has Been Successfully !!", language),
                error: false,
                data: {},
            }
        }
        if (internalSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        return {
            msg: getSuitableTranslations("Sorry, This Withdraw Is Not Found !!", language),
            error: true,
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
    createNewWithdraw,
    updateWithdrawInfo
}