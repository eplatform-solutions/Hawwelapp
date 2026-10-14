<template>
    <div class="bg-box-green-2 stat-card">
        <div class="stat-card__title">
            {{ $t(props.title) }}
        </div>
        <div class="stat-card__value">
            {{ props.number }}
        </div>
    </div>
</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const props = defineProps({
    title: {
        type: String,
        required: true
    },
    number: {
        type: Number,
        required: true
    }
});

</script>