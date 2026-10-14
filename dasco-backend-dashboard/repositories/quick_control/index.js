// Import Required Models

const { adminModel, systemSettingsModel, exchangeRateModel, paymentMethodModel, blockchainWalletModel } = require("../../models/dashboard");

const { getSuitableTranslations } = require("../../helpers/translation");

const { populateRole } = require("../../helpers/roles");

const { authorizeAdmin } = require("../../helpers/permissions");

const { dashboardDB } = require("../../database/connections");
const { existsSync, unlinkSync } = require("fs");
const path = require("path");

const { getTokenBalance, getNativeBalance } = require("../../helpers/blockchain/balances");

const DEFAULT_APP_VISUAL_IDENTITY = {
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
        accentColor: "#B9A779",
        linkColor: "#295F4D",
        successColor: "#4A856A",
        errorColor: "#E53935",
        warningColor: "#FFCC00",
        dividerColor: "#D9D9D9",
        hintTextColor: "#7A7A7A",
        iconPrimaryColor: "#6B1F2A",
        iconSecondaryColor: "#B9A779",
        navBarActiveIconColor: "#E6C07A",
        dialogBackgroundColor: "#FFFFFF",
        badgeColor: "#128372",
        appBarColor: "#128271",
        headerGradientAngle: 180,
        buttonGradientAngle: 135,
        cardGradientAngle: 180,
        navBarGradientAngle: 0,
        headerOpacity: 1,
        buttonOpacity: 1,
        cardOpacity: 1,
        navBarOpacity: 1,
    },
};

