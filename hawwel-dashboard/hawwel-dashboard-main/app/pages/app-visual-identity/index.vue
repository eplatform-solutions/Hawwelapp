<template>
  <ClientOnly>
    <div>
      <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">
        <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">
          <HeaderPage />

          <div class="vi-root">
            <div class="vi-page-header">
              <div>
                <h1 class="vi-title">{{ $t("App visual identity") }}</h1>
                <p class="vi-subtitle">{{ $t("vi_subtitle") }}</p>
              </div>
              <UButton :loading="stateSave.loading" class="vi-save-btn" @click="saveIdentity">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                {{ $t("Save visual identity") }}
              </UButton>
            </div>

            <!-- Tab navigation -->
            <div class="vi-tabs">
              <button
                v-for="tab in mainTabs" :key="tab.id"
                class="vi-tab" :class="{ 'vi-tab-active': activeTab === tab.id }"
                @click="activeTab = tab.id"
              >
                <span v-html="tab.icon"></span>
                {{ $t(tab.label) }}
              </button>
            </div>

            <!-- ============ TAB: Quick Setup ============ -->
            <div v-if="activeTab === 'quick'" class="vi-content">
              <!-- Presets -->
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Quick presets") }}</h3>
                  <p class="vi-card-desc">{{ $t("vi_presets_desc") }}</p>
                </div>
                <div class="vi-presets-grid">
                  <button
                    v-for="preset in visualPresets" :key="preset.key"
                    class="vi-preset" @click="applyPreset(preset.key)"
                  >
                    <div class="vi-preset-swatch" :style="preset.swatchStyle"></div>
                    <span class="vi-preset-label">{{ $t(preset.label) }}</span>
                  </button>
                </div>
              </div>

              <!-- Theme mode -->
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Theme mode") }}</h3>
                </div>
                <div class="vi-theme-modes">
                  <button
                    v-for="mode in themeModes" :key="mode.value"
                    class="vi-theme-mode" :class="{ 'vi-theme-mode-active': identity.themeMode === mode.value }"
                    @click="identity.themeMode = mode.value"
                  >
                    <span v-html="mode.icon"></span>
                    <span>{{ $t(mode.label) }}</span>
                  </button>
                </div>

                <div v-if="identity.themeMode === 'solid'" class="vi-field-row mt-4">
                  <ColorField :label="$t('Background color')" v-model="identity.solidBackgroundColor" />
                </div>

                <div v-if="identity.themeMode === 'gradient'" class="mt-4">
                  <GradientEditor
                    :startColor="identity.gradientStartColor"
                    :endColor="identity.gradientEndColor"
                    :angle="identity.uiTokens.headerGradientAngle || 180"
                    :opacity="identity.uiTokens.headerOpacity ?? 1"
                    @update:startColor="identity.gradientStartColor = $event"
                    @update:endColor="identity.gradientEndColor = $event"
                    @update:angle="identity.uiTokens.headerGradientAngle = $event"
                    @update:opacity="identity.uiTokens.headerOpacity = $event"
                  />
                </div>

                <div v-if="identity.themeMode === 'image'" class="vi-field-row mt-4">
                  <div class="vi-field">
                    <label>{{ $t("Background image") }}</label>
                    <input type="file" accept="image/png,image/jpeg,image/webp" @change="onBgChange" class="vi-file-input" />
                    <UButton :loading="stateUploadBackground.loading" class="vi-upload-btn mt-2" @click="uploadBackground">
                      {{ $t("Upload background image") }}
                    </UButton>
                  </div>
                </div>
              </div>

              <!-- Base colors -->
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Basic settings") }}</h3>
                </div>
                <div class="vi-color-grid">
                  <div class="vi-color-field">
                    <label class="vi-color-label">{{ $t('Text color') }}</label>
                    <div class="vi-color-input-row">
                      <input
                        type="color"
                        class="vi-color-swatch"
                        :value="normalizeHex(identity.textColor, '#000000')"
                        @input="identity.textColor = $event.target.value"
                      />
                      <input
                        type="text"
                        class="vi-color-hex"
                        :value="normalizeHex(identity.textColor, '#000000')"
                        maxlength="7"
                        @input="identity.textColor = normalizeHex($event.target.value, '#000000')"
                      />
                    </div>
                  </div>

                  <div class="vi-color-field">
                    <label class="vi-color-label">{{ $t('Screen background color') }}</label>
                    <div class="vi-color-input-row">
                      <input
                        type="color"
                        class="vi-color-swatch"
                        :value="normalizeHex(identity.uiTokens.screenBackgroundColor, '#F3F4F6')"
                        @input="identity.uiTokens.screenBackgroundColor = $event.target.value"
                      />
                      <input
                        type="text"
                        class="vi-color-hex"
                        :value="normalizeHex(identity.uiTokens.screenBackgroundColor, '#F3F4F6')"
                        maxlength="7"
                        @input="identity.uiTokens.screenBackgroundColor = normalizeHex($event.target.value, '#F3F4F6')"
                      />
                    </div>
                  </div>

                  <div class="vi-color-field">
                    <label class="vi-color-label">{{ $t('Primary text color') }}</label>
                    <div class="vi-color-input-row">
                      <input
                        type="color"
                        class="vi-color-swatch"
                        :value="normalizeHex(identity.uiTokens.primaryTextColor, '#111827')"
                        @input="identity.uiTokens.primaryTextColor = $event.target.value"
                      />
                      <input
                        type="text"
                        class="vi-color-hex"
                        :value="normalizeHex(identity.uiTokens.primaryTextColor, '#111827')"
                        maxlength="7"
                        @input="identity.uiTokens.primaryTextColor = normalizeHex($event.target.value, '#111827')"
                      />
                    </div>
                  </div>

                  <div class="vi-color-field">
                    <label class="vi-color-label">{{ $t('Secondary text color') }}</label>
                    <div class="vi-color-input-row">
                      <input
                        type="color"
                        class="vi-color-swatch"
                        :value="normalizeHex(identity.uiTokens.secondaryTextColor, '#6B7280')"
                        @input="identity.uiTokens.secondaryTextColor = $event.target.value"
                      />
                      <input
                        type="text"
                        class="vi-color-hex"
                        :value="normalizeHex(identity.uiTokens.secondaryTextColor, '#6B7280')"
                        maxlength="7"
                        @input="identity.uiTokens.secondaryTextColor = normalizeHex($event.target.value, '#6B7280')"
                      />
                    </div>
                  </div>

                  <div class="vi-color-field">
                    <label class="vi-color-label">{{ $t('Hint text color') }}</label>
                    <div class="vi-color-input-row">
                      <input
                        type="color"
                        class="vi-color-swatch"
                        :value="normalizeHex(identity.uiTokens.hintTextColor, '#7A7A7A')"
                        @input="identity.uiTokens.hintTextColor = $event.target.value"
                      />
                      <input
                        type="text"
                        class="vi-color-hex"
                        :value="normalizeHex(identity.uiTokens.hintTextColor, '#7A7A7A')"
                        maxlength="7"
                        @input="identity.uiTokens.hintTextColor = normalizeHex($event.target.value, '#7A7A7A')"
                      />
                    </div>
                  </div>

                  <div class="vi-color-field">
                    <label class="vi-color-label">{{ $t('Divider color') }}</label>
                    <div class="vi-color-input-row">
                      <input
                        type="color"
                        class="vi-color-swatch"
                        :value="normalizeHex(identity.uiTokens.dividerColor, '#D9D9D9')"
                        @input="identity.uiTokens.dividerColor = $event.target.value"
                      />
                      <input
                        type="text"
                        class="vi-color-hex"
                        :value="normalizeHex(identity.uiTokens.dividerColor, '#D9D9D9')"
                        maxlength="7"
                        @input="identity.uiTokens.dividerColor = normalizeHex($event.target.value, '#D9D9D9')"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- ============ TAB: Elements ============ -->
            <div v-if="activeTab === 'elements'" class="vi-content">
              <!-- Buttons -->
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("vi_buttons") }}</h3>
                  <div class="vi-contrast-badge" :class="buttonContrastClass">
                    {{ $t("vi_contrast") }}: {{ buttonContrastRatioLabel }}
                    <button class="vi-contrast-fix" @click="ensureReadableButtonText" v-if="parseFloat(buttonContrastRatioLabel) < 4.5">
                      {{ $t("Auto fix button contrast") }}
                    </button>
                  </div>
                </div>
                <div class="vi-style-toggle mb-4">
                  <button :class="{ active: identity.uiTokens.buttonStyleMode === 'solid' }" @click="identity.uiTokens.buttonStyleMode = 'solid'">{{ $t("Solid color") }}</button>
                  <button :class="{ active: identity.uiTokens.buttonStyleMode === 'gradient' }" @click="identity.uiTokens.buttonStyleMode = 'gradient'">{{ $t("Gradient colors") }}</button>
                </div>
                <div v-if="identity.uiTokens.buttonStyleMode === 'solid'" class="vi-color-grid">
                  <ColorField :label="$t('Button background color')" v-model="identity.uiTokens.buttonBackgroundColor" />
                  <ColorField :label="$t('Button text color')" v-model="identity.uiTokens.buttonTextColor" />
                </div>
                <div v-else>
                  <GradientEditor
                    :startColor="identity.uiTokens.buttonGradientStartColor"
                    :endColor="identity.uiTokens.buttonGradientEndColor"
                    :angle="identity.uiTokens.buttonGradientAngle || 135"
                    :opacity="identity.uiTokens.buttonOpacity ?? 1"
                    @update:startColor="identity.uiTokens.buttonGradientStartColor = $event"
                    @update:endColor="identity.uiTokens.buttonGradientEndColor = $event"
                    @update:angle="identity.uiTokens.buttonGradientAngle = $event"
                    @update:opacity="identity.uiTokens.buttonOpacity = $event"
                  />
                  <div class="vi-color-grid mt-3">
                    <ColorField :label="$t('Button text color')" v-model="identity.uiTokens.buttonTextColor" />
                  </div>
                </div>
                <div class="vi-element-preview mt-3">
                  <button class="vi-btn-preview" :style="buttonPreviewStyle">{{ $t("vi_sample_button") }}</button>
                </div>
              </div>

              <!-- Cards -->
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Cards") }}</h3>
                </div>
                <div class="vi-style-toggle mb-4">
                  <button :class="{ active: identity.uiTokens.cardStyleMode === 'solid' }" @click="identity.uiTokens.cardStyleMode = 'solid'">{{ $t("Solid color") }}</button>
                  <button :class="{ active: identity.uiTokens.cardStyleMode === 'gradient' }" @click="identity.uiTokens.cardStyleMode = 'gradient'">{{ $t("Gradient colors") }}</button>
                </div>
                <div v-if="identity.uiTokens.cardStyleMode === 'solid'" class="vi-color-grid">
                  <ColorField :label="$t('Card background color')" v-model="identity.uiTokens.cardBackgroundColor" />
                  <ColorField :label="$t('Card border color')" v-model="identity.uiTokens.cardBorderColor" />
                </div>
                <div v-else>
                  <GradientEditor
                    :startColor="identity.uiTokens.cardGradientStartColor"
                    :endColor="identity.uiTokens.cardGradientEndColor"
                    :angle="identity.uiTokens.cardGradientAngle || 180"
                    :opacity="identity.uiTokens.cardOpacity ?? 1"
                    @update:startColor="identity.uiTokens.cardGradientStartColor = $event"
                    @update:endColor="identity.uiTokens.cardGradientEndColor = $event"
                    @update:angle="identity.uiTokens.cardGradientAngle = $event"
                    @update:opacity="identity.uiTokens.cardOpacity = $event"
                  />
                  <div class="vi-color-grid mt-3">
                    <ColorField :label="$t('Card border color')" v-model="identity.uiTokens.cardBorderColor" />
                  </div>
                </div>
                <div class="vi-element-preview mt-3">
                  <div class="vi-card-preview" :style="cardPreviewStyle">
                    <div class="vi-card-preview-title" :style="{ color: identity.uiTokens.primaryTextColor }">{{ $t("vi_sample_card") }}</div>
                    <div class="vi-card-preview-text" :style="{ color: identity.uiTokens.secondaryTextColor }">{{ $t("vi_sample_card_text") }}</div>
                  </div>
                </div>
              </div>

              <!-- Inputs -->
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Inputs") }}</h3>
                </div>
                <div class="vi-style-toggle mb-4">
                  <button :class="{ active: identity.uiTokens.inputStyleMode === 'solid' }" @click="identity.uiTokens.inputStyleMode = 'solid'">{{ $t("Solid color") }}</button>
                  <button :class="{ active: identity.uiTokens.inputStyleMode === 'gradient' }" @click="identity.uiTokens.inputStyleMode = 'gradient'">{{ $t("Gradient colors") }}</button>
                </div>
                <div v-if="identity.uiTokens.inputStyleMode === 'solid'" class="vi-color-grid">
                  <ColorField :label="$t('Input background color')" v-model="identity.uiTokens.inputBackgroundColor" />
                  <ColorField :label="$t('Input border color')" v-model="identity.uiTokens.inputBorderColor" />
                  <ColorField :label="$t('Input text color')" v-model="identity.uiTokens.inputTextColor" />
                </div>
                <div v-else>
                  <GradientEditor
                    :startColor="identity.uiTokens.inputGradientStartColor"
                    :endColor="identity.uiTokens.inputGradientEndColor"
                    :angle="180"
                    :opacity="1"
                    @update:startColor="identity.uiTokens.inputGradientStartColor = $event"
                    @update:endColor="identity.uiTokens.inputGradientEndColor = $event"
                  />
                  <div class="vi-color-grid mt-3">
                    <ColorField :label="$t('Input border color')" v-model="identity.uiTokens.inputBorderColor" />
                    <ColorField :label="$t('Input text color')" v-model="identity.uiTokens.inputTextColor" />
                  </div>
                </div>
                <div class="vi-element-preview mt-3">
                  <input class="vi-input-preview" :style="inputPreviewStyle" :placeholder="$t('vi_sample_input')" />
                </div>
              </div>

              <!-- Navigation bar -->
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("vi_navbar") }}</h3>
                </div>
                <GradientEditor
                  :startColor="identity.gradientStartColor"
                  :endColor="identity.gradientEndColor"
                  :angle="identity.uiTokens.navBarGradientAngle || 0"
                  :opacity="identity.uiTokens.navBarOpacity ?? 1"
                  @update:startColor="identity.gradientStartColor = $event"
                  @update:endColor="identity.gradientEndColor = $event"
                  @update:angle="identity.uiTokens.navBarGradientAngle = $event"
                  @update:opacity="identity.uiTokens.navBarOpacity = $event"
                />
                <div class="vi-color-grid mt-3">
                  <ColorField :label="$t('Nav bar active icon')" v-model="identity.uiTokens.navBarActiveIconColor" />
                </div>
              </div>
            </div>

            <!-- ============ TAB: Semantic Colors ============ -->
            <div v-if="activeTab === 'semantic'" class="vi-content">
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Semantic colors") }}</h3>
                  <p class="vi-card-desc">{{ $t("vi_semantic_desc") }}</p>
                </div>
                <div class="vi-color-grid vi-color-grid-3">
                  <ColorField :label="$t('Accent color')" v-model="identity.uiTokens.accentColor" />
                  <ColorField :label="$t('Link color')" v-model="identity.uiTokens.linkColor" />
                  <ColorField :label="$t('Success color')" v-model="identity.uiTokens.successColor" />
                  <ColorField :label="$t('Error color')" v-model="identity.uiTokens.errorColor" />
                  <ColorField :label="$t('Warning color')" v-model="identity.uiTokens.warningColor" />
                  <ColorField :label="$t('Badge color')" v-model="identity.uiTokens.badgeColor" />
                </div>
              </div>

              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("vi_icons_bars") }}</h3>
                </div>
                <div class="vi-color-grid vi-color-grid-3">
                  <ColorField :label="$t('Icon primary color')" v-model="identity.uiTokens.iconPrimaryColor" />
                  <ColorField :label="$t('Icon secondary color')" v-model="identity.uiTokens.iconSecondaryColor" />
                  <ColorField :label="$t('App bar color')" v-model="identity.uiTokens.appBarColor" />
                  <ColorField :label="$t('Dialog background')" v-model="identity.uiTokens.dialogBackgroundColor" />
                </div>
              </div>
            </div>

            <!-- ============ TAB: Media ============ -->
            <div v-if="activeTab === 'media'" class="vi-content">
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("App logo") }}</h3>
                </div>
                <div class="vi-media-upload">
                  <div v-if="logoPreviewUrl" class="vi-media-preview">
                    <img :src="logoPreviewUrl" alt="Logo" />
                  </div>
                  <div class="vi-media-controls">
                    <input type="file" accept="image/png,image/jpeg,image/webp" @change="onLogoChange" class="vi-file-input" />
                    <UButton :loading="stateUploadLogo.loading" class="vi-upload-btn" @click="uploadLogo">
                      {{ $t("Upload logo") }}
                    </UButton>
                  </div>
                </div>
              </div>

              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Background image") }}</h3>
                  <p class="vi-card-desc">{{ $t("vi_bg_image_desc") }}</p>
                </div>
                <div class="vi-media-upload">
                  <div v-if="backgroundPreviewUrl" class="vi-media-preview vi-media-preview-wide">
                    <img :src="backgroundPreviewUrl" alt="Background" />
                  </div>
                  <div class="vi-media-controls">
                    <input type="file" accept="image/png,image/jpeg,image/webp" @change="onBgChange" class="vi-file-input" />
                    <UButton :loading="stateUploadBackground.loading" class="vi-upload-btn" @click="uploadBackground">
                      {{ $t("Upload background image") }}
                    </UButton>
                  </div>
                </div>
              </div>
            </div>

            <!-- ============ TAB: Preview ============ -->
            <div v-if="activeTab === 'preview'" class="vi-content">
              <div class="vi-card">
                <div class="vi-card-header">
                  <h3>{{ $t("Preview") }}</h3>
                  <p class="vi-card-desc">{{ $t("Live preview updates instantly as you change settings") }}</p>
                </div>

                <div class="vi-preview-tabs">
                  <button
                    v-for="tab in livePreviewTabs" :key="tab.screen"
                    class="vi-preview-tab" :class="{ 'vi-preview-tab-active': activeLiveScreen === tab.screen }"
                    @click="changeLiveScreen(tab.screen)"
                  >
                    {{ $t(tab.label) }}
                  </button>
                  <button class="vi-preview-tab vi-preview-tab-refresh" @click="reloadLivePreview">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg>
                    {{ $t("Refresh") }}
                  </button>
                </div>

                <div class="vi-preview-container">
                  <div class="vi-device-frame">
                    <div class="vi-device-notch"></div>
                    <div class="vi-device-screen">
                      <iframe ref="previewIframeRef" :src="livePreviewUrl" class="vi-device-iframe" title="Live app preview" @load="sendBrandingToPreview" />
                    </div>
                    <div class="vi-device-home-bar"></div>
                  </div>
                </div>

                <p class="vi-preview-hint">{{ $t("Preview updates in real-time as you change settings") }}</p>
              </div>
            </div>
          </div>
        </div>
        <MyNavbar />
      </div>
    </div>
  </ClientOnly>
