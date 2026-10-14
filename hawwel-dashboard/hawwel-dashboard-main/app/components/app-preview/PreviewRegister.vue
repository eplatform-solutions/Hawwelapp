<script setup>
import { computed, ref } from "vue";
import { countries } from "countries-list";
import PreviewHeader from "./PreviewHeader.vue";

defineProps({
  identity: { type: Object, default: null },
  logoUrl: { type: String, default: "" },
});

/** نفس مصدر قائمة الدول في واجهة العميل (countries-list). */
const countryCodes = Object.keys(countries).sort((a, b) => {
  const la = countries[a].native || countries[a].name;
  const lb = countries[b].native || countries[b].name;
  return la.localeCompare(lb, "ar", { sensitivity: "base" });
});

const selectedCode = ref("IQ");

const selectedMeta = computed(() => countries[selectedCode.value]);
const dialDisplay = computed(() => {
  const p = selectedMeta.value?.phone?.[0];
  return p != null ? `+${p}` : "+";
});

function isoToRegionalEmoji(code) {
  if (!code || code.length !== 2) return "";
  const A = 0x1f1e6;
  return [...code.toUpperCase()]
    .map((c) => String.fromCodePoint(A + c.charCodeAt(0) - 65))
    .join("");
}
</script>

<template>
  <div class="pr-root">
    <PreviewHeader title="إنشاء حساب" :logo-url="logoUrl" :title-offset-top="100" tall show-back />

    <div class="pr-body">
      <!-- Name row -->
      <div class="pr-row">
        <div class="pr-input pr-half">
          <span class="pr-placeholder">الاسم الأول</span>
        </div>
        <div class="pr-input pr-half">
          <span class="pr-placeholder">اسم العائلة</span>
        </div>
      </div>

      <!-- Country (قائمة كاملة كما في التطبيق / API) -->
      <div class="pr-field">
        <div class="pr-input pr-select-shell">
          <select v-model="selectedCode" class="pr-select" aria-label="اختر الدولة">
            <option v-for="c in countryCodes" :key="c" :value="c">
              {{ countries[c].native || countries[c].name }} — {{ c }}
            </option>
          </select>
          <span class="pr-chevron">▾</span>
        </div>
      </div>

      <!-- Phone + country code -->
      <div class="pr-field">
        <div class="pr-phone-row">
          <div class="pr-input pr-phone-field">
            <span class="pr-placeholder">رقم الهاتف</span>
          </div>
          <div class="pr-country-chip">
            <span>{{ isoToRegionalEmoji(selectedCode) }}</span>
            <span class="pr-dial">{{ dialDisplay }}</span>
          </div>
        </div>
      </div>

      <!-- Password -->
      <div class="pr-field">
        <div class="pr-input">
          <span class="pr-placeholder">كلمة المرور</span>
          <span class="pr-eye">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="18" height="18">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
            </svg>
          </span>
        </div>
      </div>
      <div class="pr-field">
        <div class="pr-input">
          <span class="pr-placeholder">تأكيد كلمة المرور</span>
          <span class="pr-eye">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="18" height="18">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
            </svg>
          </span>
        </div>
      </div>

      <!-- Register button -->
      <div class="pr-btn-wrap">
        <div class="pr-btn">سجل الآن</div>
      </div>

      <!-- Footer -->
      <div class="pr-footer">
        <span class="pr-footer-label">لديك حساب؟</span>
        <span class="pr-footer-link">تسجيل الدخول</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.pr-root {
  width: 100%;
  min-height: 100vh;
  background: var(--screen-bg);
}
.pr-body {
  padding: calc(16 * var(--su)) calc(25 * var(--su)) calc(20 * var(--su));
}
.pr-row {
  display: flex;
  gap: calc(10 * var(--su));
  margin-bottom: calc(12 * var(--su));
}
.pr-half {
  flex: 1;
}
.pr-field {
  margin-bottom: calc(12 * var(--su));
}
.pr-input {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: calc(50 * var(--su));
  padding: 0 calc(14 * var(--su));
  background: var(--input-bg);
  border: 1px solid var(--input-border);
  border-radius: calc(12 * var(--su));
  font-family: 'Cairo', sans-serif;
}
.pr-placeholder {
  font-size: calc(13 * var(--su));
  color: var(--hint-text);
  font-family: 'Cairo', sans-serif;
}
.pr-chevron {
  color: var(--hint-text);
  font-size: calc(14 * var(--su));
  flex-shrink: 0;
  pointer-events: none;
}
.pr-select-shell {
  padding: 0 calc(10 * var(--su)) 0 calc(14 * var(--su));
}
.pr-select {
  flex: 1;
  min-width: 0;
  height: 100%;
  border: none;
  outline: none;
  background: transparent;
  font-family: "Cairo", sans-serif;
  font-size: calc(13 * var(--su));
  color: var(--input-text);
  cursor: pointer;
  appearance: none;
  -webkit-appearance: none;
  direction: rtl;
  text-align: right;
}
.pr-select option {
  direction: rtl;
}
.pr-phone-row {
  display: flex;
  align-items: center;
  gap: calc(8 * var(--su));
}
.pr-phone-field {
  flex: 1;
}
.pr-country-chip {
  display: flex;
  align-items: center;
  gap: calc(4 * var(--su));
  height: calc(50 * var(--su));
  padding: 0 calc(10 * var(--su));
  background: var(--input-bg);
  border: 1px solid var(--button-bg);
  border-radius: calc(12 * var(--su));
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  color: var(--primary-text);
  min-width: calc(85 * var(--su));
  justify-content: center;
}
.pr-dial {
  font-size: calc(12 * var(--su));
  direction: ltr;
}
.pr-eye {
  color: var(--hint-text);
  display: flex;
  align-items: center;
}
.pr-eye svg {
  width: calc(18 * var(--su));
  height: calc(18 * var(--su));
}
.pr-btn-wrap {
  display: flex;
  justify-content: center;
  margin: calc(20 * var(--su)) 0 calc(16 * var(--su));
}
.pr-btn {
  width: calc(245 * var(--su));
  height: calc(60 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(var(--button-grad-angle), var(--button-grad-start), var(--button-grad-end));
  opacity: var(--button-opacity);
  border-radius: calc(30 * var(--su));
  font-family: 'Cairo', sans-serif;
  font-weight: 600;
  font-size: calc(20 * var(--su));
  color: var(--button-text);
}
.pr-footer {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: calc(6 * var(--su));
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
}
.pr-footer-label {
  color: var(--hint-text);
  font-weight: 600;
}
.pr-footer-link {
  color: var(--button-bg);
  font-weight: 600;
}
</style>
