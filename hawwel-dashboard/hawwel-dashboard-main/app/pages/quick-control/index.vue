<template>

    <ClientOnly>
        <div>
            <use-toast v-if="stateEditTrans.error" head="Failed"
                :body="locale == 'en' ? stateEditTrans.msg.en : stateEditTrans.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditTrans.success" head="Success"
                :body="locale == 'en' ? stateEditTrans.msg.en : stateEditTrans.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateEditMain.error" head="Failed"
                :body="locale == 'en' ? stateEditMain.msg.en : stateEditMain.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditMain.success" head="Success"
                :body="locale == 'en' ? stateEditMain.msg.en : stateEditMain.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateEditRate.error" head="Failed"
                :body="locale == 'en' ? stateEditRate.msg.en : stateEditRate.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditRate.success" head="Success"
                :body="locale == 'en' ? stateEditRate.msg.en : stateEditRate.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateEditPay.error" head="Failed"
                :body="locale == 'en' ? stateEditPay.msg.en : stateEditPay.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditPay.success" head="Success"
                :body="locale == 'en' ? stateEditPay.msg.en : stateEditPay.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateDeletePay.error" head="Failed"
                :body="locale == 'en' ? stateDeletePay.msg.en : stateDeletePay.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateDeletePay.success" head="Success"
                :body="locale == 'en' ? stateDeletePay.msg.en : stateDeletePay.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

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
                        <!-- content -->
                        <div v-else class="pb-10">
                            <div class="bg-box-green quick-card quick-card-compact mb-10">
                                <div class="flex justify-between items-center gap-20 mb-2 px-5">
                                    <div class="text-black sm:text-[16px]/8 text-[12px]/6 font-bold!">
                                        {{ $t('stopSendingOperations') }}
                                    </div>
                                    <div class="en-dir">
                                        <USwitch :loading="stateEditTrans.loading"
                                            :model-value="systemSettings.isTransferDisabled"
                                            @update:model-value="editSystemSettings('trans')" :ui="{
                                                base: systemSettings.isTransferDisabled == true ? 'bg-[#C6C6C6]!' : 'bg-[#B7B7B7]!',
                                                thumb: systemSettings.isTransferDisabled == true ? 'bg-[#F5F5F5]!' : 'bg-[#999696]!',
                                            }" />
                                    </div>
                                </div>

                                <div class="border-b border-black w-full mb-2"></div>

                                <div class="flex justify-between items-center gap-20 px-5">
                                    <div class="flex flex-col">
                                        <div class="text-black sm:text-[16px]/8 text-[12px]/6 font-bold!">
                                            {{ $t('maintenanceMode') }}
                                        </div>
                                        <div class="text-[#F6F6F6] sm:text-[12px]/8 text-[10px]/5">
                                            {{ $t('maintenanceDescription') }}
                                        </div>
                                    </div>
                                    <div class="en-dir">
                                        <USwitch :loading="stateEditMain.loading"
                                            v-model="systemSettings.isMaintenanceMode"
                                            @update:model-value="editSystemSettings('main')" :ui="{
                                                base: systemSettings.isMaintenanceMode == true ? 'bg-[#C6C6C6]!' : 'bg-[#B7B7B7]!',
                                                thumb: systemSettings.isMaintenanceMode == true ? 'bg-[#F5F5F5]!' : 'bg-[#999696]!',
                                            }" />
                                    </div>
                                </div>
                            </div>

                            <!-- second box -->
                            <form @submit.prevent="editRate" class="bg-box-green quick-card quick-card-compact mb-10">
                                <div class="text-black sm:text-[16px]/8 text-[12px]/6 font-bold! mb-4">
                                    {{ $t('editUSDTPrice') }}
                                </div>

                                <div class="mb-3">
                                    <div class="flex justify-between gap-5">
                                        <div
                                            class="border border-[#6B1F2A] rounded-2xl flex flex-row-reverse items-center sm:px-3 sm:py-2 px-2 py-1 gap-2">
                                            <div class="text-white font-bold! sm:text-[16px]/8 text-[12px]/6"> USDT
                                            </div>
                                            <div>
                                                <input type="number" v-model="exchangeRates.USDT"
                                                    class="p-1 w-20 text-black font-bold! sm:text-[16px]/8 text-[12px]/6" />
                                            </div>
                                        </div>

                                        <div
                                            class="border border-[#6B1F2A] rounded-2xl flex flex-row-reverse items-center sm:px-3 sm:py-2 px-2 py-1 gap-2">
                                            <div class="text-white font-bold! sm:text-[16px]/8 text-[12px]/6"> USDC
                                            </div>
                                            <div>
                                                <input type="number" v-model="exchangeRates.USDC"
                                                    class="p-1 w-20 text-black font-bold! sm:text-[16px]/8 text-[12px]/6" />
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex justify-center">
                                    <UButton type="submit" :loading="stateEditRate.loading"
                                        :disabled="stateEditRate.loading"
                                        class="bg-[#B9A779] sm:text-[13px]/8 text-[11px]/5 text-black px-4 py-1 rounded-2xl font-bold! w-fit cursor-pointer">
                                        {{ $t('saveEdit') }}
                                    </UButton>
                                </div>
                            </form>

                            <div v-if="paymentMethods.length > 0">
                                <div class="flex justify-center mb-2">
                                    <div class="sm:text-[16px]/8 text-[12px]/6 text-black font-bold!">
                                        {{ $t('editCommission') }}
                                    </div>
                                </div>
                                <!-- third box -->
                                <div class="bg-box-green quick-card mb-5">
                                    <div class="flex sm:gap-10 gap-5">
                                        <!-- first col -->
                                        <div class="flex flex-col gap-4">
                                            <!-- main table title -->
                                            <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                {{ $t('entity') }}
                                            </div>

                                            <div v-for="item in paymentMethods" :key="item._id"
                                                class="h-7 flex justify-center items-center">
                                                <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                    {{ locale == 'en' ? item.name.en : item.name.ar }}
                                                </div>
                                            </div>
                                        </div>

                                        <!-- second col -->
                                        <div class="flex flex-col gap-4 items-center">
                                            <!-- main table title -->
                                            <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                {{ $t('currentCommission') }}
                                            </div>

                                            <div v-for="item in paymentMethods" :key="item._id"
                                                class="h-7 flex justify-center items-center">
                                                <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                    {{ item.fee }}%
                                                </div>
                                            </div>

                                        </div>

                                        <!-- third col -->
                                        <div class="flex flex-col gap-4 items-center">
                                            <!-- main table title -->
                                            <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                {{ $t('actions') }}
                                            </div>

                                            <!-- Repeatable action buttons -->
                                            <div class="flex gap-2 items-center justify-center h-7"
                                                v-for="item in paymentMethods" :key="item._id">
                                                <!-- delete -->
                                                <button @click="showDeletePayModel(item)" class="cursor-pointer"
                                                    :title="$t('delete')">
                                                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                                                            fill="#FB0F0F" />
                                                    </svg>
                                                </button>

                                                <!-- edit -->
                                                <button @click="showEditPayModel(item)" class="cursor-pointer"
                                                    :title="$t('edit')">
                                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                            fill="black" />
                                                    </svg>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex justify-center my-3">
                                    <nuxt-link to="/payment-methods"
                                        class="text-blue-500 underline text-[14px]/5 font-bold!">
                                        {{ $t("See all payment methods") }}
                                    </nuxt-link>
                                </div>
                            </div>

                            <div v-else class="flex justify-center mx-3 my-10">
                                <div class="text-black text-[14px]/5 sm:text-[16px]/8 font-bold!">
                                    {{ $t("There are no payment methods yet") }}
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- navbar / slide menu -->
                    <MyNavbar></MyNavbar>

                </div>
            </div>

            <!-- modal for edit payment method -->
            <UModal v-model:open="openEditPay">
                <template #content>
                    <div class="bg-box-gray p-5 overflow-auto">
                        <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                            :class="{ 'flex-row-reverse': locale == 'ar' }">
                            <div class="text-black text-[16px]/8 font-bold!">
                                {{ $t('Edit commission rate') }}
                            </div>
                            <div>
                                <button @click="openEditPay = !openEditPay" class="cursor-pointer">
                                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                                </button>
                            </div>
                        </div>
                        <form @submit.prevent="editPay" :class="{ 'ar-dir': locale == 'ar' }">
                            <div class="flex flex-col gap-2 mb-5">
                                <label for="city-name" class="text-black font-bold! text-[14px]/8">
                                    {{ $t('Commission rate') }}
                                </label>
                                <input id="city-name" type="text" v-model="editPayData.fee" required
                                    class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                            </div>
                            <div class="flex justify-center">
                                <UButton type="submit" :loading="stateEditPay.loading" :disabled="stateEditPay.loading"
                                    class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                    {{ $t('Edit') }}
                                </UButton>
                            </div>
                        </form>
                    </div>
                </template>
            </UModal>

            <!-- modal for delete payment method -->
            <UModal v-model:open="openDeletePay">

                <template #content>

                    <div class="bg-box-gray p-5">

                        <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                            :class="{ 'flex-row-reverse': locale == 'ar' }">

                            <!-- title -->
                            <div class="text-black text-[16px]/8 font-bold!">
                                {{ $t("Delete payment method") }}
                            </div>

                            <!-- close icon -->
                            <div>
                                <button @click="openDeletePay = !openDeletePay" class="cursor-pointer">
                                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                                </button>
                            </div>

                        </div>

                        <form @submit.prevent="deletePay" :class="{ 'ar-dir': locale == 'ar' }">

                            <div class="flex flex-col gap-2 mb-5">
                                <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                                    {{ $t("Are you sure you want to delete this payment method?") }}
                                </div>
                            </div>

                            <div class="flex justify-center">
                                <UButton type="submit" :loading="stateDeletePay.loading"
                                    :disabled="stateDeletePay.loading"
                                    class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                    {{ $t("Delete") }}
                                </UButton>
                            </div>

                        </form>

                    </div>

                </template>
            </UModal>
        </div>
        <template #fallback>
            <div class="flex justify-center items-center min-h-screen">
                <LoadingIcon />
            </div>
        </template>
    </ClientOnly>