function getSanitizedAppVisualIdentity(newIdentity = {}, currentIdentity = DEFAULT_APP_VISUAL_IDENTITY) {
    const currentTokens = currentIdentity?.uiTokens || DEFAULT_APP_VISUAL_IDENTITY.uiTokens;
    const newTokens = newIdentity?.uiTokens || {};
    return {
        themeMode: ["solid", "gradient", "image"].includes(newIdentity?.themeMode)
            ? newIdentity.themeMode
            : (currentIdentity?.themeMode || DEFAULT_APP_VISUAL_IDENTITY.themeMode),
        solidBackgroundColor: newIdentity?.solidBackgroundColor ?? currentIdentity?.solidBackgroundColor ?? DEFAULT_APP_VISUAL_IDENTITY.solidBackgroundColor,
        gradientStartColor: newIdentity?.gradientStartColor ?? currentIdentity?.gradientStartColor ?? DEFAULT_APP_VISUAL_IDENTITY.gradientStartColor,
        gradientEndColor: newIdentity?.gradientEndColor ?? currentIdentity?.gradientEndColor ?? DEFAULT_APP_VISUAL_IDENTITY.gradientEndColor,
        textColor: newIdentity?.textColor ?? currentIdentity?.textColor ?? DEFAULT_APP_VISUAL_IDENTITY.textColor,
        logoPath: newIdentity?.logoPath ?? currentIdentity?.logoPath ?? DEFAULT_APP_VISUAL_IDENTITY.logoPath,
        backgroundImagePath: newIdentity?.backgroundImagePath ?? currentIdentity?.backgroundImagePath ?? DEFAULT_APP_VISUAL_IDENTITY.backgroundImagePath,
        uiTokens: {
            screenBackgroundColor: newTokens?.screenBackgroundColor ?? currentTokens.screenBackgroundColor,
            cardBackgroundColor: newTokens?.cardBackgroundColor ?? currentTokens.cardBackgroundColor,
            cardStyleMode: ["solid", "gradient"].includes(newTokens?.cardStyleMode)
                ? newTokens.cardStyleMode
                : currentTokens.cardStyleMode,
            cardGradientStartColor: newTokens?.cardGradientStartColor ?? currentTokens.cardGradientStartColor,
            cardGradientEndColor: newTokens?.cardGradientEndColor ?? currentTokens.cardGradientEndColor,
            cardBorderColor: newTokens?.cardBorderColor ?? currentTokens.cardBorderColor,
            primaryTextColor: newTokens?.primaryTextColor ?? currentTokens.primaryTextColor,
            secondaryTextColor: newTokens?.secondaryTextColor ?? currentTokens.secondaryTextColor,
            inputBackgroundColor: newTokens?.inputBackgroundColor ?? currentTokens.inputBackgroundColor,
            inputStyleMode: ["solid", "gradient"].includes(newTokens?.inputStyleMode)
                ? newTokens.inputStyleMode
                : currentTokens.inputStyleMode,
            inputGradientStartColor: newTokens?.inputGradientStartColor ?? currentTokens.inputGradientStartColor,
            inputGradientEndColor: newTokens?.inputGradientEndColor ?? currentTokens.inputGradientEndColor,
            inputBorderColor: newTokens?.inputBorderColor ?? currentTokens.inputBorderColor,
            inputTextColor: newTokens?.inputTextColor ?? currentTokens.inputTextColor,
            buttonBackgroundColor: newTokens?.buttonBackgroundColor ?? currentTokens.buttonBackgroundColor,
            buttonStyleMode: ["solid", "gradient"].includes(newTokens?.buttonStyleMode)
                ? newTokens.buttonStyleMode
                : currentTokens.buttonStyleMode,
            buttonGradientStartColor: newTokens?.buttonGradientStartColor ?? currentTokens.buttonGradientStartColor,
            buttonGradientEndColor: newTokens?.buttonGradientEndColor ?? currentTokens.buttonGradientEndColor,
            buttonTextColor: newTokens?.buttonTextColor ?? currentTokens.buttonTextColor,
            accentColor: newTokens?.accentColor ?? currentTokens.accentColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.accentColor,
            linkColor: newTokens?.linkColor ?? currentTokens.linkColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.linkColor,
            successColor: newTokens?.successColor ?? currentTokens.successColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.successColor,
            errorColor: newTokens?.errorColor ?? currentTokens.errorColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.errorColor,
            warningColor: newTokens?.warningColor ?? currentTokens.warningColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.warningColor,
            dividerColor: newTokens?.dividerColor ?? currentTokens.dividerColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.dividerColor,
            hintTextColor: newTokens?.hintTextColor ?? currentTokens.hintTextColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.hintTextColor,
            iconPrimaryColor: newTokens?.iconPrimaryColor ?? currentTokens.iconPrimaryColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.iconPrimaryColor,
            iconSecondaryColor: newTokens?.iconSecondaryColor ?? currentTokens.iconSecondaryColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.iconSecondaryColor,
            navBarActiveIconColor: newTokens?.navBarActiveIconColor ?? currentTokens.navBarActiveIconColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.navBarActiveIconColor,
            dialogBackgroundColor: newTokens?.dialogBackgroundColor ?? currentTokens.dialogBackgroundColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.dialogBackgroundColor,
            badgeColor: newTokens?.badgeColor ?? currentTokens.badgeColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.badgeColor,
            appBarColor: newTokens?.appBarColor ?? currentTokens.appBarColor ?? DEFAULT_APP_VISUAL_IDENTITY.uiTokens.appBarColor,
            headerGradientAngle: Math.max(0, Math.min(360, Number(newTokens?.headerGradientAngle ?? currentTokens.headerGradientAngle ?? 180))),
            buttonGradientAngle: Math.max(0, Math.min(360, Number(newTokens?.buttonGradientAngle ?? currentTokens.buttonGradientAngle ?? 135))),
            cardGradientAngle: Math.max(0, Math.min(360, Number(newTokens?.cardGradientAngle ?? currentTokens.cardGradientAngle ?? 180))),
            navBarGradientAngle: Math.max(0, Math.min(360, Number(newTokens?.navBarGradientAngle ?? currentTokens.navBarGradientAngle ?? 0))),
            headerOpacity: Math.max(0, Math.min(1, Number(newTokens?.headerOpacity ?? currentTokens.headerOpacity ?? 1))),
            buttonOpacity: Math.max(0, Math.min(1, Number(newTokens?.buttonOpacity ?? currentTokens.buttonOpacity ?? 1))),
            cardOpacity: Math.max(0, Math.min(1, Number(newTokens?.cardOpacity ?? currentTokens.cardOpacity ?? 1))),
            navBarOpacity: Math.max(0, Math.min(1, Number(newTokens?.navBarOpacity ?? currentTokens.navBarOpacity ?? 1))),
        },
    };
}

