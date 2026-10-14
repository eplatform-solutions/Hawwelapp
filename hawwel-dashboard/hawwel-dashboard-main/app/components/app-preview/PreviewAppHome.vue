<script setup>
import PreviewNavBar from "./PreviewNavBar.vue";

defineProps({
  identity: { type: Object, default: null },
  logoUrl: { type: String, default: "" },
});
</script>

<template>
  <div class="pah-root">
    <!-- Header gradient with user info -->
    <div class="pah-header">
      <div class="pah-header-gradient">
        <div class="pah-topbar">
          <div class="pah-topbar-right">
            <div v-if="logoUrl" class="pah-logo">
              <img :src="logoUrl" class="pah-logo-img" />
            </div>
          </div>
          <div class="pah-greeting">مرحباً، أحمد</div>
          <div class="pah-topbar-left">
            <svg viewBox="0 0 24 24" fill="none" stroke="var(--text-color)" stroke-width="1.5" width="20" height="20"><path d="M12 22c1.1 0 2-.9 2-2H10a2 2 0 002 2z"/><path d="M18 16v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5S10.5 3.17 10.5 4v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>
          </div>
        </div>

        <!-- Quick balance card -->
        <div class="pah-balance-card">
          <div class="pah-balance-label">رصيدك الحالي</div>
          <div class="pah-balance-amount">0.00 USDT</div>
        </div>
      </div>
    </div>

    <!-- Content area -->
    <div class="pah-content">
      <!-- Quick actions -->
      <div class="pah-section-title">الإجراءات السريعة</div>
      <div class="pah-actions-grid">
        <div class="pah-action-card">
          <div class="pah-action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="24" height="24"><path d="M22 2L11 13"/><path d="M22 2l-7 20-4-9-9-4 20-7z"/></svg>
          </div>
          <span class="pah-action-label">إرسال</span>
        </div>
        <div class="pah-action-card">
          <div class="pah-action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="24" height="24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          </div>
          <span class="pah-action-label">السجل</span>
        </div>
        <div class="pah-action-card">
          <div class="pah-action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="24" height="24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
          </div>
          <span class="pah-action-label">الملف</span>
        </div>
        <div class="pah-action-card">
          <div class="pah-action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="24" height="24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>
          </div>
          <span class="pah-action-label">المحفوظين</span>
        </div>
      </div>

      <!-- Recent transactions -->
      <div class="pah-section-title">آخر المعاملات</div>
      <div class="pah-tx-list">
        <div class="pah-tx-item">
          <div class="pah-tx-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="1.5" width="18" height="18"><polyline points="20 6 9 17 4 12"/></svg>
          </div>
          <div class="pah-tx-info">
            <div class="pah-tx-name">تحويل #1234</div>
            <div class="pah-tx-date">منذ 2 ساعة</div>
          </div>
          <div class="pah-tx-amount">250 USDT</div>
        </div>
        <div class="pah-tx-divider"></div>
        <div class="pah-tx-item">
          <div class="pah-tx-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="1.5" width="18" height="18"><polyline points="20 6 9 17 4 12"/></svg>
          </div>
          <div class="pah-tx-info">
            <div class="pah-tx-name">تحويل #1233</div>
            <div class="pah-tx-date">منذ 5 ساعات</div>
          </div>
          <div class="pah-tx-amount">100 USDT</div>
        </div>
        <div class="pah-tx-divider"></div>
        <div class="pah-tx-item">
          <div class="pah-tx-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none" stroke="var(--warning)" stroke-width="1.5" width="18" height="18"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
          </div>
          <div class="pah-tx-info">
            <div class="pah-tx-name">تحويل #1232</div>
            <div class="pah-tx-date">منذ يوم</div>
          </div>
          <div class="pah-tx-amount">500 USDT</div>
        </div>
      </div>
    </div>

    <PreviewNavBar :active-index="3" />
  </div>
</template>

<style scoped>
.pah-root {
  width: 100%;
  min-height: 100vh;
  background: var(--screen-bg);
  position: relative;
  padding-bottom: calc(90 * var(--su));
}

