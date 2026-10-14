<template>

    <!-- <use-toast v-if="state.error" head="Error" :body="locale == 'en' ? state.msg.en : state.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast> -->

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
            :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div v-if="state.loading" class="flex justify-center my-5">
                    <LoadingIcon />
                </div>

                <div v-else-if="state.error" class="flex flex-col gap-3 justify-center my-5">
                    <div class="text-center text-red-500 text-[12px]/5 sm:text-[16px]/8 font-bold!">
                        <span v-if="locale == 'ar'"> {{ $t(state.msg.ar) }} </span>
                        <span v-else> {{ $t(state.msg.en) }} </span>
                    </div>
                    <div class="flex justify-center">
                        <button
                            class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                            @click="getAllInfo">
                            {{ $t("Refresh") }}
                        </button>
                    </div>
                </div>
                <!-- boxes -->
                <div v-else class="flex justify-around flex-wrap gap-5 pb-5">

                    <div class="basis-[45%] md:basis-[30%]">
                        <my-box-card title="Number of users" :number="staticData.totalUsers">
                        </my-box-card>
                    </div>
                    <div class="basis-[45%] md:basis-[30%]">
                        <my-box-card title="Number of active users" :number="staticData.activeUsers">
                        </my-box-card>
                    </div>
                    <div class="basis-[45%] md:basis-[30%]">
                        <my-box-card title="Number of daily transfers"
                            :number="staticData.dailyTransfers"></my-box-card>
                    </div>
                    <div class="basis-[45%] md:basis-[30%]">
                        <my-box-card title="Total number of transfers"
                            :number="staticData.totalTransfers"></my-box-card>
                    </div>
                    <div class="basis-[45%] md:basis-[30%]">
                        <my-box-card title="Daily deposit amount"
                            :number="staticData.dailyDepositsAmount"></my-box-card>
                    </div>
                    <div class="basis-[45%] md:basis-[30%]">
                        <my-box-card title="Total amount of deposits"
                            :number="staticData.totalDepositsAmount"></my-box-card>
                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});
const toast = useToast();

const state = ref({
    loading: false,
    error: false,
    msg: ""
});

const staticData = ref([]);

onMounted(() => {
    getAllInfo();
});

async function getAllInfo() {
    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    state.value.msg = {
        ar: "",
        en: ""
    };
    getStaticData().then(res => {
        if (res) {
            staticData.value = res;
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getStaticData() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/overview/statistics`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            state.value.error = true;
            state.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        return response.data.data;
    }
    catch (error) {
        state.value.loading = false;
        state.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        state.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

</script>