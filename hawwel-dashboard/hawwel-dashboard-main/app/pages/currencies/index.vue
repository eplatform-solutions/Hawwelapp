<template>
    <div>
        <use-toast v-if="stateAction.error" head="Failed" :body="locale == 'en' ? stateAction.msg.en : stateAction.msg.ar"
            color="error" icon="i-heroicons-exclamation-circle-16-solid" />
        <use-toast v-if="stateAction.success" head="Success" :body="locale == 'en' ? stateAction.msg.en : stateAction.msg.ar"
            color="success" icon="i-heroicons-check-badge-16-solid" />

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">
            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">
                <HeaderPage />

                <div class="mb-4 px-5 flex justify-between items-center" :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black sm:text-[20px]/8 text-[14px]/6 font-bold!">
                        {{ $t("currenciesRates") }}
                    </div>
                    <button @click="openAddModal"
                        class="bg-[#B9A779] text-black sm:text-[16px]/8 text-[12px]/5 px-3 py-1 rounded-full font-bold! cursor-pointer">
                        {{ $t("Add currency") }}
                    </button>
                </div>

                <div v-if="state.loading" class="flex justify-center items-center py-10">
                    <LoadingIcon />
                </div>

                <div v-else-if="state.error" class="flex justify-center flex-col gap-4 items-center py-10">
                    <div class="text-[16px]/8 text-red-500 font-bold!">
                        {{ locale == 'ar' ? $t(state.msg.ar) : $t(state.msg.en) }}
                    </div>
                    <button class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                        @click="getAllCurrencies">
                        {{ $t("Refresh") }}
                    </button>
                </div>

                <div v-else class="pb-10">
                    <div v-if="currencies.length === 0" class="flex justify-center my-8">
                        <div class="text-black text-[14px]/5 sm:text-[16px]/8 font-bold!">
                            {{ $t("There are no currencies yet") }}
                        </div>
                    </div>
                    <div v-else class="flex justify-center px-3 sm:px-5">
                        <div class="overflow-auto w-full max-w-6xl">
                            <table class="bg-white w-full min-w-[760px]">
                                <thead>
                                    <tr class="border-b">
                                        <th class="min-w-[120px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ $t("Code") }}</th>
                                        <th class="min-w-[220px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ $t("Name") }}</th>
                                        <th class="min-w-[150px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ $t("Price per USDT") }}</th>
                                        <th class="min-w-[150px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ $t("Price per USDC") }}</th>
                                        <th class="min-w-[120px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ $t("actions") }}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(item, index) in currencies" :key="item._id"
                                        :class="{ 'border-b': index + 1 != currencies.length }">
                                        <td class="min-w-[120px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ item.code }}</td>
                                        <td class="min-w-[220px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ item.name || "-" }}</td>
                                        <td class="min-w-[150px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ item.usdtRate }}</td>
                                        <td class="min-w-[150px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">{{ item.usdcRate }}</td>
                                        <td class="min-w-[120px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3">
                                            <div class="flex gap-2 justify-center">
                                                <button class="cursor-pointer" @click="openEditModal(item)">{{ $t("edit") }}</button>
                                                <button class="cursor-pointer text-red-500" @click="openDeleteModal(item)">{{ $t("delete") }}</button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <MyNavbar />
        </div>

        <UModal v-model:open="openAdd">
            <template #content>
                <div class="bg-box-gray p-5 overflow-auto">
                    <form @submit.prevent="createCurrency" :class="{ 'ar-dir': locale == 'ar' }">
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Code") }}</label>
                            <USelectMenu v-model="selectedNewCurrency" :items="currencyOptions" searchable
                                value-key="value" label-key="label" class="w-full"
                                :search-input="{ placeholder: $t('Search currency') }"
                                placeholder="اختر رمز العملة ISO"
                                @update:model-value="handleNewCurrencySelect" />
                        </div>
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Name") }}</label>
                            <input type="text" v-model="newCurrency.name" readonly
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                        </div>
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Price per USDT") }}</label>
                            <input type="number" min="0.00000001" step="any" v-model="newCurrency.usdtRate" required
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                        </div>
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Price per USDC") }}</label>
                            <input type="number" min="0.00000001" step="any" v-model="newCurrency.usdcRate" required
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                        </div>
                        <div class="flex justify-center mt-4">
                            <UButton type="submit" :loading="stateAction.loading" :disabled="stateAction.loading"
                                class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                {{ $t("add") }}
                            </UButton>
                        </div>
                    </form>
                </div>
            </template>
        </UModal>

        <UModal v-model:open="openEdit">
            <template #content>
                <div class="bg-box-gray p-5 overflow-auto">
                    <form @submit.prevent="updateCurrency" :class="{ 'ar-dir': locale == 'ar' }">
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Code") }}</label>
                            <USelectMenu v-model="selectedEditCurrency" :items="currencyOptions" searchable
                                value-key="value" label-key="label" class="w-full"
                                :search-input="{ placeholder: $t('Search currency') }"
                                placeholder="اختر رمز العملة ISO"
                                @update:model-value="handleEditCurrencySelect" />
                        </div>
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Name") }}</label>
                            <input type="text" v-model="editCurrency.name" readonly
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                        </div>
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Price per USDT") }}</label>
                            <input type="number" min="0.00000001" step="any" v-model="editCurrency.usdtRate" required
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                        </div>
                        <div class="flex flex-col gap-2 mb-3">
                            <label class="text-black font-bold! text-[14px]/8">{{ $t("Price per USDC") }}</label>
                            <input type="number" min="0.00000001" step="any" v-model="editCurrency.usdcRate" required
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                        </div>
                        <div class="flex justify-center mt-4">
                            <UButton type="submit" :loading="stateAction.loading" :disabled="stateAction.loading"
                                class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                {{ $t("Edit") }}
                            </UButton>
                        </div>
                    </form>
                </div>
            </template>
        </UModal>

        <UModal v-model:open="openDelete">
            <template #content>
                <div class="bg-box-gray p-5">
                    <div class="text-red-500 font-bold! text-[20px]/8 text-center mb-5">
                        {{ $t("Are you sure you want delete this currency?") }}
                    </div>
                    <div class="flex justify-center">
                        <UButton @click="deleteCurrency" :loading="stateAction.loading" :disabled="stateAction.loading"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t("delete") }}
                        </UButton>
                    </div>
                </div>
            </template>
        </UModal>
    </div>
