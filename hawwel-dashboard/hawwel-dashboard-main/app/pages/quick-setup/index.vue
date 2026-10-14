<template>

    <use-toast v-if="banner.error" head="Failed" :body="locale == 'en' ? banner.msg.en : banner.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="banner.success" head="Success" :body="locale == 'en' ? banner.msg.en : banner.msg.ar"
        color="success" icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <div>
        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-coutnry min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />
                <vue-tel-input ref="telInputRef" class="hidden!" />

                <div class="mx-2 sm:mx-10 py-6">

                    <div class="mb-6">
                        <h1 class="text-[28px] sm:text-[34px] font-extrabold text-[#23200F]">{{ $t("Quick setup") }}</h1>
                        <p class="text-[16px] text-[#726A54] mt-1">
                            {{ $t("Set up a country, city, region, and payment method in one connected flow.") }}
                        </p>
                    </div>

                    <div class="bg-white border border-[#E3D9C1] rounded-3xl shadow-sm">

                        <!-- trail -->
                        <div class="flex items-center px-5 sm:px-8 pt-6 overflow-x-auto">
                            <template v-for="(label, i) in stepLabels" :key="i">
                                <div class="flex items-center gap-2.5 pb-5 text-[15px] font-bold! shrink-0"
                                    :class="i === step ? 'text-[#23200F]' : 'text-[#726A54]'">
                                    <span class="w-9 h-9 rounded-full flex items-center justify-center text-[14px] font-black mono shrink-0"
                                        :class="i < step ? 'bg-[#0B7A68]/20 text-[#075C4E]' : (i === step ? 'bg-[#0B7A68] text-white' : 'bg-[#EFE8D9] text-[#726A54]')">
                                        {{ i < step ? '✓' : i + 1 }}
                                    </span>
                                    <span>{{ label }}</span>
                                </div>
                                <div v-if="i < stepLabels.length - 1" class="flex-1 h-[3px] mx-3 mb-5 min-w-[24px]"
                                    :class="i < step ? 'bg-[#0B7A68]' : 'bg-[#E3D9C1]'"></div>
                            </template>
                        </div>

                        <!-- summary -->
                        <div v-if="summaryChips.length"
                            class="mx-5 sm:mx-8 mb-6 px-5 py-4 bg-[#F6F2E9] border border-[#E3D9C1] rounded-2xl flex flex-wrap items-center gap-2.5 text-[15px]">
                            <span class="text-[#726A54] font-bold!">{{ $t("Chain so far:") }}</span>
                            <template v-for="(chip, i) in summaryChips" :key="i">
                                <span class="bg-white border border-[#E3D9C1] rounded-full px-4 py-1.5 font-bold! text-[#23200F]">
                                    {{ chip }}
                                </span>
                                <span v-if="i < summaryChips.length - 1" class="text-[#726A54]">←</span>
                            </template>
                        </div>

                        <div class="px-5 sm:px-8 pb-7 max-w-2xl">

                            <!-- step: country -->
                            <div v-if="currentKey === 'country'">
                                <h2 class="text-[20px] font-extrabold mb-1.5">{{ $t("Select country") }}</h2>
                                <p class="text-[15px] text-[#726A54] mb-4">{{ $t("if it's not in the list yet.") }}</p>
                                <GeoCountrySelect v-model="countryId" :options="countryOptions" class="mb-3" />
                                <button type="button" class="text-[#008E79] text-[15px] font-bold! underline cursor-pointer"
                                    @click="showAddCountry = !showAddCountry">
                                    {{ $t("Add new country") }}
                                </button>
                                <div v-if="showAddCountry" class="bg-[#F6F2E9] border border-dashed border-[#E3D9C1] rounded-2xl p-4 mt-3">
                                    <GeoCountryQuickAddForm @success="onCountryCreated" @error="onError" />
                                </div>

                                <div v-if="countryId"
                                    class="flex items-center justify-between gap-3 bg-[#B9A779]/15 border border-[#B9A779]/40 rounded-2xl px-4 py-3.5 mt-6">
                                    <div class="text-[15px] font-bold!">
                                        {{ $t("This method works for the whole country") }}
                                        <span class="block text-[13.5px] font-medium! text-[#726A54] mt-0.5">
                                            {{ $t("Like Vodafone Cash in Egypt - no need to pick a city or region") }}
                                        </span>
                                    </div>
                                    <button type="button" role="switch" :aria-checked="wholeCountry"
                                        @click="wholeCountry = !wholeCountry"
                                        class="w-12 h-7 rounded-full relative shrink-0 transition-colors cursor-pointer"
                                        :class="wholeCountry ? 'bg-[#0B7A68]' : 'bg-[#E3D9C1]'">
                                        <span class="absolute top-[3px] w-[21px] h-[21px] bg-white rounded-full shadow transition-all"
                                            :class="wholeCountry ? 'right-[3px]' : 'right-[24px]'"></span>
                                    </button>
                                </div>
                            </div>

                            <!-- step: city -->
                            <div v-if="currentKey === 'city'">
                                <h2 class="text-[20px] font-extrabold mb-1.5">{{ $t("Select city") }}</h2>
                                <p class="text-[15px] text-[#726A54] mb-4">{{ countryLabel }}</p>
                                <div v-if="citiesLoading" class="flex justify-center py-4">
                                    <LoadingIconSec />
                                </div>
                                <GeoCombobox v-else v-model="cityId" :items="cityItems" :placeholder="$t('Select city')"
                                    :search-placeholder="$t('Search by name')" class="mb-3" />
                                <button type="button" class="text-[#008E79] text-[15px] font-bold! underline cursor-pointer"
                                    @click="showAddCity = !showAddCity">
                                    {{ $t("Add new city") }}
                                </button>
                                <div v-if="showAddCity" class="bg-[#F6F2E9] border border-dashed border-[#E3D9C1] rounded-2xl p-4 mt-3">
                                    <GeoCityQuickAddForm :locked-country="countryId" @success="onCityCreated" @error="onError" />
                                </div>
                            </div>

                            <!-- step: region -->
                            <div v-if="currentKey === 'region'">
                                <h2 class="text-[20px] font-extrabold mb-1.5">{{ $t("Select region") }}</h2>
                                <p class="text-[15px] text-[#726A54] mb-4">{{ cityLabel }}</p>
                                <div v-if="regionsLoading" class="flex justify-center py-4">
                                    <LoadingIconSec />
                                </div>
                                <GeoCombobox v-else v-model="regionId" :items="regionItems" :placeholder="$t('Select region')"
                                    :search-placeholder="$t('Search by name')" class="mb-3" />
                                <button type="button" class="text-[#008E79] text-[15px] font-bold! underline cursor-pointer"
                                    @click="showAddRegion = !showAddRegion">
                                    {{ $t("Add new region") }}
                                </button>
                                <div v-if="showAddRegion" class="bg-[#F6F2E9] border border-dashed border-[#E3D9C1] rounded-2xl p-4 mt-3">
                                    <GeoRegionQuickAddForm :locked-city="cityId" @success="onRegionCreated" @error="onError" />
                                </div>
                            </div>

                            <!-- step: payment method -->
                            <div v-if="currentKey === 'payment'">
                                <h2 class="text-[20px] font-extrabold mb-1.5">{{ $t("Select payment methods") }}</h2>
                                <p class="text-[15px] text-[#726A54] mb-4">
                                    {{ $t("Will be linked directly to") }} {{ wholeCountry ? countryLabel : regionLabel }}
                                </p>
                                <GeoPaymentMethodMultiSelect v-model="paymentMethodIds"
                                    :region-id="wholeCountry ? null : regionId" class="mb-3" />
                                <button type="button" class="text-[#008E79] text-[15px] font-bold! underline cursor-pointer"
                                    @click="showAddPaymentMethod = !showAddPaymentMethod">
                                    {{ $t("New payment method") }}
                                </button>
                                <div v-if="showAddPaymentMethod" class="bg-[#F6F2E9] border border-dashed border-[#E3D9C1] rounded-2xl p-4 mt-3">
                                    <GeoPaymentMethodForm @success="onPaymentMethodCreated" @error="onError" />
                                </div>
                            </div>

                            <!-- done -->
                            <div v-if="currentKey === 'done'" class="text-center py-6">
                                <div class="text-[48px] mb-3">✅</div>
                                <h2 class="text-[21px] font-extrabold mb-1.5">{{ $t("Setup completed successfully") }}</h2>
                                <p class="text-[15px] text-[#726A54] mb-5">
                                    {{ $t("The payment method has been linked across the whole chain in one step.") }}
                                </p>
                                <div class="inline-flex flex-wrap justify-center gap-2.5 bg-[#F6F2E9] border border-[#E3D9C1] rounded-2xl px-5 py-4 text-[15px] font-bold!">
                                    <template v-for="(chip, i) in summaryChips" :key="i">
                                        <span>{{ chip }}</span>
                                        <span v-if="i < summaryChips.length - 1" class="text-[#726A54]">←</span>
                                    </template>
                                </div>
                            </div>

                        </div>

                        <div v-if="currentKey !== 'done'" class="flex justify-between items-center px-5 sm:px-8 py-5 border-t border-[#E3D9C1]">
                            <button type="button" :disabled="step === 0" @click="goBack"
                                class="border border-[#E3D9C1] rounded-full px-7 py-2.5 text-[15px] font-bold! disabled:opacity-30 cursor-pointer disabled:cursor-not-allowed">
                                {{ $t("Back") }}
                            </button>
                            <button v-if="!isLastStep" type="button" :disabled="!canNext" @click="goNext"
                                class="bg-[#0B7A68] disabled:opacity-40 text-white rounded-full px-9 py-2.5 text-[15px] font-bold! cursor-pointer disabled:cursor-not-allowed">
                                {{ $t("Next") }}
                            </button>
                            <button v-else type="button" :disabled="!canNext || finishLoading" @click="finish"
                                class="bg-[#0B7A68] disabled:opacity-40 text-white rounded-full px-9 py-2.5 text-[15px] font-bold! cursor-pointer disabled:cursor-not-allowed">
                                {{ $t("Finish setup") }}
                            </button>
                        </div>
                        <div v-else class="flex justify-center px-5 sm:px-8 py-6 border-t border-[#E3D9C1]">
                            <button type="button" @click="resetWizard"
                                class="bg-[#B9A779] text-[#4A3F21] rounded-full px-9 py-2.5 text-[15px] font-bold! cursor-pointer">
                                {{ $t("Start new setup") }}
                            </button>
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
// Guided replacement for the four disconnected "Add" cards previously
// embedded in countries-and-cites/index.vue - walks an admin through
// country -> (whole country, or city -> region) -> payment method as one
// connected flow instead of four separate forms across two pages, reusing
// the same components those cards already used.
//
// The "whole country" toggle lives on the country step itself (not after
// picking a city) because if a payment method applies everywhere in the
// country, there is nothing for the admin to gain by being forced through
// a city/region picker first - the whole point of the toggle is to skip
// that work entirely.
import { VueTelInput } from 'vue-tel-input'
import 'vue-tel-input/vue-tel-input.css'

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale, t } = useI18n();
const { telInputRef, initCountriesList, getCountryByCode } = useCountryDisplay();

