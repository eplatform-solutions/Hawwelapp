<template>

    <!-- <use-toast v-if="state.error" head="Failed" :body="locale == 'en' ? state.msg.en : state.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast> -->

    <use-toast v-if="stateAdd.error" head="Failed" :body="locale == 'en' ? stateAdd.msg.en : stateAdd.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateAdd.success" head="Success" :body="locale == 'en' ? stateAdd.msg.en : stateAdd.msg.ar"
        color="success" icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateDelete.error" head="Failed" :body="locale == 'en' ? stateDelete.msg.en : stateDelete.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateDelete.success" head="Success"
        :body="locale == 'en' ? stateDelete.msg.en : stateDelete.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateEdit.error" head="Failed" :body="locale == 'en' ? stateEdit.msg.en : stateEdit.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateEdit.success" head="Success" :body="locale == 'en' ? stateEdit.msg.en : stateEdit.msg.ar"
        color="success" icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />
                <vue-tel-input ref="telInputRef" class="hidden!" />

                <div class="pb-10">

                    <div class="mb-4 px-5">
                        <button @click="openAddModal"
                            class="bg-[#B9A779] text-black sm:text-[16px]/8 text-[12px]/5 px-3 py-1 rounded-full font-bold! cursor-pointer">
                            {{ $t('Add new region') }}
                        </button>
                    </div>

                    <!-- search fileds -->
                    <div class="flex gap-10 items-center px-5 mb-5">
                        <input type="text" v-model="search.name"
                            class="bg-white text-black text-[16px]/8 font-bold! px-2 py-1"
                            :placeholder="t('Search by name')">
                    </div>

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
                                @click="getMyAreas">
                                {{ $t("Refresh") }}
                            </button>
                        </div>
                    </div>
                    <div v-else>

                        <div class="mx-5 overflow-auto">

                            <table class="bg-white w-full">

                                <thead>
                                    <tr>
                                        <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("City name") }}
                                        </th>
                                        <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("Country name") }}
                                        </th>
                                        <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("Region name") }}
                                        </th>
                                        <th
                                            class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                            {{ $t("Actions") }}
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr v-for="item in areas" :key="item._id">
                                        <td class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            <span v-if="locale == 'ar'" class="text-black text-[16px]/8 font-bold!">
                                                {{ item.city.name.ar }}
                                            </span>
                                            <span v-else class="text-black text-[16px]/8 font-bold!">
                                                {{ item.city.name.en }}
                                            </span>
                                        </td>
                                        <td class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ item.city.country.name }}
                                        </td>
                                        <td class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            <span v-if="locale == 'ar'" class="text-black text-[16px]/8 font-bold!">
                                                {{ item.name.ar }}
                                            </span>
                                            <span v-else class="text-black text-[16px]/8 font-bold!">
                                                {{ item.name.en }}
                                            </span>
                                        </td>
                                        <td
                                            class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                            <div class="flex justify-center gap-3">
                                                <button class="cursor-pointer" @click="openDeleteModal(item)">
                                                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                                                            fill="#FB0F0F" />
                                                    </svg>
                                                </button>
                                                <button class="cursor-pointer" @click="openEditModal(item)">
                                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                            fill="black" />
                                                    </svg>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>

                        <div class="flex justify-center px-2 my-5">
                            <UPagination v-model:page="page" :total="totalPages * 10"
                                :class="{ 'en-dir': locale == 'ar' }" />
                        </div>

                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

    <!-- modal for add region -->
    <UModal v-model:open="openAdd">

        <template #content>

            <div class="bg-box-gray my-shadow-box-modal p-5 overflow-auto">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Add new region") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openAdd = !openAdd" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <GeoRegionForm v-if="openAdd" mode="create" @success="onRegionCreated" @error="onAddError" />

            </div>

        </template>
    </UModal>

    <!-- modal for edit region -->
    <UModal v-model:open="openEdit">

        <template #content>

            <div class="bg-box-gray my-shadow-box-modal p-5 overflow-auto">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Edit region") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <GeoRegionForm v-if="openEdit" mode="edit" :region-id="editDataItem._id"
                    :initial-country="editDataItem.country" :initial-city="editDataItem.city"
                    :initial-name-ar="editDataItem.nameAr" :initial-name-en="editDataItem.nameEn"
                    @success="onRegionEdited" @error="onEditError" />

            </div>

        </template>
    </UModal>

    <!-- modal for delete -->
    <UModal v-model:open="openDelete">

        <template #content>

            <div class="bg-box-gray p-5">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Delete region") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openDelete = !openDelete" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="deleteRegion" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t("Are you sure you want to delete this region?") }}
                        </div>
                    </div>

                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateDelete.loading" :disabled="stateDelete.loading"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t("Delete") }}
                        </UButton>
                    </div>

                </form>

            </div>

        </template>
    </UModal>

