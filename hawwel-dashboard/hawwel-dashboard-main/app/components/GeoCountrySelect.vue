<template>
    <GeoCombobox :model-value="modelValue" @update:model-value="$emit('update:modelValue', $event)" :items="items"
        :placeholder="placeholder || t('Select country')" :search-placeholder="t('Search by name')"
        :disabled="disabled">
        <template #leading="{ item }">
            <span class="text-[24px] leading-none">{{ item ? item.flag : '🌍' }}</span>
        </template>
    </GeoCombobox>
</template>

<script setup>
// Searchable country picker showing a flag + name instead of a bare
// native <select> full of plain text. `options` is the raw list the
// parent already fetches ({_id, name, iso2}) - this component only
// shapes it for display.
const props = defineProps({
    modelValue: { type: String, default: '' },
    options: { type: Array, default: () => [] }, // [{ _id, name, iso2 }]
    placeholder: { type: String, default: '' },
    disabled: { type: Boolean, default: false },
});

defineEmits(['update:modelValue']);

const { t } = useI18n();

const items = computed(() => props.options.map((option) => ({
    value: option._id,
    label: option.name,
    flag: isoToFlagEmoji(option.iso2),
})));
</script>
