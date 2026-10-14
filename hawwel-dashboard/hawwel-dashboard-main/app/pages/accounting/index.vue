<template>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div>

                    <div class="text-center px-5 text-black text-[11px]/5 sm:text-[18px]/8 font-bold! mb-5">
                        {{ $t("Choose what you want to view in the accounting section") }}
                    </div>

                    <div class="flex justify-center gap-5">
                        <div>
                            <nuxt-link to="/accounting/daily-restrictions"
                                class="text-blue-900 text-[11px]/5 sm:text-[20px]/8 font-bold! underline">
                                {{ $t("Daily restrictions") }}
                            </nuxt-link>
                        </div>
                        <div>
                            <nuxt-link to="/accounting/accounting-restrictions"
                                class="text-blue-900 text-[11px]/5 sm:text-[20px]/8 font-bold! underline">
                                {{ $t("Accounting restrictions") }}
                            </nuxt-link>
                        </div>
                        <div>
                            <nuxt-link to="/accounting/financial-constraints"
                                class="text-blue-900 text-[11px]/5 sm:text-[20px]/8 font-bold! underline">
                                {{ $t("Financial constraints") }}
                            </nuxt-link>
                        </div>
                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

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
const currentPath = route.path;

const toast = useToast();
const value = ref(true);

const state = ref({
    loading: false,
    error: false,
    msg: ""
});

</script>