const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const defaultAppVisualIdentity = {
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

// Create System Settings Schema

const systemSettingsSchema = new mongoose.Schema({
    isTransferDisabled: {
        type: Boolean,
        required: [true, "isTransferDisabled is required"],
        default: false
    },
    isMaintenanceMode: {
        type: Boolean,
        required: [true, "isMaintenanceMode is required"],
        default: false
    },
    appVisualIdentity: {
        themeMode: {
            type: String,
            enum: {
                values: ["solid", "gradient", "image"],
                message: "Invalid theme mode"
            },
            default: defaultAppVisualIdentity.themeMode,
            trim: true,
            lowercase: true,
        },
        solidBackgroundColor: {
            type: String,
            default: defaultAppVisualIdentity.solidBackgroundColor,
            trim: true,
        },
        gradientStartColor: {
            type: String,
            default: defaultAppVisualIdentity.gradientStartColor,
            trim: true,
        },
        gradientEndColor: {
            type: String,
            default: defaultAppVisualIdentity.gradientEndColor,
            trim: true,
        },
        textColor: {
            type: String,
            default: defaultAppVisualIdentity.textColor,
            trim: true,
        },
        logoPath: {
            type: String,
            default: defaultAppVisualIdentity.logoPath,
            trim: true,
        },
        backgroundImagePath: {
            type: String,
            default: defaultAppVisualIdentity.backgroundImagePath,
            trim: true,
        },
        uiTokens: {
            screenBackgroundColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.screenBackgroundColor,
                trim: true,
            },
            cardBackgroundColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.cardBackgroundColor,
                trim: true,
            },
            cardStyleMode: {
                type: String,
                enum: {
                    values: ["solid", "gradient"],
                    message: "Invalid card style mode"
                },
                default: defaultAppVisualIdentity.uiTokens.cardStyleMode,
                trim: true,
                lowercase: true,
            },
            cardGradientStartColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.cardGradientStartColor,
                trim: true,
            },
            cardGradientEndColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.cardGradientEndColor,
                trim: true,
            },
            cardBorderColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.cardBorderColor,
                trim: true,
            },
            primaryTextColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.primaryTextColor,
                trim: true,
            },
            secondaryTextColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.secondaryTextColor,
                trim: true,
            },
            inputBackgroundColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.inputBackgroundColor,
                trim: true,
            },
            inputStyleMode: {
                type: String,
                enum: {
                    values: ["solid", "gradient"],
                    message: "Invalid input style mode"
                },
                default: defaultAppVisualIdentity.uiTokens.inputStyleMode,
                trim: true,
                lowercase: true,
            },
            inputGradientStartColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.inputGradientStartColor,
                trim: true,
            },
            inputGradientEndColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.inputGradientEndColor,
                trim: true,
            },
            inputBorderColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.inputBorderColor,
                trim: true,
            },
            inputTextColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.inputTextColor,
                trim: true,
            },
            buttonBackgroundColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.buttonBackgroundColor,
                trim: true,
            },
            buttonStyleMode: {
                type: String,
                enum: {
                    values: ["solid", "gradient"],
                    message: "Invalid button style mode"
                },
                default: defaultAppVisualIdentity.uiTokens.buttonStyleMode,
                trim: true,
                lowercase: true,
            },
            buttonGradientStartColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.buttonGradientStartColor,
                trim: true,
            },
            buttonGradientEndColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.buttonGradientEndColor,
                trim: true,
            },
            buttonTextColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.buttonTextColor,
                trim: true,
            },
            accentColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.accentColor,
                trim: true,
            },
            linkColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.linkColor,
                trim: true,
            },
            successColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.successColor,
                trim: true,
            },
            errorColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.errorColor,
                trim: true,
            },
            warningColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.warningColor,
                trim: true,
            },
            dividerColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.dividerColor,
                trim: true,
            },
            hintTextColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.hintTextColor,
                trim: true,
            },
            iconPrimaryColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.iconPrimaryColor,
                trim: true,
            },
            iconSecondaryColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.iconSecondaryColor,
                trim: true,
            },
            navBarActiveIconColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.navBarActiveIconColor,
                trim: true,
            },
            dialogBackgroundColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.dialogBackgroundColor,
                trim: true,
            },
            badgeColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.badgeColor,
                trim: true,
            },
            appBarColor: {
                type: String,
                default: defaultAppVisualIdentity.uiTokens.appBarColor,
                trim: true,
            },
            headerGradientAngle: { type: Number, default: defaultAppVisualIdentity.uiTokens.headerGradientAngle, min: 0, max: 360 },
            buttonGradientAngle: { type: Number, default: defaultAppVisualIdentity.uiTokens.buttonGradientAngle, min: 0, max: 360 },
            cardGradientAngle: { type: Number, default: defaultAppVisualIdentity.uiTokens.cardGradientAngle, min: 0, max: 360 },
            navBarGradientAngle: { type: Number, default: defaultAppVisualIdentity.uiTokens.navBarGradientAngle, min: 0, max: 360 },
            headerOpacity: { type: Number, default: defaultAppVisualIdentity.uiTokens.headerOpacity, min: 0, max: 1 },
            buttonOpacity: { type: Number, default: defaultAppVisualIdentity.uiTokens.buttonOpacity, min: 0, max: 1 },
            cardOpacity: { type: Number, default: defaultAppVisualIdentity.uiTokens.cardOpacity, min: 0, max: 1 },
            navBarOpacity: { type: Number, default: defaultAppVisualIdentity.uiTokens.navBarOpacity, min: 0, max: 1 },
        },
    },
}, {
    timestamps: true
});

// Create System Settings Model From System Settings Schema

const systemSettingsModel = dashboardDB.model("system_setting", systemSettingsSchema);

module.exports = systemSettingsModel;