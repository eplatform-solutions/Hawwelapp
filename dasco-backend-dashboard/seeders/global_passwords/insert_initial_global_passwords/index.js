const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const globalPasswordModel = require("../../../models/dashboard/global_password");

// require cryptoJs module for password encrypting

const cryptoJS = require("crypto-js");

const bussinessInfo = {
    email: process.env.BUSSINESS_EMAIL,
    password: process.env.BUSSINESS_EMAIL_PASSWORD,
};

async function create_initial_global_password() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        let user = await globalPasswordModel.findOne({ email: bussinessInfo.email });
        if (user) {
            await dashboardDB.close();
            return "Sorry, Can't Insert Global Password To Database Because it is Exist !!!";
        } else {
            const password = bussinessInfo.password;
            const encrypted_password = cryptoJS.AES.encrypt(password, process.env.SECRET_KEY).toString();
            bussinessInfo.password = encrypted_password;
            const new_global_password = new globalPasswordModel(bussinessInfo);
            await new_global_password.save();
            await dashboardDB.close();
            return "Ok !!, Create Initial Global Password Has Been Successfuly !!";
        }
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_global_password()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); })