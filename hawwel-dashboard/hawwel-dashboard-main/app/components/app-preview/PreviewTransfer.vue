<script setup>
import PreviewNavBar from "./PreviewNavBar.vue";

defineProps({
  identity: { type: Object, default: null },
  logoUrl: { type: String, default: "" },
});
</script>

<template>
  <div class="pt-root">
    <!-- Header gradient area (authenticated version) -->
    <div class="pt-header-area">
      <div class="pt-header-gradient">
        <!-- Top bar -->
        <div class="pt-topbar">
          <div class="pt-topbar-right">
            <div v-if="logoUrl" class="pt-logo">
              <img :src="logoUrl" class="pt-logo-img" />
            </div>
            <div v-else class="pt-logo-placeholder">
              <svg viewBox="0 0 24 24" fill="none" stroke="var(--text-color)" stroke-width="1.5" width="20" height="20"><rect x="3" y="3" width="18" height="18" rx="4"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
            </div>
          </div>
          <div class="pt-title">حوالة</div>
          <div class="pt-topbar-left">
            <div class="pt-notif-wrap">
              <svg viewBox="0 0 24 24" fill="none" stroke="var(--text-color)" stroke-width="1.5" width="20" height="20"><path d="M12 22c1.1 0 2-.9 2-2H10a2 2 0 002 2z"/><path d="M18 16v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5S10.5 3.17 10.5 4v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>
              <div class="pt-notif-badge"></div>
            </div>
            <span class="pt-lang">EN</span>
          </div>
        </div>

        <!-- Labels -->
        <div class="pt-labels">
          <div class="pt-label-row">
            <span class="pt-label">مبلغ الإرسال</span>
            <span class="pt-label">أرسل إلى</span>
          </div>
        </div>

        <!-- Amount / Country -->
        <div class="pt-inputs-row">
          <div class="pt-amount-box">
            <div class="pt-amount-inner">
              <span class="pt-coin">USDT</span>
              <span class="pt-amount-val">0.00</span>
            </div>
          </div>
          <div class="pt-country-box">
            <span class="pt-flag">🇮🇶</span>
            <span class="pt-country-name">العراق</span>
            <span class="pt-arrow">▾</span>
          </div>
        </div>

        <!-- City / Area -->
        <div class="pt-sub-row">
          <div class="pt-sub-field">
            <span class="pt-sub-icon">▾</span>
            <span class="pt-sub-label">اختر مدينة</span>
          </div>
          <div class="pt-sub-field">
            <span class="pt-sub-icon">▾</span>
            <span class="pt-sub-label">اختر منطقة</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="pt-content">
      <div class="pt-section-title">طرق التحويل</div>

      <div class="pt-chips-grid">
        <div class="pt-chip pt-chip-active">تحويل سريع</div>
        <div class="pt-chip">حوالة مالية</div>
        <div class="pt-chip">بطاقة ائتمان</div>
        <div class="pt-chip">محفظة إلكترونية</div>
      </div>

      <!-- Summary -->
      <div class="pt-summary-row">
        <div class="pt-summary-card">
          <div class="pt-summary-lbl">المستلم يحصل على</div>
          <div class="pt-summary-val">0.00 IQD</div>
        </div>
        <div class="pt-summary-sep">
          <svg viewBox="0 0 24 24" fill="none" stroke="var(--accent)" stroke-width="2" width="15" height="15"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 014-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 01-4 4H3"/></svg>
        </div>
        <div class="pt-summary-card">
          <div class="pt-summary-lbl">أنت ترسل</div>
          <div class="pt-summary-val">0.00 USDT</div>
        </div>
      </div>

      <!-- Fee -->
      <div class="pt-fee">
        <span class="pt-fee-pct">0%</span>
        <span class="pt-fee-lbl">الرسوم</span>
      </div>

      <!-- CTA -->
      <div class="pt-cta-wrap">
        <div class="pt-cta">إرسال حوالة</div>
      </div>
    </div>

    <PreviewNavBar :active-index="3" />
  </div>
</template>

<style scoped>
.pt-root {
  width: 100%;
  min-height: 100vh;
  background: var(--screen-bg);
  position: relative;
  padding-bottom: calc(90 * var(--su));
}
.pt-header-area {
  padding-bottom: calc(30 * var(--su));
}
.pt-header-gradient {
  width: 100%;
  padding-bottom: calc(20 * var(--su));
  background: linear-gradient(var(--header-grad-angle), var(--header-grad-start), var(--header-grad-end));
  opacity: var(--header-opacity);
  border-radius: 0 0 calc(20 * var(--su)) calc(20 * var(--su));
}
.pt-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: calc(12 * var(--su)) calc(16 * var(--su)) 0;
}
.pt-topbar-right, .pt-topbar-left {
  display: flex;
  align-items: center;
  gap: calc(8 * var(--su));
}
.pt-topbar-right svg, .pt-topbar-left svg {
  width: calc(22 * var(--su));
  height: calc(22 * var(--su));
}
.pt-logo, .pt-logo-placeholder {
  width: calc(25 * var(--su));
  height: calc(25 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
}
.pt-logo-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  border-radius: calc(6 * var(--su));
}
.pt-title {
  font-family: 'Cairo', sans-serif;
  font-weight: 600;
  font-size: calc(18 * var(--su));
  color: var(--text-color);
}
.pt-notif-wrap {
  position: relative;
}
.pt-notif-badge {
  position: absolute;
  top: calc(-2 * var(--su));
  right: calc(-2 * var(--su));
  width: calc(8 * var(--su));
  height: calc(8 * var(--su));
  border-radius: 50%;
  background: var(--error);
}
.pt-lang {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  color: var(--primary-text);
  font-weight: 600;
}