/* Header */
.pah-header {
  padding-bottom: calc(20 * var(--su));
}
.pah-header-gradient {
  width: 100%;
  padding-bottom: calc(24 * var(--su));
  background: linear-gradient(var(--header-grad-angle), var(--header-grad-start), var(--header-grad-end));
  opacity: var(--header-opacity);
  border-radius: 0 0 calc(20 * var(--su)) calc(20 * var(--su));
}
.pah-topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: calc(14 * var(--su)) calc(16 * var(--su)) 0;
}
.pah-topbar-right, .pah-topbar-left {
  display: flex;
  align-items: center;
  gap: calc(8 * var(--su));
}
.pah-topbar-left svg {
  width: calc(22 * var(--su));
  height: calc(22 * var(--su));
}
.pah-logo {
  width: calc(30 * var(--su));
  height: calc(30 * var(--su));
}
.pah-logo-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  border-radius: calc(8 * var(--su));
}
.pah-greeting {
  font-family: 'Cairo', sans-serif;
  font-weight: 600;
  font-size: calc(18 * var(--su));
  color: var(--text-color);
}

/* Balance card */
.pah-balance-card {
  margin: calc(20 * var(--su)) calc(24 * var(--su)) 0;
  padding: calc(16 * var(--su));
  background: rgba(255,255,255,0.12);
  border-radius: calc(16 * var(--su));
  border: 1px solid rgba(255,255,255,0.2);
  backdrop-filter: blur(8px);
  text-align: center;
}
.pah-balance-label {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  color: rgba(255,255,255,0.8);
  font-weight: 500;
  margin-bottom: calc(4 * var(--su));
}
.pah-balance-amount {
  font-family: 'Cairo', sans-serif;
  font-size: calc(26 * var(--su));
  font-weight: 700;
  color: #FFFFFF;
}

/* Content */
.pah-content {
  padding: calc(16 * var(--su)) calc(20 * var(--su));
}
.pah-section-title {
  font-family: 'Cairo', sans-serif;
  font-weight: 700;
  font-size: calc(16 * var(--su));
  color: var(--primary-text);
  margin-bottom: calc(12 * var(--su));
}

/* Actions grid */
.pah-actions-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: calc(10 * var(--su));
  margin-bottom: calc(24 * var(--su));
}
.pah-action-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: calc(6 * var(--su));
  padding: calc(12 * var(--su)) calc(4 * var(--su));
  background: var(--card-bg);
  border: 1px solid var(--card-border);
  border-radius: calc(12 * var(--su));
}
.pah-action-icon {
  width: calc(24 * var(--su));
  height: calc(24 * var(--su));
  color: var(--icon-primary);
}
.pah-action-icon svg {
  width: 100%;
  height: 100%;
}
.pah-action-label {
  font-family: 'Cairo', sans-serif;
  font-size: calc(11 * var(--su));
  font-weight: 600;
  color: var(--primary-text);
}

/* Transaction list */
.pah-tx-list {
  background: var(--card-bg);
  border: 1px solid var(--card-border);
  border-radius: calc(14 * var(--su));
  padding: calc(12 * var(--su)) calc(14 * var(--su));
}
.pah-tx-item {
  display: flex;
  align-items: center;
  gap: calc(10 * var(--su));
  padding: calc(10 * var(--su)) 0;
}
.pah-tx-icon-wrap {
  width: calc(36 * var(--su));
  height: calc(36 * var(--su));
  border-radius: 50%;
  background: var(--screen-bg);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.pah-tx-icon-wrap svg {
  width: calc(18 * var(--su));
  height: calc(18 * var(--su));
}
.pah-tx-info {
  flex: 1;
  min-width: 0;
}
.pah-tx-name {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  font-weight: 600;
  color: var(--primary-text);
}
.pah-tx-date {
  font-family: 'Cairo', sans-serif;
  font-size: calc(11 * var(--su));
  color: var(--hint-text);
}
.pah-tx-amount {
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
  font-weight: 700;
  color: var(--primary-text);
  white-space: nowrap;
}
.pah-tx-divider {
  height: 1px;
  background: var(--divider);
}
</style>
