<script setup>
import PreviewNavBar from "./PreviewNavBar.vue";

defineProps({
  identity: { type: Object, default: null },
  logoUrl: { type: String, default: "" },
});
</script>

<template>
  <div class="pw-root">
    <!-- Header gradient area -->
    <div class="pw-header-area">
      <div class="pw-header-gradient">
        <!-- Top bar: logo + title + icons -->
        <div class="pw-topbar">
          <div class="pw-topbar-right">
            <div class="pw-logo-circle" v-if="logoUrl">
              <img :src="logoUrl" class="pw-logo-img" />
            </div>
            <div v-else class="pw-logo-placeholder">
              <svg viewBox="0 0 24 24" fill="none" stroke="var(--text-color)" stroke-width="1.5" width="20" height="20"><rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
            </div>
          </div>
          <div class="pw-title">مرحباً</div>
          <div class="pw-topbar-left">
            <svg viewBox="0 0 24 24" fill="none" stroke="var(--text-color)" stroke-width="1.5" width="20" height="20"><path d="M12 22c1.1 0 2-.9 2-2H10a2 2 0 002 2z"/><path d="M18 16v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5S10.5 3.17 10.5 4v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>
            <span class="pw-lang">EN</span>
          </div>
        </div>

        <!-- Labels -->
        <div class="pw-labels">
          <div class="pw-label-row">
            <span class="pw-label">مبلغ الإرسال</span>
            <span class="pw-label">أرسل إلى</span>
          </div>
        </div>

        <!-- Currency / country inputs -->
        <div class="pw-inputs-row">
          <div class="pw-amount-box">
            <div class="pw-amount-inner">
              <span class="pw-coin">USDT</span>
              <span class="pw-amount-placeholder">0.00</span>
            </div>
          </div>
          <div class="pw-country-box">
            <span class="pw-flag">🇮🇶</span>
            <span class="pw-country-name">العراق</span>
            <span class="pw-arrow">▾</span>
          </div>
        </div>

        <!-- City / Area -->
        <div class="pw-sub-row">
          <div class="pw-sub-field">
            <span class="pw-sub-icon">▾</span>
            <span class="pw-sub-label">اختر مدينة</span>
          </div>
          <div class="pw-sub-field">
            <span class="pw-sub-icon">▾</span>
            <span class="pw-sub-label">اختر منطقة</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Content below header -->
    <div class="pw-content">
      <!-- Conversion methods title -->
      <div class="pw-section-title">طرق التحويل</div>

      <!-- Payment method chips -->
      <div class="pw-chips-grid">
        <div class="pw-chip pw-chip-active">
          <span>تحويل سريع</span>
        </div>
        <div class="pw-chip">
          <span>حوالة مالية</span>
        </div>
        <div class="pw-chip">
          <span>بطاقة ائتمان</span>
        </div>
        <div class="pw-chip">
          <span>محفظة إلكترونية</span>
        </div>
      </div>

      <!-- Summary cards row -->
      <div class="pw-summary-row">
        <div class="pw-summary-card">
          <div class="pw-summary-label">المستلم يحصل على</div>
          <div class="pw-summary-value">0.00 IQD</div>
        </div>
        <div class="pw-summary-separator">
          <svg viewBox="0 0 24 24" fill="none" stroke="var(--accent)" stroke-width="2" width="15" height="15">
            <polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 014-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 01-4 4H3"/>
          </svg>
        </div>
        <div class="pw-summary-card">
          <div class="pw-summary-label">أنت ترسل</div>
          <div class="pw-summary-value">0.00 USDT</div>
        </div>
      </div>

      <!-- Fee strip -->
      <div class="pw-fee-strip">
        <span class="pw-fee-pct">0%</span>
        <span class="pw-fee-label">الرسوم</span>
      </div>

      <!-- CTA Button -->
      <div class="pw-cta-wrap">
        <div class="pw-cta">إرسال حوالة</div>
      </div>
    </div>

    <PreviewNavBar :active-index="3" />
  </div>
</template>

<style scoped>
.pw-root {
  width: 100%;
  min-height: 100vh;
  background: var(--screen-bg);
  position: relative;
  padding-bottom: calc(90 * var(--su));
}

