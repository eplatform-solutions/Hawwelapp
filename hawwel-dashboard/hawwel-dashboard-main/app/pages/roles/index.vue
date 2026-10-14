<template>

    <!-- <use-toast v-if="state.error" head="Error" :body="locale == 'en' ? state.msg.en : state.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast> -->

    <use-toast v-if="stateAdd.error" head="Failed" :body="locale == 'en' ? stateAdd.msg.en : stateAdd.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateAdd.success" head="Success" :body="locale == 'en' ? stateAdd.msg.en : stateAdd.msg.ar"
        color="success" icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateEdit.error" head="Failed" :body="locale == 'en' ? stateEdit.msg.en : stateEdit.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateEdit.success" head="Success" :body="locale == 'en' ? stateEdit.msg.en : stateEdit.msg.ar"
        color="success" icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateDelete.error" head="Failed" :body="locale == 'en' ? stateDelete.msg.en : stateDelete.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateDelete.success" head="Success"
        :body="locale == 'en' ? stateDelete.msg.en : stateDelete.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <div>

        <div class="flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div class="mb-4 px-5">
                    <button @click="showAddModal"
                        class="bg-[#B9A779] text-black sm:text-[16px]/8 text-[12px]/5 px-3 py-1 rounded-full font-bold! cursor-pointer">
                        {{ $t('Add role') }}
                    </button>
                </div>

                <div>

                    <div v-if="state.loading" class="flex justify-center items-center py-10">
                        <div>
                            <LoadingIcon />
                        </div>
                    </div>

                    <div v-else-if="state.error" class="flex justify-center flex-col gap-4 items-center py-10">
                        <div class="text-[16px]/8 text-red-500 font-bold!">
                            {{ locale == 'ar' ? $t(state.msg.ar) : $t(state.msg.en) }}
                        </div>
                        <div class="flex justify-center">
                            <button
                                class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                @click="getAllInfo">
                                {{ $t("Refresh") }}
                            </button>
                        </div>
                    </div>

                    <div v-else class="grid">
                        <div class="flex justify-center px-3 sm:px-5">
                            <div class="overflow-auto w-full max-w-6xl">
                                <table class="bg-white w-full min-w-[760px]">
                                    <thead>
                                        <tr class="border-b">
                                            <th class="tracking-[2px]! min-w-[240px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3 whitespace-nowrap"
                                                :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                                {{ $t('Role name') }}
                                            </th>
                                            <th class="tracking-[2px]! min-w-[280px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3 whitespace-nowrap"
                                                :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                                {{ $t('permissions') }}
                                            </th>
                                            <th
                                                class="tracking-[2px]! min-w-[150px] px-4 sm:px-6 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3 whitespace-nowrap">
                                                {{ $t('actions') }}
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(item, index) in roles" :key="item._id"
                                            :class="{ 'border-b': index + 1 != roles.length }">
                                            <td class="min-w-[240px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3 whitespace-nowrap"
                                                :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                                {{ item.name }}
                                            </td>
                                            <td :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                                <div class="text-center whitespace-nowrap">
                                                    <button v-if="item?.permissions?.length > 0" @click="showPermissions(item)"
                                                        class="min-w-[280px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 cursor-pointer text-center py-3 whitespace-nowrap">
                                                        {{ $t("See permissions") }}
                                                    </button>
                                                    <div v-else
                                                        class="min-w-[280px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3 whitespace-nowrap">
                                                        {{ $t("No permissions") }}
                                                    </div>
                                                </div>
                                            </td>
                                            <td
                                                class="min-w-[150px] px-4 sm:px-6 text-black font-bold! text-[10px]/5 sm:text-[13px]/8 text-center py-3 whitespace-nowrap">
                                                <div class="flex gap-2 flex-row-reverse justify-center">
                                                    <div class="flex justify-center items-center gap-3">
                                                        <button class="cursor-pointer" @click="showDeleteModal(item)">
                                                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none"
                                                                xmlns="http://www.w3.org/2000/svg">
                                                                <path
                                                                    d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                                                                    fill="#FB0F0F" />
                                                            </svg>
                                                        </button>
                                                        <button class="cursor-pointer" @click="showEditModal(item)">
                                                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                                                xmlns="http://www.w3.org/2000/svg">
                                                                <path
                                                                    d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                                    fill="black" />
                                                            </svg>
                                                        </button>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>
    </div>

    <!-- add new role -->
    <UModal v-model:open="openAdd">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Add new role') }}
                    </div>
                    <div>
                        <button @click="openAdd = !openAdd" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="addRole" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="role-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Name') }}
                        </label>
                        <input id="role-name" type="text" v-model="newRoleData.name" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="role-des" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Description') }}
                            <span class="text-black text-[12px]/8 italic">
                                ( {{ $t("at least 5 characters") }})
                            </span>
                        </label>
                        <input id="role-des" type="text" v-model="newRoleData.description" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="role-des" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Select permissions') }}
                        </label>
                        <UCheckboxGroup v-model="newRoleData.permissions" :items="permissionItems"
                            :ui="{ fieldset: locale == 'ar' ? 'ar-dir' : 'en-dir' }" />
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateAdd.loading" :disabled="stateAdd.loading || newRoleData.description.length < 5"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('add') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- edit role -->
    <UModal v-model:open="openEdit">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Edit role') }}
                    </div>
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="editRole" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="role-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Name') }}
                        </label>
                        <input id="role-name" type="text" v-model="editRoleItem.name" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="role-des" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Description') }}
                            <span class="text-black text-[12px]/8 italic">
                                ( {{ $t("at least 5 characters") }})
                            </span>
                        </label>
                        <input id="role-des" type="text" v-model="editRoleItem.description" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="role-des" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Select permissions') }}
                        </label>
                        <UCheckboxGroup v-model="editRoleItem.permissions" :items="permissionItems"
                            :ui="{ fieldset: locale == 'ar' ? 'ar-dir' : 'en-dir' }" />
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateEdit.loading"
                            :disabled="stateEdit.loading || editRoleItem.description.length < 5"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('Edit') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- delete role -->
    <UModal v-model:open="openDelete">
        <template #content>
            <div class="bg-box-gray p-5">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Delete role') }}
                    </div>
                    <div>
                        <button @click="openDelete = !openDelete" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="deleteRole" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t('Are you sure you want delete this role?') }}
                        </div>
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateDelete.loading" :disabled="stateDelete.loading"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('delete') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- show permissions for one role -->
    <UModal v-model:open="openShowPermissions">
        <template #content>
            <div class="bg-box-gray p-5">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Show permissions') }}
                    </div>
                    <div>
                        <button @click="openShowPermissions = !openShowPermissions" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <div>
                    <div class="flex flex-col gap-2">
                        <div v-for="item in roleForPermissionsView?.permissions" :key="item._id" class="flex gap-2 items-end">
                            <div>
                                <UIcon name="i-heroicons-check-circle-16-solid" class="text-blue-500 sm:size-5" />
                            </div>
                            <div class="text-black font-bold! text-[12px]/5 sm:text-[20px]/8">
                                {{ $t(item.name) }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </template>
    </UModal>

</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const state = ref({
    loading: false,
    error: false,
    msg: {
        en: "",
        ar: ""
    }
});

const stateAdd = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

const stateEdit = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

const stateDelete = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

const roles = ref([]);
const permissions = ref([]);
const permissionItems = ref([]);

onMounted(() => {
    getAllInfo();
});

async function getAllInfo() {

    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    getAllPermissions().then(res => {
        if (res) {
            // Mirror the backend's ceiling check (helpers/permissions
            // validateRolePermissionChange): a non-super-admin can only ever
            // grant a permission they already hold themselves, and never
            // "roles_managment" itself regardless of what they hold - so
            // don't even offer those as options here. Super admins are
            // unrestricted, same as on the backend.
            const grantable = store.getIsSuperAdmin
                ? res
                : res.filter(ele =>
                    ele.codeName !== "roles_managment" &&
                    store.getPermissions.includes(ele.codeName)
                );
            permissions.value = grantable;
            permissionItems.value = [];
            grantable.forEach(ele => {
                const myItem = {
                    label: t(ele.name),
                    value: ele._id
                }
                permissionItems.value.push(myItem);
            });
        }
    }).then(() => {
        return getAllRoles().then(res => {
            if (res)
                roles.value = res;
        });
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllPermissions() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/permissions/all`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            state.value.error = true;
            state.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        return response.data.data;
    }
    catch (error) {
        state.value.loading = false;
        state.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        state.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

async function getAllRoles() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/roles/all`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            state.value.error = true;
            state.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        return response.data.data;
    }
    catch (error) {
        state.value.loading = false;
        state.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        state.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

async function getMyRoles() {

    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;
    getAllRoles().then(res => {
        if (res)
            roles.value = res;
    }).then(() => {
        state.value.loading = false;
    });
}

async function addRole() {

    stateAdd.value.loading = true;
    stateAdd.value.error = false;
    stateAdd.value.success = false;
    stateAdd.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/roles/create`;

    const data = {
        name: newRoleData.value.name,
        description: newRoleData.value.description,
        permissions: newRoleData.value.permissions
    }

    try {
        const response = await axios.post(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateAdd.value.loading = false;
            stateAdd.value.error = true;
            stateAdd.value.success = false;
            stateAdd.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateAdd.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getMyRoles();
        openAdd.value = false;
    }
    catch (error) {
        stateAdd.value.loading = false;
        stateAdd.value.error = true;
        stateAdd.value.success = false;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateAdd.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

async function editRole() {

    stateEdit.value.loading = true;
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/roles/update/${editRoleItem.value.id}`;

    const data = {
        name: editRoleItem.value.name,
        description: editRoleItem.value.description,
        permissions: editRoleItem.value.permissions
    }

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateEdit.value.loading = false;
            stateEdit.value.error = true;
            stateEdit.value.success = false;
            stateEdit.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateEdit.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getMyRoles();
        openEdit.value = false;
    }
    catch (error) {
        stateEdit.value.loading = false;
        stateEdit.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEdit.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

async function deleteRole() {

    stateDelete.value.loading = true;
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/roles/delete/${deleteRoleData.value.id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateDelete.value.loading = false;
            stateDelete.value.error = true;
            stateDelete.value.success = false;
            stateDelete.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateDelete.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getMyRoles();
        openDelete.value = false;
    }
    catch (error) {
        stateDelete.value.loading = false;
        stateDelete.value.error = true;
        stateDelete.value.success = false;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateDelete.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

const openAdd = ref(false);
const openDelete = ref(false);
const openEdit = ref(false);
const openShowPermissions = ref(false);

const newRoleData = ref({
    name: "",
    description: "",
    permissions: [],
});

const editRoleItem = ref({
    name: "",
    description: "",
    permissions: [],
    id: ""
});

const deleteRoleData = ref({
    id: "",
});

function showAddModal() {
    newRoleData.value = {
        name: "",
        description: "",
        permissions: [],
    };
    openAdd.value = true;
}

function showEditModal(item) {
    editRoleItem.value = {
        name: item.name,
        description: item.description,
        permissions: [],
        id: item._id
    };
    if (item?.permissions?.length > 0) {
        item?.permissions.forEach(ele => {
            editRoleItem.value.permissions.push(ele._id);
        });
    }
    openEdit.value = true;
}


function showDeleteModal(item) {
    deleteRoleData.value = {
        id: item._id
    };
    openDelete.value = true;
}

const roleForPermissionsView = ref(null);
function showPermissions(item) {
    roleForPermissionsView.value = item;
    openShowPermissions.value = true;
}

</script>