</template>

<script setup>
const { axios, router, store, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale, setLocale } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const state = ref({
    loading: false,
    error: false,
    msg: { en: "", ar: "" },
});
const stateAction = ref({
    loading: false,
    error: false,
    success: false,
    msg: { en: "", ar: "" },
});

const currencies = ref([]);
const openAdd = ref(false);
const openEdit = ref(false);
const openDelete = ref(false);
const deleteId = ref("");
const currencyOptions = ref([]);
const selectedNewCurrency = ref(null);
const selectedEditCurrency = ref(null);

const newCurrency = ref({ code: "", name: "", usdtRate: 1, usdcRate: 1 });
const editCurrency = ref({ _id: "", code: "", name: "", usdtRate: 1, usdcRate: 1 });

onMounted(() => {
    getAllCurrencies();
    buildCurrencyOptions();
});

function normalizeFormData(data) {
    return {
        code: String(data.code || "").trim().toUpperCase(),
        name: String(data.name || "").trim(),
        usdtRate: Number(data.usdtRate),
        usdcRate: Number(data.usdcRate),
    };
}

async function getAllCurrencies() {
    state.value.loading = true;
    state.value.error = false;
    state.value.msg = { en: "", ar: "" };
    const token = store.getToken;
    try {
        const response = await axios.get(`${BASE_URL}/currencies/all`, {
            headers: { Authorization: `Bearer ${token}` },
        });
        if (response.data.error) {
            state.value.error = true;
            state.value.msg = { ar: response.data.msg.ar, en: response.data.msg.en };
            return;
        }
        currencies.value = response.data.data || [];
    } catch (error) {
        state.value.error = true;
        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }
        state.value.msg = { ar: errorMessage, en: errorMessage };
    } finally {
        state.value.loading = false;
    }
}

function resetActionState() {
    stateAction.value = { loading: true, error: false, success: false, msg: { en: "", ar: "" } };
}

function applyActionError(errorMessage) {
    stateAction.value.loading = false;
    stateAction.value.error = true;
    stateAction.value.msg = { ar: errorMessage, en: errorMessage };
}

