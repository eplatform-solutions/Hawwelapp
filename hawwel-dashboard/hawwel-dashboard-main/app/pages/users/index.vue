<template>

    <!-- <use-toast v-if="state.error" head="Error" :body="locale == 'en' ? state.msg.en : state.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast> -->

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

                <vue-tel-input ref="telInputRef" v-model="phone" class="hidden!"></vue-tel-input>

                <div>

                    <!-- fast filter -->
                    <div class="flex flex-wrap justify-center gap-3 sm:gap-10 items-center px-5 mb-7">

                        <div class="flex flex-wrap justify-center gap-3 sm:gap-10">
                            <input type="text" v-model="search.name"
                                class="bg-white text-black text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 py-1 w-40"
                                :placeholder="t('Search by name')">
                            <input type="text" v-model="search.mobilePhone"
                                class="bg-white text-black text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 py-1 w-40"
                                :placeholder="t('Search by phone number')">
                            <input type="text" v-model="search.accountNumber"
                                class="bg-white text-black text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 py-1 w-40"
                                :placeholder="t('Search by ID')">
                            <!-- <select v-model="search.country"
                                class="bg-white text-black text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 py-1 w-40" required>

                                <option value="" disabled selected hidden
                                    class="text-gray-500 text-[12px]/5 sm:text-[16px]/8 font-bold!">
                                    {{ $t("Select country") }}
                                </option>

                                <option v-for="item in countriesList" :key="item._id" :value="item.iso2"
                                    class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!">
                                    {{ item.name }}
                                </option>
                            </select> -->
                            <div class="relative">

                                <div @click="dropdownOpen = !dropdownOpen"
                                    class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! px-3 py-2 cursor-pointer min-w-60 h-full">
                                    <div class="flex justify-between items-center">
                                        <div>{{ selectedCountryName || $t('Choose country') }}</div>
                                        <div>
                                            <svg width="21" height="15" viewBox="0 0 21 15" fill="none"
                                                class="h-2 sm:h-3" xmlns="http://www.w3.org/2000/svg">
                                                <path
                                                    d="M10.0717 15L0 3.7501L3.35721 0L10.0717 7.50007L16.786 0L20.1432 3.7501L10.0717 15Z"
                                                    fill="black" />
                                            </svg>
                                        </div>
                                    </div>
                                </div>

                                <div v-if="dropdownOpen"
                                    class="absolute top-full left-0 w-full bg-white shadow-lg mt-1 rounded-xl z-50">

                                    <div class="p-2">
                                        <input v-model="countrySearch" type="text" :placeholder="$t('search...')"
                                            class="w-full px-3 py-2 border rounded-lg text-sm" @click.stop />
                                    </div>

                                    <ul class="max-h-60 overflow-y-auto">
                                        <li v-if="countrySearch == ''" @click="selectCountry({ iso: '' })"
                                            class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-sm">
                                            {{ $t("All countries") }}
                                        </li>
                                        <li v-for="item in filteredCountries" :key="item.iso2"
                                            @click="selectCountry(item)"
                                            class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-sm">
                                            {{ item.name }}
                                        </li>
                                        <li v-if="filteredCountries.length === 0" class="px-4 py-2 text-gray-500">
                                            {{ $t("No results found") }}
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-wrap justify-center gap-5">
                            <div class="flex items-center gap-1">
                                <div class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!">
                                    {{ $t("Start date:") }}
                                </div>
                                <div>
                                    <input type="date" v-model="search.fromDate"
                                        class="border-black bg-white text-black text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 py-1"
                                        placeholder="Start date">
                                </div>
                            </div>
                            <div class="flex items-center gap-1">
                                <div class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!">
                                    {{ $t("End date:") }}
                                </div>
                                <div>
                                    <input type="date" v-model="search.toDate"
                                        class="bg-white text-black text-[12px]/5 sm:text-[16px]/8 font-bold! px-2 py-1"
                                        placeholder="End date">
                                </div>
                            </div>

                        </div>

                        <div class="flex bg-white px-2 py-1">
                            <div class="w-32 flex justify-center items-center"
                                :class="{ 'border-l-2': locale == 'ar', 'border-r-2': locale == 'en' }">
                                <div class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!">
                                    {{ $t("State") }}
                                </div>
                            </div>
                            <div class="flex gap-4 px-5">

                                <button @click="search.status = ''"
                                    class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                    :class="{ 'text-[#008E79]!': search.status == '' }">
                                    {{ $t("All") }}
                                </button>

                                <button @click="search.status = 'active'"
                                    class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                    :class="{ 'text-[#008E79]!': search.status == 'active' }">
                                    {{ $t("Active") }}
                                </button>

                                <button @click="search.status = 'blocked'"
                                    class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                    :class="{ 'text-[#008E79]!': search.status == 'blocked' }">
                                    {{ $t("Blocked") }}
                                </button>

                            </div>
                        </div>

                    </div>

                    <div class="mb-5 flex justify-center mx-3">
                        <button @click="page = 1; getAllInfo()"
                            class="text-black text-[11px]/5 sm:text-[14px]/8 font-bold! cursor-pointer bg-[#B9A779CF] border border-[#6B1F2A] rounded-xl px-5 py-1">
                            {{ $t("Filter") }}
                        </button>
                    </div>

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

                    <!-- table -->
                    <div v-else class="px-3 md:px-10">
                        <div class="mb-5 overflow-auto">

                            <table class="bg-white w-full overflow-auto">

                                <thead>
                                    <tr>
                                        <th class="border-b border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap w-36"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("Account number") }}
                                        </th>
                                        <th class="border-b border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap w-40"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("Name") }}
                                        </th>
                                        <th class="border-b border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap w-60"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("Phone") }}
                                        </th>
                                        <th class="border-b border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap w-40"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("Country") }}
                                        </th>
                                        <th class="border-b border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap w-60"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("State") }}
                                        </th>
                                        <th
                                            class="border-b border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap w-60">
                                            {{ $t("Actions") }}
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr v-for="item in users" :key="item._id">
                                        <td class="border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ item.accountNumber }}
                                        </td>
                                        <td class="border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ getUserDisplayName(item) }}
                                        </td>
                                        <td class="border-black px-5 en-dir text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ item.mobilePhone }}
                                        </td>
                                        <td class="border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ item.countryName.name }}
                                        </td>
                                        <td class="border-black px-5 text-black text-[14px]/8 py-2 font-bold! text-center whitespace-nowrap"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t(item.status) }}
                                        </td>
                                        <td
                                            class="text-black text-[16px]/8 font-bold text-center px-4 py-2 whitespace-nowrap">
                                            <div class="flex justify-center gap-7">
                                                <button class="cursor-pointer" @click="showDeleteModel(item)">
                                                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                                                            fill="#FB0F0F" />
                                                    </svg>

                                                </button>
                                                <button class="cursor-pointer" @click="showEditModel(item)">
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

                        <div class="flex flex-wrap gap-3 justify-center md:justify-start px-10 pb-10">

                            <div class="text-black text-[16px]/8 font-bold!">
                                {{ $t("Page size:") }}
                            </div>

                            <div class="mx-5">
                                <select v-model="numberOfFieldsInOnePage" class="bg-white text-black font-bold!">
                                    <option value="25"
                                        class="bg-[#D9D9D9] text-[18px]/5 text-black font-bold! px-2 py-1">
                                        25
                                    </option>
                                    <option value="50"
                                        class="bg-[#D9D9D9] text-[18px]/5 text-black font-bold! px-2 py-1">
                                        50
                                    </option>
                                    <option value="75"
                                        class="bg-[#D9D9D9] text-[18px]/5 text-black font-bold! px-2 py-1">
                                        75
                                    </option>
                                    <option value="100"
                                        class="bg-[#D9D9D9] text-[18px]/5 text-black font-bold! px-2 py-1">
                                        100
                                    </option>
                                </select>
                            </div>

                            <div class="flex gap-2 text-[#4A4949] text-[16px]/8 font-bold! mx-5">
                                <div>
                                    {{ $t("Number") }}
                                </div>
                                <div>
                                    {{ totalNumberOfFields }}-{{ currentFields }}
                                </div>
                            </div>

                            <div class="flex mx-5 items-center gap-5" :class="{ 'flex-row-reverse': locale == 'en' }">
                                <div>
                                    <UButton @click="nextPage"
                                        class="cursor-pointer bg-transparent disabled:bg-transparent hover:bg-transparent"
                                        :disabled="(currentPage * numberOfFieldsInOnePage) >= totalNumberOfFields">
                                        <svg width="15" height="15" viewBox="0 0 15 15" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M7.50005 7.50008L0 2.50001L3.75008 0L15 7.50008L3.75008 15L0 12.5L7.50005 7.50008Z"
                                                fill="black" />
                                        </svg>
                                    </UButton>
                                </div>

                                <div class="px-3 bg-black text-[#F5F5F5] text-[20px]/8 font-bold!">
                                    {{ currentPage }}
                                </div>

                                <div>
                                    <UButton @click="previousPage"
                                        class="cursor-pointer bg-transparent disabled:bg-transparent hover:bg-transparent"
                                        :disabled="currentPage <= 1">
                                        <svg width="15" height="15" viewBox="0 0 15 15" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M7.49987 7.50008L15 12.5L11.2498 15L0 7.50008L11.2498 0L15 2.50001L7.49987 7.50008Z"
                                                fill="black" />
                                        </svg>
                                    </UButton>
                                </div>
                            </div>

                        </div>

                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

    <!-- modal for edit user -->
    <UModal v-model:open="openEdit">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Edit user info') }}
                    </div>
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="editUser" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="mb-3">
                        <div for="user-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Select country') }}
                        </div>
                        <select v-model="editUserData.country"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8"
                            required>

                            <option value="" disabled selected hidden class="text-gray-500 text-[16px]/8 font-bold!">
                                {{ $t("Select country") }}
                            </option>

                            <!-- countries -->
                            <option v-for="item in countriesList" :key="item._id" :value="item.iso2"
                                class="text-black text-[16px]/8 font-bold!">
                                {{ item.name }}
                            </option>
                        </select>
                    </div>

                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Name') }}
                        </label>
                        <input id="user-name" type="text" v-model="editUserData.name" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-nickname" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Nick name') }}
                        </label>
                        <input id="user-nickname" type="text" v-model="editUserData.nickname" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-fatherName" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Father name') }}
                        </label>
                        <input id="user-fatherName" type="text" v-model="editUserData.fatherName" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-mobilePhone" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Mobile phone') }}
                        </label>
                        <input id="user-mobilePhone" type="text" v-model="editUserData.mobilePhone" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-black font-bold! text-[14px]/8">
                            {{ $t('Select status') }}
                        </div>
                        <select v-model="editUserData.status"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8">
                            <option value="active">
                                {{ $t("Active") }}
                            </option>
                            <option value="blocked">
                                {{ $t("Blocked") }}
                            </option>
                        </select>
                    </div>
                    <div v-if="editUserData.status == 'blocked'" class="flex flex-col gap-2 mb-5">
                        <label for="user-block" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Write the reason for the block') }}
                        </label>
                        <input id="user-block" type="text" v-model="editUserData.blockReason" :required="copyOfUserData.status != 'blocked'"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateEdit.loading" :disabled="stateEdit.loading"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('Edit') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- modal for delete user -->
    <UModal v-model:open="openDelete">

        <template #content>

            <div class="bg-box-gray p-5">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Delete user") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openDelete = !openDelete" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="deleteUser" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t("Are you sure you want to delete this user?") }}
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

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});
import { VueTelInput } from 'vue-tel-input'
import 'vue-tel-input/vue-tel-input.css'

