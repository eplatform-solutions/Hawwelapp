<template>

    <!-- title -->
    <div class="flex gap-1 items-center p-3 mb-5 justify-between surface-panel"
        :class="{ 'ar-dir': locale == 'ar' }">
        <div class="flex gap-1 items-center">
            <MySlideover v-if="authUser" />
            <div class="size-4 bg-[#999696] rounded-full"></div>
            <nuxt-link to="/" class="text-black font-bold! text-[16px]/8">
                {{ $t('admin') }}
            </nuxt-link>
        </div>
        <UButton v-if="!authUser" class="cursor-pointer brand-btn text-sm px-2 py-1" @click="changeLang">
            <span v-if="locale == 'ar'"> {{ $t("arabic") }} </span>
            <span v-else> {{ $t("english") }} </span>
        </UButton>
        <div v-else>
            <button class="cursor-pointer brand-btn text-sm px-2 py-1 rounded-lg text-white" @click="logout">
                {{ $t("Logout") }}
            </button>
        </div>
    </div>

</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

function logout() {
    store.updateToken(null);
    router.push("/login");
}

function changeLang() {
    let myLan = locale.value;
    myLan = myLan == 'ar' ? 'en' : 'ar';
    setLocale(myLan);
    store.updateLanguage(myLan);
}

</script>