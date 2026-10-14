<template>

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
        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">
            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div
                    class="md:flex justify-between w-full flex-row-reverse px-4 items-center bg-[#d8d8d8] py-5 border-b border-black">

                    <div class="md:mb-0 mb-4 text-center">
                        <button @click="showAddModal"
                            class="bg-[#B9A779] text-black sm:text-[16px]/8 text-[12px]/5 px-3 py-1 rounded-full font-bold! cursor-pointer">
                            {{ $t('Add employee') }}
                        </button>
                    </div>

                    <div class="sm:flex items-center flex-row-reverse justify-between gap-3 lg:gap-5">
                        <div
                            class="flex items-center flex-row-reverse flex-wrap justify-center sm:justify-between gap-3 lg:gap-5 sm:mb-0 mb-4">

                            <div class="relative inline-block">
                                <button @click="toggleDropdownState"
                                    class="flex flex-row-reverse gap-2 items-center bg-[#B9A779] px-3 py-1 rounded-full cursor-pointer w-full min-w-30">
                                    <div class="transform transition-transform duration-200"
                                        :class="{ 'rotate-180': showDropdownState }">
                                        <svg width="13" height="8" viewBox="0 0 13 8" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M6.36391 4.94972L11.3137 0L12.7279 1.41421L6.36391 7.77822L0 1.41421L1.41421 0L6.36391 4.94972Z"
                                                fill="black" />
                                        </svg>
                                    </div>
                                    <div
                                        class="text-black sm:text-[16px]/8 text-[12px]/5 font-bold! flex-1 text-center">
                                        {{ selectedOptionState || $t('status') }}
                                    </div>
                                </button>
                                <div v-if="showDropdownState"
                                    class="absolute top-full mt-2 right-0 z-50 bg-white border border-gray-300 rounded-lg shadow-xl min-w-37.5">
                                    <div class="py-2">
                                        <div v-for="option in optionsState" :key="option.value"
                                            @click="selectOptionState(option)"
                                            class="px-4 py-2 hover:bg-gray-100 cursor-pointer flex items-center justify-between gap-3"
                                            :class="{ 'bg-[#B9A779] bg-opacity-20': selectedOptionState === option.label }">
                                            <span class="text-black text-[14px] font-medium">{{ option.label }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div v-if="cities?.length > 0" class="relative inline-block">
                                <button @click="toggleDropdownCity"
                                    class="flex flex-row-reverse gap-2 items-center bg-[#B9A779] px-3 py-1 rounded-full cursor-pointer w-full min-w-30">
                                    <div class="transform transition-transform duration-200"
                                        :class="{ 'rotate-180': showDropdownCity }">
                                        <svg width="13" height="8" viewBox="0 0 13 8" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M6.36391 4.94972L11.3137 0L12.7279 1.41421L6.36391 7.77822L0 1.41421L1.41421 0L6.36391 4.94972Z"
                                                fill="black" />
                                        </svg>
                                    </div>
                                    <div
                                        class="text-black sm:text-[16px]/8 text-[12px]/5 font-bold! flex-1 text-center">
                                        {{ selectedOptionCity || $t('city') }}
                                    </div>
                                </button>
                                <div v-if="showDropdownCity"
                                    class="absolute top-full mt-2 right-0 z-50 bg-white border border-gray-300 rounded-lg shadow-xl min-w-37.5">
                                    <div class="py-2">
                                        <div v-for="option in optionsCity" :key="option.value"
                                            @click="selectOptionCity(option)"
                                            class="px-4 py-2 hover:bg-gray-100 cursor-pointer flex items-center justify-between gap-3"
                                            :class="{ 'bg-[#B9A779] bg-opacity-20': selectedOptionCity === option.label }">
                                            <span class="text-black text-[14px] font-medium">{{ option.label }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="flex justify-center">
                            <input type="text" v-model="search.fullName"
                                class="border-[#6B1F2A] sm:text-[16px]/8 text-[12px]/5 bg-[#F5F5F5] border-2 text-black font-bold! px-3 py-1 rounded-full"
                                :placeholder="$t('search')">
                        </div>
                    </div>
                </div>

                <div>
                    <div v-if="state.loading" class="flex justify-center items-center py-10">
                        <div>
                            <LoadingIcon />
                        </div>
                    </div>
                    <div v-else-if="state.error" class="flex justify-center flex-col gap-4 items-center py-10">
                        <div class="text-[16px]/8 text-red-500 font-bold!">
                            <span v-if="locale == 'ar'"> {{ $t(state.msg.ar) }} </span>
                            <span v-else> {{ $t(state.msg.en) }} </span>
                        </div>
                        <div class="flex justify-center">
                            <button
                                class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                @click="getAllInfo">
                                {{ $t("Refresh") }}
                            </button>
                        </div>
                    </div>
                    <div v-else class="bg-role-tabel">
                        <div class="bg-role-table overflow-auto pb-4 pt-2">
                            <table class="w-full">
                                <thead>
                                    <tr>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('fullName') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('email') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('phoneNumber') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('city') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('status') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('joinDate') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('actions') }}
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in employees" :key="item._id">
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.fullName }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.email }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.mobilePhone }}
                                        </td>
                                        <td class="px-3 sm:px-5 text-center whitespace-nowrap">
                                            <div
                                                class="bg-white rounded-3xl text-black font-bold! text-[10px]/5 sm:text-[12px]/8 px-3">
                                                {{ item.city ? (locale == 'ar' ? item.city.name?.ar : item.city.name?.en) : '-------' }}
                                            </div>
                                        </td>
                                        <td class="px-3 sm:px-5 text-center whitespace-nowrap">
                                            <div
                                                class="bg-white rounded-3xl text-black font-bold! text-[10px]/5 sm:text-[12px]/8 px-3">
                                                {{ $t(item.status) }}
                                            </div>
                                        </td>
                                        <td>
                                            <div v-if="item.createdAt"
                                                class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center pb-1 sm:pb-2 whitespace-nowrap">
                                                {{ item.createdAt.split('T')[0] }}
                                            </div>
                                            <div v-else
                                                class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center pb-1 sm:pb-2 whitespace-nowrap">
                                                -------
                                            </div>
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center pb-1 sm:pb-2 whitespace-nowrap">
                                            <div class="flex gap-2 flex-row-reverse justify-center items-center">
                                                <div>
                                                    <button class="cursor-pointer" @click="showEditModal(item)">
                                                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                                            xmlns="http://www.w3.org/2000/svg">
                                                            <path
                                                                d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                                fill="black" />
                                                        </svg>
                                                    </button>
                                                </div>
                                                <div>
                                                    <button class="cursor-pointer" @click="showDeleteModal(item)">
                                                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none"
                                                            xmlns="http://www.w3.org/2000/svg">
                                                            <path
                                                                d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                                                                fill="#FB0F0F" />
                                                        </svg>
                                                    </button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="py-10 flex justify-center" :class="{ 'en-dir': locale == 'ar' }">
                            <UPagination v-model:page="page" :total="totalPages" />
                        </div>
                    </div>
                </div>
            </div>

            <MyNavbar></MyNavbar>

        </div>
    </div>

    <!-- add new employee -->
    <UModal v-model:open="openAdd">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Add employee') }}
                    </div>
                    <div>
                        <button @click="openAdd = !openAdd" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="addNewEmployee" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="emp-full-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('fullName') }}
                        </label>
                        <input id="emp-full-name" type="text" v-model="newEmployeeData.fullName" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="emp-email" class="text-black font-bold! text-[14px]/8">
                            {{ $t('email') }}
                        </label>
                        <input id="emp-email" type="email" v-model="newEmployeeData.email" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="emp-phone" class="text-black font-bold! text-[14px]/8">
                            {{ $t('phoneNumber') }}
                        </label>
                        <input id="emp-phone" type="number" v-model="newEmployeeData.mobilePhone" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="emp-password" class="text-black font-bold! text-[14px]/8">
                            {{ $t('password') }}
                        </label>
                        <div class="relative">
                            <input id="emp-password" type="password" v-model="newEmployeeData.password" required
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                            <button type="button" @click="switchIcon('emp-password')"
                                class="absolute top-2 sm:top-4 cursor-pointer"
                                :class="{ 'left-2': locale == 'ar', 'right-2': locale == 'en' }">
                                <UIcon v-if="isShowPass" name="i-heroicons-eye-slash-16-solid" class="size-5" />
                                <UIcon v-else name="i-heroicons-eye-16-solid" class="size-5" />
                            </button>
                        </div>
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="emp-city" class="text-black font-bold! text-[14px]/8">
                            {{ $t('city') }}
                        </label>
                        <select v-model="newEmployeeData.city" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                            <option value="" disabled>{{ $t('Select city') }}</option>
                            <option v-for="item in citiesForSelect" :key="item.value" :value="item.value"
                                class="text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                                {{ item.label }}
                            </option>
                        </select>
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateAdd.loading" :disabled="stateAdd.loading"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('add') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- edit employee -->
    <UModal v-model:open="openEdit">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Edit employee') }}
                    </div>
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="editEmployee" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-full-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('fullName') }}
                        </label>
                        <input id="edit-full-name" type="text" v-model="editEmployeeData.fullName" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-email" class="text-black font-bold! text-[14px]/8">
                            {{ $t('email') }}
                        </label>
                        <input id="edit-email" type="email" v-model="editEmployeeData.email" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-phone" class="text-black font-bold! text-[14px]/8">
                            {{ $t('phoneNumber') }}
                        </label>
                        <input id="edit-phone" type="number" v-model="editEmployeeData.mobilePhone" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-city" class="text-black font-bold! text-[14px]/8">
                            {{ $t('city') }}
                        </label>
                        <select v-model="editEmployeeData.city"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                            <option v-for="item in citiesForSelect" :key="item.value" :value="item.value"
                                class="text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                                {{ item.label }}
                            </option>
                        </select>
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-status" class="text-black font-bold! text-[14px]/8">
                            {{ $t('status') }}
                        </label>
                        <select v-model="editEmployeeData.status"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                            <option value="active">{{ $t('active') }}</option>
                            <option value="suspended">{{ $t('suspended') }}</option>
                            <option value="blocked">{{ $t('blocked') }}</option>
                        </select>
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateEdit.loading"
                            :disabled="(stateEdit.loading) || (checkLastEdit.email == editEmployeeData.email && checkLastEdit.fullName == editEmployeeData.fullName && checkLastEdit.mobilePhone == editEmployeeData.mobilePhone && checkLastEdit.city == editEmployeeData.city && checkLastEdit.status == editEmployeeData.status)"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('Edit') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- delete employee -->
    <UModal v-model:open="openDelete">
        <template #content>
            <div class="bg-box-gray p-5">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Delete employee') }}
                    </div>
                    <div>
                        <button @click="openDelete = !openDelete" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="deleteEmployee" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t('Are you sure you want to delete this employee?') }}
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