const step = ref(0);
const wholeCountry = ref(false);

const countryId = ref('');
const countryOptions = ref([]);
const showAddCountry = ref(false);

const cityId = ref('');
const cityOptions = ref([]);
const citiesLoading = ref(false);
const showAddCity = ref(false);

const regionId = ref('');
const regionOptions = ref([]);
const regionsLoading = ref(false);
const showAddRegion = ref(false);

const paymentMethodIds = ref([]);
const showAddPaymentMethod = ref(false);

const finishLoading = ref(false);
const banner = ref({ error: false, success: false, msg: { ar: '', en: '' } });

// The path length is dynamic: 2 steps when the method applies to the whole
// country, 4 steps when it's scoped to a specific city/region.
const stepKeys = computed(() => wholeCountry.value
    ? ['country', 'payment']
    : ['country', 'city', 'region', 'payment']);

const currentKey = computed(() => stepKeys.value[step.value] || 'done');
const isLastStep = computed(() => step.value === stepKeys.value.length - 1);

const stepLabels = computed(() => wholeCountry.value
    ? [t('Country'), t('Payment method')]
    : [t('Country'), t('City'), t('Region'), t('Payment method')]);

const countryLabel = computed(() => countryOptions.value.find((o) => o._id === countryId.value)?.name || '');
const cityItems = computed(() => cityOptions.value.map((c) => ({
    value: c._id,
    label: locale.value == 'ar' ? c.name.ar : c.name.en,
})));
const cityLabel = computed(() => cityItems.value.find((i) => i.value === cityId.value)?.label || '');
const regionItems = computed(() => regionOptions.value.map((r) => ({
    value: r._id,
    label: locale.value == 'ar' ? r.name.ar : r.name.en,
})));
const regionLabel = computed(() => regionItems.value.find((i) => i.value === regionId.value)?.label || '');