const telInputRef = ref(null)
const countriesList = ref([]);
const counItems = ref([]);

onMounted(() => {
    countriesList.value = telInputRef.value.$props.allCountries;
    getAllInfo();
});

const getCountryByCode = (code) => {
    return countriesList.value.find(c => c.iso2 === code)
}


const numberOfFieldsInOnePage = ref(25);
const totalNumberOfFields = ref(0);
const currentFields = ref(25);
const currentPage = ref(1);

const isNextButtonDisabled = computed(() => {
    return currentFields.value >= totalNumberOfFields.value;
});

function nextPage() {
    if (currentPage.value < totalNumberOfFields.value) {
        currentPage.value += 1;
        const newVal = Math.min(
            numberOfFieldsInOnePage.value * currentPage.value,
            totalNumberOfFields.value
        );
        currentFields.value = newVal;
        getAllInfo();
    }
}

function previousPage() {
    if (currentPage.value > 1) {
        currentPage.value -= 1;
        const newVal = Math.min(
            numberOfFieldsInOnePage.value * currentPage.value,
            totalNumberOfFields.value
        );
        currentFields.value = newVal;
        getAllInfo();
    }
}

const totalPages = computed(() => {
    return Math.ceil(totalNumberOfFields.value / numberOfFieldsInOnePage.value);
});

