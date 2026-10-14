const { systemSettingsModel } = require("../../models/dashboard");
const { getSuitableTranslations } = require("../../helpers/translation");
const { DEFAULT_SEND_CURRENCY_SYMBOL } = require("../../constants/currencies");

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

function normalizeIdentity(identity = {}) {
    const assetsBaseUrl = (
        process.env.DASHBOARD_ASSETS_BASE_URL ||
        process.env.BASE_ADMIN_API_URL ||
        "http://127.0.0.1:3033"
    ).replace(/\/+$/, "");

    const resolvePath = (pathValue) => {
        const raw = (pathValue || "").toString().trim();
        if (!raw) return "";
        if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;
        return `${assetsBaseUrl}/${raw.replace(/^\/+/, "")}`;
    };

    return {
        themeMode: ["solid", "gradient", "image"].includes(identity?.themeMode)
            ? identity.themeMode
            : DEFAULT_APP_VISUAL_IDENTITY.themeMode,
        solidBackgroundColor: identity?.solidBackgroundColor || DEFAULT_APP_VISUAL_IDENTITY.solidBackgroundColor,
        gradientStartColor: identity?.gradientStartColor || DEFAULT_APP_VISUAL_IDENTITY.gradientStartColor,
        gradientEndColor: identity?.gradientEndColor || DEFAULT_APP_VISUAL_IDENTITY.gradientEndColor,
        textColor: identity?.textColor || DEFAULT_APP_VISUAL_IDENTITY.textColor,
        logoPath: resolvePath(identity?.logoPath || DEFAULT_APP_VISUAL_IDENTITY.logoPath),
        backgroundImagePath: resolvePath(identity?.backgroundImagePath || DEFAULT_APP_VISUAL_IDENTITY.backgroundImagePath),
        uiTokens: {
            ...DEFAULT_APP_VISUAL_IDENTITY.uiTokens,
            ...(identity?.uiTokens || {}),
        },
    };
}

async function getPublicAppVisualIdentity(language) {
    try {
        const systemSettings = await systemSettingsModel.findOne({}, { appVisualIdentity: 1, allowedSendCurrencies: 1, _id: 0 });
        const identity = normalizeIdentity(systemSettings?.appVisualIdentity || {});
        // Carried on the config call the app already makes at launch, so
        // withdrawing a stablecoin reaches every installed app on next start
        // without an app-store release. Order matters: the first entry is what
        // the app pre-selects.
        const allowedSendCurrencies = Array.isArray(systemSettings?.allowedSendCurrencies) && systemSettings.allowedSendCurrencies.length > 0
            ? systemSettings.allowedSendCurrencies
            : [DEFAULT_SEND_CURRENCY_SYMBOL];
        return {
            msg: getSuitableTranslations("Get System Overview Process Has Been Successfully !!", language),
            error: false,
            data: { ...identity, allowedSendCurrencies },
        };
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    getPublicAppVisualIdentity,
};
