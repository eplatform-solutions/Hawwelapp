<template>

    <div>

        <div class="flex">

            <div class="basis-full bg-main-color-page ar-dir min-h-screen">

                <HeaderPage />

                <div class="flex justify-center pb-10">
                    <div @submit.prevent="login" class="bg-[#B9A779] p-5 w-[95%] sm:w-5/6 md:w-3/4 lg:w-1/2">

                        <div class="text-center text-black font-bold! text-[20px]/5 sm:text-[25px]/10 mb-10">
                            {{ $t("Welcome back") }}
                        </div>


                        <div class="flex justify-center">
                            <nuxt-link to="/login"
                                class="bg-stone-500 text-black font-bold! text-[14px]/8 px-5 py-1.5 border border-[#B9A779]/90 cursor-pointer rounded-xl">
                                {{ $t("Login") }}
                            </nuxt-link>
                        </div>

                    </div>
                </div>

            </div>

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

</script>