</template>

<script setup>
import { defineComponent, h as createEl } from "vue";

definePageMeta({ ssr: false });

const { axios, router, store, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale, setLocale } = useI18n();

/* ─── Inline sub-components ─── */

const ColorField = defineComponent({
  props: { label: String, modelValue: String },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const hexText = ref(props.modelValue || '#000000');
    watch(() => props.modelValue, v => { hexText.value = v || '#000000'; });

    function onColorInput(e) { emit('update:modelValue', e.target.value); }
    function onHexInput(e) {
      let v = e.target.value.trim();
      if (!v.startsWith('#')) v = '#' + v;
      if (/^#[0-9A-Fa-f]{6}$/.test(v)) emit('update:modelValue', v);
      hexText.value = v;
    }

    return () => createEl('div', { class: 'vi-color-field' }, [
      createEl('label', { class: 'vi-color-label' }, props.label),
      createEl('div', { class: 'vi-color-input-row' }, [
        createEl('input', {
          type: 'color', value: props.modelValue || '#000000',
          class: 'vi-color-swatch', onInput: onColorInput
        }),
        createEl('input', {
          type: 'text', value: hexText.value, placeholder: '#000000',
          class: 'vi-color-hex', onInput: onHexInput, maxlength: 7
        }),
      ]),
    ]);
  }
});

