<template>

    <use-toast v-if="stateDelete.error" head="Failed" :body="locale == 'en' ? stateDelete.msg.en : stateDelete.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateDelete.success" head="Success"
        :body="locale == 'en' ? stateDelete.msg.en : stateDelete.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateDeleteCity.error" head="Failed"
        :body="locale == 'en' ? stateDeleteCity.msg.en : stateDeleteCity.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateDeleteCity.success" head="Success"
        :body="locale == 'en' ? stateDeleteCity.msg.en : stateDeleteCity.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateEditCity.error" head="Failed"
        :body="locale == 'en' ? stateEditCity.msg.en : stateEditCity.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateEditCity.success" head="Success"
        :body="locale == 'en' ? stateEditCity.msg.en : stateEditCity.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateBind.error" head="Failed" :body="locale == 'en' ? stateBind.msg.en : stateBind.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateBind.success" head="Success" :body="locale == 'en' ? stateBind.msg.en : stateBind.msg.ar"
        color="success" icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-coutnry min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />
                <vue-tel-input ref="telInputRef" class="hidden!" />

                <div>

                    <div v-if="stateGetCountries.loading" class="flex justify-center items-center py-10">
                        <div>
                            <LoadingIcon />
                        </div>
                    </div>
                    <div v-else-if="stateGetCountries.error"
                        class="flex justify-center flex-col gap-4 items-center pt-10 pb-20">
                        <div class="text-[16px]/8 text-red-500 font-bold!">
                            <span v-if="locale == 'ar'"> {{ $t(stateGetCountries.msg.ar) }} </span>
                            <span v-else> {{ $t(stateGetCountries.msg.en) }} </span>
                        </div>
                        <div class="flex justify-center">
                            <button
                                class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                @click="getMyCountries">
                                {{ $t("Refresh") }}
                            </button>
                        </div>
                    </div>
                    <div v-else>

                        <div class="mx-2 sm:mx-10 mb-10 bg-white border border-[#E3D9C1] rounded-3xl shadow-sm p-5 sm:p-8">

                            <div class="flex items-center justify-between gap-3 mb-6">
                                <h2 class="text-[19px] sm:text-[21px] font-extrabold text-[#23200F]">
                                    {{ $t("Countries from which shipping is possible") }}
                                </h2>
                                <span class="text-[13px] font-bold text-[#726A54] mono shrink-0">
                                    {{ counItems.length }}
                                </span>
                            </div>

                            <div v-if="counItems.length > 0"
                                class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
                                <div v-for="item in counItems" :key="item.dialCode"
                                    class="flex items-center gap-3 bg-[#F6F2E9] border border-[#E3D9C1] rounded-2xl p-4">

                                    <span class="text-[30px] leading-none shrink-0">{{ isoToFlagEmoji(item.iso2) }}</span>

                                    <div class="min-w-0 flex-1">
                                        <div class="text-[16px] font-extrabold text-[#23200F] truncate">
                                            {{ item.name }}
                                        </div>
                                        <div class="text-[13px] font-bold text-[#726A54] en-dir mono">
                                            +{{ item.dialCode }}
                                        </div>
                                    </div>

                                    <div class="flex items-center gap-1.5 shrink-0">
                                        <button type="button" @click="openBindModal('country', item._id)"
                                            :disabled="bindCheckLoading" :title="$t('Enable payment method')"
                                            class="w-9 h-9 rounded-full flex items-center justify-center bg-[#0B7A68] text-white text-[15px] cursor-pointer hover:brightness-110 disabled:opacity-50 disabled:cursor-not-allowed">
                                            💳
                                        </button>
                                        <button type="button" @click="openDeleteCountryModal(item)"
                                            class="w-9 h-9 rounded-full flex items-center justify-center border border-[#E3D9C1] bg-white text-[#A8383A] cursor-pointer hover:bg-red-50">
                                            <svg width="15" height="15" viewBox="0 0 23 23" fill="none"
                                                xmlns="http://www.w3.org/2000/svg">
                                                <path
                                                    d="M17.25 4.6H23V6.9H20.7V21.85C20.7 22.4851 20.1851 23 19.55 23H3.45C2.81488 23 2.3 22.4851 2.3 21.85V6.9H0V4.6H5.75V1.15C5.75 0.514878 6.26488 0 6.9 0H16.1C16.7351 0 17.25 0.514878 17.25 1.15V4.6ZM18.4 6.9H4.6V20.7H18.4V6.9ZM8.05 10.35H10.35V17.25H8.05V10.35ZM12.65 10.35H14.95V17.25H12.65V10.35ZM8.05 2.3V4.6H14.95V2.3H8.05Z"
                                                    fill="currentColor" />
                                            </svg>
                                        </button>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- add new country/city/region/payment method -->
                    <div class="mx-2 sm:mx-10 mb-10">
                        <NuxtLink to="/quick-setup"
                            class="flex items-center justify-between gap-4 bg-white border border-[#E3D9C1] rounded-3xl shadow-sm p-5 sm:p-6 hover:border-[#0B7A68]/50 transition-colors">
                            <div class="flex items-center gap-3">
                                <span class="text-[28px]">🧭</span>
                                <div>
                                    <div class="text-[16px] sm:text-[17px] font-extrabold text-[#23200F]">
                                        {{ $t("Quick setup") }}
                                    </div>
                                    <div class="text-[13px] text-[#726A54]">
                                        {{ $t("Set up a country, city, region, and payment method in one connected flow.") }}
                                    </div>
                                </div>
                            </div>
                            <span class="shrink-0 bg-[#0B7A68] text-white rounded-full px-5 py-2 text-[13.5px] font-bold!">
                                {{ $t("Start new setup") }}
                            </span>
                        </NuxtLink>
                    </div>

                    <div v-if="stateGetCities.loading" class="flex justify-center items-center py-10">
                        <div>
                            <LoadingIcon />
                        </div>
                    </div>
                    <div v-else-if="stateGetCities.error" class="flex justify-center flex-col gap-4 items-center py-10">
                        <div class="text-[16px]/8 text-red-500 font-bold!">
                            <span v-if="locale == 'ar'"> {{ $t(stateGetCities.msg.ar) }} </span>
                            <span v-else> {{ $t(stateGetCities.msg.en) }} </span>
                        </div>
                        <div class="flex justify-center">
                            <button
                                class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                @click="getMyCities">
                                {{ $t("Refresh") }}
                            </button>
                        </div>
                    </div>

                    <div v-else class="py-6">

                        <div class="mx-2 sm:mx-10 bg-white border border-[#E3D9C1] rounded-3xl shadow-sm overflow-hidden">

                            <div class="overflow-x-auto">
                                <table class="w-full border-collapse">

                                    <thead>
                                        <tr class="bg-[#F6F2E9]">
                                            <th class="text-[#23200F] text-[15px] font-extrabold text-start px-6 py-4 whitespace-nowrap">
                                                {{ $t("City") }}
                                            </th>
                                            <th class="text-[#23200F] text-[15px] font-extrabold text-start px-6 py-4 whitespace-nowrap">
                                                {{ $t("Country") }}
                                            </th>
                                            <th class="text-[#23200F] text-[15px] font-extrabold text-center px-6 py-4 whitespace-nowrap">
                                                {{ $t("Actions") }}
                                            </th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr v-for="item in cities" :key="item._id"
                                            class="border-t border-[#E3D9C1] hover:bg-[#F6F2E9]/60 transition-colors">
                                            <td class="px-6 py-4 whitespace-nowrap text-[16px] font-bold! text-[#23200F]">
                                                {{ locale == 'ar' ? item.name.ar : item.name.en }}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-[15px] font-bold! text-[#23200F]">
                                                <span class="inline-flex items-center gap-2">
                                                    <span class="text-[20px] leading-none">{{ item.countryFlag }}</span>
                                                    <span>{{ item.countryName }}</span>
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="flex justify-center items-center gap-2">
                                                    <button type="button" @click="openBindModal('city', item._id)"
                                                        :disabled="bindCheckLoading" :title="$t('Enable payment method')"
                                                        class="w-9 h-9 rounded-full flex items-center justify-center bg-[#0B7A68] text-white text-[15px] cursor-pointer hover:brightness-110 disabled:opacity-50 disabled:cursor-not-allowed">
                                                        💳
                                                    </button>
                                                    <button type="button" @click="openEditCityModel(item)"
                                                        class="w-9 h-9 rounded-full flex items-center justify-center border border-[#E3D9C1] bg-white text-[#23200F] cursor-pointer hover:bg-[#F6F2E9]">
                                                        <svg width="15" height="15" viewBox="0 0 18 18" fill="none"
                                                            xmlns="http://www.w3.org/2000/svg">
                                                            <path
                                                                d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                                fill="currentColor" />
                                                        </svg>
                                                    </button>
                                                    <button type="button" @click="openDeleteCityModel(item)"
                                                        class="w-9 h-9 rounded-full flex items-center justify-center border border-[#E3D9C1] bg-white text-[#A8383A] cursor-pointer hover:bg-red-50">
                                                        <svg width="15" height="15" viewBox="0 0 20 20" fill="none"
                                                            xmlns="http://www.w3.org/2000/svg">
                                                            <path
                                                                d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                                                                fill="currentColor" />
                                                        </svg>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>

                                </table>
                            </div>

                        </div>
                        <div class="grid w-full">
                            <div class="w-full mt-10 mb-2 overflow-x-auto overflow-y-hidden grid en-dir">
                                <div class="flex justify-center">
                                    <div
                                        class="bg-white px-2 py-1 rounded-xl flex gap-3 items-baseline flex-row-reverse">
                                        <div>
                                            <button class="cursor-pointer" @click="page = page + 1"
                                                :class="{ 'cursor-not-allowed!': page == totalPages }"
                                                :disabled="page == totalPages">
                                                <svg width="16" height="15" viewBox="0 0 16 15" fill="none"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path
                                                        d="M15.0255 7.44204L3.81426 14.9998L0.0513704 12.5191L7.52566 7.48055L1.61971e-05 2.51918L3.73723 -1.77553e-05L15.0255 7.44204Z"
                                                        fill="#0B7A68" />
                                                </svg>
                                            </button>
                                        </div>

                                        <div class="flex justify-center items-center gap-3">
                                            <button v-for="myPage in totalPages" :key="myPage" @click="page = myPage"
                                                :class="{ 'pag-shadow py-2! px-3!': page == myPage }"
                                                class="bg-[#0B7A68] py-1.5 px-3 text-white font-bold! text-[16px] rounded-lg cursor-pointer">
                                                {{ myPage }}
                                            </button>
                                        </div>

                                        <div>
                                            <button class="cursor-pointer" @click="page = page - 1"
                                                :class="{ 'cursor-not-allowed!': page == 1 }" :disabled="page == 1">
                                                <svg width="16" height="15" viewBox="0 0 16 15" fill="none"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path
                                                        d="M1.63099e-05 7.44204L11.2113 14.9998L14.9741 12.5191L7.49985 7.48055L15.0255 2.51918L11.2883 -1.77565e-05L1.63099e-05 7.44204Z"
                                                        fill="#0B7A68" />
                                                </svg>
                                            </button>
                                        </div>
                                    </div>
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

    <!-- modal for delete country -->
    <UModal v-model:open="openDeleteCountry">

        <template #content>

            <div class="bg-box-gray p-5">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Delete country") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openDeleteCountry = !openDeleteCountry" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="deleteCountry" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t("Are you sure you want to delete this country?") }}
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

    <!-- modal for edit city -->
    <UModal v-model:open="openEditCity">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Edit city') }}
                    </div>
                    <div>
                        <button @click="openEditCity = !openEditCity" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="editCity" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="mb-3">
                        <select v-model="cityDataEdit.country"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8"
                            required>

                            <option value="" disabled selected hidden class="text-gray-500 text-[16px]/8 font-bold!">
                                {{ $t("Select country") }}
                            </option>

                            <!-- countries -->
                            <option v-for="item in counItems" :key="item._id" :value="item._id"
                                class="text-black text-[16px]/8 font-bold!">
                                {{ item.name }}
                            </option>
                        </select>
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="city-name-ar" class="text-black font-bold! text-[14px]/8">
                            {{ $t('City name in arabic') }}
                        </label>
                        <input id="city-name-ar" type="text" v-model="cityDataEdit.nameAr" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="city-name-en" class="text-black font-bold! text-[14px]/8">
                            {{ $t('City name in english') }}
                        </label>
                        <input id="city-name-en" type="text" v-model="cityDataEdit.nameEn" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateEditCity.loading" :disabled="stateEditCity.loading"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('Edit') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- modal for delete city -->
    <UModal v-model:open="openDeleteCity">

        <template #content>

            <div class="bg-box-gray p-5">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Delete city") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openDeleteCity = !openDeleteCity" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="deleteCity" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t("Are you sure you want to delete this city?") }}
                        </div>
                    </div>

                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateDeleteCity.loading" :disabled="stateDeleteCity.loading"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t("Delete") }}
                        </UButton>
                    </div>

                </form>

            </div>

        </template>
    </UModal>

    <UModal v-model:open="openBind">

        <template #content>

            <div class="bg-box-gray my-shadow-box-modal p-5 overflow-auto">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ bindTarget.type == 'country' ? $t("Enable payment method for this country") : $t("Enable payment method for this city") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openBind = !openBind" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <GeoBindPaymentMethodsForm v-if="openBind" :entity-type="bindTarget.type"
                    :entity-id="bindTarget.id" @success="onBindSuccess" @error="onBindError" />

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