const summaryChips = computed(() => {
    const chips = [];
    if (countryLabel.value) chips.push(countryLabel.value);
    if (!wholeCountry.value && cityLabel.value) chips.push(cityLabel.value);
    if (wholeCountry.value) chips.push(t('Whole country'));
    else if (regionLabel.value) chips.push(regionLabel.value);
    if (paymentMethodIds.value.length) chips.push(`${paymentMethodIds.value.length} ${t('payment method(s)')}`);
    return chips;
});

const canNext = computed(() => {
    if (currentKey.value === 'country') return !!countryId.value;
    if (currentKey.value === 'city') return !!cityId.value;
    if (currentKey.value === 'region') return !!regionId.value;
    if (currentKey.value === 'payment') return paymentMethodIds.value.length > 0;
    return false;
});

function handleUnauthorized(errorMessage) {
    if (errorMessage == "Unauthorized") {
        store.updateToken(null);
        router.push("/login");
    }
}

function onError(msg) {
    banner.value = { error: true, success: false, msg };
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
    if (!countryId.value) {
        cityOptions.value = [];
        return;
    }
    citiesLoading.value = true;
    const token = store.getToken;
    try {
        const response = await axios.get(`${BASE_URL}/cities/all-cities-inside-the-page`, {
            headers: { 'Authorization': `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 200, country: countryId.value },
        });
        citiesLoading.value = false;
        cityOptions.value = response.data.error ? [] : response.data.data.cities;
    } catch (error) {
        citiesLoading.value = false;
        handleUnauthorized(handelErrorType(error));
    }
}

async function fetchRegions() {
    if (!cityId.value) {
        regionOptions.value = [];
        return;
    }
    regionsLoading.value = true;
    const token = store.getToken;
    try {
        const response = await axios.get(`${BASE_URL}/regions/all-regions-inside-the-page`, {
            headers: { 'Authorization': `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 200, city: cityId.value },
        });
        regionsLoading.value = false;
        regionOptions.value = response.data.error ? [] : response.data.data.regions;
    } catch (error) {
        regionsLoading.value = false;
        handleUnauthorized(handelErrorType(error));
    }
}