</template>


<script setup>
definePageMeta({
    ssr: false
})
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const editPayData = ref({
    fee: "",
    _id: ""
});

const deletePayData = ref({
    _id: ""
});

const openEditPay = ref(false);

function showEditPayModel(item) {
    editPayData.value.fee = item.fee;
    editPayData.value._id = item._id;
    openEditPay.value = true;
}

const openDeletePay = ref(false);

function showDeletePayModel(item) {
    deletePayData.value._id = item._id;
    openDeletePay.value = true;
}

const state = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEditPay = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateDeletePay = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const myDataInfo = ref(null);

const systemSettings = ref({
    isTransferDisabled: true,
    isMaintenanceMode: true
});

const exchangeRates = ref({
    USDT: 0,
    USDC: 0
});

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

    try {
        const res = await getControleInfo();
        if (!res) return;

        myDataInfo.value = res;
        systemSettings.value = {
            isTransferDisabled: res.systemSettings?.isTransferDisabled ?? false,
            isMaintenanceMode: res.systemSettings?.isMaintenanceMode ?? false
        };

        exchangeRates.value.USDT = 0;
        exchangeRates.value.USDC = 0;
        (res.exchangeRates || []).forEach(ele => {
            if (ele.baseSymbol == "USDT")
                exchangeRates.value.USDT = ele.rate;
            else if (ele.baseSymbol == "USDC")
                exchangeRates.value.USDC = ele.rate;
        });

        paymentMethods.value = res.paymentMethods || [];
    }
    finally {
        // always stop loader even if response shape is incomplete
        state.value.loading = false;
    }
}

