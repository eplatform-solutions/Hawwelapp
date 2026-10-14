<template>

</template>


<script setup>
const { locale, locales, setLocale, t } = useI18n();
const toast = useToast();

const props = defineProps({
    head: {
        type: String,
        required: false,
    },
    body: {
        type: String,
        required: false,
    },
    color: {
        type: String,
        required: false,
    },
    icon: {
        type: String,
        required: false,
    },
});

// تحويل props إلى reactive references
const { head, body, color, icon } = toRefs(props)

onMounted(() => {

    const isRTL = locale.value === 'ar';

    if (color.value) {
        if (icon.value) {
            toast.add({
                title: t(head.value || ''),
                description: t(body.value || ''),
                color: color.value,
                icon: icon.value,
                class: isRTL ? 'toast-rtl' : 'toast-ltr'
            });
        } else {
            toast.add({
                title: t(head.value || ''),
                description: t(body.value || ''),
                color: color.value,
                class: isRTL ? 'toast-rtl' : 'toast-ltr'
            });
        }
    } else {
        toast.add({
            title: t(head.value || ''),
            description: t(body.value || ''),
            class: isRTL ? 'toast-rtl' : 'toast-ltr'
        });
    }
});

</script>