const totalPages = ref(1);
const page = ref(1);
const pageSize = ref(10);

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});
const currentPath = route.path;
const toast = useToast();


const value = ref(true);

const stateGetCountries = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});
const stateGetCities = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const validatePhone = ({ valid }) => {

    // يمكنك إضافة notifiction
    if (valid) {
        toast.add({
            title: 'نجاح',
            description: 'رقم الهاتف صحيح',
            color: 'green'
        });
    }
};

const cities = ref([]);
const countries = ref([]);

const getCountryByCode = (code) => {
    return countriesList.value.find(c => c.iso2 === code)
}

onMounted(() => {
    countriesList.value = telInputRef.value.$props.allCountries;
    getAllInfo();
});

const counItems = ref([]);
async function getAllInfo() {

    // Change state loading to loading
    stateGetCountries.value.loading = true;
    stateGetCities.value.loading = true;

    // clean error state
    stateGetCountries.value.error = false;
    stateGetCities.value.error = false;
    getAllCities().then((res) => {
        if (res) {
            // cities.value = res.cities;
            let myCities = [];
            res.cities.forEach(ele => {
                const myCoun = getCountryByCode(ele?.country?.code);
                const myItemCity = ele;
                myItemCity.countryName = myCoun?.name;
                myItemCity.countryFlag = isoToFlagEmoji(myCoun?.iso2);
                myCities.push(myItemCity);
            });
            cities.value = myCities;
            totalPages.value = Math.ceil(res.citiesCount / pageSize.value);
        }
    }).then(() => {
        stateGetCities.value.loading = false;
    }).then(() => {
        getAllCountries().then(res => {
            if (res) {
                counItems.value = [];
                countries.value = res;
                res.forEach(ele => {
                    const myCoun = getCountryByCode(ele.code);
                    myCoun._id = ele._id;
                    counItems.value.push(myCoun);
                });
            }
        }).then(() => {
            stateGetCountries.value.loading = false;
        });
    });
}