/* ── Header ── */
.pw-header-area {
  padding-bottom: calc(30 * var(--su));
}
.pw-header-gradient {
  width: 100%;
  padding-bottom: calc(20 * var(--su));
  background: linear-gradient(var(--header-grad-angle), var(--header-grad-start), var(--header-grad-end));
  opacity: var(--header-opacity);
  border-radius: 0 0 calc(20 * var(--su)) calc(20 * var(--su));
}
.pw-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: calc(12 * var(--su)) calc(16 * var(--su)) 0;
}
.pw-topbar-right, .pw-topbar-left {
  display: flex;
  align-items: center;
  gap: calc(8 * var(--su));
}
.pw-topbar-left svg, .pw-topbar-right svg {
  width: calc(22 * var(--su));
  height: calc(22 * var(--su));
}
.pw-logo-circle {
  width: calc(25 * var(--su));
  height: calc(25 * var(--su));
}
.pw-logo-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  border-radius: calc(6 * var(--su));
}
.pw-logo-placeholder {
  width: calc(25 * var(--su));
  height: calc(25 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
}
.pw-title {
  font-family: 'Cairo', sans-serif;
  font-weight: 600;
  font-size: calc(18 * var(--su));
  color: var(--text-color);
}
.pw-lang {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  color: var(--primary-text);
  font-weight: 600;
}

/* ── Labels ── */
.pw-labels {
  padding: calc(20 * var(--su)) calc(20 * var(--su)) 0;
}
.pw-label-row {
  display: flex;
  justify-content: space-between;
}
.pw-label {
  font-family: 'Cairo', sans-serif;
  font-size: calc(11 * var(--su));
  font-weight: 600;
  color: var(--secondary-text);
}

/* ── Inputs row ── */
.pw-inputs-row {
  display: flex;
  justify-content: center;
  gap: calc(12 * var(--su));
  padding: calc(8 * var(--su)) calc(16 * var(--su)) 0;
}
.pw-amount-box {
  width: calc(170 * var(--su));
  height: calc(45 * var(--su));
  border: 1.5px solid var(--accent);
  border-radius: calc(10 * var(--su));
  display: flex;
  align-items: center;
  padding: 0 calc(10 * var(--su));
}
.pw-amount-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}
.pw-coin {
  font-family: 'Cairo', sans-serif;
  font-size: calc(14 * var(--su));
  font-weight: 600;
  color: var(--secondary-text);
}
.pw-amount-placeholder {
  font-family: 'Cairo', sans-serif;
  font-size: calc(14 * var(--su));
  color: var(--hint-text);
}
.pw-country-box {
  width: calc(170 * var(--su));
  height: calc(45 * var(--su));
  border: 1.5px solid var(--accent);
  border-radius: calc(10 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
  gap: calc(6 * var(--su));
  padding: 0 calc(8 * var(--su));
}
.pw-flag {
  font-size: calc(22 * var(--su));
}
.pw-country-name {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  font-weight: 600;
  color: var(--secondary-text);
}
.pw-arrow {
  font-size: calc(12 * var(--su));
  color: var(--secondary-text);
}

/* ── Sub row (city/area) ── */
.pw-sub-row {
  display: flex;
  justify-content: center;
  gap: calc(12 * var(--su));
  padding: calc(12 * var(--su)) calc(16 * var(--su)) 0;
}
.pw-sub-field {
  flex: 1;
  height: calc(40 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
  gap: calc(4 * var(--su));
  border-bottom: 1px solid var(--divider);
}
.pw-sub-icon {
  font-size: calc(12 * var(--su));
  color: var(--secondary-text);
}
.pw-sub-label {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  color: var(--secondary-text);
}

/* ── Content below header ── */
.pw-content {
  padding: calc(10 * var(--su)) calc(20 * var(--su));
}
.pw-section-title {
  font-family: 'Cairo', sans-serif;
  font-weight: 700;
  font-size: calc(18 * var(--su));
  color: var(--primary-text);
  margin-bottom: calc(10 * var(--su));
  text-align: center;
}

/* ── Chips grid ── */
.pw-chips-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: calc(10 * var(--su));
  margin-bottom: calc(16 * var(--su));
}
.pw-chip {
  height: calc(42 * var(--su));
  border-radius: calc(12 * var(--su));
  border: 1px solid var(--icon-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  font-weight: 600;
  color: var(--primary-text);
  background: transparent;
}
.pw-chip-active {
  background: var(--link);
  color: #FFFFFF;
  border-color: var(--link);
}

/* ── Summary row ── */
.pw-summary-row {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: calc(8 * var(--su));
  margin-bottom: calc(14 * var(--su));
}
.pw-summary-card {
  width: calc(145 * var(--su));
  height: calc(80 * var(--su));
  border: 1px solid var(--card-border);
  border-radius: calc(12 * var(--su));
  background: var(--card-bg);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: calc(4 * var(--su));
}
.pw-summary-label {
  font-family: 'Cairo', sans-serif;
  font-size: calc(11 * var(--su));
  color: var(--secondary-text);
  font-weight: 600;
}
.pw-summary-value {
  font-family: 'Cairo', sans-serif;
  font-size: calc(14 * var(--su));
  color: var(--primary-text);
  font-weight: 700;
}
.pw-summary-separator {
  display: flex;
  align-items: center;
}
.pw-summary-separator svg {
  width: calc(15 * var(--su));
  height: calc(15 * var(--su));
}

/* ── Fee strip ── */
.pw-fee-strip {
  width: calc(250 * var(--su));
  height: calc(44 * var(--su));
  margin: 0 auto calc(16 * var(--su));
  border: 1px solid var(--card-border);
  border-radius: calc(8 * var(--su));
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 calc(16 * var(--su));
  font-family: 'Cairo', sans-serif;
}
.pw-fee-pct {
  font-size: calc(14 * var(--su));
  color: var(--secondary-text);
  font-weight: 600;
}
.pw-fee-label {
  font-size: calc(15 * var(--su));
  color: var(--primary-text);
  font-weight: 600;
}

/* ── CTA ── */
.pw-cta-wrap {
  display: flex;
  justify-content: center;
}
.pw-cta {
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
</style>
