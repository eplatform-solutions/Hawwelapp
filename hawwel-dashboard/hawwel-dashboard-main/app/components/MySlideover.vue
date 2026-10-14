<template>
    <USlideover v-model:open="open" :side="locale == 'en' ? 'left' : 'right'" :ui="{ content: 'w-60' }">
        <div class="size-7 lg:hidden block">
            <button class="size-7 cursor-pointer">
                <UIcon class="size-7" name="i-heroicons-bars-3-center-left-20-solid" />
            </button>
        </div>

        <template #content>
            <div class="h-full px-4 py-3 side-shell" :class="{ 'ar-dir': locale == 'en' }">

                <div class="flex justify-between items-baseline border-b-2 border-black mb-3 pb-2">
                    <!-- عنوان اللغات -->
                    <UButton v-if="authUser" class="cursor-pointer brand-btn text-sm px-2 py-1" @click="changeLang">
                        <span v-if="locale == 'ar'"> {{ $t("arabic") }} </span>
                        <span v-else> {{ $t("english") }} </span>
                    </UButton>
                    <!-- عنوان القائمة -->
                    <div class="flex gap-1 items-start">
                        <div class="text-black text-[14px]/5 font-bold!">
                            {{ $t('menu') }}
                        </div>
                        <!-- زر الإغلاق -->
                        <button class="cursor-pointer" @click="open = !open">
                            <UIcon class="size-5" name="i-heroicons-x-circle-16-solid" />
                        </button>
                    </div>
                </div>

                <div class="h-full overflow-auto pb-10">
                    <div class="p-2">
                        <div v-for="item in mainItems" :key="item.to" class="mb-2 flex justify-end">
                            <nuxt-link :to="item.to"
                                class="text-black text-[16px]/8 font-bold! border-b border-dashed pb-1 w-full text-end hover:text-[#097F6E]! duration-200"
                                :class="{ 'text-[#097F6E]!': currentPath == item.to }">
                                {{ $t(item.label) }}
                            </nuxt-link>
                        </div>

                        <template v-if="!isEmployee && canSeeAccounting">
                            <div class="mb-2 flex justify-end">
                                <nuxt-link :to="accountingItem.to"
                                    class="text-black text-[16px]/8 font-bold! border-b border-dashed pb-1 w-full text-end hover:text-[#097F6E]! duration-200"
                                    :class="{ 'text-[#097F6E]!': isAccounting }">
                                    {{ $t(accountingItem.label) }}
                                </nuxt-link>
                            </div>
                            <div v-if="isAccounting" class="pe-3">
                                <div v-for="child in accountingChildren" :key="child.path" class="mb-2 flex justify-end">
                                    <nuxt-link :to="child.path"
                                        class="text-black text-[16px]/8 font-bold! border-b border-dashed pb-1 w-full text-end hover:text-[#097F6E]! duration-200"
                                        :class="{ 'text-[#097F6E]!': currentPath == child.path }">
                                        {{ $t(child.label) }}
                                    </nuxt-link>
                                </div>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
        </template>
    </USlideover>
</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { hasPermission } = usePermissions();
const { adminItems, accountingItem, accountingChildren, employeeItems } = useNavItems();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const currentPath = route.path;

const open = ref(false)
const myLan = ref(locale.value)

defineShortcuts({
    o: () => open.value = !open.value
});

const isAccounting = ref(false);

onMounted(() => {
    isAccounting.value = currentPath.toLowerCase().includes('accounting');
});

const isEmployee = computed(() => store.getIsEmployee);

const mainItems = computed(() => {
    if (isEmployee.value) return employeeItems;
    return adminItems.filter((item) => hasPermission(item.permission));
});

const canSeeAccounting = computed(() => hasPermission(accountingItem.permission));

function changeLang() {
    let myLan = locale.value;
    myLan = myLan == 'ar' ? 'en' : 'ar';
    setLocale(myLan);
    store.updateLanguage(myLan);
}
</script>
