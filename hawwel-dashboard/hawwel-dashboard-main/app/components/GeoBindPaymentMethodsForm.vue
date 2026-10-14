<template>
    <div>
        <div class="text-black text-[12px]/5 mb-3">
            {{ entityType == 'country' ? $t("This will enable the selected payment methods for this country only. It will not automatically apply to its cities or regions - bind those separately.") : $t("This will enable the selected payment methods for this city only. It will not automatically apply to its regions - bind those separately.") }}
        </div>

        <GeoPaymentMethodMultiSelect v-model="selectedIds" />

        <div class="flex justify-end mt-4">
            <UButton :loading="loading" :disabled="loading" @click="submit"
                class="text-black text-[12px]/8 font-bold! px-5 py-0.5 bg-[#B9A779] cursor-pointer border border-[#6B1F2A] rounded-xl">
                {{ $t("Enable") }}
            </UButton>
        </div>
    </div>
</template>

<script setup>
// Enables a payment method for a single country or city. Availability is
// not hierarchical: this does not cascade to cities/regions underneath -
// each level must be bound separately (see repositories/countries and
// repositories/cities on the backend).
const props = defineProps({
    entityType: { type: String, required: true }, // 'country' | 'city'
    entityId: { type: String, required: true },
});

const emit = defineEmits(['success', 'error']);

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();

const selectedIds = ref([]);
const loading = ref(false);

async function submit() {
    if (selectedIds.value.length === 0) {
        emit('error', { ar: "يرجى اختيار طريقة دفع واحدة على الأقل", en: "Please select at least one payment method" });
        return;
    }

    loading.value = true;
    const token = store.getToken;
    const path = props.entityType === 'country'
        ? `countries/${props.entityId}/payment-methods`
        : `cities/${props.entityId}/payment-methods`;

    try {
        const response = await axios.post(`${BASE_URL}/${path}`, { paymentMethods: selectedIds.value }, {
            headers: { 'Authorization': `Bearer ${token}` },
        });

        loading.value = false;

        if (response.data.error) {
            emit('error', response.data.msg);
            return;
        }

        emit('success', response.data.msg);
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
