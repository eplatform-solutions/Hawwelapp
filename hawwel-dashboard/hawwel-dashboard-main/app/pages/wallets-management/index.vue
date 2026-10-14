<template>

    <!-- <use-toast v-if="state.error" head="Error" :body="locale == 'en' ? state.msg.en : state.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast> -->

    <div>

        <use-toast v-if="stateCopy.active" head="Success"
            :body="locale == 'en' ? stateCopy.msg.en : stateCopy.msg.ar" color="success"
            icon="i-heroicons-check-badge-16-solid">
        </use-toast>

        <div class="lg:flex flex-container-fix" :class="{ 'flex-row-reverse': locale == 'en' }"
            style="display: -webkit-box !important;">

            <!-- navbar / slide menu -->
            <MyNavbar v-if="locale == 'en'"></MyNavbar>

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div class="mb-6 mx-5">
                    <div class="flex items-center justify-center gap-3 mb-4">
                        <div class="text-black text-[16px]/8 sm:text-[22px]/9 font-black!">
                            {{ $t('Main & Fee-Funding Wallet Balances') }}
                        </div>
                        <button @click="getWalletBalances" :disabled="balancesLoading"
                            class="cursor-pointer text-[12px]/5 sm:text-[14px]/7 font-bold! text-[#008E79] disabled:opacity-50">
                            {{ balancesLoading ? $t('Loading balance...') : $t('Refresh balances') }}
                        </button>
                    </div>

                    <div v-if="balancesError" class="flex justify-center mb-4">
                        <div class="text-red-500 text-[12px]/5 sm:text-[14px]/7 font-bold!">
                            {{ $t('Balance unavailable') }}
                        </div>
                    </div>

                    <div class="flex flex-wrap justify-center items-start gap-6">

                        <div v-if="centralBalances.length > 0" class="overflow-auto max-w-full">
                            <div class="text-center text-black text-[13px]/6 sm:text-[16px]/8 font-bold! mb-2">
                                {{ $t('Main Wallet Addresses') }}
                            </div>
                            <table class="bg-white rounded-xl overflow-hidden mx-auto shadow-sm">
                                <thead>
                                    <tr class="bg-box-green">
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Currency Name") }}
                                        </th>
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Network") }}
                                        </th>
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Balance") }}
                                        </th>
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Wallet Address") }}
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in centralBalances" :key="item.walletId" class="border-b border-black/10 last:border-0">
                                        <td class="text-[20px]/8 sm:text-[30px]/10 font-black! text-black text-center px-6 py-3 whitespace-nowrap">
                                            {{ item.asset }}
                                        </td>
                                        <td class="text-[12px]/5 sm:text-[14px]/7 font-bold! text-black text-center px-5 py-3 whitespace-nowrap">
                                            {{ item.network }}
                                        </td>
                                        <td class="text-[20px]/8 sm:text-[30px]/10 font-black! text-center px-6 py-3 whitespace-nowrap"
                                            :class="item.error ? 'text-red-500' : 'text-[#008E79]'">
                                            <span v-if="item.error" class="text-[13px]/6 sm:text-[16px]/8">{{ $t('Balance unavailable') }}</span>
                                            <span v-else>{{ formatBalance(item.balance) }}</span>
                                        </td>
                                        <td class="text-center px-5 py-3">
                                            <button @click="copyToClipboard(item.address)"
                                                class="underline text-[11px]/5 sm:text-[12px]/6 font-bold! text-black cursor-pointer en-dir">
                                                {{ item.address }}
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div v-if="fundingBalances.length > 0" class="overflow-auto max-w-full">
                            <div class="text-center text-black text-[13px]/6 sm:text-[16px]/8 font-bold! mb-2">
                                {{ $t('Network Fee Funding Blockchain Wallet Addresses') }}
                            </div>
                            <table class="bg-white rounded-xl overflow-hidden mx-auto shadow-sm">
                                <thead>
                                    <tr class="bg-box-green">
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Currency Name") }}
                                        </th>
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Network") }}
                                        </th>
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Balance") }}
                                        </th>
                                        <th class="text-black text-[12px]/5 sm:text-[14px]/7 font-bold! text-center px-5 py-2 whitespace-nowrap">
                                            {{ $t("Wallet Address") }}
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in fundingBalances" :key="item.walletId" class="border-b border-black/10 last:border-0">
                                        <td class="text-[20px]/8 sm:text-[30px]/10 font-black! text-black text-center px-6 py-3 whitespace-nowrap">
                                            {{ item.asset }}
                                        </td>
                                        <td class="text-[12px]/5 sm:text-[14px]/7 font-bold! text-black text-center px-5 py-3 whitespace-nowrap">
                                            {{ item.network }}
                                        </td>
                                        <td class="text-[20px]/8 sm:text-[30px]/10 font-black! text-center px-6 py-3 whitespace-nowrap"
                                            :class="item.error ? 'text-red-500' : 'text-[#008E79]'">
                                            <span v-if="item.error" class="text-[13px]/6 sm:text-[16px]/8">{{ $t('Balance unavailable') }}</span>
                                            <span v-else>{{ formatBalance(item.balance) }}</span>
                                        </td>
                                        <td class="text-center px-5 py-3">
                                            <button @click="copyToClipboard(item.address)"
                                                class="underline text-[11px]/5 sm:text-[12px]/6 font-bold! text-black cursor-pointer en-dir">
                                                {{ item.address }}
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>

                <div class="mb-6 mx-5">
                    <div class="text-black text-[16px]/8 sm:text-[22px]/9 font-black! text-center mb-4">
                        {{ $t('Client Wallets & Withdraw Status') }}
                    </div>

                    <div class="bg-white rounded-2xl shadow-sm p-4 sm:p-5">
                        <div class="flex flex-wrap justify-center gap-3 sm:gap-4">

                            <input type="text" v-model="search.text" :placeholder="$t('Search')"
                                class="wm-filter-input">

                            <select v-model="search.withdrawStatus" class="wm-filter-input">
                                <option disabled selected value="">
                                    {{ $t("Withdraw status") }}
                                </option>
                                <option value="">
                                    {{ $t("All status") }}
                                </option>
                                <option value="pending">
                                    {{ $t("pending") }}
                                </option>
                                <option value="success">
                                    {{ $t("Success") }}
                                </option>
                                <option value="failed">
                                    {{ $t("Failed") }}
                                </option>
                            </select>

                            <select v-model="search.network" class="wm-filter-input">
                                <option value="">
                                    {{ $t("All networks") }}
                                </option>
                                <option value="BSC">
                                    {{ $t("BSC") }}
                                </option>
                                <option value="MATIC">
                                    {{ $t("MATIC") }}
                                </option>
                            </select>

                            <input type="text" v-model="search.address" :placeholder="$t('Type Wallet Address')"
                                class="wm-filter-input">

                            <input type="number" v-model="search.transferNumber"
                                :placeholder="$t('Type Reference Order Number')"
                                class="wm-filter-input">

                            <button @click="page = 1; getAllInfo()" class="brand-btn cursor-pointer text-[12px]/5 sm:text-[14px]/7 px-6">
                                {{ $t("Filter") }}
                            </button>

                        </div>
                    </div>
                </div>

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
                <div v-else-if="filteredWallets.length == 0 && wallets.length > 0" class="flex justify-center my-5 font-bold! text-[14px]/6">
                    {{ $t("No results found") }}
                </div>
                <!-- boxes -->
                <div v-else class="mx-5">
                    <div class="overflow-x-auto">

                        <table class="w-full bg-white rounded-xl overflow-hidden shadow-sm">

                            <thead>
                                <tr class="bg-box-green">
                                    <th class="wm-th wm-th-tight">{{ $t("Currency Name") }}</th>
                                    <th class="wm-th wm-th-tight">{{ $t("Network") }}</th>
                                    <th class="wm-th">{{ $t("Wallet Address") }}</th>
                                    <th class="wm-th">{{ $t("Private Key") }}</th>
                                    <th class="wm-th wm-th-tight">{{ $t("Withdraw status") }}</th>
                                    <th class="wm-th">{{ $t("Reference Order Number") }}</th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr v-for="item in filteredWallets" :key="item._id"
                                    class="border-b border-black/8 last:border-0 hover:bg-black/[0.03] transition-colors">
                                    <td class="wm-td wm-td-tight">
                                        <span class="wm-currency-badge">{{ item.transfer.symbol }}</span>
                                    </td>
                                    <td class="wm-td wm-td-tight font-bold! text-black">
                                        {{ item.network }}
                                    </td>
                                    <td class="wm-td">
                                        <button @click="copyToClipboard(item.address)" :title="item.address"
                                            class="wm-copy-btn en-dir">
                                            {{ item.address }}
                                            <UIcon name="i-heroicons-clipboard-document" class="size-3.5 shrink-0" />
                                        </button>
                                    </td>
                                    <td class="wm-td">
                                        <button @click="copyToClipboard(item.privateKey)" :title="item.privateKey"
                                            class="wm-copy-btn en-dir">
                                            {{ item.privateKey }}
                                            <UIcon name="i-heroicons-clipboard-document" class="size-3.5 shrink-0" />
                                        </button>
                                    </td>
                                    <td class="wm-td wm-td-tight">
                                        <div class="flex flex-col items-center gap-1">
                                            <span class="transfer-status-pill wm-status-pill" :style="{ background: withdrawStatusColor(item.withdrawStatus) }">
                                                <span class="dot"></span>{{ $t(item.withdrawStatus) }}
                                            </span>
                                            <button v-if="item.withdrawStatus == 'failed'" @click="ShowWhyFailedModel(item)"
                                                class="text-red-500 hover:text-red-700 text-[12px]/5 sm:text-[13px]/6 cursor-pointer font-bold! underline duration-200">
                                                {{ $t("See why") }}
                                            </button>
                                        </div>
                                    </td>
                                    <td class="wm-td font-black! text-[#008E79] text-[16px]/6 sm:text-[19px]/8">
                                        {{ item.transfer.transferNumber }}
                                    </td>
                                </tr>
                            </tbody>

                        </table>
                    </div>

                    <div class="py-8 flex flex-col items-center gap-2" :class="{ 'en-dir': locale == 'ar' }">
                        <div class="text-black/60 text-[11px]/5 sm:text-[12px]/6 font-bold!">
                            {{ filteredWallets.length }} / {{ totalPages * 10 }} {{ $t("results") }}
                        </div>
                        <UPagination v-model:page="page" :total="totalPages * 10" />
                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar v-if="locale == 'ar'"></MyNavbar>

        </div>

    </div>

    <!-- modal for show logo -->
    <UModal v-model:open="openModel">

        <template #content>

            <div class="bg-box-gray p-5">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Withdraw Failed Reason") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openModel = !openModel" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <div class="">
                    <div
                        class="text-center text-red-500 font-bold! text-[14px]/5 sm:text-[16px]/8 mb-3 border-b border-dashed border-black pb-1">
                        {{ $t(myReasonData.withdrawFailedReason) }}
                    </div>
                    <div class="text-center text-black font-bold! text-[14px]/5 sm:text-[16px]/8 mb-1">
                        {{ $t("Server error during withdrawal") }}
                    </div>
                    <div class="text-center text-red-500 font-bold! text-[14px]/5 sm:text-[16px]/8 mb-3">
                        {{ myReasonData.withdrawServerError }}
                    </div>
                </div>

            </div>

        </template>
    </UModal>

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
    loading: false,
    error: false,
    msg: ""
});

