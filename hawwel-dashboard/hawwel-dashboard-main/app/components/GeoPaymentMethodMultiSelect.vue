<template>
    <div>
        <input type="text" v-model="searchName" @input="onSearchInput"
            class="bg-white text-black text-[16px]/8 font-bold! px-2 py-1 mb-2 w-full"
            :placeholder="t('Search by name')">

        <UCheckboxGroup v-model="proxyValue" :items="items" :ui="{ fieldset: locale == 'ar' ? 'ar-dir' : 'en-dir' }" />
    </div>
</template>

<script setup>
// Shared payment-method picker used everywhere a country/city/region form
// needs to let an admin choose which payment methods apply. Replaces what
// used to be 5 separately hand-copied fetch+map implementations across the
// countries-and-cities and regions pages.
const props = defineProps({
    modelValue: { type: Array, default: () => [] },
    // When set, the picker also fetches whichever payment methods are
    // already bound to this region and seeds modelValue with them - used
    // to pre-check the boxes when editing an existing region.
    regionId: { type: String, default: null },
});

const emit = defineEmits(['update:modelValue']);

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale, t } = useI18n();

const searchName = ref('');
const rawPaymentMethods = ref([]);
const state = ref({ loading: false, error: false, msg: { ar: '', en: '' } });

const proxyValue = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val),
});

const items = computed(() => rawPaymentMethods.value.map((paymentMethod) => ({
    label: locale.value == 'ar' ? paymentMethod.name.ar : paymentMethod.name.en,
    value: paymentMethod._id,
})));

function handleUnauthorized(errorMessage) {
    if (errorMessage == "Unauthorized") {
        store.updateToken(null);
        router.push("/login");
    }
}

async function fetchItems() {
    state.value.loading = true;
    state.value.error = false;
    const token = store.getToken;

    try {
        const response = await axios.get(`${BASE_URL}/payment-methods/all-payment-methods-inside-the-page`, {
            headers: { 'Authorization': `Bearer ${token}` },
            params: {
                pageNumber: 1,
                pageSize: 20,
                ...(searchName.value ? { name: searchName.value } : {}),
            },
        });

        state.value.loading = false;
        if (!response.data.error) {
            rawPaymentMethods.value = response.data.data.paymentMethods;
        }
    } catch (error) {
        state.value.loading = false;
        const errorMessage = handelErrorType(error);
        handleUnauthorized(errorMessage);
        state.value.error = true;
        state.value.msg = { ar: errorMessage, en: errorMessage };
    }
}

async function fetchBoundToRegion() {
    if (!props.regionId) return;
    const token = store.getToken;

    try {
        const response = await axios.get(`${BASE_URL}/payment-methods/all-payment-methods-inside-the-page`, {
            headers: { 'Authorization': `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 1000, region: props.regionId },
        });

        if (!response.data.error) {
            proxyValue.value = response.data.data.paymentMethods.map((paymentMethod) => paymentMethod._id);
        }
    } catch (error) {
        handleUnauthorized(handelErrorType(error));
    }
}

let searchDebounce = null;
function onSearchInput() {
    clearTimeout(searchDebounce);
    searchDebounce = setTimeout(fetchItems, 300);
}

onMounted(async () => {
    await fetchItems();
    await fetchBoundToRegion();
});
</script>
