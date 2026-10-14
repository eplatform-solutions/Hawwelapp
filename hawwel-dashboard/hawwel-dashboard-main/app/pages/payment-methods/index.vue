<template>

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

    <use-toast v-if="stateEditImage.error" head="Failed"
        :body="locale == 'en' ? stateEditImage.msg.en : stateEditImage.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateEditImage.success" head="Success"
        :body="locale == 'en' ? stateEditImage.msg.en : stateEditImage.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <use-toast v-if="stateUnbind.error" head="Failed" :body="locale == 'en' ? stateUnbind.msg.en : stateUnbind.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateUnbind.success" head="Success"
        :body="locale == 'en' ? stateUnbind.msg.en : stateUnbind.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <vue-tel-input ref="telInputRef" class="hidden!" />

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div class="flex gap-10 items-center px-5 mb-10">

                    <button @click="openAddModal"
                        class="text-black text-[16px]/8 font-bold! cursor-pointer bg-[#B9A779CF] border border-[#6B1F2A] rounded-xl px-5 py-1">
                        {{ $t("New payment method") }}
                    </button>

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
                            @click="getAllInfo">
                            {{ $t("Refresh") }}
                        </button>
                    </div>
                </div>

                <div v-else>

                    <div class="mx-5 overflow-auto">

                        <table class="bg-box-gray w-full">

                            <thead>
                                <tr>
                                    <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Payment methods") }}
                                    </th>
                                    <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Logo") }}
                                    </th>
                                    <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Currency") }}
                                    </th>
                                    <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Minimum transmission") }}
                                    </th>
                                    <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Maximum transmission limit") }}
                                    </th>
                                    <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Commission") }}
                                    </th>
                                    <th class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Status") }}
                                    </th>
                                    <th
                                        class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                        {{ $t("The procedure") }}
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr v-for="item in paymentMethods" :key="item._id">
                                    <td class="text-black text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <span v-if="locale == 'ar'" class="text-black text-[16px]/8 font-bold!">
                                            {{ item.name.ar }}
                                        </span>
                                        <span v-else class="text-black text-[16px]/8 font-bold!">
                                            {{ item.name.en }}
                                        </span>
                                    </td>
                                    <td class="border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <div class="flex justify-center">
                                            <button @click="openShowLogoModal(item)"
                                                class="text-black text-[16px]/8 font-bold! cursor-pointer">
                                                {{ $t("See logo") }}
                                            </button>
                                        </div>
                                    </td>
                                    <td class="text-black text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.symbol }}
                                    </td>
                                    <td class="text-black text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.minAmount }}
                                    </td>
                                    <td class="text-black text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.maxAmount }}
                                    </td>
                                    <td class="text-black text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.fee }}%
                                    </td>
                                    <td class="text-black text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.isActivated ? $t('Actived') : $t('Inactive') }}
                                    </td>
                                    <td
                                        class="text-black text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                        <div class="flex justify-center gap-3">
                                            <button class="cursor-pointer" @click="openDeleteModal(item)">
                                                <svg width="23" height="23" viewBox="0 0 23 23" fill="none"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path
                                                        d="M17.25 4.6H23V6.9H20.7V21.85C20.7 22.4851 20.1851 23 19.55 23H3.45C2.81488 23 2.3 22.4851 2.3 21.85V6.9H0V4.6H5.75V1.15C5.75 0.514878 6.26488 0 6.9 0H16.1C16.7351 0 17.25 0.514878 17.25 1.15V4.6ZM18.4 6.9H4.6V20.7H18.4V6.9ZM8.05 10.35H10.35V17.25H8.05V10.35ZM12.65 10.35H14.95V17.25H12.65V10.35ZM8.05 2.3V4.6H14.95V2.3H8.05Z"
                                                        fill="black" />
                                                </svg>
                                            </button>
                                            <button class="cursor-pointer" @click="openEditModal(item)">
                                                <svg width="23" height="23" viewBox="0 0 18 18" fill="none"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path
                                                        d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                        fill="black" />
                                                </svg>
                                            </button>
                                            <button class="cursor-pointer" @click="openBindingsModal(item)"
                                                :title="$t('Where is this used?')">
                                                <UIcon name="i-heroicons-map-pin" class="size-[23px] text-black" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

    <!-- modal for Add payment method -->
    <UModal v-model:open="openAdd" :ui="{ content: 'md:max-w-[75vw]! w-[75vw]!' }">

        <template #content>

            <div class="bg-[#D9D9D9] my-shadow-box-modal p-5 overflow-auto">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Add a new payment method") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openAdd = !openAdd" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <GeoPaymentMethodForm v-if="openAdd" @success="onPaymentMethodAdded" @error="onPaymentMethodAddError" />

            </div>

        </template>
    </UModal>


    <!-- modal for edit payment method -->
    <UModal v-model:open="openEdit" :ui="{ content: 'md:max-w-[75vw]! w-[75vw]!' }">

        <template #content>

            <div class="bg-[#D9D9D9] my-shadow-box-modal p-5 overflow-auto">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Edit payment method") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="editPaymentMethod" class="mb-10" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex lg:flex-row flex-col gap-2 mb-5">
                        <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Payment method name in arabic:") }}
                        </div>
                        <input type="text" v-model="editItem.nameAr" required
                            class="basis-full sm:basis-[50%] md:basis-[60%] bg-[#F5F5F5] px-2 text-black text-[11px]/8" />
                    </div>
                    <div class="flex lg:flex-row flex-col gap-2 mb-5">
                        <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Payment method name in english:") }}
                        </div>
                        <input type="text" v-model="editItem.nameEn" required
                            class="basis-full sm:basis-[50%] md:basis-[60%] bg-[#F5F5F5] px-2 text-black text-[11px]/8" />
                    </div>
                    <div class="flex lg:flex-row flex-col gap-2 mb-5">
                        <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Currency:") }}
                        </div>
                        <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                            <select v-model="editItem.symbol" required
                                class="text-black font-bold! text-[10px]/8 bg-white w-full py-2">
                                <option v-for="item in availableCurrencies" :key="item.code" :value="item.code"
                                    class="text-black font-bold! text-[10px]/8">
                                    {{ item.name || item.code }}
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="flex lg:flex-row flex-col gap-2 mb-5">
                        <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Status:") }}
                        </div>
                        <div class="basis-full sm:basis-[50%] md:basis-[60%]">
                            <select v-model="editItem.isActivated" required
                                class="text-black font-bold! text-[10px]/8 bg-white w-full py-2">
                                <option :value="true" class="text-black font-bold! text-[10px]/8">
                                    {{ $t("Actived") }}
                                </option>
                                <option :value="false" class="text-black font-bold! text-[10px]/8">
                                    {{ $t("Inactive") }}
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="flex lg:flex-row flex-col gap-2 mb-5">
                        <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Minimum limit:") }}
                        </div>
                        <input type="number" v-model="editItem.minAmount" required
                            class="basis-full sm:basis-[50%] md:basis-[60%] bg-[#F5F5F5] px-2 text-black text-[11px]/8" />
                    </div>
                    <div class="flex lg:flex-row flex-col gap-2 mb-5">
                        <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Maximum limit:") }}
                        </div>
                        <input type="number" v-model="editItem.maxAmount" required
                            class="basis-full sm:basis-[50%] md:basis-[60%] bg-[#F5F5F5] px-2 text-black text-[11px]/8" />
                    </div>
                    <div class="flex lg:flex-row flex-col gap-2 mb-5">
                        <div class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Commission %:") }}
                        </div>
                        <input type="number" v-model="editItem.fee" required
                            class="basis-full sm:basis-[50%] md:basis-[60%] bg-[#F5F5F5] px-2 text-black text-[11px]/8" />
                    </div>

                    <div class="flex justify-end">
                        <UButton type="submit" :loading="stateEdit.loading" :disabled="stateEdit.loading"
                            class="text-black text-[12px]/8 font-bold! px-8 py-0 bg-[#B9A779] cursor-pointer rounded-full">
                            {{ $t("Edit payment method") }}
                        </UButton>
                    </div>

                </form>

                <form @submit.prevent="editPaymentMethodImage" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex sm:flex-row flex-col gap-2 mb-5">
                        <label for="select-image-edit"
                            class="sm:basis-[30%] md:basis-[25%] text-black font-bold! text-[14px]/8">
                            {{ $t("Select logo image:") }}
                        </label>
                        <input id="select-image-edit" type="file" @change="handleImageUpload($event)"
                            accept=".jpg,.png,.webp"
                            class="basis-full sm:basis-[50%] md:basis-[60%] bg-[#F5F5F5] px-2 text-black text-[11px]/8" />
                    </div>

                    <div class="flex justify-end">
                        <UButton type="submit" :loading="stateEditImage.loading" :disabled="stateEditImage.loading"
                            class="text-black text-[12px]/8 font-bold! px-8 py-0 bg-[#B9A779] cursor-pointer rounded-full">
                            {{ $t("Edit logo of payment method") }}
                        </UButton>
                    </div>

                </form>

            </div>

        </template>
    </UModal>

    <!-- modal for delete payment method -->
    <UModal v-model:open="openDelete">

        <template #content>

            <div class="bg-box-gray p-5">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Delete payment method") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openDelete = !openDelete" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="deletePaymentMethod" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t("Are you sure you want to delete this payment method?") }}
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

    <!-- modal for show logo -->
    <UModal v-model:open="openShowLogo">

        <template #content>

            <div class="bg-box-gray p-5">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Show logo") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openShowLogo = !openShowLogo" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <div class="flex justify-center">
                    <img :src="`${BASE_URL}/${logoItem}`" alt="" class="size-50">
                </div>

            </div>

        </template>
    </UModal>

    <!-- modal for showing / managing where a payment method is bound -->
    <UModal v-model:open="openBindings" :ui="{ content: 'md:max-w-[60vw]! w-[60vw]!' }">

        <template #content>

            <div class="bg-box-gray p-5 overflow-auto max-h-[80vh]">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Where is this used?") }}
                        <span v-if="bindingsItem">
                            - {{ locale == 'ar' ? bindingsItem.name.ar : bindingsItem.name.en }}
                        </span>
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openBindings = !openBindings" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <div v-if="stateBindings.loading" class="flex justify-center items-center py-10">
                    <LoadingIcon />
                </div>

                <div v-else-if="stateBindings.error" class="text-red-500 font-bold! text-center py-6">
                    {{ locale == 'ar' ? stateBindings.msg.ar : stateBindings.msg.en }}
                </div>

                <div v-else class="flex flex-col gap-6" :class="{ 'ar-dir': locale == 'ar' }">

                    <!-- country-level bindings -->
                    <div>
                        <div class="text-black font-bold! text-[14px]/8 mb-2">
                            {{ $t("Bound to whole countries") }}
                        </div>
                        <div v-if="bindingsData.countries.length === 0" class="text-black/60 text-[13px]/6">
                            {{ $t("None") }}
                        </div>
                        <div v-else class="flex flex-wrap gap-2">
                            <div v-for="country in bindingsData.countries" :key="country._id"
                                class="flex items-center gap-2 bg-[#F5F5F5] rounded-full px-3 py-1">
                                <span class="text-[18px] leading-none">
                                    {{ isoToFlagEmoji(country.code) }}
                                </span>
                                <span class="text-black text-[13px]/6 font-bold!">
                                    {{ getCountryByCode(country.code)?.name || country.code }}
                                </span>
                                <button class="cursor-pointer" :disabled="stateUnbind.loading"
                                    @click="confirmUnbind('country', country._id, getCountryByCode(country.code)?.name || country.code)">
                                    <UIcon name="i-heroicons-x-mark-solid" class="size-4 text-red-600" />
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- city-level bindings -->
                    <div>
                        <div class="text-black font-bold! text-[14px]/8 mb-2">
                            {{ $t("Bound to whole cities") }}
                        </div>
                        <div v-if="bindingsData.cities.length === 0" class="text-black/60 text-[13px]/6">
                            {{ $t("None") }}
                        </div>
                        <div v-else class="flex flex-wrap gap-2">
                            <div v-for="city in bindingsData.cities" :key="city._id"
                                class="flex items-center gap-2 bg-[#F5F5F5] rounded-full px-3 py-1">
                                <span class="text-[18px] leading-none">
                                    {{ isoToFlagEmoji(city.country.code) }}
                                </span>
                                <span class="text-black text-[13px]/6 font-bold!">
                                    {{ locale == 'ar' ? city.name.ar : city.name.en }}
                                </span>
                                <button class="cursor-pointer" :disabled="stateUnbind.loading"
                                    @click="confirmUnbind('city', city._id, locale == 'ar' ? city.name.ar : city.name.en)">
                                    <UIcon name="i-heroicons-x-mark-solid" class="size-4 text-red-600" />
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- region-level bindings -->
                    <div>
                        <div class="text-black font-bold! text-[14px]/8 mb-2">
                            {{ $t("Bound to specific regions") }}
                        </div>
                        <div v-if="bindingsData.regions.length === 0" class="text-black/60 text-[13px]/6">
                            {{ $t("None") }}
                        </div>
                        <div v-else class="flex flex-wrap gap-2">
                            <div v-for="region in bindingsData.regions" :key="region._id"
                                class="flex items-center gap-2 bg-[#F5F5F5] rounded-full px-3 py-1">
                                <span class="text-[18px] leading-none">
                                    {{ isoToFlagEmoji(region.country.code) }}
                                </span>
                                <span class="text-black text-[13px]/6 font-bold!">
                                    {{ locale == 'ar' ? region.city.name.ar : region.city.name.en }}
                                    -
                                    {{ locale == 'ar' ? region.name.ar : region.name.en }}
                                </span>
                                <button class="cursor-pointer" :disabled="stateUnbind.loading"
                                    @click="confirmUnbind('region', region._id, (locale == 'ar' ? region.city.name.ar : region.city.name.en) + ' - ' + (locale == 'ar' ? region.name.ar : region.name.en))">
                                    <UIcon name="i-heroicons-x-mark-solid" class="size-4 text-red-600" />
                                </button>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </template>
    </UModal>

