<script setup>
const props = defineProps({
  activeIndex: { type: Number, default: 3 },
});

const icons = [
  { label: "History", svg: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>' },
  { label: "Profile", svg: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>' },
  { label: "Contacts", svg: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>' },
  { label: "Home", svg: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>' },
];
</script>

<template>
  <div class="pn-outer">
    <div class="pn-bar">
      <div
        v-for="(icon, i) in icons"
        :key="i"
        class="pn-item"
        :class="{ 'pn-active': i === activeIndex }"
      >
        <div class="pn-icon-wrap">
          <span class="pn-icon" v-html="icon.svg" />
        </div>
        <div v-if="i === activeIndex" class="pn-dot" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.pn-outer {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 0 calc(20 * var(--su)) calc(16 * var(--su));
  pointer-events: none;
  z-index: 100;
}
.pn-bar {
  display: flex;
  align-items: center;
  justify-content: space-evenly;
  padding: calc(6 * var(--su)) calc(10 * var(--su));
  background: linear-gradient(var(--nav-grad-angle), var(--header-grad-start), var(--header-grad-end));
  opacity: var(--nav-opacity);
  border-radius: calc(28 * var(--su));
  border: 1px solid rgba(255,255,255,0.15);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  box-shadow:
    0 calc(8 * var(--su)) calc(28 * var(--su)) rgba(0,0,0,0.35),
    0 calc(2 * var(--su)) calc(60 * var(--su)) rgba(0,0,0,0.12);
  pointer-events: auto;
}
.pn-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: calc(3 * var(--su));
  width: calc(50 * var(--su));
  height: calc(50 * var(--su));
  justify-content: center;
  border-radius: calc(18 * var(--su));
  transition: all 0.25s ease;
}
.pn-item.pn-active {
  width: calc(60 * var(--su));
  background: rgba(255,255,255,0.18);
}
.pn-icon-wrap {
  width: calc(22 * var(--su));
  height: calc(22 * var(--su));
}
.pn-icon {
  display: block;
  width: 100%;
  height: 100%;
  color: rgba(255,255,255,0.5);
}
.pn-active .pn-icon {
  color: var(--nav-active);
}
.pn-dot {
  width: calc(5 * var(--su));
  height: calc(5 * var(--su));
  border-radius: 50%;
  background: var(--nav-active);
  box-shadow: 0 0 calc(6 * var(--su)) var(--nav-active);
}
</style>