</template>

<script setup>
const { axios, router, route, store, authUser, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const toast = useToast();
const state = ref({
    loading: false,
    error: false,
    msg: { en: "", ar: "" }
});

const newEmployeeData = ref({
    fullName: "",
    email: "",
    mobilePhone: "",
    password: "",
    city: "",
});

const editEmployeeData = ref({
    fullName: "",
    email: "",
    mobilePhone: "",
    city: "",
    status: "",
    id: ""
});

const checkLastEdit = ref({
    fullName: "",
    email: "",
    mobilePhone: "",
    city: "",
    status: "",
    id: ""
});

const openAdd = ref(false);
const openEdit = ref(false);
const openDelete = ref(false);

const showDropdownState = ref(false);
const showDropdownCity = ref(false);
const selectedOptionState = ref('');
const selectedOptionCity = ref('');

const search = ref({
    state: "",
    city: "",
    fullName: "",
});

const optionsState = computed(() => [
    { value: '', label: t('All status') },
    { value: 'active', label: t('active') },
    { value: 'blocked', label: t('blocked') }
]);

const optionsCity = ref([{ value: "", label: t('All cities') }]);
const citiesForSelect = ref([]);

const toggleDropdownState = () => { showDropdownState.value = !showDropdownState.value; }
const toggleDropdownCity = () => { showDropdownCity.value = !showDropdownCity.value; }

const selectOptionState = (option) => {
    search.value.state = option.value;
    selectedOptionState.value = option.label;
    showDropdownState.value = false;
}

const selectOptionCity = (option) => {
    search.value.city = option.value;
    selectedOptionCity.value = option.label;
    showDropdownCity.value = false;
}

const handleClickOutside = (event) => {
    if (!event.target.closest('.relative')) {
        showDropdownState.value = false;
        showDropdownCity.value = false;
    }
}

const employees = ref([]);
const cities = ref([]);
const totalPages = ref(0);
const page = ref(1);

onMounted(() => {
    getAllInfo();
});

async function getAllInfo() {
    state.value.loading = true;
    state.value.error = false;
    state.value.msg = { ar: "", en: "" };

    getAllCities().then(res => {
        if (res?.length > 0) {
            cities.value = res;
            optionsCity.value = [{ value: "", label: t('All cities') }];
            citiesForSelect.value = [];
            res.forEach(ele => {
                const myItem = {
                    value: ele._id,
                    label: locale.value == 'ar' ? ele.name?.ar : ele.name?.en
                };
                optionsCity.value.push(myItem);
                citiesForSelect.value.push(myItem);
            });
        }
    }).then(() => {
        getAllEmployees().then(res => {
            if (res) {
                employees.value = res.employees;
                totalPages.value = Math.ceil(res.employeesCount / 10);
            }
        }).then(() => {
            state.value.loading = false;
        });
    });
}

async function getAllCities() {
    const token = store.getToken;
    const apiUrl = `${BASE_URL}/cities/all-cities-inside-the-page`;

    try {
        const response = await axios.get(apiUrl, {
            headers: { 'Authorization': `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 1000 }
        });

        if (response.data.error) {
            return [];
        }
        return response.data.data?.cities || [];
    }
    catch (error) {
        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }
        return [];
    }
}

async function getAllEmployees() {
    const token = store.getToken;
    const apiUrl = `${BASE_URL}/employees/all-employees-inside-the-page`;

    let myParams = {
        pageNumber: page.value,
        pageSize: 10
    };

    if (search.value.state != "") myParams.status = search.value.state;
    if (search.value.city != "") myParams.city = search.value.city;
    if (search.value.fullName != "") myParams.fullName = search.value.fullName;

    try {
        const response = await axios.get(apiUrl, {
            headers: { 'Authorization': `Bearer ${token}` },
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

        state.value.msg = { ar: errorMessage, en: errorMessage };
    }
}

async function getMyEmployees() {
    state.value.loading = true;
    state.value.error = false;
    state.value.msg = { ar: "", en: "" };
    getAllEmployees().then(res => {
        if (res) {
            employees.value = res.employees;
            totalPages.value = Math.ceil(res.employeesCount / 10);
        }
    }).then(() => {
        state.value.loading = false;
    });
}

function showAddModal() {
    if (citiesForSelect.value?.length == 0) {
        stateAdd.value.error = false;
        stateAdd.value.msg = {
            ar: "يرجى إضافة مدينة واحدة على الأقل قبل إضافة موظف جديد.",
            en: "Please add at least one city before adding a new employee"
        };
        nextTick(() => { stateAdd.value.error = true; });
        return;
    }
    newEmployeeData.value = { fullName: "", email: "", mobilePhone: "", password: "", city: "" };
    openAdd.value = true;
}

function showEditModal(item) {
    editEmployeeData.value = {
        fullName: item.fullName,
        email: item.email,
        mobilePhone: Number(item.mobilePhone),
        city: item.city?._id,
        status: item.status,
        id: item._id
    };
    checkLastEdit.value = { ...editEmployeeData.value };
    openEdit.value = true;
}

const deleteEmployeeItem = ref({ id: "" });

function showDeleteModal(item) {
    openDelete.value = true;
    deleteEmployeeItem.value.id = item._id;
}

const isValidSyrianPhone = (num) => {
    const cleanNum = String(num).replace(/[\s-_]/g, '');
    return /^9639[986543]\d{7}$/.test(cleanNum);
};

const isStrongPassword = (password) => {
    if (password.length < 8) return false;
    return /[A-Z]/.test(password) && /[a-z]/.test(password) && /\d/.test(password) && /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);
};

// Add
const stateAdd = ref({ loading: false, error: false, success: false, msg: { ar: "", en: "" } });

async function addNewEmployee() {
    newEmployeeData.value.mobilePhone = String(newEmployeeData.value.mobilePhone);
    if (!isValidSyrianPhone(newEmployeeData.value.mobilePhone)) {
        toast.add({ title: locale.value == 'en' ? 'Failed' : 'فشل', description: locale.value == 'en' ? 'Phone number is not valid' : 'رقم الهاتف غير صالح', color: "error" });
        return;
    }
    if (!isStrongPassword(newEmployeeData.value.password)) {
        toast.add({ title: locale.value == 'en' ? 'Failed' : 'فشل', description: locale.value == 'en' ? 'The password must contain at least one number, one lowercase, one uppercase, one symbol, and be at least 8 characters.' : 'يجب ان تحتوي كلمة المرور على رقم وحرف صغير وحرف كبير ورمز وان يكون طولها 8 محارف على الاقل', color: "error" });
        return;
    }
    if (newEmployeeData.value.city == "") {
        toast.add({ title: locale.value == 'en' ? 'Failed' : 'فشل', description: locale.value == 'en' ? 'You must choose a city' : 'يجب ان تختار مدينة', color: "error" });
        return;
    }

    stateAdd.value.loading = true;
    stateAdd.value.error = false;
    stateAdd.value.success = false;
    stateAdd.value.msg = { ar: "", en: "" };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/employees/create`;

    try {
        const response = await axios.post(apiUrl, {
            email: newEmployeeData.value.email,
            password: newEmployeeData.value.password,
            fullName: newEmployeeData.value.fullName,
            mobilePhone: `+${newEmployeeData.value.mobilePhone}`,
            city: newEmployeeData.value.city
        }, { headers: { 'Authorization': `Bearer ${token}` } });

        stateAdd.value.loading = false;

        if (!response.data.error) {
            stateAdd.value.success = true;
            stateAdd.value.msg = { en: response.data.msg.en, ar: response.data.msg.ar };
        } else {
            stateAdd.value.error = true;
            stateAdd.value.msg = { en: response.data.msg.en, ar: response.data.msg.ar };
            return;
        }

        getMyEmployees();
        openAdd.value = false;
    }
    catch (error) {
        stateAdd.value.loading = false;
        stateAdd.value.error = true;
        const errorMessage = handelErrorType(error);
        stateAdd.value.msg = { en: errorMessage, ar: errorMessage };
    }
}

// Edit
const stateEdit = ref({ loading: false, error: false, success: false, msg: { ar: "", en: "" } });

async function editEmployee() {
    editEmployeeData.value.mobilePhone = String(editEmployeeData.value.mobilePhone);
    if (!isValidSyrianPhone(editEmployeeData.value.mobilePhone)) {
        toast.add({ title: locale.value == 'en' ? 'Failed' : 'فشل', description: locale.value == 'en' ? 'Phone number is not valid' : 'رقم الهاتف غير صالح', color: "error" });
        return;
    }

    stateEdit.value.loading = true;
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = { ar: "", en: "" };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/employees/update/${editEmployeeData.value.id}`;

    let data = {};
    if (checkLastEdit.value.email != editEmployeeData.value.email) data.email = editEmployeeData.value.email;
    if (checkLastEdit.value.fullName != editEmployeeData.value.fullName) data.fullName = editEmployeeData.value.fullName;
    if (checkLastEdit.value.status != editEmployeeData.value.status) data.status = editEmployeeData.value.status;
    if (checkLastEdit.value.mobilePhone != editEmployeeData.value.mobilePhone) data.mobilePhone = `+${editEmployeeData.value.mobilePhone}`;
    if (checkLastEdit.value.city != editEmployeeData.value.city) data.city = editEmployeeData.value.city;

    try {
        const response = await axios.put(apiUrl, data, {
            headers: { 'Authorization': `Bearer ${token}` }
        });

        stateEdit.value.loading = false;

        if (!response.data.error) {
            stateEdit.value.success = true;
            stateEdit.value.msg = { en: response.data.msg.en, ar: response.data.msg.ar };
        } else {
            stateEdit.value.error = true;
            stateEdit.value.msg = { en: response.data.msg.en, ar: response.data.msg.ar };
            return;
        }

        getMyEmployees();
        openEdit.value = false;
    }
    catch (error) {
        stateEdit.value.loading = false;
        stateEdit.value.error = true;
        const errorMessage = handelErrorType(error);
        stateEdit.value.msg = { en: errorMessage, ar: errorMessage };
    }
}

// Delete
const stateDelete = ref({ loading: false, error: false, success: false, msg: { ar: "", en: "" } });

async function deleteEmployee() {
    stateDelete.value.loading = true;
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = { ar: "", en: "" };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/employees/delete/${deleteEmployeeItem.value.id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: { 'Authorization': `Bearer ${token}` }
        });

        stateDelete.value.loading = false;

        if (!response.data.error) {
            stateDelete.value.success = true;
            stateDelete.value.msg = { en: response.data.msg.en, ar: response.data.msg.ar };
        } else {
            stateDelete.value.error = true;
            stateDelete.value.msg = { en: response.data.msg.en, ar: response.data.msg.ar };
            return;
        }

        page.value = 1;
        getMyEmployees();
        openDelete.value = false;
    }
    catch (error) {
        stateDelete.value.loading = false;
        stateDelete.value.error = true;
        const errorMessage = handelErrorType(error);
        stateDelete.value.msg = { en: errorMessage, ar: errorMessage };
    }
}

watch(() => page.value, () => { getMyEmployees(); });
watch(() => search.value.state, () => { getMyEmployees(); });
watch(() => search.value.city, () => { getMyEmployees(); });
watch(() => search.value.fullName, () => { getMyEmployees(); });

const isShowPass = ref(false);

function switchIcon(ele) {
    let inputEle = document.getElementById(ele);
    if (inputEle.type == 'password') {
        inputEle.type = "text";
        isShowPass.value = true;
    } else {
        inputEle.type = "password";
        isShowPass.value = false;
    }
}

onMounted(() => {
    document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside);
});
</script>