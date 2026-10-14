const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const systemSettingsModel = require("../../../models/dashboard/system_setting");

async function create_initial_system_settings() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        const systemSettings = await systemSettingsModel.findOne({});
        if (systemSettings) {
            await dashboardDB.close();
            return "Sorry, Can't Create Initial System Settings Because it is Exist !!";
        } else {
            const newSystemSettingsInstance = new systemSettingsModel({});
            await newSystemSettingsInstance.save();
            await dashboardDB.close();
            return "Ok !!, Create Initial Initial System Settings Has Been Successfuly !!";
        }
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_system_settings()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); })