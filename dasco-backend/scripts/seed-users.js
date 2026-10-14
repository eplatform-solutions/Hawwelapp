const { resolve } = require("path");
const { hash } = require("bcryptjs");
const { clientDB } = require("../database/connections");
const userModel = require("../models/client/user");

require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const DEFAULT_PASSWORD = process.env.SEED_USERS_PASSWORD || "UserPass123#";

const INITIAL_USERS = [
    {
        name: "Ahmad Alhamwi",
        nickname: "ahmad",
        fatherName: "Khaled",
        country: "SY",
        mobilePhone: "+963944000101",
        email: "ahmad.sy@example.com",
    },
    {
        name: "Rama Darwish",
        nickname: "rama",
        fatherName: "Yousef",
        country: "SY",
        mobilePhone: "+963944000102",
        email: "rama.sy@example.com",
    },
    {
        name: "Omar Alali",
        nickname: "omar",
        fatherName: "Mahmoud",
        country: "SY",
        mobilePhone: "+963944000103",
        email: "omar.sy@example.com",
    },
    {
        name: "Lina Haddad",
        nickname: "lina",
        fatherName: "Fares",
        country: "SY",
        mobilePhone: "+963944000104",
        email: "lina.sy@example.com",
    },
    {
        name: "Yazan Shami",
        nickname: "yazan",
        fatherName: "Sami",
        country: "SY",
        mobilePhone: "+963944000105",
        email: "yazan.sy@example.com",
    },
];

async function seedUsers() {
    await clientDB.openUri(process.env.DB_URL);
    const encryptedPassword = await hash(DEFAULT_PASSWORD, 10);
    let createdCount = 0;

    for (const user of INITIAL_USERS) {
        const exists = await userModel.findOne({
            $or: [{ mobilePhone: user.mobilePhone }, { email: user.email }],
        });

        if (exists) continue;

        await new userModel({
            ...user,
            password: encryptedPassword,
            status: "active",
            isVerified: true,
            verifiedAt: new Date(),
        }).save();

        createdCount += 1;
    }

    await clientDB.close();
    console.log(`[seed-users] Done. Created ${createdCount} users. Password: ${DEFAULT_PASSWORD}`);
}

seedUsers()
    .then(() => process.exit(0))
    .catch(async (err) => {
        console.error("[seed-users]", err?.message || err);
        await clientDB.close();
        process.exit(1);
    });
