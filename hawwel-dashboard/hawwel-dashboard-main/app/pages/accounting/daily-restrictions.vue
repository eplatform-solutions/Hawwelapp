<template>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div v-if="state.loading" class="flex justify-center items-center py-10">
                    <div>
                        <LoadingIcon />
                    </div>
                </div>
                <div v-else-if="state.error" class="flex justify-center flex-col gap-4 items-center py-10">
                    <div class="text-[16px]/8 text-red-500 font-bold!">
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

                <div v-else>

                    <div class="flex justify-center items-center mb-5 gap-5 mx-3">

                        <div v-for="item in myData.exchangeRates" :key="item._id"
                            class="bg-[#B9A779] px-5 py-0.5 rounded-xl">
                            <div class="text-black text-[10px]/8 font-bold! text-center">
                                {{ $t("The price of") }} {{ item.baseSymbol }} {{ $t("today") }}
                            </div>
                            <div class="text-black text-[15px]/8 font-bold! text-center">
                                {{ item.rate }}
                            </div>
                        </div>

                    </div>

                    <div class="flex justify-center flex-wrap gap-5 mx-5 mb-10">
                        <div class="basis-[90%] sm:basis-[45%] md:basis-[30%] lg:basis-[22%]">
                            <my-box-card :title="t('Total transfers')"
                                :number="myData.stats.totalTransfersAmount"></my-box-card>
                        </div>
                        <div class="basis-[90%] sm:basis-[45%] md:basis-[30%] lg:basis-[22%]">
                            <my-box-card :title="t('Commissions collected')"
                                :number="myData.stats.totalCommissions"></my-box-card>
                        </div>
                    </div>

                    <div v-if="stateTrans.loading" class="flex justify-center items-center py-10">
                        <div>
                            <LoadingIcon />
                        </div>
                    </div>
                    <div v-else-if="stateTrans.error" class="flex justify-center flex-col gap-4 items-center py-10">
                        <div class="text-[16px]/8 text-red-500 font-bold!">
                            <span v-if="locale == 'ar'"> {{ $t(stateTrans.msg.ar) }} </span>
                            <span v-else> {{ $t(stateTrans.msg.en) }} </span>
                        </div>
                        <div class="flex justify-center">
                            <button
                                class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                @click="getMyTrans">
                                {{ $t("Refresh") }}
                            </button>
                        </div>
                    </div>

                    <div v-else class="pb-10">

                        <div class="my-10">
                            <div class="mx-5 overflow-auto">

                                <table class="bg-box-green-2">
                                    <thead>
                                        <tr>
                                            <th
                                                class="text-[#343333] text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 ">
                                                {{ $t("State") }}
                                            </th>
                                            <th
                                                class="text-[#343333] text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 ">
                                                {{ $t("The network") }}
                                            </th>
                                            <th
                                                class="text-[#343333] w-26 text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 ">
                                                {{ $t("Commission") }}
                                            </th>

                                            <!--  -->
                                            <th class="text-[#343333] w-40 text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ $t("SYP Amount") }}
                                            </th>
                                            <th class="text-[#343333] w-40 text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ $t("USD Amount") }}
                                            </th>
                                            <th class="text-[#343333] w-60 text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ $t("User") }}
                                            </th>
                                            <th class="text-[#343333] w-38 text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ $t("Date and time") }}
                                            </th>
                                            <!-- <th class="text-[#343333] text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                            :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                            {{ $t("Type of operation") }}
                                        </th> -->
                                            <th class="text-[#343333] text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ $t("ID") }}
                                            </th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr v-for="item in transPaid" :key="item._id">
                                            <td
                                                class="text-black text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 ">
                                                {{ $t(item.status) }}
                                            </td>
                                            <td
                                                class="text-black text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 ">
                                                {{ item.network }}
                                            </td>
                                            <td
                                                class="text-black w-26 text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 ">
                                                {{ item.fee }}%
                                            </td>

                                            <!--  -->
                                            <td class="text-black w-40 text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ item.paid * item.rate }}
                                            </td>
                                            <td class="text-black w-40 text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ item.paid }}
                                            </td>
                                            <td class="text-black w-60 text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ item.sender.name }} {{ item.sender.fatherName }}
                                                {{ item.sender.nickname }}
                                            </td>
                                            <td class="text-black w-38 text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ item.createdAt.split('T')[0] }}
                                            </td>
                                            <!-- <td class="text-black text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                            :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                            {{ item.status }}
                                        </td> -->
                                            <td class="text-black text-[10px]/5 sm:text-[12px]/8 font-bold! px-2 text-center whitespace-nowrap py-2 border-black"
                                                :class="{ 'border-r-2': locale == 'ar', 'border-l-2': locale == 'en' }">
                                                {{ item.transferNumber }}
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                            </div>

                        </div>

                        <div class="flex justify-center px-2 my-5">
                            <UPagination v-model:page="page" :total="totalPages * 10"
                                :class="{ 'en-dir': locale == 'ar' }" />
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
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const state = ref({
    loading: true,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateTrans = ref({
    loading: true,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const myData = ref(null);
const transPaid = ref(null);

onMounted(() => {
    getAllInfo();
});

async function getAllInfo() {

    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    getAllData().then(res => {
        if (res) {
            myData.value = res;
        }
    }).then(() => {
        getTransPaidInDay().then(res => {
            if (res) {
                transPaid.value = res.transfers;
                totalPages.value = Math.ceil(res.transfersCount / 10);
            }
        }).then(() => {
            state.value.loading = false;
            stateTrans.value.loading = false;
        });
    });
}

async function getAllData() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/accounting/daily-restrictions`;

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

const page = ref(1);
const totalPages = ref(1);

function getMyTrans() {

    // Change state loading to loading
    stateTrans.value.loading = true;

    // clean error state
    stateTrans.value.error = false;

    getTransPaidInDay().then(res => {
        if (res) {
            transPaid.value = res.transfers;
            totalPages.value = res.transfersCount;
        }
    }).then(() => {
        stateTrans.value.loading = false;
    });
}

async function getTransPaidInDay() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/accounting/daily-restrictions/transfers`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
            params: {
                pageNumber: page.value,
                pageSize: 10
            }
        });

        if (response.data.error) {
            stateTrans.value.error = true;
            stateTrans.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        return response.data.data;
    }
    catch (error) {
        stateTrans.value.loading = false;
        stateTrans.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateTrans.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

watch(
    () => page.value,
    () => {
        getMyTrans();
    }
)
</script>