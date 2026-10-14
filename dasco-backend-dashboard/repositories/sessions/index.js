const { sessionModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { dashboardDB } = require("../../database/connections");

async function getSession(sessionId, language) {
    try {
        const session = await sessionModel.findById(sessionId);
        if (!session) {
            return {
                msg: getSuitableTranslations("Sorry, This Session Is Not Exist !!", language),
                error: true,
                data: {}
            }
        }
        return {
            msg: getSuitableTranslations("Get Session Process Has Been Successfully !!", language),
            error: false,
            data: session
        }
    }
    catch (err) {
        throw Error(err);
    }
}

async function checkOrCreateSession(email, mobilePhone, typeOfUse, language, dbSession = null) {
    let internalSession = false;
    try {
        let session = null;
        session = await sessionModel.findOne({ typeOfUse, ...email ? { email } : { mobilePhone } });
        if (!session) {
            const sessionInstance = new sessionModel({
                ...email && { email },
                ...mobilePhone && { mobilePhone },
                typeOfUse
            });
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            session = await sessionInstance.save({ session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
        }
        return {
            msg: getSuitableTranslations("Creating New Session Process Has Been Successfully !!", language),
            error: false,
            data: session
        }
    }
    catch (err) {
        if (internalSession && dbSession) {
            await dbSession.abortTransaction();
            await dbSession.endSession();
        }
        throw Error(err);
    } s
}

module.exports = {
    getSession,
    checkOrCreateSession
}