const { dashboardDB } = require("../../../database/connections");

const { resolve } = require("path");

require("dotenv").config({
    path: resolve(__dirname, `../../../.env.${process.env.NODE_ENV || "development"}`),
});

const adminModel = require("../../../models/dashboard/admin");

// require bcryptjs module for password encrypting

const { hash } = require("bcryptjs");

const INITIAL_ADMIN_INFO = {
    fullName: process.env.MAIN_ADMIN_FULL_NAME,
    userName: process.env.MAIN_ADMIN_USER_NAME,
    email: process.env.MAIN_ADMIN_EMAIL,
    mobilePhone: process.env.MAIN_ADMIN_MOBILE_PHONE,
    password: process.env.MAIN_ADMIN_PASSWORD,
    isSuperAdmin: true,
}

async function create_initial_admin_account() {
    try {
        await dashboardDB.openUri(process.env.DASH_DB_URL);
        let admin = await adminModel.findOne({ email: INITIAL_ADMIN_INFO.email });
        if (admin) {
            await dashboardDB.close();
            return "Sorry, Can't Insert Admin Data To Database Because it is Exist !!!";
        }
        const encrypted_password = await hash(INITIAL_ADMIN_INFO.password, 10);
        INITIAL_ADMIN_INFO.password = encrypted_password;
        const new_admin_user = new adminModel(INITIAL_ADMIN_INFO);
        await new_admin_user.save();
        await dashboardDB.close();
        return "Ok !!, Create Initial Admin Account Process Has Been Successfuly !!";
    } catch (err) {
        await dashboardDB.close();
        throw Error(err);
    }
}

create_initial_admin_account()
    .then((result) => { console.log(result); process.exit(0); })
    .catch((err) => { console.log(err); process.exit(1); })