onMounted(() => {
    getAllInfo();
    getWalletBalances();
});

const balances = ref([]);
const balancesLoading = ref(false);
const balancesError = ref(false);

const centralBalances = computed(() => balances.value.filter((b) => b.type === 'central'));
const fundingBalances = computed(() => balances.value.filter((b) => b.type === 'network-fee-funding'));

const formatBalance = (balance) => Number(balance || 0).toFixed(4);

const WITHDRAW_STATUS_COLORS = {
    pending: '#F59E0B',
    success: '#097F6E',
    failed: '#DC2626',
};
const withdrawStatusColor = (status) => WITHDRAW_STATUS_COLORS[status] || '#6B7280';

// Real on-chain RPC calls per wallet - slower and more likely to fail
// transiently than the rest of the page's data, so it's fetched and
// refreshed independently instead of blocking the client-wallets table.
async function getWalletBalances() {
    balancesLoading.value = true;
    balancesError.value = false;

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/quick-control/wallet-balances`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            balancesError.value = true;
            return;
        }

        balances.value = response.data.data.balances || [];
    }
    catch (error) {
        balancesError.value = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }
    }
    finally {
        balancesLoading.value = false;
    }
}

const stateCopy = ref({
    active: false,
    msg: {
        ar: "تم نسخ عنوان المحفظة إلى الحافظة",
        en: "Wallet address copyed to clipboard"
    }
});
const copyToClipboard = async (text) => {
    stateCopy.value.active = false;
    navigator.clipboard.writeText(text);
    await nextTick();
    stateCopy.value.active = true;
}

const search = ref({
    text: "",
    symbol: "",
    network: "",
    address: "",
    status: "",
    transferNumber: "",
    amount: "",
    paid: "",
    withdrawStatus: ""
});

const wallets = ref([]);
const filteredWallets = ref([])
const page = ref(1);
const totalPages = ref(1);
const pageSize = ref(10);

async function getAllInfo() {
    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    state.value.msg = {
        ar: "",
        en: ""
    };
    getAllWallets().then(res => {
        if (res) {
            wallets.value = res.wallets;
            filteredWallets.value = res.wallets;
            totalPages.value = Math.ceil(res.walletsCount / 10);
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllWallets() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/blockchain-wallets/clients/all-inside-the-page`;

    let myParams = {
        pageNumber: page.value,
        pageSize: pageSize.value,
    }

    if (search.value.symbol != "")
        myParams.symbol = search.value.symbol;
    if (search.value.network != "")
        myParams.network = search.value.network;
    if (search.value.address != "")
        myParams.address = search.value.address;
    if (search.value.status != "")
        myParams.status = search.value.status;
    if (search.value.transferNumber != "")
        myParams.transferNumber = search.value.transferNumber;
    if (search.value.amount != "")
        myParams.amount = search.value.amount;
    if (search.value.paid != "")
        myParams.paid = search.value.paid;
    if (search.value.withdrawStatus != "")
        myParams.withdrawStatus = search.value.withdrawStatus;

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

const openModel = ref(false);
const myReasonData = ref(null);

function ShowWhyFailedModel(item) {
    myReasonData.value = item;
    openModel.value = true;
}

watch(
    () => page.value,
    () => {
        getAllInfo();
    }
)

const getRowDisplayText = (item) => {
    const texts = [];
    
    texts.push(item.transfer?.symbol || '');
    texts.push(item.network || '');
    texts.push(item.address || '');
    texts.push(item.privateKey || '');
    texts.push(item.transfer?.transferNumber?.toString() || '');
    
    if (item.withdrawStatus) {
        texts.push(item.withdrawStatus);
        
        const translated = t(item.withdrawStatus);
        if (translated && translated !== item.withdrawStatus) {
            texts.push(translated);
        }
        
        if (item.withdrawStatus === 'failed') {
            texts.push(t('See why'));
        }
    }
    
    return texts;
};

const filterWallets = () => {
    const searchText = search.value.text.toLowerCase().trim();

    if (!searchText) {
        filteredWallets.value = wallets.value;
        return;
    }

    filteredWallets.value = wallets.value.filter(item => {
        const displayTexts = getRowDisplayText(item);
        
        return displayTexts.some(text => 
            text.toLowerCase().includes(searchText)
        );
    });
};

watch(
    () => search.value.text,
    () => {
        filterWallets();
    }
);

watch(
    () => locale.value,
    () => {
        filterWallets(); 
    }
);

</script>