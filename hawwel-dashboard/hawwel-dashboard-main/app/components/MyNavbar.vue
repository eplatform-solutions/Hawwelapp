<template>
    <div class="sticky right-0 top-0 h-screen z-50 hidden lg:block shrink-0 transition-all duration-300 side-shell"
        :class="isCollapsed ? 'w-[76px]' : 'w-[220px]'">

        <div class="min-h-screen max-h-screen py-5 flex flex-col gap-2 overflow-auto w-full"
            :class="{ 'ar-dir': locale == 'en', 'en-dir': locale == 'ar' }">

            <div class="mb-2 flex items-center gap-2" :class="{ 'justify-center': isCollapsed, 'justify-end': !isCollapsed }">
                <UButton v-if="authUser && !isCollapsed" class="cursor-pointer brand-btn text-sm px-2 py-1" @click="changeLang">
                    <span v-if="locale == 'ar'">{{ $t("arabic") }}</span>
                    <span v-else>{{ $t("english") }}</span>
                </UButton>
                <button class="cursor-pointer brand-btn p-2 rounded-xl" @click="toggleSidebar"
                    :title="isCollapsed ? $t('Expand menu') : $t('Collapse menu')">
                    <UIcon :name="isCollapsed ? 'i-heroicons-chevron-double-left-16-solid' : 'i-heroicons-chevron-double-right-16-solid'"
                        class="size-4" />
                </button>
            </div>

            <div class="flex flex-col gap-1">
                <nuxt-link v-for="item in mainItems" :key="item.to" :to="item.to"
                    class="side-link"
                    :class="[
                        isLinkActive(item.to) ? 'is-active' : '',
                        isCollapsed ? 'justify-center' : 'justify-end gap-2'
                    ]"
                    :title="$t(item.label)">
                    <UIcon :name="item.icon" class="size-4 shrink-0" />
                    <span v-if="!isCollapsed" class="truncate">{{ $t(item.label) }}</span>
                </nuxt-link>

                <nuxt-link v-if="!isEmployee && canSeeAccounting" :to="accountingItem.to" class="side-link"
                    :class="[isAccounting ? 'is-active' : '', isCollapsed ? 'justify-center' : 'justify-end gap-2']"
                    :title="$t(accountingItem.label)">
                    <UIcon :name="accountingItem.icon" class="size-4 shrink-0" />
                    <span v-if="!isCollapsed" class="truncate">{{ $t(accountingItem.label) }}</span>
                </nuxt-link>

                <template v-if="!isEmployee && canSeeAccounting && !isCollapsed && isAccounting">
                    <div class="pe-3 flex flex-col gap-1">
                        <nuxt-link v-for="item in accountingChildren" :key="item.path" :to="item.path"
                            class="side-sub-link"
                            :class="{ 'is-active': currentPath == item.path }">
                            {{ $t(item.label) }}
                        </nuxt-link>
                    </div>
                </template>
            </div>
        </div>
    </div>
</template>

<script setup>
const { route, store, authUser } = useUtils();
const { hasPermission } = usePermissions();
const { adminItems, accountingItem, accountingChildren, employeeItems } = useNavItems();
const { locale, setLocale, t } = useI18n();

onMounted(() => {
    const myLan = store.getLanguage;
    setLocale(myLan);
});

const currentPath = computed(() => route.path);
const isAccounting = computed(() => currentPath.value.toLowerCase().includes("accounting"));

const isEmployee = computed(() => store.getIsEmployee);

const mainItems = computed(() => {
    if (isEmployee.value) return employeeItems;
    return adminItems.filter((item) => hasPermission(item.permission));
});

const canSeeAccounting = computed(() => hasPermission(accountingItem.permission));

const isCollapsed = ref(false);

onMounted(() => {
    const saved = localStorage.getItem("dashboard_sidebar_collapsed");
    isCollapsed.value = saved === "true";
    applySidebarLayoutClass(isCollapsed.value);
});

watch(isCollapsed, (value) => {
    localStorage.setItem("dashboard_sidebar_collapsed", String(value));
    applySidebarLayoutClass(value);
});

onUnmounted(() => {
    document.body.classList.remove("dashboard-sidebar-collapsed");
});

function toggleSidebar() {
    isCollapsed.value = !isCollapsed.value;
}

function applySidebarLayoutClass(collapsed) {
    if (collapsed) {
        document.body.classList.add("dashboard-sidebar-collapsed");
        return;
    }
    document.body.classList.remove("dashboard-sidebar-collapsed");
}

function isLinkActive(path) {
    return currentPath.value === path;
}

function changeLang() {
    let myLan = locale.value;
    myLan = myLan == "ar" ? "en" : "ar";
    setLocale(myLan);
    store.updateLanguage(myLan);
}
</script>