/* Labels */
.pt-labels {
  padding: calc(20 * var(--su)) calc(20 * var(--su)) 0;
}
.pt-label-row {
  display: flex;
  justify-content: space-between;
}
.pt-label {
  font-family: 'Cairo', sans-serif;
  font-size: calc(11 * var(--su));
  font-weight: 600;
  color: var(--accent);
}

/* Amount / Country */
.pt-inputs-row {
  display: flex;
  justify-content: center;
  gap: calc(12 * var(--su));
  padding: calc(8 * var(--su)) calc(16 * var(--su)) 0;
}
.pt-amount-box {
  width: calc(170 * var(--su));
  height: calc(45 * var(--su));
  border: 1.5px solid var(--accent);
  border-radius: calc(10 * var(--su));
  display: flex;
  align-items: center;
  padding: 0 calc(10 * var(--su));
}
.pt-amount-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}
.pt-coin {
  font-family: 'Cairo', sans-serif;
  font-size: calc(14 * var(--su));
  font-weight: 600;
  color: var(--accent);
}
.pt-amount-val {
  font-family: 'Cairo', sans-serif;
  font-size: calc(14 * var(--su));
  color: var(--hint-text);
}
.pt-country-box {
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
.pt-flag { font-size: calc(22 * var(--su)); }
.pt-country-name {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  font-weight: 600;
  color: var(--accent);
}
.pt-arrow {
  font-size: calc(12 * var(--su));
  color: var(--accent);
}

/* Sub row */
.pt-sub-row {
  display: flex;
  justify-content: center;
  gap: calc(12 * var(--su));
  padding: calc(12 * var(--su)) calc(16 * var(--su)) 0;
}
.pt-sub-field {
  flex: 1;
  height: calc(40 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
  gap: calc(4 * var(--su));
  border-bottom: 1px solid var(--divider);
}
.pt-sub-icon {
  font-size: calc(12 * var(--su));
  color: var(--secondary-text);
}
.pt-sub-label {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  color: var(--secondary-text);
}

/* Content */
.pt-content {
  padding: calc(10 * var(--su)) calc(20 * var(--su));
}
.pt-section-title {
  font-family: 'Cairo', sans-serif;
  font-weight: 700;
  font-size: calc(18 * var(--su));
  color: var(--primary-text);
  margin-bottom: calc(10 * var(--su));
  text-align: center;
}
.pt-chips-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: calc(10 * var(--su));
  margin-bottom: calc(16 * var(--su));
}
.pt-chip {
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
}
.pt-chip-active {
  background: var(--link);
  color: #FFFFFF;
  border-color: var(--link);
}

/* Summary */
.pt-summary-row {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: calc(8 * var(--su));
  margin-bottom: calc(14 * var(--su));
}
.pt-summary-card {
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
.pt-summary-lbl {
  font-family: 'Cairo', sans-serif;
  font-size: calc(11 * var(--su));
  color: var(--secondary-text);
  font-weight: 600;
}
.pt-summary-val {
  font-family: 'Cairo', sans-serif;
  font-size: calc(14 * var(--su));
  color: var(--primary-text);
  font-weight: 700;
}
.pt-summary-sep {
  display: flex;
  align-items: center;
}
.pt-summary-sep svg {
  width: calc(15 * var(--su));
  height: calc(15 * var(--su));
}

/* Fee */
.pt-fee {
  width: calc(250 * var(--su));
  height: calc(44 * var(--su));
  margin: 0 auto calc(16 * var(--su));
  border: 1px solid var(--icon-primary);
  border-radius: calc(8 * var(--su));
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 calc(16 * var(--su));
  font-family: 'Cairo', sans-serif;
}
.pt-fee-pct {
  font-size: calc(14 * var(--su));
  color: var(--secondary-text);
  font-weight: 600;
}
.pt-fee-lbl {
  font-size: calc(15 * var(--su));
  color: var(--primary-text);
  font-weight: 600;
}

/* CTA */
.pt-cta-wrap {
  display: flex;
  justify-content: center;
}
.pt-cta {
  width: calc(245 * var(--su));
  height: calc(60 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(var(--header-grad-angle), var(--header-grad-start), var(--header-grad-end));
  border-radius: calc(30 * var(--su));
  font-family: 'Cairo', sans-serif;
  font-weight: 600;
  font-size: calc(20 * var(--su));
  color: var(--button-text);
}
</style>