</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

import { VueTelInput } from 'vue-tel-input'
import 'vue-tel-input/vue-tel-input.css'

const telInputRef = ref(null)
const countriesList = ref([]);

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const state = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateAdd = ref({
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEdit = ref({
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

function onRegionCreated(msg) {
    stateAdd.value = { error: false, success: true, msg };
    page.value = 1;
    getMyAreas();
    openAdd.value = false;
}

function onAddError(msg) {
    stateAdd.value = { error: true, success: false, msg };
}

function onRegionEdited(msg) {
    stateEdit.value = { error: false, success: true, msg };
    getMyAreas();
    openEdit.value = false;
}

function onEditError(msg) {
    stateEdit.value = { error: true, success: false, msg };
}

const search = ref({
    name: "",
    city: ""
});

const openAdd = ref(false);
const openEdit = ref(false);
const openDelete = ref(false);

const areas = ref([]);
const totalPages = ref(1);
const page = ref(1);
const pageSize = ref(10);

const getCountryByCode = (code) => {
    return countriesList.value.find(c => c.iso2 === code)
}

onMounted(() => {
    countriesList.value = telInputRef.value.$props.allCountries;
    getMyAreas();
});

async function getMyAreas() {
    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;
    getAllAreas().then(res => {
        if (res) {
            areas.value = [];
            res.regions.forEach(ele => {
                const myCoun = getCountryByCode(ele.city.country.code);
                const myObj = ele;
                myObj.city.country.name = myCoun.name;
                areas.value.push(myObj);
            });
            totalPages.value = Math.ceil(res.regionsCount / 10);
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllAreas() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/regions/all-regions-inside-the-page`;

    let myParams = {
        pageNumber: page.value,
        pageSize: pageSize.value
    }

    if (search.value.name != "")
        myParams.name = search.value.name;


    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
            params: myParams
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

const editDataItem = ref({
    city: "",
    country: "",
    nameAr: "",
    nameEn: "",
    _id: ""
})

function openEditModal(item) {
    editDataItem.value = {
        city: item.city._id,
        country: item.city.country._id,
        nameAr: item.name.ar,
        nameEn: item.name.en,
        _id: item._id
    }
    openEdit.value = true;
}

function openDeleteModal(item) {
    deleteRegionItem.value._id = item._id;
    openDelete.value = true;
}

function openAddModal() {
    openAdd.value = true;
}

const stateDelete = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

const deleteRegionItem = ref({
    _id: "",
});

async function deleteRegion() {


    stateDelete.value.loading = true;
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/regions/delete/${deleteRegionItem.value._id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
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

        page.value = 1;
        getMyAreas();
        openDelete.value = false;
    }
    catch (error) {
        stateDelete.value.loading = false;
        stateDelete.value.error = true;

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

const isResettingPage = ref(false);

watch(
    () => page.value,
    () => {
        if (!isResettingPage.value) {
            getMyAreas();
        }
    }
)


// debounce function
const debounce = (fn, delay) => {
    let timeoutId
    return (...args) => {
        clearTimeout(timeoutId)
        timeoutId = setTimeout(() => fn(...args), delay)
    }
}

// debounced version
const debouncedRefresh = debounce(() => {
    getMyAreas();
}, 500)

// watch
watch(
    () => ({ ...search.value }),
    async () => {
        isResettingPage.value = true;
        page.value = 1;

        await nextTick();
        debouncedRefresh()

        isResettingPage.value = false;
    },
    { deep: true }
)

</script>