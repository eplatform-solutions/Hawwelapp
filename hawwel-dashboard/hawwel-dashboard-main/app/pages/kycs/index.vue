<template>

    <!-- <use-toast v-if="state.error" head="Error" :body="locale == 'en' ? state.msg.en : state.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast> -->

    <use-toast v-if="stateDownload.error" head="Failed"
        :body="locale == 'en' ? stateDownload.msg.en : stateDownload.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateDownload.success" head="Success"
        :body="locale == 'en' ? stateDownload.msg.en : stateDownload.msg.ar" color="success"
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

            <!-- basis-[85%] (not w-[85%]) so the shared sidebar-width rule in
                 main.css applies; a fixed width left a blank strip beside
                 the collapsed sidebar. -->
            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />
                <vue-tel-input ref="telInputRef" :dropdown-options="dropdownOptions" class="hidden!"></vue-tel-input>

                <div
                    class="flex flex-wrap justify-center md:justify-between gap-5 items-center mb-5 sm:mb-10 px-2 sm:px-10">
                    <div>

                        <div class="relative">

                            <div @click="dropdownOpen = !dropdownOpen"
                                class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! rounded-xl px-3 py-2 cursor-pointer min-w-60">
                                <div class="flex justify-between items-center">
                                    <div>{{ selectedCountryName || $t('Choose country') }}</div>
                                    <div>
                                        <svg width="21" height="15" viewBox="0 0 21 15" fill="none" class="h-2 sm:h-3"
                                            xmlns="http://www.w3.org/2000/svg">
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
                                    <li v-for="item in filteredCountries" :key="item.iso2" @click="selectCountry(item)"
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

                    <div>
                        <input type="date" v-model="search.date"
                            class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! rounded-xl px-3 py-2" />
                    </div>
                    <div>
                        <select v-model="search.status" name="" id=""
                            class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! rounded-xl px-3 py-2">
                            <option value="" selected>
                                {{ $t("All status") }}
                            </option>
                            <option v-for="item in selectStatus" :value="item.value" :key="item.value">
                                {{ $t(item.name) }}
                            </option>
                        </select>
                    </div>
                </div>

                <div v-if="state.loading" class="flex justify-center my-5">
                    <LoadingIcon />
                </div>

                <div v-else-if="state.error" class="flex flex-col gap-3 justify-center my-5">
                    <div class="text-center text-red-500 text-[12px]/5 sm:text-[16px]/8 font-bold!">
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
                <!-- boxes -->
                <div v-else class="pb-5 flex justify-center items-center">

                    <div class="overflow-auto">

                        <table class="bg-white">

                            <thead>
                                <tr>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Name") }}
                                    </th>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Nickname") }}
                                    </th>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Country") }}
                                    </th>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Phone number") }}
                                    </th>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Order date") }}
                                    </th>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Status") }}
                                    </th>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Processing date") }}
                                    </th>
                                    <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t("Actions") }}
                                    </th>
                                    <th
                                        class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                        {{ $t("KYC documents") }}
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr v-for="(item, index) in kycs" :key="item._id">
                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.user.name }}
                                    </td>
                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.user.nickname }}
                                    </td>
                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.user.country }}
                                    </td>
                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap en-dir"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.user.mobilePhone }}
                                    </td>
                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.createdAt.split('T')[0] }}
                                    </td>
                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <div>
                                            <div v-if="item.status == 'rejected' || item.status == 'blocked' || item.status == 'remove-verified'"
                                                class="flex flex-col gap-1">
                                                <div class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!">
                                                    {{ $t(item.status) }}
                                                </div>
                                                <button @click="openShowWhyModel(item)"
                                                    class="hover:text-blue-800 text-black text-[12px]/5 sm:text-[16px]/8 cursor-pointer font-bold! duration-200">
                                                    {{ $t("See why") }}
                                                </button>
                                            </div>
                                            <div v-else class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!">
                                                {{ $t(item.status) }}
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap en-dir"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ getLatestDate(item) }}
                                    </td>
                                    <td :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }"
                                        class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                        <div class="flex justify-center gap-7">
                                            <select name="" id=""
                                                @change="showEditModel(item, $event.target.value); $event.target.value = ''">
                                                <option disabled value="" selected>
                                                    {{ $t("Choose the action") }}
                                                </option>
                                                <option value="approve">
                                                    {{ $t("Approve") }}
                                                </option>
                                                <option value="reject">
                                                    {{ $t("Reject") }}
                                                </option>
                                                <option value="block">
                                                    {{ $t("Block") }}
                                                </option>
                                                <option value="unapprove">
                                                    {{ $t("Unapprove") }}
                                                </option>
                                                <option value="unblock">
                                                    {{ $t("Unblock") }}
                                                </option>
                                            </select>
                                        </div>
                                    </td>
                                    <td
                                        class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!  border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                        <div class="flex gap-3 justify-center">
                                            <div class="flex flex-col items-center gap-1">
                                                <span class="text-gray-500 text-[10px]/3 sm:text-[12px]/4 font-bold!">
                                                    {{ $t("First image") }}
                                                </span>
                                                <button type="button" @click="openReviewModal(item, 0)"
                                                    class="group relative w-20 h-16 sm:w-24 sm:h-20 rounded-lg overflow-hidden border border-black/10 bg-gray-100 cursor-pointer shadow-sm">
                                                    <img v-if="thumbnails[thumbKey(item, 0)]?.url"
                                                        :src="thumbnails[thumbKey(item, 0)].url" :alt="$t('First image')"
                                                        class="w-full h-full object-cover transition-transform duration-200 group-hover:scale-110" />
                                                    <div v-else-if="thumbnails[thumbKey(item, 0)]?.error"
                                                        class="w-full h-full flex items-center justify-center text-gray-400">
                                                        <UIcon name="i-heroicons-photo" class="size-6" />
                                                    </div>
                                                    <div v-else class="w-full h-full animate-pulse bg-gray-200"></div>
                                                    <span
                                                        class="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors duration-200"></span>
                                                </button>
                                                <button :id="`icon-file-0-${index}-${page}`"
                                                    @click="downloadKycFile(item, 0, index)"
                                                    class="cursor-pointer underline text-[10px]/3 sm:text-[12px]/4">
                                                    {{ $t("Download") }}
                                                </button>
                                            </div>
                                            <div class="flex flex-col items-center gap-1">
                                                <span class="text-gray-500 text-[10px]/3 sm:text-[12px]/4 font-bold!">
                                                    {{ $t("Second image") }}
                                                </span>
                                                <template v-if="hasSecondKycImage(item)">
                                                    <button type="button" @click="openReviewModal(item, 1)"
                                                        class="group relative w-20 h-16 sm:w-24 sm:h-20 rounded-lg overflow-hidden border border-black/10 bg-gray-100 cursor-pointer shadow-sm">
                                                        <img v-if="thumbnails[thumbKey(item, 1)]?.url"
                                                            :src="thumbnails[thumbKey(item, 1)].url" :alt="$t('Second image')"
                                                            class="w-full h-full object-cover transition-transform duration-200 group-hover:scale-110" />
                                                        <div v-else-if="thumbnails[thumbKey(item, 1)]?.error"
                                                            class="w-full h-full flex items-center justify-center text-gray-400">
                                                            <UIcon name="i-heroicons-photo" class="size-6" />
                                                        </div>
                                                        <div v-else class="w-full h-full animate-pulse bg-gray-200"></div>
                                                        <span
                                                            class="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors duration-200"></span>
                                                    </button>
                                                    <button :id="`icon-file-1-${index}-${page}`"
                                                        @click="downloadKycFile(item, 1, index)"
                                                        class="cursor-pointer underline text-[10px]/3 sm:text-[12px]/4">
                                                        {{ $t("Download") }}
                                                    </button>
                                                </template>
                                                <div v-else
                                                    class="w-20 h-16 sm:w-24 sm:h-20 rounded-lg flex items-center justify-center text-center text-gray-400 text-[10px]/3 sm:text-[11px]/4 bg-gray-50 border border-dashed border-gray-300">
                                                    {{ $t("Not available") }}
                                                </div>
                                            </div>
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

    <!-- edit state of KYC -->
    <UModal v-model:open="openEdit">
        <template #content>
            <div class="bg-box-gray p-5">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!" :class="{ 'ar-dir': locale == 'ar' }">
                        {{ $t('Update Kycs') }}
                    </div>
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="editKycs" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t('Are you sure you want to update the KYCS status to') }} {{ $t(editKycsData.state) }}
                        </div>
                    </div>

                    <div v-if="editKycsData.state == 'reject' || editKycsData.state == 'block' || editKycsData.state == 'unapprove'"
                        class="flex flex-col gap-2 mb-5">
                        <label for="reason" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Type reason') }}
                        </label>
                        <input id="reason" type="text" v-model="editKycsData.reason" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateEdit.loading"
                            :disabled="stateEdit.loading || (editKycsData.reason.length < 4 && (editKycsData.state == 'reject' || editKycsData.state == 'block' || editKycsData.state == 'unapprove'))"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('Edit') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- show reason for KYC -->
    <UModal v-model:open="openShowWhy">
        <template #content>
            <div class="bg-box-gray p-5">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!" :class="{ 'ar-dir': locale == 'ar' }">
                        {{ $t('Show reason') }}
                    </div>
                    <div>
                        <button @click="openShowWhy = !openShowWhy" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <div v-if="itemReason.status == 'rejected'" class="text-red-500 font-bold! text-[20px]/8 text-center">
                    {{ itemReason.rejectionReason }}
                </div>
                <div v-else-if="itemReason.status == 'blocked'"
                    class="text-red-500 font-bold! text-[20px]/8 text-center">
                    {{ itemReason.blockingReason }}
                </div>
                <div v-else-if="itemReason.status == 'remove-verified'"
                    class="text-red-500 font-bold! text-[20px]/8 text-center">
                    {{ itemReason.removeVerifyingReason }}
                </div>
            </div>
        </template>
    </UModal>

    <!-- review KYC images (lightbox) -->
    <UModal v-model:open="openReview" :ui="{ content: 'sm:max-w-4xl' }">
        <template #content>
            <div class="bg-box-gray p-5" v-if="reviewItem">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div :class="{ 'ar-dir': locale == 'ar' }">
                        <div class="text-black text-[18px]/8 font-bold!">
                            {{ reviewItem.user.name }}
                            <span v-if="reviewItem.user.nickname">{{ reviewItem.user.nickname }}</span>
                        </div>
                        <div class="text-black/60 text-[12px]/5 en-dir">
                            {{ reviewItem.user.mobilePhone }} · {{ reviewItem.user.country }}
                        </div>
                    </div>
                    <button @click="openReview = false" class="cursor-pointer">
                        <UIcon class="size-8" name="i-heroicons-x-mark-solid" />
                    </button>
                </div>

                <div class="mb-4">
                    <span class="text-black text-[12px]/4 font-bold!">
                        {{ activeReviewIndex === 0 ? $t('First image') : $t('Second image') }}
                    </span>
                    <button type="button" @click="zoomOpen = true"
                        class="group relative w-full mt-2 h-[60vh] rounded-xl overflow-hidden bg-gray-100 border border-black/10 flex items-center justify-center cursor-zoom-in">
                        <img v-if="activeReviewUrl" :src="activeReviewUrl"
                            :alt="activeReviewIndex === 0 ? $t('First image') : $t('Second image')"
                            class="w-full h-full object-contain" />
                        <div v-else-if="thumbnails[thumbKey(reviewItem, activeReviewIndex)]?.error"
                            class="w-full h-full flex flex-col items-center justify-center text-gray-400 gap-1">
                            <UIcon name="i-heroicons-photo" class="size-8" />
                        </div>
                        <div v-else class="w-full h-full animate-pulse bg-gray-200"></div>
                        <span
                            class="absolute bottom-2 right-2 rtl:right-auto rtl:left-2 bg-black/50 text-white text-[11px]/4 rounded-lg px-2 py-1 opacity-0 group-hover:opacity-100 transition-opacity duration-200 flex items-center gap-1">
                            <UIcon name="i-heroicons-magnifying-glass-plus" class="size-4" />
                            {{ $t('Click to zoom') }}
                        </span>
                    </button>
                </div>

                <div v-if="hasSecondKycImage(reviewItem)" class="flex justify-center gap-3 mb-6">
                    <button v-for="fi in reviewImageIndexes" :key="fi" type="button"
                        @click="activeReviewIndex = fi"
                        class="w-20 h-16 rounded-lg overflow-hidden border-2 bg-gray-100 cursor-pointer"
                        :class="activeReviewIndex === fi ? 'border-[#6B1F2A]' : 'border-black/10'">
                        <img v-if="thumbnails[thumbKey(reviewItem, fi)]?.url" :src="thumbnails[thumbKey(reviewItem, fi)].url"
                            :alt="fi === 0 ? $t('First image') : $t('Second image')"
                            class="w-full h-full object-cover" />
                        <div v-else class="w-full h-full animate-pulse bg-gray-200"></div>
                    </button>
                </div>

                <div class="flex justify-center gap-4">
                    <button type="button" @click="showEditModel(reviewItem, 'approve'); openReview = false"
                        class="bg-green-600 hover:bg-green-700 transition-colors duration-200 text-white rounded-xl px-6 py-2 text-[14px]/6 font-bold! cursor-pointer">
                        {{ $t('Approve') }}
                    </button>
                    <button type="button" @click="showEditModel(reviewItem, 'reject'); openReview = false"
                        class="bg-red-600 hover:bg-red-700 transition-colors duration-200 text-white rounded-xl px-6 py-2 text-[14px]/6 font-bold! cursor-pointer">
                        {{ $t('Reject') }}
                    </button>
                </div>
            </div>
        </template>
    </UModal>

    <!-- full-screen zoom of the active review image -->
    <UModal v-model:open="zoomOpen" fullscreen>
        <template #content>
            <div class="relative w-full h-full bg-black flex items-center justify-center">
                <button @click="zoomOpen = false"
                    class="absolute top-4 right-4 rtl:right-auto rtl:left-4 z-10 cursor-pointer text-white">
                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                </button>
                <img v-if="activeReviewUrl" :src="activeReviewUrl" class="max-w-full max-h-full object-contain" />
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

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const dropdownOptions = {
    showDialCodeInSelection: true,
    showDialCodeInList: true,
    showFlags: true,
    showSearchBox: true,
    tabindex: 0,
    disabled: false,
    required: false,
    dropdownContainer: 'body'
}

