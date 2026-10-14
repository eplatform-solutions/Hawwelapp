<script setup>
defineProps({
  title: { type: String, default: "" },
  logoUrl: { type: String, default: "" },
  showBack: { type: Boolean, default: false },
  tall: { type: Boolean, default: false },
  titleOffsetTop: { type: Number, default: 120 },
});
</script>

<template>
  <div class="ph-wrap" :class="{ 'ph-tall': tall }">
    <div class="ph-gradient">
      <!-- Back arrow -->
      <div v-if="showBack" class="ph-back">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--button-text, #fff)" stroke-width="2">
          <polyline points="15 18 9 12 15 6" />
        </svg>
      </div>

      <!-- Logo -->
      <img v-if="logoUrl" :src="logoUrl" class="ph-logo" />

      <!-- Title -->
      <div class="ph-title" :style="{ paddingTop: `calc(${titleOffsetTop} * var(--su))` }">
        {{ title }}
      </div>
    </div>
  </div>
</template>

<style scoped>
.ph-wrap {
  width: 100%;
  position: relative;
}
.ph-gradient {
  width: 100%;
  height: calc(280 * var(--su));
  background: linear-gradient(var(--header-grad-angle), var(--header-grad-start), var(--header-grad-end));
  opacity: var(--header-opacity);
  border-radius: 0 0 calc(20 * var(--su)) calc(20 * var(--su));
  position: relative;
  overflow: hidden;
}
.ph-tall .ph-gradient {
  height: calc(260 * var(--su));
}
.ph-back {
  position: absolute;
  top: calc(50 * var(--su));
  left: calc(5 * var(--su));
  width: calc(30 * var(--su));
  height: calc(30 * var(--su));
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}
.ph-back svg {
  width: calc(24 * var(--su));
  height: calc(24 * var(--su));
}
.ph-logo {
  position: absolute;
  top: calc(12 * var(--su));
  right: calc(12 * var(--su));
  width: calc(46 * var(--su));
  height: calc(46 * var(--su));
  border-radius: calc(10 * var(--su));
  object-fit: contain;
}
.ph-title {
  width: 100%;
  text-align: center;
  font-family: 'Cairo', sans-serif;
  font-weight: 700;
  font-size: calc(20 * var(--su));
  color: var(--text-color);
  padding-left: calc(16 * var(--su));
  padding-right: calc(16 * var(--su));
}
</style>