</template>

<script setup>
import { VueTelInput } from 'vue-tel-input'
import 'vue-tel-input/vue-tel-input.css'

const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();
const { telInputRef, initCountriesList, getCountryByCode } = useCountryDisplay();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
    initCountriesList();
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
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEdit = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEditImage = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateDelete = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateBindings = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateUnbind = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const paymentMethods = ref([]);
const availableCurrencies = ref([]);
const totalPages = ref(0);
const page = ref(1);

onMounted(() => {
    getAllInfo();
});

async function getAllInfo() {

    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;
    Promise.all([getAllPaymentMethods(), getAllCurrenciesOptions()]).then(([methodsRes, currenciesRes]) => {
        if (methodsRes) {
            paymentMethods.value = methodsRes.paymentMethods;
            totalPages.value = methodsRes.paymentMethodsCount;
        }
        if (currenciesRes) {
            availableCurrencies.value = currenciesRes;
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllPaymentMethods() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/all-payment-methods-inside-the-page`;

    const myParams = {
        pageNumber: page.value,
        pageSize: 10,
    }

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

async function getAllCurrenciesOptions() {
    const token = store.getToken;
    const apiUrl = `${BASE_URL}/currencies/all`;
    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        if (response.data.error) {
            return [];
        }
        return response.data.data || [];
    } catch (_) {
        return [];
    }
}

const openAdd = ref(false);
const openEdit = ref(false);
const openDelete = ref(false);
const openShowLogo = ref(false);
const logoItem = ref("");
const openBindings = ref(false);
const bindingsItem = ref(null);
const bindingsData = ref({ countries: [], cities: [], regions: [] });

function openAddModal() {
    openAdd.value = true;
}

const editItem = ref({
    nameAr: "",
    nameEn: "",
    symbol: "",
    minAmount: "",
    maxAmount: "",
    isActivated: "",
    fee: "",
    _id: "",
    image: null
});

const editItemCheck = ref({
    nameAr: "",
    nameEn: "",
    symbol: "",
    minAmount: "",
    maxAmount: "",
    isActivated: "",
    fee: "",
    _id: "",
    image: null
});

function openEditModal(item) {
    editItem.value = {
        nameAr: item.name.ar,
        nameEn: item.name.en,
        symbol: item.symbol,
        minAmount: item.minAmount,
        maxAmount: item.maxAmount,
        isActivated: item.isActivated,
        fee: item.fee,
        _id: item._id,
        image: null
    }
    editItemCheck.value = {
        nameAr: item.name.ar,
        nameEn: item.name.en,
        symbol: item.symbol,
        minAmount: item.minAmount,
        maxAmount: item.maxAmount,
        isActivated: item.isActivated,
        fee: item.fee,
        _id: item._id,
        image: null
    }
    openEdit.value = true;
}

function openDeleteModal(item) {
    deleteItem.value._id = item._id;
    openDelete.value = true;
}

function openShowLogoModal(item) {
    logoItem.value = item.logoPath;
    openShowLogo.value = true;
}

function openBindingsModal(item) {
    bindingsItem.value = item;
    openBindings.value = true;
    fetchBindings(item._id);
}

async function fetchBindings(paymentMethodId) {
    stateBindings.value.loading = true;
    stateBindings.value.error = false;

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/${paymentMethodId}/bindings`;

    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateBindings.value.loading = false;
            stateBindings.value.error = true;
            stateBindings.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        bindingsData.value = response.data.data;
        stateBindings.value.loading = false;
    }
    catch (error) {
        stateBindings.value.loading = false;
        stateBindings.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateBindings.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

function confirmUnbind(level, entityId, label) {
    const question = locale.value == 'ar'
        ? `هل تريد إلغاء ربط طريقة الدفع من "${label}"؟`
        : `Unbind this payment method from "${label}"?`;
    if (!window.confirm(question)) return;
    unbindPaymentMethod(level, entityId);
}

async function unbindPaymentMethod(level, entityId) {
    stateUnbind.value.loading = true;
    stateUnbind.value.error = false;
    stateUnbind.value.success = false;
    stateUnbind.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/${bindingsItem.value._id}/bindings/${level}/${entityId}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateUnbind.value.loading = false;
            stateUnbind.value.error = true;
            stateUnbind.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateUnbind.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        const key = level === 'country' ? 'countries' : level === 'city' ? 'cities' : 'regions';
        bindingsData.value[key] = bindingsData.value[key].filter((entity) => entity._id !== entityId);
    }
    catch (error) {
        stateUnbind.value.loading = false;
        stateUnbind.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateUnbind.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

/**
 * Handles image upload for both add and edit operations
 * Validates file size and type, updates the appropriate state
 * @param {Event} event - The file input change event
 * @param {string} mode - 'add' or 'edit' to determine which state to update
 */
const handleImageUpload = async (event) => {
    const file = event.target.files[0];

    // Reset file input and image if no file selected
    if (!file) {
        editItem.value.image = null;
        return;
    }

    // File validation constants
    const maxSize = 5 * 1024 * 1024; // 5MB in bytes
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

    // Get file extension
    const fileExtension = file.name.split('.').pop().toLowerCase();

    // Helper function to reset states and show error
    const resetAndShowError = async (enMsg, arMsg) => {
        // Reset all states
        stateEditImage.value.loading = false;
        stateEditImage.value.error = false;
        stateEditImage.value.success = false;

        await nextTick();

        // Set error state with message
        stateEditImage.value.error = true;
        stateEditImage.value.msg = {
            en: enMsg,
            ar: arMsg,
        };

        // Clear file input
        event.target.value = '';
        editItem.value.image = null;
    };

    // 1️⃣ Validate file type (extension and MIME type)
    if (!allowedTypes.includes(file.type) || !allowedExtensions.includes(fileExtension)) {
        await resetAndShowError(
            "File type not supported! Only JPG, PNG, and WebP images are allowed.",
            "نوع الملف غير مدعوم! فقط صور JPG و PNG و WebP مسموح بها."
        );
        return;
    }

    // 2️⃣ Validate file size
    if (file.size > maxSize) {
        const fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);
        await resetAndShowError(
            `File size is too large (${fileSizeMB} MB)! Maximum allowed size is 5 MB.`,
            `حجم الملف كبير جداً (${fileSizeMB} ميجابايت)! الحد الأقصى المسموح به هو 5 ميجابايت.`
        );
        return;
    }

    // 3️⃣ If all validations pass, save the file
    editItem.value.image = file;

    // Auto-hide success message after 3 seconds
    setTimeout(() => {
        stateEditImage.value.success = false;
        stateEditImage.value.msg = { en: "", ar: "" };
    }, 3000);
}

function onPaymentMethodAdded(msg) {
    stateAdd.value = { error: false, success: true, msg };
    getAllInfo();
    openAdd.value = false;
}

function onPaymentMethodAddError(msg) {
    stateAdd.value = { error: true, success: false, msg };
}


async function editPaymentMethod() {

    stateEdit.value.loading = true;
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = {
        en: "",
        ar: "",
    };

    let data = {}

    if (editItem.value.nameAr != editItemCheck.value.nameAr ||
        editItem.value.nameEn != editItemCheck.value.nameEn) {

        data.name = {
            ar: editItem.value.nameAr,
            en: editItem.value.nameEn
        }
    }
    if (editItem.value.symbol != editItemCheck.value.symbol)
        data.symbol = editItem.value.symbol;
    if (editItem.value.minAmount != editItemCheck.value.minAmount)
        data.minAmount = editItem.value.minAmount;
    if (editItem.value.maxAmount != editItemCheck.value.maxAmount)
        data.maxAmount = editItem.value.maxAmount;
    if (editItem.value.fee != editItemCheck.value.fee)
        data.fee = editItem.value.fee;
    if (editItem.value.isActivated != editItemCheck.value.isActivated)
        data.isActivated = editItem.value.isActivated;


    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/update/${editItem.value._id}`;

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

async function editPaymentMethodImage() {

    stateEditImage.value.loading = true;
    stateEditImage.value.error = false;
    stateEditImage.value.success = false;
    stateEditImage.value.msg = {
        en: "",
        ar: "",
    };

    await nextTick();
    if (editItem.value.image == null) {
        stateEditImage.value.loading = false;
        stateEditImage.value.error = true;
        stateEditImage.value.msg = {
            en: "A logo image must be added",
            ar: "يجب إضافة صورة الشعار",
        };
        return;
    }

    const formData = new FormData();
    formData.append('logoImage', editItem.value.image);

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/change-logo-image/${editItem.value._id}`;

    try {
        const response = await axios.put(apiUrl, formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateEditImage.value.loading = false;
            stateEditImage.value.error = true;
            stateEditImage.value.success = false;
            stateEditImage.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateEditImage.value = {
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
        stateEditImage.value.loading = false;
        stateEditImage.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditImage.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

const deleteItem = ref({
    _id: ""
});

async function deletePaymentMethod() {

    stateDelete.value.loading = true;
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/delete/${deleteItem.value._id}`;

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

</script>