const state = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateDownload = ref({
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

const openEdit = ref(false);
const openShowWhy = ref(false);
const openReview = ref(false);
const reviewItem = ref(null);
const activeReviewIndex = ref(0);
const zoomOpen = ref(false);

const reviewImageIndexes = computed(() => {
    if (!reviewItem.value) return [];
    return hasSecondKycImage(reviewItem.value) ? [0, 1] : [0];
});

const activeReviewUrl = computed(() => {
    if (!reviewItem.value) return null;
    return thumbnails.value[thumbKey(reviewItem.value, activeReviewIndex.value)]?.url ?? null;
});

const editKycsData = ref({
    _id: "",
    state: "",
    reason: ""
});

const itemReason = ref(null);

function showEditModel(item, state) {
    editKycsData.value._id = item._id;
    editKycsData.value.state = state;
    editKycsData.value.reason = "";
    openEdit.value = true;
}

async function openShowWhyModel(item) {
    itemReason.value = item;
    await nextTick();
    openShowWhy.value = true;
}

const search = ref({
    country: "",
    date: "",
    status: "",
});

const selectStatus = ref([
    { value: 'verified', name: 'Verified' },
    // { value: 'expired', name: 'Expired' },
    { value: 'remove-verified', name: 'Remove verified' },
    { value: 'under-review', name: 'Under review' },
    { value: 'blocked', name: 'Blocked' },
    { value: 'rejected', name: 'Rejected' },
]);

const kycs = ref([]);
const pageSize = ref(10);
const totalPages = ref(1);
const page = ref(1);

const telInputRef = ref(null);
const countriesList = ref([]);

const getCountryByCode = (code) => {
    return countriesList.value.find(c => c.iso2 === code)
}

onMounted(() => {
    countriesList.value = telInputRef.value.$props.allCountries;
    getAllInfo();
});

async function getAllInfo() {
    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    state.value.msg = {
        ar: "",
        en: ""
    };
    getKycs().then(res => {
        if (res) {
            clearThumbnails();
            kycs.value = [];
            res.kycs.forEach(ele => {
                const myCoun = getCountryByCode(ele.user.country);
                const myItemCity = ele;
                myItemCity.user.country = myCoun.name;
                kycs.value.push(myItemCity);
            });
            totalPages.value = Math.ceil(res.kycs / 10);
            kycs.value.forEach(loadThumbnailsForItem);
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getKycs() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/kycs/all-kycs-inside-the-page`;

    const myParams = {
        pageNumber: page.value,
        pageSize: pageSize.value
    }

    if (search.value.country != "")
        myParams.country = search.value.country;

    if (search.value.status != "")
        myParams.status = search.value.status;

    if (search.value.date != "") {
        myParams.fromDate = search.value.date;
        myParams.toDate = search.value.date;
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
            if (response?.data?.msg?.ar)
                state.value.msg = {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en,
                }
            else
                state.value.msg = {
                    ar: response.data.msg,
                    en: response.data.msg,
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

function hasSecondKycImage(item) {
    return Array.isArray(item.documentImages) && item.documentImages.length > 1;
}

function getKycFileUrl(item, fileIndex) {
    return `${BASE_URL}/kycs/${item._id}/files/${fileIndex}`;
}

const thumbnails = ref({});

function thumbKey(item, fileIndex) {
    return `${item._id}_${fileIndex}`;
}

function clearThumbnails() {
    Object.values(thumbnails.value).forEach(entry => {
        if (entry?.url) window.URL.revokeObjectURL(entry.url);
    });
    thumbnails.value = {};
}

async function loadThumbnail(item, fileIndex) {
    const key = thumbKey(item, fileIndex);
    if (thumbnails.value[key]) return;
    thumbnails.value[key] = { url: null, loading: true, error: false };
    try {
        const response = await fetchKycFileBlob(item, fileIndex);
        const url = window.URL.createObjectURL(new Blob([response.data]));
        thumbnails.value[key] = { url, loading: false, error: false };
    } catch (error) {
        thumbnails.value[key] = { url: null, loading: false, error: true };
    }
}

function loadThumbnailsForItem(item) {
    loadThumbnail(item, 0);
    if (hasSecondKycImage(item)) loadThumbnail(item, 1);
}

async function openReviewModal(item, fileIndex) {
    reviewItem.value = item;
    activeReviewIndex.value = fileIndex;
    await loadThumbnail(item, fileIndex);
    if (hasSecondKycImage(item)) await loadThumbnail(item, fileIndex === 0 ? 1 : 0);
    openReview.value = true;
}

onUnmounted(() => {
    clearThumbnails();
});

async function fetchKycFileBlob(item, fileIndex) {
    const token = store.getToken;
    const response = await axios.get(getKycFileUrl(item, fileIndex), {
        responseType: 'blob',
        headers: {
            Authorization: `Bearer ${token}`,
        },
    });
    return response;
}

const downloadKycFile = async (item, fileIndex, index) => {
    stateDownload.value = {
        loading: true,
        error: false,
        success: false,
        msg: {
            ar: "",
            en: ""
        }
    }
    await nextTick();
    let myFileIcon = document.getElementById(`icon-file-${fileIndex}-${index}-${page.value}`);
    myFileIcon.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 100 100"
        preserveAspectRatio="xMidYMid" width="20" height="20"
        style="shape-rendering: auto; display: block; background: rgba(255, 255, 255, 0);">
        <g>
            <circle stroke-dasharray="164.93361431346415 56.97787143782138" r="35" stroke-width="10" stroke="#5b72e1"
                fill="none" cy="50" cx="50">
                <animateTransform keyTimes="0;1" values="0 50 50;360 50 50" dur="1s" repeatCount="indefinite"
                    type="rotate" attributeName="transform" />
            </circle>
            <g />
        </g>
    </svg>`;
    myFileIcon.disabled = true;
    try {
        const response = await fetchKycFileBlob(item, fileIndex);
        const fileName = (Array.isArray(item.documentImages) && item.documentImages[fileIndex])
            ? item.documentImages[fileIndex].split('/').pop()
            : item.filePath.split('/').pop();
        const cleanFileName = decodeURIComponent(fileName)

        const url = window.URL.createObjectURL(new Blob([response.data]))
        const link = document.createElement('a')
        link.href = url
        link.download = cleanFileName
        link.click()
        window.URL.revokeObjectURL(url)

        stateDownload.value.loading = false;
        stateDownload.value.success = true;
        stateDownload.value.msg = {
            en: "File downloaded successfully",
            ar: "تم تنزيل الملف بنجاح"
        };
        myFileIcon.innerHTML = `<svg width="26" height="34" viewBox="0 0 26 34" fill="none"
            xmlns="http://www.w3.org/2000/svg">
            <path
            d="M18.7563 18.4962C18.5102 18.2495 18.1147 18.2495 17.8686 18.4962L13.3941 22.9695V0.627821C13.3941 0.280636 13.1135 0 12.7663 0C12.4191 0 12.1385 0.280636 12.1385 0.627821V22.9695L7.66462 18.4962C7.41914 18.2495 7.02236 18.2495 6.77688 18.4962C6.5314 18.7405 6.5314 19.1372 6.77688 19.3834L12.3224 24.9283C12.3802 24.9867 12.4499 25.0319 12.5258 25.0639C12.6031 25.0959 12.6841 25.1128 12.7663 25.1128C12.8485 25.1128 12.9295 25.0959 13.0068 25.0639C13.0827 25.0319 13.1524 24.9867 13.2102 24.9283L18.7563 19.3834C19.0012 19.1372 19.0012 18.7405 18.7563 18.4962Z"
            fill="black" />
            <path
            d="M21.3453 7.95215H19.4499H18.1026H16.8601H16.847V7.95529C16.5073 7.96219 16.2323 8.23781 16.2323 8.57997C16.2323 8.92213 16.5073 9.19775 16.847 9.20528V9.20779H16.8601H18.1026H19.4499H21.3453C22.9607 9.20779 24.2772 10.5231 24.2772 12.1397V29.2968C24.2772 30.9135 22.9607 32.2287 21.3453 32.2287H4.18819C2.57218 32.2287 1.25627 30.9135 1.25627 29.2968V12.1397C1.25627 10.5231 2.57218 9.20779 4.18819 9.20779H6.08296H7.43026H8.67272H8.6859V9.20528C9.02618 9.19775 9.30054 8.92213 9.30054 8.57997C9.30054 8.23843 9.02618 7.96345 8.6859 7.95529V7.95215H8.67272H7.43026H6.08233H4.18757C1.87844 7.95215 0 9.83059 0 12.1397V29.2968C0 31.6059 1.87844 33.4844 4.18757 33.4844H21.3447C23.6538 33.4844 25.5322 31.6059 25.5322 29.2968V12.1397C25.5329 9.83059 23.6538 7.95215 21.3453 7.95215Z"
            fill="black" />
        </svg>`;
        myFileIcon.disabled = false;

    } catch (error) {
        stateDownload.value.loading = false;
        stateDownload.value.error = true;


        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateDownload.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
        myFileIcon.innerHTML = `<svg width="26" height="34" viewBox="0 0 26 34" fill="none"
            xmlns="http://www.w3.org/2000/svg">
            <path
            d="M18.7563 18.4962C18.5102 18.2495 18.1147 18.2495 17.8686 18.4962L13.3941 22.9695V0.627821C13.3941 0.280636 13.1135 0 12.7663 0C12.4191 0 12.1385 0.280636 12.1385 0.627821V22.9695L7.66462 18.4962C7.41914 18.2495 7.02236 18.2495 6.77688 18.4962C6.5314 18.7405 6.5314 19.1372 6.77688 19.3834L12.3224 24.9283C12.3802 24.9867 12.4499 25.0319 12.5258 25.0639C12.6031 25.0959 12.6841 25.1128 12.7663 25.1128C12.8485 25.1128 12.9295 25.0959 13.0068 25.0639C13.0827 25.0319 13.1524 24.9867 13.2102 24.9283L18.7563 19.3834C19.0012 19.1372 19.0012 18.7405 18.7563 18.4962Z"
            fill="black" />
            <path
            d="M21.3453 7.95215H19.4499H18.1026H16.8601H16.847V7.95529C16.5073 7.96219 16.2323 8.23781 16.2323 8.57997C16.2323 8.92213 16.5073 9.19775 16.847 9.20528V9.20779H16.8601H18.1026H19.4499H21.3453C22.9607 9.20779 24.2772 10.5231 24.2772 12.1397V29.2968C24.2772 30.9135 22.9607 32.2287 21.3453 32.2287H4.18819C2.57218 32.2287 1.25627 30.9135 1.25627 29.2968V12.1397C1.25627 10.5231 2.57218 9.20779 4.18819 9.20779H6.08296H7.43026H8.67272H8.6859V9.20528C9.02618 9.19775 9.30054 8.92213 9.30054 8.57997C9.30054 8.23843 9.02618 7.96345 8.6859 7.95529V7.95215H8.67272H7.43026H6.08233H4.18757C1.87844 7.95215 0 9.83059 0 12.1397V29.2968C0 31.6059 1.87844 33.4844 4.18757 33.4844H21.3447C23.6538 33.4844 25.5322 31.6059 25.5322 29.2968V12.1397C25.5329 9.83059 23.6538 7.95215 21.3453 7.95215Z"
            fill="black" />
        </svg>`;
        myFileIcon.disabled = false;
    }
}

async function editKycs() {

    stateEdit.value.loading = true;
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = {
        en: "",
        ar: "",
    };

    let myStatus = "";
    let data = {};

    if (editKycsData.value.state == 'approve')
        myStatus = "approve";
    else if (editKycsData.value.state == 'reject') {
        myStatus = "reject";
        data.rejectionReason = editKycsData.value.reason;
    }
    else if (editKycsData.value.state == 'block') {
        myStatus = "blocking";
        data.blockingReason = editKycsData.value.reason;
    }
    else if (editKycsData.value.state == 'unapprove') {
        myStatus = "remove-verifying";
        data.removeVerifyingReason = editKycsData.value.reason;
    }
    else if (editKycsData.value.state == 'unblock')
        myStatus = "cancel-blocking";

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/kycs/${myStatus}/${editKycsData.value._id}`;


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

watch(
    () => ({ ...search.value }),
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

const selectCountry = (country) => {
    search.value.country = country.iso2
    dropdownOpen.value = false
    countrySearch.value = ''
}

/**
 * Format date to yyyy-mm-dd / hh:mm:ss
 * @param {Date|string} dateInput - Date object or date string
 * @returns {string} Formatted date string
 */
const formatDate = (dateInput) => {
    if (!dateInput) return '----/--/-- / --:--:--';
    
    const date = new Date(dateInput);
    
    // Check if date is valid
    if (isNaN(date.getTime())) return '----/--/-- / --:--:--';
    
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    
    return `${year}-${month}-${day} / ${hours}:${minutes}:${seconds}`;
};

const getLatestDate = (item) => {

    const dateFields = [
        'verifiedAt',
        'blockedAt',
        'cancelBlockedAt',
        'removeVerifiedAt',
        'rejectedAt'
    ];

    const isValidDate = (dateStr) => {
        if (!dateStr) return false;
        const date = new Date(dateStr);
        return date instanceof Date && !isNaN(date);
    };

    const validTimestamps = dateFields
        .filter(field => isValidDate(item[field]))
        .map(field => new Date(item[field]).getTime());

    if (validTimestamps.length === 0) {
        return "----------";
    }

    const latestTimestamp = Math.max(...validTimestamps);
    const myData = new Date(latestTimestamp)
    return formatDate(myData);
};

</script>