/**
 * ينشئ حساب المشرف من متغيرات MAIN_ADMIN_* إن لم يكن موجوداً.
 * يُستدعى من run-local-memory.js مع DASH_DB_URL المؤقت.
 */
const { resolve } = require("path");
require("dotenv").config({
    path: resolve(__dirname, `../.env.${process.env.NODE_ENV || "development"}`),
});

const { dashboardDB } = require("../database/connections");
const adminModel = require("../models/dashboard/admin");
const systemSettingsModel = require("../models/dashboard/system_setting");
const exchangeRateModel = require("../models/dashboard/exchange_rate");
const blockchainWalletModel = require("../models/dashboard/blockchain_wallet");
const currencyRateModel = require("../models/dashboard/currency_rate");
const permissionModel = require("../models/dashboard/permission");
const { INITIAL_PERMISSIONS } = require("../constants/permissions");
const { hash } = require("bcryptjs");
const web3 = require("web3");

function stripQuotes(v) {
    if (typeof v !== "string") return v;
    const t = v.trim();
    if ((t.startsWith("'") && t.endsWith("'")) || (t.startsWith('"') && t.endsWith('"'))) {
        return t.slice(1, -1);
    }
    return t;
}

async function main() {
    const uri = process.env.DASH_DB_URL;
    if (!uri) return;
    await dashboardDB.openUri(uri);
    const email = process.env.MAIN_ADMIN_EMAIL;
    if (!email) {
        await dashboardDB.close();
        return;
    }
    const exists = await adminModel.findOne({ email });
    if (exists) {
        await ensureDashboardDefaults();
        await dashboardDB.close();
        return;
    }
    const plain = stripQuotes(process.env.MAIN_ADMIN_PASSWORD);
    const encrypted_password = await hash(plain, 10);
    await new adminModel({
        fullName: stripQuotes(process.env.MAIN_ADMIN_FULL_NAME) || "Admin",
        userName: stripQuotes(process.env.MAIN_ADMIN_USER_NAME) || "admin",
        email,
        mobilePhone: process.env.MAIN_ADMIN_MOBILE_PHONE,
        password: encrypted_password,
        isSuperAdmin: true,
    }).save();
    await ensureDashboardDefaults();
    await dashboardDB.close();
    console.log("[seed-dev-admin] Created initial admin:", email);
}

async function ensureDashboardDefaults() {
    await permissionModel.bulkWrite(
        INITIAL_PERMISSIONS.map((perm) => ({
            updateOne: {
                filter: { codeName: perm.codeName },
                update: { $setOnInsert: perm },
                upsert: true,
            },
        }))
    );

    await systemSettingsModel.updateOne(
        {},
        {
            $setOnInsert: {
                isTransferDisabled: false,
                isMaintenanceMode: false,
                appVisualIdentity: {
                    themeMode: "gradient",
                    solidBackgroundColor: "#FFFFFF",
                    gradientStartColor: "#00443A",
                    gradientEndColor: "#00AA91",
                    textColor: "#000000",
                    logoPath: "",
                    backgroundImagePath: "",
                    uiTokens: {
                        screenBackgroundColor: "#F3F4F6",
                        cardBackgroundColor: "#FFFFFF",
                        cardStyleMode: "solid",
                        cardGradientStartColor: "#FFFFFF",
                        cardGradientEndColor: "#E5E7EB",
                        cardBorderColor: "#D1D5DB",
                        primaryTextColor: "#111827",
                        secondaryTextColor: "#6B7280",
                        inputBackgroundColor: "#FFFFFF",
                        inputStyleMode: "solid",
                        inputGradientStartColor: "#FFFFFF",
                        inputGradientEndColor: "#F3F4F6",
                        inputBorderColor: "#D1D5DB",
                        inputTextColor: "#111827",
                        buttonBackgroundColor: "#6B1F2A",
                        buttonStyleMode: "solid",
                        buttonGradientStartColor: "#6B1F2A",
                        buttonGradientEndColor: "#9B3A49",
                        buttonTextColor: "#FFFFFF",
                    },
                },
            },
        },
        { upsert: true }
    );

    await exchangeRateModel.updateOne(
        { baseSymbol: "USDT", quoteSymbol: "SYP" },
        { $setOnInsert: { baseSymbol: "USDT", quoteSymbol: "SYP", rate: 15000 } },
        { upsert: true }
    );

    await exchangeRateModel.updateOne(
        { baseSymbol: "USDC", quoteSymbol: "SYP" },
        { $setOnInsert: { baseSymbol: "USDC", quoteSymbol: "SYP", rate: 14950 } },
        { upsert: true }
    );

    await currencyRateModel.updateOne(
        { code: "SYP" },
        { $setOnInsert: { code: "SYP", name: "Syrian Pound", usdtRate: 15000, usdcRate: 14950 } },
        { upsert: true }
    );
    await currencyRateModel.updateOne(
        { code: "USD" },
        { $setOnInsert: { code: "USD", name: "US Dollar", usdtRate: 1, usdcRate: 1 } },
        { upsert: true }
    );

    await ensureWalletExists({
        type: "central",
        symbol: "USDT",
        network: "MATIC",
        address: "0x1111111111111111111111111111111111111111",
    });
    await ensureWalletExists({
        type: "central",
        symbol: "USDC",
        network: "MATIC",
        address: "0x3333333333333333333333333333333333333333",
    });

    await ensureWalletExists({
        type: "network-fee-funding",
        symbol: "USDT",
        network: "BSC",
        address: "0x4444444444444444444444444444444444444444",
        // Throwaway key generated per local run; never commit a real key here.
        privateKey: web3.eth.accounts.create().privateKey,
    });
    await ensureWalletExists({
        type: "network-fee-funding",
        symbol: "USDC",
        network: "BSC",
        address: "0x2222222222222222222222222222222222222222",
        privateKey: web3.eth.accounts.create().privateKey,
    });
}

async function ensureWalletExists(wallet) {
    const exists = await blockchainWalletModel.findOne({
        symbol: wallet.symbol,
        network: wallet.network,
    });
    if (exists) return;
    await new blockchainWalletModel(wallet).save();
}

module.exports = { main };
