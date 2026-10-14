<template>
    <div>
        <vue-tel-input ref="telInputRef" class="hidden!" />

        <div class="mb-5">
            <GeoCombobox v-model="selectedIso2" :items="items" :placeholder="$t('Select country')"
                :search-placeholder="$t('Search by name')">
                <template #leading="{ item }">
                    <span class="text-[20px] leading-none">{{ item ? item.flag : '🌍' }}</span>
                </template>
            </GeoCombobox>
        </div>

        <div class="flex justify-center">
            <UButton @click="submit" :loading="loading" :disabled="loading"
                class="bg-[#0B7A68] hover:brightness-110 disabled:opacity-60 rounded-full cursor-pointer px-8 py-2 text-white font-bold!">
                {{ $t("Save") }}
            </UButton>
        </div>
    </div>
</template>

<script setup>
// Picks a country to register from the full world list (there's no DB
// record yet, unlike GeoCountrySelect which picks among countries
// already added) - built on the same GeoCombobox so it looks and behaves
// like every other country picker instead of vue-tel-input's own dropdown.
import { VueTelInput } from 'vue-tel-input'
import 'vue-tel-input/vue-tel-input.css'

const emit = defineEmits(['success', 'error']);

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { telInputRef, countriesList, initCountriesList } = useCountryDisplay();

const selectedIso2 = ref('');
const loading = ref(false);

const items = computed(() => countriesList.value.map((country) => ({
    value: country.iso2,
    label: country.name,
    sublabel: `+${country.dialCode}`,
    flag: isoToFlagEmoji(country.iso2),
})));

onMounted(() => {
    initCountriesList();
});

async function submit() {
    if (!selectedIso2.value) {
        emit('error', { ar: "عذراً ، يرجى اختيار بلد !!", en: "Sorry, Please Select A Country !!" });
        return;
    }

    loading.value = true;
    const token = store.getToken;

    try {
        const response = await axios.post(`${BASE_URL}/countries/create`, {
            code: selectedIso2.value,
        }, { headers: { 'Authorization': `Bearer ${token}` } });

        loading.value = false;

        if (response.data.error) {
            emit('error', response.data.msg);
            return;
        }

        selectedIso2.value = '';
        emit('success', response.data.msg, response.data.data?._id);
    } catch (error) {
        loading.value = false;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        emit('error', { ar: errorMessage, en: errorMessage });
    }
}
</script>
