<template>
    <form @submit.prevent="submit">

        <div class="mb-3" v-if="!lockedCountry">
            <GeoCountrySelect v-model="selectedCountry" :options="countryOptions" />
        </div>

        <div class="mb-3">
            <GeoTextField v-model="nameAr" :placeholder="$t('Type city name in arabic')" required />
        </div>

        <div class="mb-5">
            <GeoTextField v-model="nameEn" :placeholder="$t('Type city name in english')" required />
        </div>

        <div class="flex justify-center">
            <UButton type="submit" :loading="loading" :disabled="loading"
                class="bg-[#0B7A68] hover:brightness-110 disabled:opacity-60 rounded-full cursor-pointer px-8 py-2 text-white font-bold!">
                {{ $t("Save") }}
            </UButton>
        </div>
    </form>
</template>

<script setup>
const props = defineProps({
    countryOptions: { type: Array, default: () => [] },
    lockedCountry: { type: String, default: null },
});

const emit = defineEmits(['success', 'error']);

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();

const selectedCountry = ref('');
const nameAr = ref('');
const nameEn = ref('');
const loading = ref(false);

async function submit() {
    const country = props.lockedCountry || selectedCountry.value;

    if (!country) {
        emit('error', { ar: "عذراً ، يرجى اختيار بلد !!", en: "Sorry, Please Select A Country !!" });
        return;
    }
    if (!nameAr.value || !nameEn.value) {
        emit('error', { ar: "يجب كتابة اسم المدينة", en: "City name is required" });
        return;
    }

    loading.value = true;
    const token = store.getToken;

    try {
        const response = await axios.post(`${BASE_URL}/cities/create`, {
            country,
            name: { ar: nameAr.value, en: nameEn.value },
        }, { headers: { 'Authorization': `Bearer ${token}` } });

        loading.value = false;

        if (response.data.error) {
            emit('error', response.data.msg);
            return;
        }

        selectedCountry.value = '';
        nameAr.value = '';
        nameEn.value = '';
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
