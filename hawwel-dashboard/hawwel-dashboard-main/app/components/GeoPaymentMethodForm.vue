<template>
    <form @submit.prevent="submit" :class="{ 'ar-dir': locale == 'ar' }">

        <div class="flex lg:flex-row flex-col gap-2 mb-5 lg:items-center">
            <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                {{ $t("Payment method name in arabic:") }}
            </div>
            <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                <GeoTextField v-model="nameAr" required />
            </div>
        </div>
        <div class="flex lg:flex-row flex-col gap-2 mb-5 lg:items-center">
            <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                {{ $t("Payment method name in english:") }}
            </div>
            <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                <GeoTextField v-model="nameEn" required />
            </div>
        </div>
        <div class="flex lg:flex-row flex-col gap-2 mb-5 lg:items-center">
            <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                {{ $t("Currency:") }}
            </div>
            <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                <GeoCurrencySelect v-model="currency" :options="currencyOptions" />
            </div>
        </div>
        <div class="flex lg:flex-row flex-col gap-2 mb-5 lg:items-center">
            <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                {{ $t("Minimum limit:") }}
            </div>
            <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                <GeoTextField v-model="mini" type="number" required />
            </div>
        </div>
        <div class="flex lg:flex-row flex-col gap-2 mb-5 lg:items-center">
            <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                {{ $t("Maximum limit:") }}
            </div>
            <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                <GeoTextField v-model="maxi" type="number" required />
            </div>
        </div>
        <div class="flex lg:flex-row flex-col gap-2 mb-5 lg:items-center">
            <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                {{ $t("Commission %:") }}
            </div>
            <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                <GeoTextField v-model="commission" type="number" required />
            </div>
        </div>
        <div class="flex lg:flex-row flex-col gap-2 mb-5 lg:items-center">
            <label for="select-image" class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                {{ $t("Select logo image:") }}
            </label>
            <input id="select-image" type="file" @change="onImageSelected" accept=".jpg,.png,.webp"
                class="basis-full sm:basis-[50%] md:basis-[60%] bg-[#EFE8D9] border border-[#E3D9C1] rounded-2xl px-3.5 py-2.5 text-black font-bold! text-[13px]" />
        </div>

        <div v-if="imageError" class="text-red-500 text-[12px]/5 mb-3">
            {{ locale == 'ar' ? imageError.ar : imageError.en }}
        </div>

        <div class="flex justify-end">
            <UButton type="submit" :loading="loading" :disabled="loading"
                class="bg-[#0B7A68] hover:brightness-110 disabled:opacity-60 rounded-full cursor-pointer px-8 py-2 text-white font-bold!">
                {{ $t("Save payment method") }}
            </UButton>
        </div>

    </form>
</template>

<script setup>
// Shared "Add Payment Method" form. Previously duplicated between the
// Payment Methods page and the embedded section on the Countries & Cities
// page, with the latter using a much weaker (unvalidated) image picker -
// this standardizes on the more robust validation the dedicated page had.
const emit = defineEmits(['success', 'error']);

const { axios, store, router, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale } = useI18n();
const { currencyOptions } = useCurrencyOptions();

const nameAr = ref('');
const nameEn = ref('');
const currency = ref('');
const mini = ref('');
const maxi = ref('');
const commission = ref('');
const image = ref(null);
const imageError = ref(null);
const loading = ref(false);

watch(currencyOptions, (options) => {
    if (!currency.value && options.length > 0) {
        currency.value = options[0].code;
    }
});

const MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5MB
const ALLOWED_IMAGE_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
const ALLOWED_IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'png', 'webp'];

function onImageSelected(event) {
    const file = event.target.files[0];
    imageError.value = null;

    if (!file) {
        image.value = null;
        return;
    }

    const fileExtension = file.name.split('.').pop().toLowerCase();
    if (!ALLOWED_IMAGE_TYPES.includes(file.type) || !ALLOWED_IMAGE_EXTENSIONS.includes(fileExtension)) {
        imageError.value = {
            en: "File type not supported! Only JPG, PNG, and WebP images are allowed.",
            ar: "نوع الملف غير مدعوم! فقط صور JPG و PNG و WebP مسموح بها.",
        };
        event.target.value = '';
        image.value = null;
        return;
    }

    if (file.size > MAX_IMAGE_SIZE) {
        const fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);
        imageError.value = {
            en: `File size is too large (${fileSizeMB} MB)! Maximum allowed size is 5 MB.`,
            ar: `حجم الملف كبير جداً (${fileSizeMB} ميجابايت)! الحد الأقصى المسموح به هو 5 ميجابايت.`,
        };
        event.target.value = '';
        image.value = null;
        return;
    }

    image.value = file;
}

async function submit() {
    if (image.value == null) {
        emit('error', { ar: "يجب إضافة صورة الشعار", en: "A logo image must be added." });
        return;
    }

    loading.value = true;

    const formData = new FormData();
    formData.append('name', JSON.stringify({ ar: nameAr.value, en: nameEn.value }));
    formData.append('symbol', currency.value);
    formData.append('fee', Number(commission.value));
    formData.append('minAmount', Number(mini.value));
    formData.append('maxAmount', Number(maxi.value));
    formData.append('logoImage', image.value);

    const token = store.getToken;

    try {
        const response = await axios.post(`${BASE_URL}/payment-methods/create`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
                'Authorization': `Bearer ${token}`,
            },
        });

        loading.value = false;

        if (response.data.error) {
            emit('error', response.data.msg);
            return;
        }

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