async function createCurrency() {
    resetActionState();
    const token = store.getToken;
    const payload = normalizeFormData(newCurrency.value);
    try {
        const response = await axios.post(`${BASE_URL}/currencies/create`, payload, {
            headers: { Authorization: `Bearer ${token}` },
        });
        if (response.data.error) {
            stateAction.value.loading = false;
            stateAction.value.error = true;
            stateAction.value.msg = { ar: response.data.msg.ar, en: response.data.msg.en };
            return;
        }
        stateAction.value.loading = false;
        stateAction.value.success = true;
        stateAction.value.msg = { ar: response.data.msg.ar, en: response.data.msg.en };
        openAdd.value = false;
        await getAllCurrencies();
    } catch (error) {
        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }
        applyActionError(errorMessage);
    }
}

async function updateCurrency() {
    resetActionState();
    const token = store.getToken;
    const payload = normalizeFormData(editCurrency.value);
    try {
        const response = await axios.put(`${BASE_URL}/currencies/update/${editCurrency.value._id}`, payload, {
            headers: { Authorization: `Bearer ${token}` },
        });
        if (response.data.error) {
            stateAction.value.loading = false;
            stateAction.value.error = true;
            stateAction.value.msg = { ar: response.data.msg.ar, en: response.data.msg.en };
            return;
        }
        stateAction.value.loading = false;
        stateAction.value.success = true;
        stateAction.value.msg = { ar: response.data.msg.ar, en: response.data.msg.en };
        openEdit.value = false;
        await getAllCurrencies();
    } catch (error) {
        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }
        applyActionError(errorMessage);
    }
}

async function deleteCurrency() {
    resetActionState();
    const token = store.getToken;
    try {
        const response = await axios.delete(`${BASE_URL}/currencies/delete/${deleteId.value}`, {
            headers: { Authorization: `Bearer ${token}` },
        });
        if (response.data.error) {
            stateAction.value.loading = false;
            stateAction.value.error = true;
            stateAction.value.msg = { ar: response.data.msg.ar, en: response.data.msg.en };
            return;
        }
        stateAction.value.loading = false;
        stateAction.value.success = true;
        stateAction.value.msg = { ar: response.data.msg.ar, en: response.data.msg.en };
        openDelete.value = false;
        await getAllCurrencies();
    } catch (error) {
        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }
        applyActionError(errorMessage);
    }
}

function openAddModal() {
    newCurrency.value = { code: "", name: "", usdtRate: 1, usdcRate: 1 };
    selectedNewCurrency.value = null;
    openAdd.value = true;
}

function openEditModal(item) {
    editCurrency.value = {
        _id: item._id,
        code: item.code,
        name: item.name || "",
        usdtRate: item.usdtRate,
        usdcRate: item.usdcRate,
    };
    selectedEditCurrency.value = currencyOptions.value.find(opt => opt.value === item.code) || {
        label: `${item.code} - ${item.name || item.code}`,
        value: item.code,
        arName: item.name || "",
    };
    openEdit.value = true;
}

function openDeleteModal(item) {
    deleteId.value = item._id;
    openDelete.value = true;
}

function buildCurrencyOptions() {
    try {
        const values = typeof Intl.supportedValuesOf === "function" ? Intl.supportedValuesOf("currency") : [];
        const displayAr = new Intl.DisplayNames(["ar"], { type: "currency" });
        const displayEn = new Intl.DisplayNames(["en"], { type: "currency" });
        currencyOptions.value = values.map(code => {
            const arName = displayAr.of(code) || code;
            const enName = displayEn.of(code) || code;
            return {
                label: `${code} - ${arName}`,
                value: code,
                arName,
                enName,
            };
        });
    } catch (_) {
        currencyOptions.value = [
            { label: "USD - دولار أمريكي", value: "USD", arName: "دولار أمريكي", enName: "US Dollar" },
            { label: "EUR - يورو", value: "EUR", arName: "يورو", enName: "Euro" },
            { label: "SYP - ليرة سورية", value: "SYP", arName: "ليرة سورية", enName: "Syrian Pound" },
        ];
    }
}

function handleNewCurrencySelect(item) {
    if (!item) return;
    const selected = typeof item === "string"
        ? currencyOptions.value.find(opt => opt.value === item)
        : item;
    if (!selected) return;
    newCurrency.value.code = selected.value;
    newCurrency.value.name = selected.arName || selected.label || selected.value;
}

function handleEditCurrencySelect(item) {
    if (!item) return;
    const selected = typeof item === "string"
        ? currencyOptions.value.find(opt => opt.value === item)
        : item;
    if (!selected) return;
    editCurrency.value.code = selected.value;
    editCurrency.value.name = selected.arName || selected.label || selected.value;
}
</script>
