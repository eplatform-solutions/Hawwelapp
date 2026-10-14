<template>
    <form @submit.prevent="submit" :class="{ 'ar-dir': locale == 'ar' }">

        <vue-tel-input ref="telInputRef" class="hidden!" />

        <div class="mb-5">

            <div class="flex justify-between items-center mb-1">
                <div class="text-black font-bold! text-[16px]/8">
                    {{ $t("Select country") }}
                </div>
                <button type="button" @click="showQuickAddCountry = !showQuickAddCountry"
                    class="text-[#008E79] text-[12px]/5 font-bold! cursor-pointer underline">
                    {{ $t("Add new country") }}
                </button>
            </div>

            <div v-if="showQuickAddCountry" class="bg-[#F5F5F5] p-3 rounded-xl mb-3">
                <GeoCountryQuickAddForm @success="onCountryQuickAdded" @error="(msg) => emit('error', msg)" />
            </div>

            <GeoCountrySelect v-model="country" :options="countryOptions" />

        </div>

        <div class="mb-5">

            <div class="flex justify-between items-center mb-1">
                <div class="text-black font-bold! text-[14px]/8">
                    {{ $t("Select city") }}
                </div>
                <button type="button" @click="showQuickAddCity = !showQuickAddCity" :disabled="country == ''"
                    class="text-[#008E79] text-[12px]/5 font-bold! cursor-pointer underline">
                    {{ $t("Add new city") }}
                </button>
            </div>

            <div v-if="showQuickAddCity && country != ''" class="bg-[#F5F5F5] p-3 rounded-xl mb-3">
                <GeoCityQuickAddForm :locked-country="country" @success="onCityQuickAdded"
                    @error="(msg) => emit('error', msg)" />
            </div>

            <div v-if="citiesLoading" class="flex justify-center">
                <LoadingIconSec />
            </div>
            <div v-else-if="citiesError" class="flex flex-col gap-2">
                <div class="text-red-500 text-[12px]/5">{{ $t("Something went wrong") }}</div>
                <div>
                    <button type="button" @click="fetchCities" class="text-blue-500 text-[12px]/8 underline cursor-pointer">
                        {{ $t("Refresh") }}
                    </button>
                </div>
            </div>
            <GeoCombobox v-else v-model="city" :items="cityItems" :placeholder="$t('Select city')"
                :search-placeholder="$t('Search by name')">
                <template #leading>
                    <span class="text-[22px] leading-none">🏙️</span>
                </template>
            </GeoCombobox>
        </div>

        <div class="mb-3">
            <label class="text-black font-bold! text-[14px]/8 block mb-1.5">{{ $t("Region name in arabic:") }}</label>
            <GeoTextField v-model="nameAr" />
        </div>

        <div class="mb-5">
            <label class="text-black font-bold! text-[14px]/8 block mb-1.5">{{ $t("Region name in english:") }}</label>
            <GeoTextField v-model="nameEn" />
        </div>

        <div class="mb-5">
            <div class="text-black font-bold! text-[14px]/8 mb-2">
                {{ $t("Select payment methods") }}
            </div>
            <GeoPaymentMethodMultiSelect v-model="paymentMethods" :region-id="props.mode == 'edit' ? regionId : null" />
        </div>

        <div class="flex justify-end">
            <UButton type="submit" :loading="loading" :disabled="loading"
                class="bg-[#0B7A68] hover:brightness-110 disabled:opacity-60 rounded-full cursor-pointer px-8 py-2 text-white font-bold!">
                {{ props.mode == 'edit' ? $t("Edit the region") : $t("Add the region") }}
            </UButton>
        </div>

    </form>
</template>

<script setup>
// Shared create/edit region form. Both the dedicated Regions page and the
// Countries & Cities page's embedded "add region" section use this instead
// of each hand-rolling their own copy - previously the two implementations
// had drifted (one validated, one didn't).
import { VueTelInput } from 'vue-tel-input'
import 'vue-tel-input/vue-tel-input.css'

const props = defineProps({
    mode: { type: String, required: true }, // 'create' | 'edit'
    regionId: { type: String, default: null },
    initialCountry: { type: String, default: '' },
    initialCity: { type: String, default: '' },
    initialNameAr: { type: String, default: '' },
    initialNameEn: { type: String, default: '' },
});

