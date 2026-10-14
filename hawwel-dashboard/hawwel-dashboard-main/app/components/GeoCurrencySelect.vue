<template>
    <GeoCombobox :model-value="modelValue" @update:model-value="$emit('update:modelValue', $event)" :items="items"
        :placeholder="placeholder || t('Currency:')" :search-placeholder="t('Search by name')">
        <template #leading="{ item }">
            <span class="w-[30px] h-[30px] rounded-lg flex items-center justify-center text-[11px] font-black text-white"
                :style="{ background: item ? item.color : '#726A54' }">
                {{ item ? item.value.slice(0, 2) : '؟' }}
            </span>
        </template>
    </GeoCombobox>
</template>

<script setup>
// Searchable currency picker: a colored badge with the currency code
// instead of a bare native <select> where every option looked identical.
const props = defineProps({
    modelValue: { type: String, default: '' },
    options: { type: Array, default: () => [] }, // [{ code, name }]
    placeholder: { type: String, default: '' },
});

defineEmits(['update:modelValue']);

const { t } = useI18n();

// Stable color per currency code, derived from the code itself so it
// never changes between renders/reloads without needing to store one.
function colorForCode(code) {
    const palette = ['#0b7a68', '#3457a6', '#a8383a', '#8f7b45', '#2f7d4f', '#b9532b', '#1f6f5c', '#5b4b8a'];
    let hash = 0;
    for (let i = 0; i < code.length; i++) hash = (hash * 31 + code.charCodeAt(i)) >>> 0;
    return palette[hash % palette.length];
}

const items = computed(() => props.options.map((option) => ({
    value: option.code,
    label: option.name || option.code,
    sublabel: option.code,
    color: colorForCode(option.code),
})));
</script>
