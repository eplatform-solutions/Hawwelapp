<template>
    <input :type="type" :value="modelValue" @input="$emit('update:modelValue', $event.target.value)"
        :placeholder="placeholder" :required="required"
        class="w-full bg-[#EFE8D9] border border-[#E3D9C1] rounded-2xl px-4 py-3 text-[16px] font-bold! text-[#23200F] placeholder:text-[#726A54] placeholder:font-medium! focus:outline-none focus:ring-2 focus:ring-[#0B7A68]" />
</template>

<script setup>
// A single consistent text-field look for the geo forms, matching
// GeoCombobox's warm-gray/bordered style - previously each form's plain
// <input> used a slightly different, borderless background color, so
// some fields (payment methods especially) barely read as an input at all.
defineProps({
    modelValue: { type: [String, Number], default: '' },
    type: { type: String, default: 'text' },
    placeholder: { type: String, default: '' },
    required: { type: Boolean, default: false },
});

defineEmits(['update:modelValue']);
</script>