function removeOldImageIfNeeded(oldPath, newPath) {
    if (!oldPath || oldPath === newPath) return;
    const normalized = oldPath.replace(/\\/g, "/");
    if (!normalized.startsWith("assets/images/app_identity/")) return;
    const absolutePath = path.resolve(process.cwd(), normalized);
    if (existsSync(absolutePath)) {
        unlinkSync(absolutePath);
    }
}

async function getSystemOverview(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "quick_control_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const systemSettingsDoc = await systemSettingsModel.findOne({}, { __v: 0, _id: 0, createdAt: 0 });
            const systemSettings = systemSettingsDoc || {
                isTransferDisabled: false,
                isMaintenanceMode: false,
                appVisualIdentity: DEFAULT_APP_VISUAL_IDENTITY,
            };
            systemSettings.appVisualIdentity = getSanitizedAppVisualIdentity({}, systemSettings.appVisualIdentity);
            const exchangeRates = await exchangeRateModel.find({}, { __v: 0, _id: 0 });
            const paymentMethods = await paymentMethodModel.find({}, { __v: 0 }).sort({ createdAt: -1 }).limit(5);
            const centralBlockchainWallets = await blockchainWalletModel.find({ type: "central" }, { __v: 0, privateKey: 0 });
            const networkFeeFundingBlockchainWallets = await blockchainWalletModel.find({ type: "network-fee-funding" }, { __v: 0 });
            const networkFeeFundingWalletsAfterDecryptPrivateKey = networkFeeFundingBlockchainWallets.map((wallet) => {
                const obj = wallet.toObject();
                try {
                    const decrypted = wallet.decryptPrivateKey();
                    if (decrypted && decrypted.length >= 4) {
                        obj.privateKey = `********${decrypted.slice(-4)}`;
                    } else {
                        obj.privateKey = "********";
                    }
                } catch (error) {
                    // Keep endpoint resilient even if one legacy/encrypted key is invalid.
                    obj.privateKey = "********";
                    console.error(
                        `[quick-control] wallet private key decrypt failed for walletId=${wallet?._id}: ${error?.message || error}`
                    );
                }
                return obj;
            });
            return {
                msg: getSuitableTranslations("Get System Overview Process Has Been Successfully !!", language),
                error: false,
                data: {
                    systemSettings,
                    exchangeRates,
                    paymentMethods,
                    centralBlockchainWallets,
                    networkFeeFundingBlockchainWallets: networkFeeFundingWalletsAfterDecryptPrivateKey
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

async function updateSystemSettings(adminId, newSystemSettings, language, dbSession = null) {
    let internalSession = false;
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "quick_control_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            let systemSettings = await systemSettingsModel.findOne();
            if (!systemSettings) {
                systemSettings = new systemSettingsModel({});
            }
            systemSettings.isTransferDisabled = newSystemSettings?.isTransferDisabled ?? systemSettings.isTransferDisabled;
            systemSettings.isMaintenanceMode = newSystemSettings?.isMaintenanceMode ?? systemSettings.isMaintenanceMode;
            if (newSystemSettings?.appVisualIdentity) {
                systemSettings.appVisualIdentity = getSanitizedAppVisualIdentity(
                    newSystemSettings.appVisualIdentity,
                    systemSettings.appVisualIdentity
                );
            } else if (!systemSettings.appVisualIdentity) {
                systemSettings.appVisualIdentity = { ...DEFAULT_APP_VISUAL_IDENTITY };
            }
            if (!dbSession) {
                dbSession = await dashboardDB.startSession();
                dbSession.startTransaction();
                internalSession = true;
            }
            await systemSettings.save({ session: dbSession });
            if (internalSession) {
                await dbSession.commitTransaction();
                await dbSession.endSession();
            }
            return {
                msg: getSuitableTranslations("Updating System Settings Process Has Been Successfully !!", language),
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

async function updateAppVisualIdentityImage(adminId, imagePath, imageType, language) {
    try {
        const admin = await adminModel.findById(adminId, { __v: false, password: false });
        if (!admin) {
            return {
                msg: getSuitableTranslations("Sorry, This Admin Is Not Exist !!", language),
                error: true,
                code: "ADMIN_NOT_FOUND",
                data: {},
            };
        }

        const populatedAdmin = await populateRole(admin);
        const authorizationResult = authorizeAdmin(populatedAdmin, "quick_control_managment", language);
        if (authorizationResult.error) {
            return authorizationResult;
        }

        let systemSettings = await systemSettingsModel.findOne();
        if (!systemSettings) {
            systemSettings = new systemSettingsModel({});
        }

        systemSettings.appVisualIdentity = getSanitizedAppVisualIdentity({}, systemSettings.appVisualIdentity);
        const oldPath = imageType === "logo"
            ? systemSettings.appVisualIdentity.logoPath
            : systemSettings.appVisualIdentity.backgroundImagePath;

        if (imageType === "logo") {
            systemSettings.appVisualIdentity.logoPath = imagePath;
        } else {
            systemSettings.appVisualIdentity.backgroundImagePath = imagePath;
            if (systemSettings.appVisualIdentity.themeMode === "image" && !imagePath) {
                systemSettings.appVisualIdentity.themeMode = "gradient";
            }
        }

        await systemSettings.save();
        removeOldImageIfNeeded(oldPath, imagePath);

        return {
            msg: getSuitableTranslations("Updating System Settings Process Has Been Successfully !!", language),
            error: false,
            data: {
                appVisualIdentity: systemSettings.appVisualIdentity
            },
        };
    }
    catch (err) {
        throw Error(err);
    }
}

// Kept separate from getSystemOverview on purpose - this makes real RPC
// calls to a blockchain node per wallet, so it's slower and more likely to
// fail transiently than the rest of the overview data. The frontend fetches
// it independently (with its own loading/refresh state) so a slow or
// unreachable node never blocks the page's other data from showing.
async function getWalletBalances(adminId, language) {
    try {
        const admin = await adminModel.findById(adminId);
        if (admin) {
            const populatedAdmin = await populateRole(admin);
            const authorizationResult = authorizeAdmin(populatedAdmin, "quick_control_managment", language);
            if (authorizationResult.error) {
                return authorizationResult;
            }
            const allWallets = await blockchainWalletModel.find({ type: { $in: ["central", "network-fee-funding"] } }, { __v: 0 });
            // A network-fee-funding wallet holds native gas, which is one
            // balance per network address - it's stored as one document per
            // (network, symbol) purely because the schema requires a
            // symbol, so USDT and USDC end up pointing at the exact same
            // address on the same network. Keep just one per network so it
            // isn't reported (and displayed) twice.
            const seenFundingNetworks = new Set();
            const wallets = allWallets.filter((wallet) => {
                if (wallet.type !== "network-fee-funding") return true;
                if (seenFundingNetworks.has(wallet.network)) return false;
                seenFundingNetworks.add(wallet.network);
                return true;
            });
            const balances = await Promise.all(wallets.map(async (wallet) => {
                const base = {
                    walletId: wallet._id,
                    type: wallet.type,
                    network: wallet.network,
                    address: wallet.address,
                };
                try {
                    if (wallet.type === "central") {
                        const balance = await getTokenBalance(wallet.network, wallet.symbol, wallet.address);
                        return { ...base, asset: wallet.symbol, balance, error: null };
                    }
                    const nativeAsset = wallet.network === "MATIC" ? "MATIC" : "BNB";
                    const balance = await getNativeBalance(wallet.network, wallet.address);
                    return { ...base, asset: nativeAsset, balance, error: null };
                } catch (err) {
                    return { ...base, asset: wallet.symbol, balance: null, error: err?.message || "Failed to fetch balance" };
                }
            }));
            return {
                msg: getSuitableTranslations("Get Wallet Balances Process Has Been Successfully !!", language),
                error: false,
                data: { balances },
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
    getSystemOverview,
    updateSystemSettings,
    updateAppVisualIdentityImage,
    getWalletBalances,
}