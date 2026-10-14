<script setup>
defineProps({
  identity: { type: Object, default: null },
  logoUrl: { type: String, default: "" },
});
</script>

<template>
  <div class="pnot-root">
    <!-- Full gradient background layer -->
    <div class="pnot-gradient-bg">
      <div class="pnot-header-title">الإشعارات</div>
    </div>

    <!-- White content panel -->
    <div class="pnot-panel">
      <!-- Notification cards -->
      <div class="pnot-list">
        <div class="pnot-card pnot-card-paid">
          <div class="pnot-card-inner">
            <div class="pnot-card-title">تم إكمال التحويل #1234</div>
            <div class="pnot-card-body">تم تسليم المبلغ بنجاح إلى المستفيد في العراق</div>
            <div class="pnot-card-time">🕐 منذ 30 دقيقة</div>
          </div>
        </div>

        <div class="pnot-card pnot-card-under">
          <div class="pnot-card-inner">
            <div class="pnot-card-title">تحويل #1233 بانتظار الدفع</div>
            <div class="pnot-card-body">يرجى إكمال الدفع خلال 24 ساعة</div>
            <div class="pnot-card-time">🕐 منذ ساعتين</div>
          </div>
        </div>

        <div class="pnot-card pnot-card-cancelled">
          <div class="pnot-card-inner">
            <div class="pnot-card-title">تم إلغاء التحويل #1230</div>
            <div class="pnot-card-body">تم إلغاء الحوالة بسبب انتهاء المهلة</div>
            <div class="pnot-card-time">🕐 منذ يومين</div>
          </div>
        </div>

        <div class="pnot-card pnot-card-paid">
          <div class="pnot-card-inner">
            <div class="pnot-card-title">تم إكمال التحويل #1228</div>
            <div class="pnot-card-body">تم تسليم المبلغ بنجاح</div>
            <div class="pnot-card-time">🕐 منذ 3 أيام</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.pnot-root {
  width: 100%;
  min-height: 100vh;
  position: relative;
}

/* Full gradient background */
.pnot-gradient-bg {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 100vh;
  background: linear-gradient(var(--header-grad-angle), var(--header-grad-start), var(--header-grad-end));
  opacity: var(--header-opacity);
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: calc(70 * var(--su));
}
.pnot-header-title {
  font-family: 'Cairo', sans-serif;
  font-weight: 700;
  font-size: calc(17 * var(--su));
  color: var(--button-text);
}

/* White panel overlay */
.pnot-panel {
  position: relative;
  margin-top: calc(150 * var(--su));
  min-height: calc(100vh - 150 * var(--su));
  background: var(--screen-bg);
  border-radius: calc(30 * var(--su)) calc(30 * var(--su)) 0 0;
  padding: calc(30 * var(--su)) calc(16 * var(--su)) calc(40 * var(--su));
  z-index: 1;
}

/* List */
.pnot-list {
  display: flex;
  flex-direction: column;
  gap: calc(12 * var(--su));
}

/* Card base */
.pnot-card {
  border-radius: calc(25 * var(--su));
  padding: calc(10 * var(--su));
}
.pnot-card-inner {
  padding: calc(14 * var(--su)) calc(18 * var(--su));
  display: flex;
  flex-direction: column;
  gap: calc(4 * var(--su));
  text-align: right;
}
.pnot-card-paid {
  background: var(--header-grad-end);
}
.pnot-card-under {
  background: var(--divider);
}
.pnot-card-cancelled {
  background: var(--icon-primary);
}

.pnot-card-title {
  font-family: 'Cairo', sans-serif;
  font-size: calc(12 * var(--su));
  font-weight: 700;
  color: var(--primary-text);
}
.pnot-card-body {
  font-family: 'Cairo', sans-serif;
  font-size: calc(12 * var(--su));
  font-weight: 700;
  color: var(--secondary-text);
}
.pnot-card-time {
  font-family: 'Cairo', sans-serif;
  font-size: calc(12 * var(--su));
  font-weight: 700;
  color: var(--hint-text);
}
</style>