async function getAllPaymentMethods() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/all-payment-methods-inside-the-page`;

    const myParams = {
        pageNumber: pagePay.value,
        pageSize: pageSize.value,
    }

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
            params: myParams
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

async function getControleInfo() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/quick-control/system-overview`;

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

const paymentMethods = ref([]);

const stateEditTrans = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEditMain = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

async function editSystemSettings(params) {

    let data = {
        isTransferDisabled: systemSettings.value.isTransferDisabled,
        isMaintenanceMode: systemSettings.value.isMaintenanceMode,
    };

    if (params == "trans") {
        data.isTransferDisabled = !data.isTransferDisabled;
        stateEditTrans.value = {
            loading: true,
            error: false,
            success: false,
            msg: {
                ar: "",
                en: ""
            }
        }
    }

    else {
        // data.isMaintenanceMode = !data.isMaintenanceMode;
        stateEditMain.value = {
            loading: true,
            error: false,
            success: false,
            msg: {
                ar: "",
                en: ""
            }
        }
    }


    const token = store.getToken;
    const apiUrl = `${BASE_URL}/quick-control/update-system-settings`;

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            if (params == "trans")
                stateEditTrans.value = {
                    loading: false,
                    error: true,
                    success: false,
                    msg: {
                        ar: response.data.msg.ar,
                        en: response.data.msg.en
                    }
                }
            else
                stateEditMain.value = {
                    loading: false,
                    error: true,
                    success: false,
                    msg: {
                        ar: response.data.msg.ar,
                        en: response.data.msg.en
                    }
                }
            return;
        }

        if (params == "trans")
            stateEditTrans.value = {
                loading: false,
                error: false,
                success: true,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
        else
            stateEditMain.value = {
                loading: false,
                error: false,
                success: true,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
        getAllInfo();
    }
    catch (error) {

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        if (params = "trans")
            stateEditTrans.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: errorMessage,
                    en: errorMessage
                }
            }
        else
            stateEditMain.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: errorMessage,
                    en: errorMessage
                }
            }
    }
}