const GradientEditor = defineComponent({
  props: {
    startColor: { type: String, default: '#000000' },
    endColor: { type: String, default: '#FFFFFF' },
    angle: { type: Number, default: 180 },
    opacity: { type: Number, default: 1 },
  },
  emits: ['update:startColor', 'update:endColor', 'update:angle', 'update:opacity'],
  setup(props, { emit }) {
    const localAngle = ref(props.angle);
    const localOpacity = ref(Math.round((props.opacity ?? 1) * 100));
    const startHex = ref(props.startColor);
    const endHex = ref(props.endColor);

    watch(() => props.angle, v => { localAngle.value = v; });
    watch(() => props.opacity, v => { localOpacity.value = Math.round((v ?? 1) * 100); });
    watch(() => props.startColor, v => { startHex.value = v; });
    watch(() => props.endColor, v => { endHex.value = v; });

    const gradientCSS = computed(() =>
      `linear-gradient(${localAngle.value}deg, ${startHex.value}, ${endHex.value})`
    );

    function emitAngle(e) {
      const v = Math.max(0, Math.min(360, parseInt(e.target.value) || 0));
      localAngle.value = v;
      emit('update:angle', v);
    }
    function emitOpacity(e) {
      const v = Math.max(0, Math.min(100, parseInt(e.target.value) || 0));
      localOpacity.value = v;
      emit('update:opacity', v / 100);
    }
    function onStartHex(e) {
      let v = e.target.value.trim();
      if (!v.startsWith('#')) v = '#' + v;
      startHex.value = v;
      if (/^#[0-9A-Fa-f]{6}$/.test(v)) emit('update:startColor', v);
    }
    function onEndHex(e) {
      let v = e.target.value.trim();
      if (!v.startsWith('#')) v = '#' + v;
      endHex.value = v;
      if (/^#[0-9A-Fa-f]{6}$/.test(v)) emit('update:endColor', v);
    }

    const { t } = useI18n();

    return () => createEl('div', { class: 'vi-gradient-editor' }, [
      createEl('div', { class: 'vi-gradient-bar', style: { background: gradientCSS.value, opacity: localOpacity.value / 100 } }),
      createEl('div', { class: 'vi-gradient-colors' }, [
        createEl('div', { class: 'vi-gradient-color-field' }, [
          createEl('label', t('vi_start_color')),
          createEl('div', { class: 'vi-color-input-row' }, [
            createEl('input', { type: 'color', value: startHex.value, class: 'vi-color-swatch', onInput: e => { startHex.value = e.target.value; emit('update:startColor', e.target.value); } }),
            createEl('input', { type: 'text', value: startHex.value, class: 'vi-color-hex', onInput: onStartHex, maxlength: 7 }),
          ]),
        ]),
        createEl('div', { class: 'vi-gradient-color-field' }, [
          createEl('label', t('vi_end_color')),
          createEl('div', { class: 'vi-color-input-row' }, [
            createEl('input', { type: 'color', value: endHex.value, class: 'vi-color-swatch', onInput: e => { endHex.value = e.target.value; emit('update:endColor', e.target.value); } }),
            createEl('input', { type: 'text', value: endHex.value, class: 'vi-color-hex', onInput: onEndHex, maxlength: 7 }),
          ]),
        ]),
      ]),
      createEl('div', { class: 'vi-gradient-sliders' }, [
        createEl('div', { class: 'vi-slider-group' }, [
          createEl('label', t('vi_angle')),
          createEl('div', { class: 'vi-slider-row' }, [
            createEl('input', { type: 'range', min: 0, max: 360, value: localAngle.value, class: 'vi-range', onInput: emitAngle }),
            createEl('div', { class: 'vi-num-input' }, [
              createEl('input', { type: 'number', min: 0, max: 360, value: localAngle.value, class: 'vi-angle-num', onInput: emitAngle }),
              createEl('span', { class: 'vi-unit' }, '°'),
            ]),
            createEl('div', { class: 'vi-angle-compass', style: { transform: `rotate(${localAngle.value}deg)` } }, [
              createEl('div', { class: 'vi-compass-needle' }),
            ]),
          ]),
        ]),
        createEl('div', { class: 'vi-slider-group' }, [
          createEl('label', t('vi_opacity')),
          createEl('div', { class: 'vi-slider-row' }, [
            createEl('input', { type: 'range', min: 0, max: 100, value: localOpacity.value, class: 'vi-range vi-range-opacity', onInput: emitOpacity }),
            createEl('div', { class: 'vi-num-input' }, [
              createEl('input', { type: 'number', min: 0, max: 100, value: localOpacity.value, class: 'vi-angle-num', onInput: emitOpacity }),
              createEl('span', { class: 'vi-unit' }, '%'),
            ]),
          ]),
        ]),
      ]),
    ]);
  }
});

/* ─── State ─── */

const identity = ref({
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
});

const selectedLogoFile = ref(null);
const selectedBackgroundFile = ref(null);
const stateSave = ref({ loading: false });
const stateUploadLogo = ref({ loading: false });
const stateUploadBackground = ref({ loading: false });
const activeTab = ref('quick');

const mainTabs = [
  { id: 'quick', label: 'vi_tab_quick', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>' },
  { id: 'elements', label: 'vi_tab_elements', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>' },
  { id: 'semantic', label: 'vi_tab_semantic', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="13.5" cy="6.5" r="2.5"/><circle cx="17.5" cy="10.5" r="2.5"/><circle cx="8.5" cy="7.5" r="2.5"/><circle cx="6.5" cy="12.5" r="2.5"/></svg>' },
  { id: 'media', label: 'vi_tab_media', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>' },
  { id: 'preview', label: 'vi_tab_preview', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="2" width="14" height="20" rx="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></svg>' },
];

const themeModes = [
  { value: 'solid', label: 'Solid color', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><rect x="3" y="3" width="18" height="18" rx="3"/></svg>' },
  { value: 'gradient', label: 'Gradient colors', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"><defs><linearGradient id="grd" x1="0%" y1="0%" x2="100%"><stop offset="0%" style="stop-color:#00443A"/><stop offset="100%" style="stop-color:#00AA91"/></linearGradient></defs><rect x="3" y="3" width="18" height="18" rx="3" fill="url(#grd)"/></svg>' },
  { value: 'image', label: 'Background image', icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>' },
];

const visualPresets = [
  {
    key: "classic", label: "Classic brand",
    swatchStyle: { background: "linear-gradient(135deg, #00443A, #00AA91)" },
  },
  {
    key: "midnight", label: "Midnight dark",
    swatchStyle: { background: "linear-gradient(135deg, #0F172A, #1E293B)" },
  },
  {
    key: "mint", label: "Mint light",
    swatchStyle: { background: "linear-gradient(135deg, #EFFFF8, #22C55E)" },
  },
  {
    key: "ocean", label: "vi_ocean",
    swatchStyle: { background: "linear-gradient(135deg, #0C4A6E, #38BDF8)" },
  },
  {
    key: "sunset", label: "vi_sunset",
    swatchStyle: { background: "linear-gradient(135deg, #7C2D12, #FB923C)" },
  },
  {
    key: "royal", label: "vi_royal",
    swatchStyle: { background: "linear-gradient(135deg, #581C87, #A855F7)" },
  },
];

const livePreviewTabs = [
  { screen: "welcome", label: "Welcome screen" },
  { screen: "login", label: "Login screen" },
  { screen: "register", label: "Register screen" },
  { screen: "transfer", label: "Transfer screen" },
  { screen: "notifications", label: "Notifications screen" },
];

const activeLiveScreen = ref("welcome");
const previewReloadNonce = ref(Date.now());
const textTokenSyncState = ref({ primary: true, secondary: true });
const isAutoSyncingTextTokens = ref(false);

/* ─── Computed ─── */

const logoPreviewUrl = computed(() =>
  identity.value.logoPath ? `${BASE_URL}/${identity.value.logoPath}` : ""
);
const backgroundPreviewUrl = computed(() =>
  identity.value.backgroundImagePath ? `${BASE_URL}/${identity.value.backgroundImagePath}` : ""
);

const livePreviewUrl = computed(() => {
  const screen = encodeURIComponent(activeLiveScreen.value);
  return `/app-preview?screen=${screen}&_r=${previewReloadNonce.value}`;
});

const previewIframeRef = ref(null);

function sendBrandingToPreview() {
  try {
    const iframe = previewIframeRef.value;
    if (iframe?.contentWindow) {
      iframe.contentWindow.postMessage(
        { type: "branding-update", identity: JSON.parse(JSON.stringify(identity.value)) },
        "*"
      );
    }
  } catch { /* cross-origin or iframe not ready */ }
}

watch(identity, () => { sendBrandingToPreview(); }, { deep: true });

const buttonPreviewStyle = computed(() => {
  const tk = identity.value.uiTokens;
  return {
    background: tk.buttonStyleMode === "gradient"
      ? `linear-gradient(${tk.buttonGradientAngle || 135}deg, ${tk.buttonGradientStartColor}, ${tk.buttonGradientEndColor})`
      : tk.buttonBackgroundColor,
    color: tk.buttonTextColor,
    opacity: tk.buttonOpacity ?? 1,
  };
});

const cardPreviewStyle = computed(() => {
  const tk = identity.value.uiTokens;
  return {
    background: tk.cardStyleMode === "gradient"
      ? `linear-gradient(${tk.cardGradientAngle || 180}deg, ${tk.cardGradientStartColor}, ${tk.cardGradientEndColor})`
      : tk.cardBackgroundColor,
    borderColor: tk.cardBorderColor,
    opacity: tk.cardOpacity ?? 1,
  };
});

const inputPreviewStyle = computed(() => {
  const tk = identity.value.uiTokens;
  return {
    background: tk.inputStyleMode === "gradient"
      ? `linear-gradient(180deg, ${tk.inputGradientStartColor}, ${tk.inputGradientEndColor})`
      : tk.inputBackgroundColor,
    borderColor: tk.inputBorderColor,
    color: tk.inputTextColor,
  };
});

const buttonContrastRatioLabel = computed(() => {
  const textColor = normalizeHex(identity.value.uiTokens.buttonTextColor, "#FFFFFF");
  const backgrounds = currentButtonBackgroundColors();
  const minRatio = Math.min(...backgrounds.map(bg => contrastRatio(bg, textColor)));
  return minRatio.toFixed(2);
});

const buttonContrastClass = computed(() => {
  const ratio = parseFloat(buttonContrastRatioLabel.value);
  if (ratio >= 7) return 'vi-contrast-aaa';
  if (ratio >= 4.5) return 'vi-contrast-aa';
  return 'vi-contrast-fail';
});

/* ─── Lifecycle ─── */

onMounted(async () => {
  setLocale(store.getLanguage);
  await getIdentity();
});

/* ─── Methods ─── */

function changeLiveScreen(screen) {
  activeLiveScreen.value = screen;
  previewReloadNonce.value = Date.now();
}

function reloadLivePreview() {
  previewReloadNonce.value = Date.now();
}

function onLogoChange(event) { selectedLogoFile.value = event?.target?.files?.[0] || null; }
function onBgChange(event) { selectedBackgroundFile.value = event?.target?.files?.[0] || null; }

function applyPreset(key) {
  const base = { ...identity.value.uiTokens };

  if (key === "midnight") {
    Object.assign(identity.value, { themeMode: "gradient", gradientStartColor: "#0F172A", gradientEndColor: "#1E293B", textColor: "#F8FAFC" });
    Object.assign(base, { screenBackgroundColor: "#0B1220", cardStyleMode: "solid", cardBackgroundColor: "#111827", cardBorderColor: "#334155", primaryTextColor: "#F8FAFC", secondaryTextColor: "#CBD5E1", inputStyleMode: "solid", inputBackgroundColor: "#1F2937", inputBorderColor: "#334155", inputTextColor: "#F8FAFC", buttonStyleMode: "gradient", buttonGradientStartColor: "#0EA5E9", buttonGradientEndColor: "#22D3EE", buttonTextColor: "#0F172A", hintTextColor: "#94A3B8", dividerColor: "#334155", accentColor: "#38BDF8", iconPrimaryColor: "#38BDF8", iconSecondaryColor: "#94A3B8", dialogBackgroundColor: "#1F2937", appBarColor: "#0F172A", headerGradientAngle: 135, buttonGradientAngle: 135 });
  } else if (key === "mint") {
    Object.assign(identity.value, { themeMode: "solid", solidBackgroundColor: "#EFFFF8", textColor: "#0F172A" });
    Object.assign(base, { screenBackgroundColor: "#F0FDF4", cardStyleMode: "gradient", cardGradientStartColor: "#FFFFFF", cardGradientEndColor: "#DCFCE7", cardBorderColor: "#86EFAC", primaryTextColor: "#052E16", secondaryTextColor: "#166534", inputStyleMode: "solid", inputBackgroundColor: "#FFFFFF", inputBorderColor: "#86EFAC", inputTextColor: "#14532D", buttonStyleMode: "solid", buttonBackgroundColor: "#22C55E", buttonTextColor: "#FFFFFF", hintTextColor: "#4ADE80", accentColor: "#22C55E", iconPrimaryColor: "#166534", iconSecondaryColor: "#22C55E", dividerColor: "#BBF7D0", dialogBackgroundColor: "#F0FDF4", appBarColor: "#166534", cardGradientAngle: 135 });
  } else if (key === "ocean") {
    Object.assign(identity.value, { themeMode: "gradient", gradientStartColor: "#0C4A6E", gradientEndColor: "#38BDF8", textColor: "#F0F9FF" });
    Object.assign(base, { screenBackgroundColor: "#F0F9FF", cardStyleMode: "solid", cardBackgroundColor: "#FFFFFF", cardBorderColor: "#BAE6FD", primaryTextColor: "#0C4A6E", secondaryTextColor: "#0369A1", inputStyleMode: "solid", inputBackgroundColor: "#FFFFFF", inputBorderColor: "#7DD3FC", inputTextColor: "#0C4A6E", buttonStyleMode: "gradient", buttonGradientStartColor: "#0284C7", buttonGradientEndColor: "#38BDF8", buttonTextColor: "#FFFFFF", hintTextColor: "#7DD3FC", accentColor: "#0EA5E9", iconPrimaryColor: "#0284C7", iconSecondaryColor: "#38BDF8", dividerColor: "#BAE6FD", dialogBackgroundColor: "#FFFFFF", appBarColor: "#0C4A6E", headerGradientAngle: 150, buttonGradientAngle: 120 });
  } else if (key === "sunset") {
    Object.assign(identity.value, { themeMode: "gradient", gradientStartColor: "#7C2D12", gradientEndColor: "#FB923C", textColor: "#FFF7ED" });
    Object.assign(base, { screenBackgroundColor: "#FFF7ED", cardStyleMode: "solid", cardBackgroundColor: "#FFFFFF", cardBorderColor: "#FED7AA", primaryTextColor: "#7C2D12", secondaryTextColor: "#C2410C", inputStyleMode: "solid", inputBackgroundColor: "#FFFFFF", inputBorderColor: "#FDBA74", inputTextColor: "#7C2D12", buttonStyleMode: "gradient", buttonGradientStartColor: "#EA580C", buttonGradientEndColor: "#FB923C", buttonTextColor: "#FFFFFF", hintTextColor: "#FB923C", accentColor: "#EA580C", iconPrimaryColor: "#C2410C", iconSecondaryColor: "#FB923C", dividerColor: "#FED7AA", dialogBackgroundColor: "#FFFFFF", appBarColor: "#7C2D12", headerGradientAngle: 160, buttonGradientAngle: 135 });
  } else if (key === "royal") {
    Object.assign(identity.value, { themeMode: "gradient", gradientStartColor: "#581C87", gradientEndColor: "#A855F7", textColor: "#FAF5FF" });
    Object.assign(base, { screenBackgroundColor: "#FAF5FF", cardStyleMode: "solid", cardBackgroundColor: "#FFFFFF", cardBorderColor: "#E9D5FF", primaryTextColor: "#581C87", secondaryTextColor: "#7E22CE", inputStyleMode: "solid", inputBackgroundColor: "#FFFFFF", inputBorderColor: "#D8B4FE", inputTextColor: "#581C87", buttonStyleMode: "gradient", buttonGradientStartColor: "#7C3AED", buttonGradientEndColor: "#A855F7", buttonTextColor: "#FFFFFF", hintTextColor: "#C084FC", accentColor: "#8B5CF6", iconPrimaryColor: "#7C3AED", iconSecondaryColor: "#C084FC", dividerColor: "#E9D5FF", dialogBackgroundColor: "#FFFFFF", appBarColor: "#581C87", headerGradientAngle: 145, buttonGradientAngle: 120 });
  } else {
    Object.assign(identity.value, { themeMode: "gradient", gradientStartColor: "#00443A", gradientEndColor: "#00AA91", textColor: "#000000" });
    Object.assign(base, { screenBackgroundColor: "#F3F4F6", cardStyleMode: "solid", cardBackgroundColor: "#FFFFFF", cardBorderColor: "#D1D5DB", primaryTextColor: "#111827", secondaryTextColor: "#6B7280", inputStyleMode: "solid", inputBackgroundColor: "#FFFFFF", inputBorderColor: "#D1D5DB", inputTextColor: "#111827", buttonStyleMode: "solid", buttonBackgroundColor: "#6B1F2A", buttonTextColor: "#FFFFFF", hintTextColor: "#7A7A7A", accentColor: "#B9A779", iconPrimaryColor: "#6B1F2A", iconSecondaryColor: "#B9A779", dividerColor: "#D9D9D9", dialogBackgroundColor: "#FFFFFF", appBarColor: "#128271", headerGradientAngle: 180, buttonGradientAngle: 135 });
  }

  identity.value.uiTokens = base;
  textTokenSyncState.value = { primary: true, secondary: true };
  syncTextTokensFromTextColor(identity.value.textColor, { force: true });
  ensureReadableButtonText();
}

function normalizeHex(value, fallback = "#000000") {
  const raw = String(value || "").trim();
  const hex = raw.startsWith("#") ? raw : `#${raw}`;
  if (!/^#[0-9A-Fa-f]{6}$/.test(hex)) return fallback;
  return hex.toUpperCase();
}

function mixHexColors(baseHex, targetHex, ratio) {
  const base = normalizeHex(baseHex, "#000000");
  const target = normalizeHex(targetHex, "#FFFFFF");
  const mix = Math.max(0, Math.min(1, Number(ratio) || 0));
  const toRgb = (hex) => ({
    r: parseInt(hex.slice(1, 3), 16),
    g: parseInt(hex.slice(3, 5), 16),
    b: parseInt(hex.slice(5, 7), 16),
  });
  const b = toRgb(base);
  const t = toRgb(target);
  const toHex = (n) => n.toString(16).padStart(2, "0").toUpperCase();
  const r = Math.round(b.r + (t.r - b.r) * mix);
  const g = Math.round(b.g + (t.g - b.g) * mix);
  const bl = Math.round(b.b + (t.b - b.b) * mix);
  return `#${toHex(r)}${toHex(g)}${toHex(bl)}`;
}

function isDarkHex(hex) {
  const normalizedHex = normalizeHex(hex, "#111827");
  const r = parseInt(normalizedHex.slice(1, 3), 16);
  const g = parseInt(normalizedHex.slice(3, 5), 16);
  const b = parseInt(normalizedHex.slice(5, 7), 16);
  const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
  return luminance < 0.55;
}

function autoSecondaryColorFrom(baseHex) {
  return isDarkHex(baseHex)
    ? mixHexColors(baseHex, "#FFFFFF", 0.38)
    : mixHexColors(baseHex, "#000000", 0.38);
}

function syncTextTokensFromTextColor(baseColor, { force = false } = {}) {
  const primary = normalizeHex(baseColor, "#111827");
  const secondary = autoSecondaryColorFrom(primary);
  isAutoSyncingTextTokens.value = true;
  try {
    if (force || textTokenSyncState.value.primary) {
      identity.value.uiTokens.primaryTextColor = primary;
    }
    if (force || textTokenSyncState.value.secondary) {
      identity.value.uiTokens.secondaryTextColor = secondary;
    }
  } finally {
    isAutoSyncingTextTokens.value = false;
  }
}

function hexToRgb(hex) {
  const safe = normalizeHex(hex);
  return { r: Number.parseInt(safe.slice(1, 3), 16), g: Number.parseInt(safe.slice(3, 5), 16), b: Number.parseInt(safe.slice(5, 7), 16) };
}

function relativeLuminance(hex) {
  const { r, g, b } = hexToRgb(hex);
  const t = c => { const v = c / 255; return v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4; };
  return 0.2126 * t(r) + 0.7152 * t(g) + 0.0722 * t(b);
}

function contrastRatio(a, b) {
  const l1 = relativeLuminance(a), l2 = relativeLuminance(b);
  return (Math.max(l1, l2) + 0.05) / (Math.min(l1, l2) + 0.05);
}

function currentButtonBackgroundColors() {
  if (identity.value.uiTokens.buttonStyleMode === "gradient") {
    return [
      normalizeHex(identity.value.uiTokens.buttonGradientStartColor, "#6B1F2A"),
      normalizeHex(identity.value.uiTokens.buttonGradientEndColor, "#9B3A49"),
    ];
  }
  return [normalizeHex(identity.value.uiTokens.buttonBackgroundColor, "#6B1F2A")];
}

function ensureReadableButtonText() {
  const bgs = currentButtonBackgroundColors();
  const whiteScore = Math.min(...bgs.map(bg => contrastRatio(bg, "#FFFFFF")));
  const blackScore = Math.min(...bgs.map(bg => contrastRatio(bg, "#000000")));
  identity.value.uiTokens.buttonTextColor = whiteScore >= blackScore ? "#FFFFFF" : "#000000";
}

watch(() => identity.value.textColor, (newColor) => {
  syncTextTokensFromTextColor(newColor);
});

watch(() => identity.value.uiTokens.primaryTextColor, (newColor) => {
  if (isAutoSyncingTextTokens.value) return;
  const normalized = normalizeHex(newColor, "#111827");
  const base = normalizeHex(identity.value.textColor, "#111827");
  textTokenSyncState.value.primary = normalized === base;
});

watch(() => identity.value.uiTokens.secondaryTextColor, (newColor) => {
  if (isAutoSyncingTextTokens.value) return;
  const normalized = normalizeHex(newColor, "#6B7280");
  const expected = autoSecondaryColorFrom(identity.value.textColor);
  textTokenSyncState.value.secondary = normalized === expected;
});

async function getIdentity() {
  try {
    const token = store.getToken;
    const response = await axios.get(`${BASE_URL}/quick-control/system-overview`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (response.data?.error) return;
    const fromServer = response.data?.data?.systemSettings?.appVisualIdentity || {};
    identity.value = {
      ...identity.value,
      ...fromServer,
      uiTokens: { ...identity.value.uiTokens, ...(fromServer?.uiTokens || {}) },
    };
    const baseTextColor = normalizeHex(identity.value.textColor, "#111827");
    const expectedSecondary = autoSecondaryColorFrom(baseTextColor);
    textTokenSyncState.value = {
      primary: normalizeHex(identity.value.uiTokens.primaryTextColor, "#111827") === baseTextColor,
      secondary: normalizeHex(identity.value.uiTokens.secondaryTextColor, "#6B7280") === expectedSecondary,
    };
  } catch (error) {
    if (handelErrorType(error) === "Unauthorized") { store.updateToken(null); router.push("/login"); }
  }
}

async function saveIdentity() {
  stateSave.value.loading = true;
  try {
    ensureReadableButtonText();
    const token = store.getToken;
    const response = await axios.put(
      `${BASE_URL}/quick-control/update-system-settings`,
      { appVisualIdentity: identity.value },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    if (!response.data?.error) { await getIdentity(); reloadLivePreview(); }
  } catch (error) {
    if (handelErrorType(error) === "Unauthorized") { store.updateToken(null); router.push("/login"); }
  } finally { stateSave.value.loading = false; }
}

async function uploadLogo() {
  if (!selectedLogoFile.value) return;
  stateUploadLogo.value.loading = true;
  try {
    const token = store.getToken;
    const fd = new FormData();
    fd.append("logoImage", selectedLogoFile.value);
    const response = await axios.put(`${BASE_URL}/quick-control/update-app-logo`, fd, {
      headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" },
    });
    if (!response.data?.error) {
      identity.value.logoPath = response.data?.data?.appVisualIdentity?.logoPath || identity.value.logoPath;
      reloadLivePreview();
    }
  } catch (error) {
    if (handelErrorType(error) === "Unauthorized") { store.updateToken(null); router.push("/login"); }
  } finally { stateUploadLogo.value.loading = false; }
}

async function uploadBackground() {
  if (!selectedBackgroundFile.value) return;
  stateUploadBackground.value.loading = true;
  try {
    const token = store.getToken;
    const fd = new FormData();
    fd.append("backgroundImage", selectedBackgroundFile.value);
    const response = await axios.put(`${BASE_URL}/quick-control/update-app-background-image`, fd, {
      headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" },
    });
    if (!response.data?.error) {
      identity.value.backgroundImagePath = response.data?.data?.appVisualIdentity?.backgroundImagePath || identity.value.backgroundImagePath;
      reloadLivePreview();
    }
  } catch (error) {
    if (handelErrorType(error) === "Unauthorized") { store.updateToken(null); router.push("/login"); }
  } finally { stateUploadBackground.value.loading = false; }
}
</script>

<style scoped>
/* ─── Page root ─── */
.vi-root { padding: 20px 24px 40px; max-width: 900px; }

/* ─── Header ─── */
.vi-page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
.vi-title { font-size: 22px; font-weight: 700; color: #111827; margin: 0; }
.vi-subtitle { font-size: 13px; color: #6B7280; margin: 4px 0 0; }
.vi-save-btn {
  display: inline-flex; align-items: center; gap: 8px;
  padding: 10px 24px; border-radius: 12px; font-weight: 600; font-size: 14px;
  background: linear-gradient(135deg, #6B1F2A, #9B3A49); color: #fff;
  border: none; cursor: pointer; transition: all .2s;
  box-shadow: 0 2px 8px rgba(107, 31, 42, 0.25);
}
.vi-save-btn:hover { box-shadow: 0 4px 16px rgba(107, 31, 42, 0.35); transform: translateY(-1px); }

/* ─── Tabs ─── */
.vi-tabs {
  display: flex; gap: 4px; padding: 4px; border-radius: 14px;
  background: #F3F4F6; margin-bottom: 24px; overflow-x: auto;
}
.vi-tab {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 10px 16px; border-radius: 10px; font-size: 13px; font-weight: 600;
  color: #6B7280; background: transparent; border: none; cursor: pointer;
  transition: all .2s; white-space: nowrap;
}
.vi-tab:hover { color: #111827; background: rgba(255,255,255,0.6); }
.vi-tab-active { background: #fff!important; color: #111827!important; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
.vi-tab :deep(svg) { flex-shrink: 0; }

/* ─── Content ─── */
.vi-content { display: flex; flex-direction: column; gap: 20px; }

/* ─── Cards ─── */
.vi-card {
  background: #fff; border: 1px solid #E5E7EB; border-radius: 16px;
  padding: 20px 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.04);
}
.vi-card-header { margin-bottom: 16px; }
.vi-card-header h3 { font-size: 15px; font-weight: 700; color: #111827; margin: 0; }
.vi-card-desc { font-size: 12px; color: #6B7280; margin: 4px 0 0; }

/* ─── Presets ─── */
.vi-presets-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 10px; }
.vi-preset {
  display: flex; flex-direction: column; align-items: center; gap: 8px;
  padding: 12px 10px; border-radius: 12px; border: 2px solid #E5E7EB;
  background: #FAFAFA; cursor: pointer; transition: all .2s;
}
.vi-preset:hover { border-color: #6B1F2A; box-shadow: 0 2px 8px rgba(107,31,42,0.12); transform: translateY(-1px); }
.vi-preset-swatch { width: 100%; height: 36px; border-radius: 8px; }
.vi-preset-label { font-size: 12px; font-weight: 600; color: #374151; }

/* ─── Theme mode toggle ─── */
.vi-theme-modes { display: flex; gap: 10px; flex-wrap: wrap; }
.vi-theme-mode {
  flex: 1; min-width: 100px; display: flex; flex-direction: column; align-items: center; gap: 6px;
  padding: 14px 12px; border-radius: 12px; border: 2px solid #E5E7EB;
  background: #FAFAFA; cursor: pointer; transition: all .2s;
  font-size: 12px; font-weight: 600; color: #6B7280;
}
.vi-theme-mode:hover { border-color: #9CA3AF; }
.vi-theme-mode-active { border-color: #6B1F2A; background: #FFF5F5; color: #6B1F2A; }

/* ─── Color grid ─── */
.vi-color-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; }
.vi-color-grid-3 { grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); }

/* ─── Color field ─── */
.vi-color-field { display: flex; flex-direction: column; gap: 6px; }
.vi-color-label { font-size: 12px; font-weight: 600; color: #374151; }
.vi-color-input-row { display: flex; align-items: center; gap: 8px; }
.vi-color-swatch {
  width: 40px; height: 36px; border-radius: 8px; border: 2px solid #E5E7EB;
  cursor: pointer; padding: 2px; flex-shrink: 0;
}
.vi-color-hex {
  flex: 1; height: 36px; border: 1px solid #D1D5DB; border-radius: 8px;
  padding: 0 10px; font-size: 13px; font-family: 'SF Mono', Monaco, monospace;
  color: #111827; background: #F9FAFB; outline: none; min-width: 0;
}
.vi-color-hex:focus { border-color: #6B1F2A; box-shadow: 0 0 0 2px rgba(107,31,42,0.1); }

/* ─── Style toggle (solid/gradient) ─── */
.vi-style-toggle { display: inline-flex; border-radius: 10px; background: #F3F4F6; padding: 3px; }
.vi-style-toggle button {
  padding: 6px 16px; border-radius: 8px; font-size: 12px; font-weight: 600;
  color: #6B7280; background: transparent; border: none; cursor: pointer; transition: all .15s;
}
.vi-style-toggle button.active { background: #fff; color: #111827; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }

/* ─── Gradient editor ─── */
.vi-gradient-editor { background: #F9FAFB; border: 1px solid #E5E7EB; border-radius: 12px; padding: 16px; }
.vi-gradient-bar {
  width: 100%; height: 40px; border-radius: 8px; margin-bottom: 14px;
  border: 1px solid rgba(0,0,0,0.08);
}
.vi-gradient-colors { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 14px; }
.vi-gradient-color-field { display: flex; flex-direction: column; gap: 6px; }
.vi-gradient-color-field label { font-size: 11px; font-weight: 600; color: #6B7280; text-transform: uppercase; letter-spacing: 0.5px; }
.vi-gradient-sliders { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.vi-slider-group { display: flex; flex-direction: column; gap: 6px; }
.vi-slider-group > label { font-size: 11px; font-weight: 600; color: #6B7280; text-transform: uppercase; letter-spacing: 0.5px; }
.vi-slider-row { display: flex; align-items: center; gap: 8px; }
.vi-range {
  flex: 1; height: 6px; -webkit-appearance: none; border-radius: 3px;
  background: linear-gradient(90deg, #E5E7EB, #6B1F2A); outline: none;
}
.vi-range::-webkit-slider-thumb {
  -webkit-appearance: none; width: 18px; height: 18px; border-radius: 50%;
  background: #fff; border: 2px solid #6B1F2A; cursor: pointer;
  box-shadow: 0 1px 4px rgba(0,0,0,0.15);
}
.vi-range-opacity { background: linear-gradient(90deg, rgba(0,0,0,0.05), #111827); }
.vi-num-input { display: flex; align-items: center; gap: 2px; flex-shrink: 0; }
.vi-angle-num {
  width: 52px; height: 32px; border: 1px solid #D1D5DB; border-radius: 6px;
  text-align: center; font-size: 13px; color: #111827; outline: none;
  font-family: 'SF Mono', Monaco, monospace;
}
.vi-angle-num:focus { border-color: #6B1F2A; }
.vi-unit { font-size: 12px; color: #6B7280; font-weight: 500; }
.vi-angle-compass {
  width: 28px; height: 28px; border-radius: 50%; border: 2px solid #D1D5DB;
  position: relative; flex-shrink: 0; background: #fff; transition: transform .15s;
}
.vi-compass-needle {
  position: absolute; top: 3px; left: 50%; width: 2px; height: 10px;
  background: #6B1F2A; border-radius: 1px; transform: translateX(-50%);
}

/* ─── Contrast badge ─── */
.vi-contrast-badge {
  display: inline-flex; align-items: center; gap: 8px;
  padding: 4px 10px; border-radius: 8px; font-size: 12px; font-weight: 600; margin-top: 4px;
}
.vi-contrast-aaa { background: #DCFCE7; color: #166534; }
.vi-contrast-aa { background: #FEF9C3; color: #854D0E; }
.vi-contrast-fail { background: #FEE2E2; color: #991B1B; }
.vi-contrast-fix {
  padding: 2px 8px; border-radius: 6px; font-size: 11px; font-weight: 600;
  background: #fff; color: #991B1B; border: 1px solid #FCA5A5; cursor: pointer;
}

/* ─── Element previews ─── */
.vi-element-preview {
  display: flex; align-items: center; justify-content: center;
  padding: 16px; background: #F9FAFB; border-radius: 10px; border: 1px dashed #E5E7EB;
}
.vi-btn-preview {
  padding: 10px 32px; border-radius: 10px; font-size: 14px; font-weight: 600;
  border: none; cursor: default;
}
.vi-card-preview {
  width: 100%; max-width: 280px; padding: 16px; border-radius: 12px;
  border: 2px solid; min-height: 60px;
}
.vi-card-preview-title { font-size: 14px; font-weight: 600; margin-bottom: 4px; }
.vi-card-preview-text { font-size: 12px; }
.vi-input-preview {
  width: 100%; max-width: 280px; height: 40px; border-radius: 10px;
  border: 2px solid; padding: 0 12px; font-size: 13px; outline: none;
}

/* ─── Media ─── */
.vi-media-upload { display: flex; flex-direction: column; gap: 12px; }
.vi-media-preview {
  width: 100px; height: 100px; border-radius: 12px; overflow: hidden;
  border: 2px solid #E5E7EB; background: #F3F4F6;
}
.vi-media-preview-wide { width: 200px; height: 120px; }
.vi-media-preview img { width: 100%; height: 100%; object-fit: cover; }
.vi-media-controls { display: flex; flex-direction: column; gap: 8px; }
.vi-file-input { font-size: 13px; color: #374151; }
.vi-upload-btn {
  display: inline-flex; align-items: center; gap: 6px; width: fit-content;
  padding: 8px 16px; border-radius: 10px; font-size: 13px; font-weight: 600;
  background: #F3F4F6; color: #374151; border: 1px solid #D1D5DB; cursor: pointer;
}
.vi-upload-btn:hover { background: #E5E7EB; }

/* ─── Preview ─── */
.vi-preview-tabs { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 20px; }
.vi-preview-tab {
  display: inline-flex; align-items: center; gap: 4px;
  padding: 7px 14px; border-radius: 8px; font-size: 12px; font-weight: 600;
  background: #F3F4F6; color: #6B7280; border: 1px solid #E5E7EB; cursor: pointer; transition: all .15s;
}
.vi-preview-tab:hover { background: #E5E7EB; color: #111827; }
.vi-preview-tab-active { background: #111827!important; color: #fff!important; border-color: #111827!important; }
.vi-preview-tab-refresh { background: #FFF7ED; color: #C2410C; border-color: #FDBA74; }

.vi-preview-container { display: flex; justify-content: center; padding: 12px 0; }
.vi-device-frame {
  width: 320px; background: #111827; border-radius: 32px;
  padding: 12px 10px 8px; box-shadow: 0 20px 50px rgba(0,0,0,0.3);
}
.vi-device-notch { width: 100px; height: 14px; background: #1f2937; margin: 0 auto 8px; border-radius: 999px; }
.vi-device-screen { position: relative; border-radius: 22px; height: 620px; width: 100%; overflow: hidden; }
.vi-device-iframe { position: absolute; inset: 0; width: 100%; height: 100%; display: block; background: #fff; border: none; }
.vi-device-home-bar { width: 80px; height: 4px; background: #374151; margin: 8px auto 0; border-radius: 999px; }
.vi-preview-hint { font-size: 11px; color: #9CA3AF; text-align: center; margin-top: 8px; }

/* ─── Responsive ─── */
@media (max-width: 640px) {
  .vi-root { padding: 12px 14px 30px; }
  .vi-gradient-colors, .vi-gradient-sliders { grid-template-columns: 1fr; }
  .vi-color-grid, .vi-color-grid-3 { grid-template-columns: 1fr; }
  .vi-presets-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