const emit = defineEmits(['success', 'error']);

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale } = useI18n();
const { telInputRef, initCountriesList, getCountryByCode } = useCountryDisplay();

const country = ref(props.initialCountry);
const city = ref(props.initialCity);
const nameAr = ref(props.initialNameAr);
const nameEn = ref(props.initialNameEn);
const paymentMethods = ref([]);
const loading = ref(false);

const countryOptions = ref([]);
const cities = ref([]);
const citiesLoading = ref(false);
const citiesError = ref(false);

const showQuickAddCountry = ref(false);
const showQuickAddCity = ref(false);

const cityItems = computed(() => cities.value.map((item) => ({
    value: item._id,
    label: locale.value == 'ar' ? item.name.ar : item.name.en,
})));

function handleUnauthorized(errorMessage) {
    if (errorMessage == "Unauthorized") {
        store.updateToken(null);
        router.push("/login");
    }
}

async function fetchCountries() {
    const token = store.getToken;
    try {
        const response = await axios.get(`${BASE_URL}/countries/all`, {
            headers: { 'Authorization': `Bearer ${token}` },
        });
        if (!response.data.error) {
            countryOptions.value = response.data.data.map((item) => {
                const display = getCountryByCode(item.code);
                return { _id: item._id, name: display?.name || item.code, iso2: item.code };
            });
        }
    } catch (error) {
        handleUnauthorized(handelErrorType(error));
    }
}

async function fetchCities() {
    if (!country.value) {
        cities.value = [];
        return;
    }
    citiesLoading.value = true;
    citiesError.value = false;
    const token = store.getToken;
    try {
        const response = await axios.get(`${BASE_URL}/cities/all-cities-inside-the-page`, {
            headers: { 'Authorization': `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 200, country: country.value },
        });
        citiesLoading.value = false;
        if (response.data.error) {
            citiesError.value = true;
        } else {
            cities.value = response.data.data.cities;
        }
    } catch (error) {
        citiesLoading.value = false;
        citiesError.value = true;
        handleUnauthorized(handelErrorType(error));
    }
}

watch(country, () => {
    city.value = '';
    fetchCities();
});

onMounted(async () => {
    initCountriesList();
    await fetchCountries();
    await fetchCities();
});

async function onCountryQuickAdded() {
    showQuickAddCountry.value = false;
    await fetchCountries();
}

async function onCityQuickAdded() {
    showQuickAddCity.value = false;
    await fetchCities();
}

function validate() {
    if (!city.value) return { ar: "يجب اختيار مدينة", en: "A city must be chosen" };
    if (!nameAr.value) return { ar: "يجب كتابة الاسم العربي للمنطقة", en: "The Arabic name of the region must be written." };
    if (!nameEn.value) return { ar: "يجب كتابة الاسم الانكليزي للمنطقة", en: "The english name of the region must be written" };
    return null;
}

async function submit() {
    const validationError = validate();
    if (validationError) {
        emit('error', validationError);
        return;
    }

    loading.value = true;
    const token = store.getToken;
    const payload = {
        city: city.value,
        name: { ar: nameAr.value, en: nameEn.value },
        // A region starts with no payment methods unless the admin picks
        // some explicitly - availability doesn't cascade down from the
        // city/country, since not every location actually has the same
        // agents/cash points available.
        paymentMethods: paymentMethods.value,
    };

    try {
        const response = props.mode === 'edit'
            ? await axios.put(`${BASE_URL}/regions/update/${props.regionId}`, payload, { headers: { 'Authorization': `Bearer ${token}` } })
            : await axios.post(`${BASE_URL}/regions/create`, payload, { headers: { 'Authorization': `Bearer ${token}` } });

        loading.value = false;

        if (response.data.error) {
            emit('error', response.data.msg);
            return;
        }

        emit('success', response.data.msg, response.data.data?._id);
    } catch (error) {
        loading.value = false;
        const errorMessage = handelErrorType(error);
        handleUnauthorized(errorMessage);
        emit('error', { ar: errorMessage, en: errorMessage });
    }
}
</script>
