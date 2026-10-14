<script setup>
definePageMeta({ layout: false, middleware: false });

import { ref, computed, onMounted, onBeforeUnmount } from "vue";
import PreviewWelcome from "~/components/app-preview/PreviewWelcome.vue";
import PreviewLogin from "~/components/app-preview/PreviewLogin.vue";
import PreviewRegister from "~/components/app-preview/PreviewRegister.vue";
import PreviewTransfer from "~/components/app-preview/PreviewTransfer.vue";
import PreviewAppHome from "~/components/app-preview/PreviewAppHome.vue";
import PreviewNotifications from "~/components/app-preview/PreviewNotifications.vue";

const route = useRoute();
const config = useRuntimeConfig();
const BASE_URL = config.public.BASE_URL;

const screenMap = {
  welcome: PreviewWelcome,
  login: PreviewLogin,
  register: PreviewRegister,
  transfer: PreviewTransfer,
  "app-home": PreviewAppHome,
  notifications: PreviewNotifications,
};

const currentScreen = computed(() => {
  const s = (route.query.screen || "welcome").toString();
  return screenMap[s] || PreviewWelcome;
});

const identity = ref(null);
const previewRootRef = ref(null);

const defaultIdentity = {
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

function applyBrandingVars(id) {
  if (!id) return;
  const tk = id.uiTokens || {};
  const root = previewRootRef.value;
  if (!root) return;

  const vars = {
    "--screen-bg": tk.screenBackgroundColor || "#F3F4F6",
    "--header-grad-start": id.gradientStartColor || "#00443A",
    "--header-grad-end": id.gradientEndColor || "#00AA91",
    "--header-grad-angle": `${tk.headerGradientAngle ?? 180}deg`,
    "--header-opacity": tk.headerOpacity ?? 1,
    "--solid-bg": id.solidBackgroundColor || "#FFFFFF",
    "--text-color": id.textColor || "#000000",
    "--primary-text": tk.primaryTextColor || "#111827",
    "--secondary-text": tk.secondaryTextColor || "#6B7280",
    "--hint-text": tk.hintTextColor || "#7A7A7A",
    "--button-bg": tk.buttonBackgroundColor || "#6B1F2A",
    "--button-text": tk.buttonTextColor || "#FFFFFF",
    "--button-grad-start": tk.buttonGradientStartColor || "#6B1F2A",
    "--button-grad-end": tk.buttonGradientEndColor || "#9B3A49",
    "--button-grad-angle": `${tk.buttonGradientAngle ?? 135}deg`,
    "--button-opacity": tk.buttonOpacity ?? 1,
    "--button-style": tk.buttonStyleMode || "solid",
    "--card-bg": tk.cardBackgroundColor || "#FFFFFF",
    "--card-border": tk.cardBorderColor || "#D1D5DB",
    "--card-grad-start": tk.cardGradientStartColor || "#FFFFFF",
    "--card-grad-end": tk.cardGradientEndColor || "#E5E7EB",
    "--card-grad-angle": `${tk.cardGradientAngle ?? 180}deg`,
    "--card-opacity": tk.cardOpacity ?? 1,
    "--card-style": tk.cardStyleMode || "solid",
    "--input-bg": tk.inputBackgroundColor || "#FFFFFF",
    "--input-border": tk.inputBorderColor || "#D1D5DB",
    "--input-text": tk.inputTextColor || "#111827",
    "--accent": tk.accentColor || "#B9A779",
    "--link": tk.linkColor || "#295F4D",
    "--success": tk.successColor || "#4A856A",
    "--error": tk.errorColor || "#E53935",
    "--warning": tk.warningColor || "#FFCC00",
    "--divider": tk.dividerColor || "#D9D9D9",
    "--icon-primary": tk.iconPrimaryColor || "#6B1F2A",
    "--icon-secondary": tk.iconSecondaryColor || "#B9A779",
    "--nav-active": tk.navBarActiveIconColor || "#E6C07A",
    "--nav-grad-angle": `${tk.navBarGradientAngle ?? 0}deg`,
    "--nav-opacity": tk.navBarOpacity ?? 1,
    "--dialog-bg": tk.dialogBackgroundColor || "#FFFFFF",
    "--badge": tk.badgeColor || "#128372",
    "--app-bar": tk.appBarColor || "#128271",
    "--theme-mode": id.themeMode || "gradient",
    "--logo-url": id.logoPath ? `url(${BASE_URL}/${id.logoPath})` : "none",
    "--bg-image-url": id.backgroundImagePath ? `url(${BASE_URL}/${id.backgroundImagePath})` : "none",
  };

  for (const [k, v] of Object.entries(vars)) {
    root.style.setProperty(k, v);
  }
}

function onMessage(event) {
  if (!event.data) return;
  let data = event.data;
  if (typeof data === "string") {
    try { data = JSON.parse(data); } catch { return; }
  }
  if (data.type === "branding-update" && data.identity) {
    identity.value = data.identity;
    applyBrandingVars(data.identity);
  }
}

async function fetchBrandingFallback() {
  try {
    const res = await $fetch(`${BASE_URL}/app-visual-identity/public`);
    const d = res?.data?.appVisualIdentity || res?.appVisualIdentity || res?.data || res;
    if (d && d.uiTokens) {
      identity.value = d;
      applyBrandingVars(d);
    }
  } catch {
    identity.value = defaultIdentity;
    applyBrandingVars(defaultIdentity);
  }
}

onMounted(() => {
  window.addEventListener("message", onMessage);
  applyBrandingVars(defaultIdentity);
  fetchBrandingFallback();
});

onBeforeUnmount(() => {
  window.removeEventListener("message", onMessage);
});

const logoUrl = computed(() => {
  if (!identity.value) return "";
  return identity.value.logoPath ? `${BASE_URL}/${identity.value.logoPath}` : "";
});
</script>

<template>
  <div ref="previewRootRef" class="preview-root">
    <component :is="currentScreen" :identity="identity" :logo-url="logoUrl" />
  </div>
</template>

<style scoped>
.preview-root {
  --su: calc(100vw / 375);
  --screen-bg: #F3F4F6;
  --header-grad-start: #00443A;
  --header-grad-end: #00AA91;
  --header-grad-angle: 180deg;
  --header-opacity: 1;
  --solid-bg: #FFFFFF;
  --text-color: #000000;
  --primary-text: #111827;
  --secondary-text: #6B7280;
  --hint-text: #7A7A7A;
  --button-bg: #6B1F2A;
  --button-text: #FFFFFF;
  --button-grad-start: #6B1F2A;
  --button-grad-end: #9B3A49;
  --button-grad-angle: 135deg;
  --button-opacity: 1;
  --button-style: solid;
  --card-bg: #FFFFFF;
  --card-border: #D1D5DB;
  --card-grad-start: #FFFFFF;
  --card-grad-end: #E5E7EB;
  --card-grad-angle: 180deg;
  --card-opacity: 1;
  --card-style: solid;
  --input-bg: #FFFFFF;
  --input-border: #D1D5DB;
  --input-text: #111827;
  --accent: #B9A779;
  --link: #295F4D;
  --success: #4A856A;
  --error: #E53935;
  --warning: #FFCC00;
  --divider: #D9D9D9;
  --icon-primary: #6B1F2A;
  --icon-secondary: #B9A779;
  --nav-active: #E6C07A;
  --nav-grad-angle: 0deg;
  --nav-opacity: 1;
  --dialog-bg: #FFFFFF;
  --badge: #128372;
  --app-bar: #128271;
  --logo-url: none;
  --bg-image-url: none;
  --theme-mode: gradient;

  width: 100vw;
  height: 100vh;
  overflow-y: auto;
  overflow-x: hidden;
  position: relative;
  background: var(--screen-bg);
  direction: rtl;
  font-family: 'Cairo', sans-serif;
  -webkit-font-smoothing: antialiased;
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
</style>

