<script setup>
import PreviewHeader from "./PreviewHeader.vue";

defineProps({
  identity: { type: Object, default: null },
  logoUrl: { type: String, default: "" },
});
</script>

<template>
  <div class="pl-root">
    <PreviewHeader title="تسجيل الدخول" :logo-url="logoUrl" :title-offset-top="120" />

    <div class="pl-body">
      <div class="pl-welcome">مرحباً بعودتك</div>

      <!-- Phone field -->
      <div class="pl-field-group">
        <div class="pl-input">
          <span class="pl-placeholder">رقم الهاتف</span>
        </div>
      </div>

      <!-- Password field -->
      <div class="pl-field-group">
        <div class="pl-input">
          <span class="pl-placeholder">كلمة المرور</span>
          <span class="pl-eye">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="18" height="18">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
            </svg>
          </span>
        </div>
      </div>

      <!-- Forgot password -->
      <div class="pl-forgot">نسيت كلمة المرور؟</div>

      <!-- Login button -->
      <div class="pl-btn-wrap">
        <div class="pl-btn">تسجيل الدخول</div>
      </div>

      <!-- Footer -->
      <div class="pl-footer">
        <span class="pl-footer-label">ليس لديك حساب؟</span>
        <span class="pl-footer-link">سجل الآن</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.pl-root {
  width: 100%;
  min-height: 100vh;
  background: var(--screen-bg);
}
.pl-body {
  padding: calc(50 * var(--su)) calc(30 * var(--su)) calc(20 * var(--su));
}
.pl-welcome {
  font-family: 'Cairo', sans-serif;
  font-weight: 600;
  font-size: calc(24 * var(--su));
  color: var(--primary-text);
  text-align: center;
  margin-bottom: calc(30 * var(--su));
}
.pl-field-group {
  margin-bottom: calc(16 * var(--su));
  padding: 0 calc(18 * var(--su));
}
.pl-input {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: calc(55 * var(--su));
  padding: 0 calc(16 * var(--su));
  background: var(--input-bg);
  border: 1px solid var(--input-border);
  border-radius: calc(12 * var(--su));
  font-family: 'Cairo', sans-serif;
}
.pl-placeholder {
  font-size: calc(14 * var(--su));
  color: var(--hint-text);
  font-family: 'Cairo', sans-serif;
}
.pl-eye {
  color: var(--hint-text);
  display: flex;
  align-items: center;
}
.pl-eye svg {
  width: calc(18 * var(--su));
  height: calc(18 * var(--su));
}
.pl-forgot {
  text-align: left;
  padding: 0 calc(30 * var(--su));
  margin-bottom: calc(30 * var(--su));
  font-size: calc(14 * var(--su));
  font-weight: 600;
  color: var(--secondary-text);
  font-family: 'Cairo', sans-serif;
}
.pl-btn-wrap {
  display: flex;
  justify-content: center;
  margin-bottom: calc(24 * var(--su));
}
.pl-btn {
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
  color: #FFFFFF;
}
.pl-footer {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: calc(6 * var(--su));
  font-family: 'Cairo', sans-serif;
  font-size: calc(13 * var(--su));
}
.pl-footer-label {
  color: var(--secondary-text);
  font-weight: 600;
}
.pl-footer-link {
  color: var(--icon-primary);
  font-weight: 600;
}
</style>
