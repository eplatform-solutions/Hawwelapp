<template>
    <UApp>
        <NuxtPage />
    </UApp>
</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

watch(() => store.getLanguage, setLocale, { immediate: true })

</script>

<style>
@import "tailwindcss";
</style>