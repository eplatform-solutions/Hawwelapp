<template>
    <form @submit.prevent="submit">

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
// Lightweight "just the name" region creator scoped to an already-known
// city - mirrors GeoCityQuickAddForm's lockedCountry pattern. Used by the
// quick-setup wizard, where the city was already chosen in an earlier
// step, so the full GeoRegionForm (with its own country/city pickers) is
// more than this context needs. Creates the region with no payment
// methods bound yet - the wizard's own payment-method step handles that
// as a separate, explicit action.
const props = defineProps({
    lockedCity: { type: String, required: true },
});

const emit = defineEmits(['success', 'error']);

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();

const nameAr = ref('');
const nameEn = ref('');
const loading = ref(false);

async function submit() {
    if (!nameAr.value || !nameEn.value) {
        emit('error', { ar: "يجب كتابة اسم المنطقة", en: "Region name is required" });
        return;
    }

    loading.value = true;
    const token = store.getToken;

    try {
        const response = await axios.post(`${BASE_URL}/regions/create`, {
            city: props.lockedCity,
            name: { ar: nameAr.value, en: nameEn.value },
        }, { headers: { 'Authorization': `Bearer ${token}` } });

        loading.value = false;

        if (response.data.error) {
            emit('error', response.data.msg);
            return;
        }

        const newId = response.data.data?._id;
        nameAr.value = '';
        nameEn.value = '';
        emit('success', response.data.msg, newId);
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