onMounted(async () => {
    initCountriesList();
    await fetchCountries();
});

watch(countryId, () => {
    cityId.value = '';
    wholeCountry.value = false;
});

watch(cityId, () => {
    regionId.value = '';
});

// Fetch the next step's options lazily, only when actually moving into
// that step - if "whole country" is on, city/region are never fetched at
// all, since the country-level binding is checked directly by the app
// now and doesn't need any city/region to exist.
async function goNext() {
    if (currentKey.value === 'country' && !wholeCountry.value) await fetchCities();
    if (currentKey.value === 'city') await fetchRegions();
    step.value++;
}

function goBack() {
    if (step.value > 0) step.value--;
}

async function onCountryCreated(msg, newId) {
    showAddCountry.value = false;
    await fetchCountries();
    if (newId) countryId.value = newId;
}

async function onCityCreated(msg, newId) {
    showAddCity.value = false;
    await fetchCities();
    if (newId) cityId.value = newId;
}

async function onRegionCreated(msg, newId) {
    showAddRegion.value = false;
    await fetchRegions();
    if (newId) regionId.value = newId;
}

function onPaymentMethodCreated(msg, newId) {
    showAddPaymentMethod.value = false;
    if (newId && !paymentMethodIds.value.includes(newId)) {
        paymentMethodIds.value = [...paymentMethodIds.value, newId];
    }
}

async function finish() {
    finishLoading.value = true;
    const token = store.getToken;
    try {
        const response = wholeCountry.value
            ? await axios.post(`${BASE_URL}/countries/${countryId.value}/payment-methods`,
                { paymentMethods: paymentMethodIds.value }, { headers: { 'Authorization': `Bearer ${token}` } })
            : await axios.put(`${BASE_URL}/regions/update/${regionId.value}`,
                { paymentMethods: paymentMethodIds.value }, { headers: { 'Authorization': `Bearer ${token}` } });

        finishLoading.value = false;

        if (response.data.error) {
            banner.value = { error: true, success: false, msg: response.data.msg };
            return;
        }

        banner.value = { error: false, success: true, msg: response.data.msg };
        step.value = stepKeys.value.length;
    } catch (error) {
        finishLoading.value = false;
        const errorMessage = handelErrorType(error);
        handleUnauthorized(errorMessage);
        banner.value = { error: true, success: false, msg: { ar: errorMessage, en: errorMessage } };
    }
}

function resetWizard() {
    step.value = 0;
    wholeCountry.value = false;
    countryId.value = '';
    cityId.value = '';
    regionId.value = '';
    paymentMethodIds.value = [];
    cityOptions.value = [];
    regionOptions.value = [];
    showAddCountry.value = false;
    showAddCity.value = false;
    showAddRegion.value = false;
    showAddPaymentMethod.value = false;
    banner.value = { error: false, success: false, msg: { ar: '', en: '' } };
}
</script>