watch(
    () => numberOfFieldsInOnePage.value,
    (newValue) => {
        currentPage.value = 1;
        currentFields.value = Math.min(newValue, totalNumberOfFields.value);

    }
);

watch(
    () => totalNumberOfFields.value,
    (newTotal) => {
        if (currentFields.value > newTotal) {
            currentFields.value = Math.min(
                numberOfFieldsInOnePage.value,
                newTotal
            );
            currentPage.value = 1;
        }
    }
);

const state = ref({
    loading: false,
    error: false,
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

const users = ref([]);
const page = ref(1);

const search = ref({
    name: "",
    status: "",
    _id: "",
    accountNumber: "",
    country: "",
    mobilePhone: "",
    email: "",
    fromDate: "",
    toDate: ""
});

onMounted(() => {
    getAllInfo();
});

async function getAllInfo() {

    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    getAllUsers().then(res => {
        if (res) {
            users.value = [];
            res.users.forEach(ele => {
                ele.countryName = getCountryByCode(ele.country);
                users.value.push(ele);
            });
            totalNumberOfFields.value = res.usersCount;
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllUsers() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/users/all-users-inside-the-page`;

    let myPrarms = {
        pageNumber: currentPage.value,
        pageSize: numberOfFieldsInOnePage.value
    };

    if (search.value.name != "")
        myPrarms.name = search.value.name;

    if (search.value.status != "")
        myPrarms.status = search.value.status;

    if (search.value.country != "")
        myPrarms.country = search.value.country;

    if (search.value.accountNumber != "")
        myPrarms.accountNumber = search.value.accountNumber;

    if (search.value.mobilePhone != "")
        myPrarms.mobilePhone = search.value.mobilePhone;

    if (search.value.fromDate != "")
        myPrarms.fromDate = search.value.fromDate;

    if (search.value.toDate != "")
        myPrarms.toDate = search.value.toDate;


    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
            params: myPrarms
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

const copyOfUserData = ref({
    name: "",
    nickname: "",
    fatherName: "",
    country: "",
    mobilePhone: "",
    email: "",
    status: "",
    _id: "",
});

const editUserData = ref({
    name: "",
    nickname: "",
    fatherName: "",
    country: "",
    mobilePhone: "",
    email: "",
    status: "",
    blockReason: "",
    _id: "",
});

const openEdit = ref(false);

function showEditModel(item) {
    editUserData.value = {
        name: item.name,
        nickname: item.nickname,
        fatherName: item.fatherName,
        country: item.country,
        mobilePhone: item.mobilePhone,
        email: item.email,
        status: item.status,
        blockReason: "",
        _id: item._id,
    };
    copyOfUserData.value = {
        name: item.name,
        nickname: item.nickname,
        fatherName: item.fatherName,
        country: item.country,
        mobilePhone: item.mobilePhone,
        email: item.email,
        status: item.status,
        blockReason: "",
        _id: item._id,
    };
    openEdit.value = true;
}

const openDelete = ref(false);
const deleteUserItem = ref({
    _id: "",
});
function showDeleteModel(item) {
    deleteUserItem.value = {
        _id: item._id,
    }
    openDelete.value = true;
}

async function editUser() {

    stateEdit.value.loading = true;
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/users/update/${editUserData.value._id}`;

    let data = {}

    if (copyOfUserData.value.name != editUserData.value.name)
        data.name = editUserData.value.name;
    if (copyOfUserData.value.nickname != editUserData.value.nickname)
        data.nickname = editUserData.value.nickname;
    if (copyOfUserData.value.fatherName != editUserData.value.fatherName)
        data.fatherName = editUserData.value.fatherName;
    if (copyOfUserData.value.country != editUserData.value.country)
        data.country = editUserData.value.country;
    if (copyOfUserData.value.mobilePhone != editUserData.value.mobilePhone)
        data.mobilePhone = editUserData.value.mobilePhone;
    if (copyOfUserData.value.status != editUserData.value.status) {
        data.status = editUserData.value.status;
        if (editUserData.value.status == 'blocked')
            data.blockingReason = editUserData.value.blockReason;
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

        getAllInfo();
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

async function deleteUser() {

    stateDelete.value.loading = true;
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/users/delete/${deleteUserItem.value._id}`;

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

        getAllInfo();
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

watch(
    () => numberOfFieldsInOnePage.value,
    () => {
        getAllInfo();
    }
)

const dropdownOpen = ref(false)
const countrySearch = ref('')

const filteredCountries = computed(() => {
    return countriesList.value.filter(country =>
        country.name.toLowerCase().includes(countrySearch.value.toLowerCase())
    )
})

const selectedCountryName = computed(() => {
    const country = countriesList.value.find(c => c.iso2 === search.value.country)
    return country?.name
})

function getUserDisplayName(item) {
    const name = String(item?.name || "").trim();
    const nickname = String(item?.nickname || "").trim();
    return [name, nickname].filter(Boolean).join(" ") || "-";
}

const selectCountry = (country) => {
    search.value.country = country.iso2
    dropdownOpen.value = false
    countrySearch.value = ''
}

</script>