const stateEditRate = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

async function editRate() {

    stateEditRate.value = {
        loading: true,
        error: false,
        success: false,
        msg: {
            ar: "",
            en: ""
        }
    }

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/exchange-rates/update`;

    let data = {
        USDT_RATE: exchangeRates.value.USDT,
        USDC_RATE: exchangeRates.value.USDC,
    };

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateEditRate.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
            return;
        }

        stateEditRate.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en
            }
        }
        getAllInfo();
    }
    catch (error) {

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditRate.value = {
            loading: false,
            error: true,
            success: false,
            msg: {
                ar: errorMessage,
                en: errorMessage
            }
        }
    }
}

async function editPay() {

    stateEditPay.value = {
        loading: true,
        error: false,
        success: false,
        msg: {
            ar: "",
            en: ""
        }
    }

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/update/${editPayData.value._id}`;

    let data = {
        fee: Number(editPayData.value.fee)
    };

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateEditPay.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
            return;
        }

        stateEditPay.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en
            }
        }
        getAllInfo();
        openEditPay.value = false;
    }
    catch (error) {

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditPay.value = {
            loading: false,
            error: true,
            success: false,
            msg: {
                ar: errorMessage,
                en: errorMessage
            }
        }
    }
}

async function deletePay() {

    stateDeletePay.value.loading = true;
    stateDeletePay.value.error = false;
    stateDeletePay.value.success = false;
    stateDeletePay.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/delete/${deletePayData.value._id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateDeletePay.value.loading = false;
            stateDeletePay.value.error = true;
            stateDeletePay.value.success = false;
            stateDeletePay.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateDeletePay.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getAllInfo();
        openDeletePay.value = false;
    }
    catch (error) {
        stateDeletePay.value.loading = false;
        stateDeletePay.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateDeletePay.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

</script>