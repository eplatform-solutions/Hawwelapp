<template>
    <div ref="rootEl" class="relative">
        <button type="button" :disabled="disabled" @click="toggle"
            class="w-full flex items-center gap-2.5 bg-[#EFE8D9] hover:bg-[#E6DCC6] disabled:opacity-60 disabled:cursor-not-allowed border border-[#E3D9C1] rounded-2xl px-4 py-3 text-[16px] font-bold! text-[#23200F] transition-colors">
            <span class="shrink-0 flex items-center">
                <slot name="leading" :item="selectedItem" />
            </span>
            <span class="truncate" :class="{ 'text-[#726A54]! font-medium!': !selectedItem }">
                {{ selectedItem ? selectedItem.label : (placeholder || t('Select')) }}
            </span>
            <svg class="shrink-0 mr-auto transition-transform" :class="{ 'rotate-180': open }" width="14" height="14"
                viewBox="0 0 24 24" fill="none">
                <path d="M6 9l6 6 6-6" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"
                    stroke-linejoin="round" />
            </svg>
        </button>

        <div v-if="open"
            class="absolute inset-x-0 top-[calc(100%+8px)] z-20 bg-white border border-[#E3D9C1] rounded-2xl shadow-lg overflow-hidden">
            <div class="p-2.5 border-b border-[#E3D9C1]">
                <input ref="searchEl" v-model="search" type="text"
                    :placeholder="searchPlaceholder || t('Search by name')"
                    class="w-full border border-[#E3D9C1] rounded-xl px-3.5 py-2.5 text-[15px] font-bold! text-[#23200F] bg-[#F6F2E9]" />
            </div>
            <div class="max-h-[380px] overflow-y-auto p-1.5">
                <div v-if="filteredItems.length === 0" class="py-5 text-center text-[13.5px] text-[#726A54]">
                    {{ t('No results found') }}
                </div>
                <button v-for="item in filteredItems" :key="item.value" type="button"
                    @click="select(item)"
                    class="w-full flex items-center gap-2.5 px-3 py-2.5 rounded-xl text-[16px] font-bold! text-[#23200F] hover:bg-[#EFE8D9]"
                    :class="{ 'bg-[#EFE8D9]': item.value === modelValue }">
                    <span class="shrink-0 flex items-center">
                        <slot name="leading" :item="item" />
                    </span>
                    <span class="truncate">{{ item.label }}</span>
                    <span v-if="item.sublabel" class="mr-auto text-[13px] font-bold! text-[#726A54]">{{ item.sublabel }}</span>
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
// Generic searchable dropdown used by GeoCountrySelect/GeoCurrencySelect
// (and inline for plain lists like city) so every "pick one of these"
// field in the geo forms looks and behaves the same way, instead of each
// being a bare, unstyled native <select>.
const props = defineProps({
    modelValue: { type: [String, Number], default: '' },
    items: { type: Array, default: () => [] }, // [{ value, label, sublabel? }]
    placeholder: { type: String, default: '' },
    searchPlaceholder: { type: String, default: '' },
    disabled: { type: Boolean, default: false },
});

const emit = defineEmits(['update:modelValue']);

const { t } = useI18n();

const rootEl = ref(null);
const searchEl = ref(null);
const open = ref(false);
const search = ref('');

const selectedItem = computed(() => props.items.find((item) => item.value === props.modelValue) || null);

const filteredItems = computed(() => {
    const query = search.value.trim().toLowerCase();
    if (!query) return props.items;
    return props.items.filter((item) => item.label.toLowerCase().includes(query)
        || String(item.sublabel || '').toLowerCase().includes(query));
});

async function toggle() {
    if (props.disabled) return;
    open.value = !open.value;
    if (open.value) {
        search.value = '';
        await nextTick();
        searchEl.value?.focus();
    }
}

function select(item) {
    emit('update:modelValue', item.value);
    open.value = false;
}

function onClickOutside(event) {
    if (rootEl.value && !rootEl.value.contains(event.target)) {
        open.value = false;
    }
}

onMounted(() => document.addEventListener('click', onClickOutside));
onBeforeUnmount(() => document.removeEventListener('click', onClickOutside));
</script>