async function getMyCountries() {

    // Change state loading to loading
    stateGetCountries.value.loading = true;

    // clean error state
    stateGetCountries.value.error = false;
    getAllCountries().then(res => {
        if (res) {
            counItems.value = [];
            countries.value = res;
            res.forEach(ele => {
                const myCoun = getCountryByCode(ele.code);
                myCoun._id = ele._id;
                counItems.value.push(myCoun);
            });
        }
    }).then(() => {
        stateGetCountries.value.loading = false;
    });
}

async function getMyCities() {

    // Change state loading to loading
    stateGetCities.value.loading = true;

    // clean error state
    stateGetCities.value.error = false;
    getAllCities().then((res) => {
        if (res) {
            // cities.value = res.cities;
            let myCities = [];
            res.cities.forEach(ele => {
                const myCoun = getCountryByCode(ele.country.code);
                const myItemCity = ele;
                myItemCity.countryName = myCoun.name;
                myItemCity.countryFlag = isoToFlagEmoji(myCoun?.iso2);
                myCities.push(myItemCity);
            });
            cities.value = myCities;
            totalPages.value = Math.ceil(res.citiesCount / pageSize.value);
        }
    }).then(() => {
        stateGetCities.value.loading = false;
    });
}

async function getAllCountries() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/countries/all`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateGetCountries.value.error = true;
            stateGetCountries.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        return response.data.data;
    }
    catch (error) {
        stateGetCountries.value.loading = false;
        stateGetCountries.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateGetCountries.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

async function getAllCities() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/cities/all-cities-inside-the-page`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
            params: {
                pageNumber: 1,
                pageSize: pageSize.value
            }
        });

        if (response.data.error) {
            stateGetCities.value.error = true;
            stateGetCities.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        return response.data.data;
    }
    catch (error) {
        stateGetCities.value.loading = false;
        stateGetCities.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateGetCities.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
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

const stateEditCity = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

const stateDeleteCity = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

const openDeleteCountry = ref(false);
const deleteCountryItem = ref({
    _id: "",
});

function openDeleteCountryModal(item) {
    deleteCountryItem.value._id = item._id;
    openDeleteCountry.value = true;
}

async function deleteCountry() {

    stateDelete.value.loading = true;
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/countries/delete/${deleteCountryItem.value._id}`;

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

        getMyCountries();
        openDeleteCountry.value = false;
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

const openEditCity = ref(false);
const cityDataEdit = ref({
    country: "",
    nameAr: "",
    nameEn: "",
    _id: ""
});

function openEditCityModel(item) {
    cityDataEdit.value = {
        country: item.country._id,
        nameAr: item.name.ar,
        nameEn: item.name.en,
        _id: item._id
    };
    openEditCity.value = true;
}

async function editCity() {

    stateEditCity.value.loading = true;
    stateEditCity.value.error = false;
    stateEditCity.value.success = false;
    stateEditCity.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/cities/update/${cityDataEdit.value._id}`;

    const data = {
        country: cityDataEdit.value.country,
        name: {
            ar: cityDataEdit.value.nameAr,
            en: cityDataEdit.value.nameEn
        },
    }

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateEditCity.value.loading = false;
            stateEditCity.value.error = true;
            stateEditCity.value.success = false;
            stateEditCity.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateEditCity.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getAllInfo();
        openEditCity.value = false;
    }
    catch (error) {
        stateEditCity.value.loading = false;
        stateEditCity.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditCity.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

const deleteCityItem = ref({
    _id: ""
});

const openDeleteCity = ref(false);

function openDeleteCityModel(item) {
    deleteCityItem.value._id = item._id;
    openDeleteCity.value = true;
}

async function deleteCity() {

    stateDeleteCity.value.loading = true;
    stateDeleteCity.value.error = false;
    stateDeleteCity.value.success = false;
    stateDeleteCity.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/cities/delete/${deleteCityItem.value._id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateDeleteCity.value.loading = false;
            stateDeleteCity.value.error = true;
            stateDeleteCity.value.success = false;
            stateDeleteCity.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateDeleteCity.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        page.value = 1;
        getAllInfo();
        openDeleteCity.value = false;
    }
    catch (error) {
        stateDeleteCity.value.loading = false;
        stateDeleteCity.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateDeleteCity.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

watch(
    () => page.value,
    () => {
        getMyCities();
    }
)

const openBind = ref(false);
const bindTarget = ref({ type: "country", id: "" });
const stateBind = ref({
    error: false,
    success: false,
    msg: { en: "", ar: "" }
});

const bindCheckLoading = ref(false);

// A payment method bound at the country level is now checked directly by
// the app (no city/region needed - see hawwel-api's transferByParameter),
// so no prerequisite check is needed there. A payment method bound at the
// CITY level still only ever reaches real users by cascading down into an
// actual region - the app has no city-level check, only country-level or
// region-level - so that path still requires at least one region to exist.
async function checkHasChild(type, id) {
    const token = store.getToken;
    try {
        const response = await axios.get(`${BASE_URL}/regions/all-regions-inside-the-page`, {
            headers: { 'Authorization': `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 1, city: id },
        });
        return !response.data.error;
    } catch (_) {
        return false;
    }
}

async function openBindModal(type, id) {
    if (type === 'country') {
        bindTarget.value = { type, id };
        openBind.value = true;
        return;
    }

    bindCheckLoading.value = true;
    const ok = await checkHasChild(type, id);
    bindCheckLoading.value = false;

    if (!ok) {
        stateBind.value = {
            error: true,
            success: false,
            msg: { ar: "أضف منطقة واحدة على الأقل لهذه المدينة أولاً - وإلا فلن يصل التفعيل لأي منطقة حقيقية يتحقق منها التطبيق.", en: "Add at least one region for this city first - otherwise the activation never reaches a real region the app checks against." },
        };
        return;
    }

    bindTarget.value = { type, id };
    openBind.value = true;
}

function onBindSuccess(msg) {
    stateBind.value = { error: false, success: true, msg };
    openBind.value = false;
}

function onBindError(msg) {
    stateBind.value = { error: true, success: false, msg };
}

</script>

<style scoped>
:deep(.vti__dropdown-arrow) {
    margin-right: auto;
}

:deep(.vti__phone) {
    display: none !important;
}

:deep(.vti__dropdown-list) {
    max-width: 350px !important;
    right: 0px;
}

:deep(.vti__dropdown) {
    width: 100% !important;
    display: block !important;
    padding: 12px !important;
    border-radius: 0px;
    border-radius: 8px !important;
    cursor: pointer !important;
}

:deep(.vti__dropdown:hover) {
    background: #D9D9D9 !important;
    border-color: #D9D9D9 !important;
}
</style>