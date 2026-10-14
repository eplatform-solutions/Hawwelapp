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
        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">
            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div
                    class="md:flex justify-between w-full flex-row-reverse px-4 items-center bg-[#d8d8d8] py-5 border-b border-black">

                    <div class="md:mb-0 mb-4 text-center">
                        <button @click="showAddModal"
                            class="bg-[#B9A779] text-black sm:text-[16px]/8 text-[12px]/5 px-3 py-1 rounded-full font-bold! cursor-pointer">
                            {{ $t('Add admin') }}
                        </button>
                    </div>

                    <div class="sm:flex items-center flex-row-reverse justify-between gap-3 lg:gap-5">
                        <div
                            class="flex items-center flex-row-reverse flex-wrap justify-center sm:justify-between gap-3 lg:gap-5 sm:mb-0 mb-4">
                            <div class="relative inline-block">
                                <div class="relative flex flex-row-reverse gap-2 items-center bg-[#B9A779] px-3 py-1 rounded-full cursor-pointer"
                                    @click="openDatePicker">
                                    <input type="date" ref="dateInput" v-model="selectedDate"
                                        class="absolute top-0 left-0 w-full h-full opacity-0 cursor-pointer sm:text-[16px]/8 text-[12px]/5 font-bold!" />
                                    <div class="pointer-events-none">
                                        <svg width="13" height="8" viewBox="0 0 13 8" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M6.36391 4.94972L11.3137 0L12.7279 1.41421L6.36391 7.77822L0 1.41421L1.41421 0L6.36391 4.94972Z"
                                                fill="black" />
                                        </svg>
                                    </div>
                                    <span
                                        class="text-black sm:text-[16px]/8 text-[12px]/5 font-bold! pointer-events-none">
                                        {{ displayDate }}
                                    </span>
                                    <div class="pointer-events-none">
                                        <svg width="15" height="15" viewBox="0 0 15 15" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M5.25 0V1.5H9.75V0H11.25V1.5H14.25C14.6642 1.5 15 1.83579 15 2.25V14.25C15 14.6642 14.6642 15 14.25 15H0.75C0.33579 15 0 14.6642 0 14.25V2.25C0 1.83579 0.33579 1.5 0.75 1.5H3.75V0H5.25ZM13.5 7.5H1.5V13.5H13.5V7.5ZM6.75 9V12H3V9H6.75ZM3.75 3H1.5V6H13.5V3H11.25V4.5H9.75V3H5.25V4.5H3.75V3Z"
                                                fill="black" />
                                        </svg>
                                    </div>
                                </div>
                            </div>

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
                                            <svg v-if="selectedOptionState === option.label" width="16" height="16"
                                                viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <path d="M13.333 4L6.00033 11.3333L2.66699 8" stroke="#B9A779"
                                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                            </svg>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div v-if="roles?.length > 0" class="relative inline-block">
                                <button @click="toggleDropdownRole"
                                    class="flex flex-row-reverse gap-2 items-center bg-[#B9A779] px-3 py-1 rounded-full cursor-pointer w-full min-w-30">
                                    <div class="transform transition-transform duration-200"
                                        :class="{ 'rotate-180': showDropdownRole }">
                                        <svg width="13" height="8" viewBox="0 0 13 8" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M6.36391 4.94972L11.3137 0L12.7279 1.41421L6.36391 7.77822L0 1.41421L1.41421 0L6.36391 4.94972Z"
                                                fill="black" />
                                        </svg>
                                    </div>
                                    <div
                                        class="text-black sm:text-[16px]/8 text-[12px]/5 font-bold! flex-1 text-center">
                                        {{ selectedOptionRole || $t('role') }}
                                    </div>
                                </button>
                                <div v-if="showDropdownRole"
                                    class="absolute top-full mt-2 right-0 z-50 bg-white border border-gray-300 rounded-lg shadow-xl min-w-37.5">
                                    <div class="py-2">
                                        <div v-for="option in optionsRole" :key="option.value"
                                            @click="selectOptionRole(option)"
                                            class="px-4 py-2 hover:bg-gray-100 cursor-pointer flex items-center justify-between gap-3"
                                            :class="{ 'bg-[#B9A779] bg-opacity-20': selectedOptionRole === option.label }">
                                            <span class="text-black text-[14px] font-medium">{{ option.label }}</span>
                                            <svg v-if="selectedOptionRole === option.label" width="16" height="16"
                                                viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                <path d="M13.333 4L6.00033 11.3333L2.66699 8" stroke="#B9A779"
                                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                            </svg>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="flex justify-center">
                            <input type="text" v-model="search.userName"
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
                                            {{ $t('username') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('status') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('role') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('joinDate') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('lastActivity') }}
                                        </th>
                                        <th
                                            class="tracking-[20%]! px-3 sm:px-5 text-[#6B1F2A] font-bold! text-[10px]/5 sm:text-[12px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t('actions') }}
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in admins" :key="item._id">
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
                                            {{ item.userName }}
                                        </td>
                                        <td class="px-3 sm:px-5 text-center whitespace-nowrap">
                                            <div
                                                class="bg-white rounded-3xl text-black font-bold! text-[10px]/5 sm:text-[12px]/8 px-3">
                                                {{ $t(item.status) }}
                                            </div>
                                        </td>
                                        <td class="px-3 sm:px-5 text-center whitespace-nowrap">
                                            <div v-if="item.isSuperAdmin"
                                                class="bg-white rounded-3xl text-black font-bold! text-[10px]/5 sm:text-[12px]/8 px-3">
                                                {{ $t('administrator') }}
                                            </div>
                                            <div v-else-if="item.role"
                                                class="bg-white rounded-3xl text-black font-bold! text-[10px]/5 sm:text-[12px]/8 px-3">
                                                {{ item.role.name }}
                                            </div>
                                        </td>
                                        <td>
                                            <div v-if="item.createdAt"
                                                class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center pb-1 sm:pb-2 whitespace-nowrap">
                                                {{ formatDateOnly(item.createdAt) }}
                                            </div>
                                            <div v-else
                                                class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center pb-1 sm:pb-2 whitespace-nowrap">
                                                -------
                                            </div>
                                        </td>
                                        <td>
                                            <div v-if="item.lastActivity"
                                                class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[12px]/8 text-center pb-1 sm:pb-2 whitespace-nowrap">
                                                {{ formatDateTime(item.lastActivity) }}
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
                                                    <button v-if="!item.isSuperAdmin" class="cursor-pointer"
                                                        @click="showEditModal(item)">
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

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>
    </div>

    <!-- add new admin -->
    <UModal v-model:open="openAdd">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('addNewUser') }}
                    </div>
                    <div>
                        <button @click="openAdd = !openAdd" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="addNewAdmin" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-full-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('fullName') }}
                        </label>
                        <input id="user-full-name" type="text" v-model="newUserData.fullName" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-email" class="text-black font-bold! text-[14px]/8">
                            {{ $t('email') }}
                        </label>
                        <input id="user-email" type="email" v-model="newUserData.email" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-user-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Admin name') }}
                        </label>
                        <input id="user-user-name" type="text" v-model="newUserData.userName" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-phone-number" class="text-black font-bold! text-[14px]/8">
                            {{ $t('phoneNumber') }}
                        </label>
                        <input id="user-phone-number" type="number" v-model="newUserData.mobilePhone" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-password" class="text-black font-bold! text-[14px]/8">
                            {{ $t('password') }}
                        </label>
                        <div class="relative">
                            <input id="user-password" type="password" v-model="newUserData.password" required
                                class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                            <button type="button" @click="switchIcon('user-password')"
                                class="absolute top-2 sm:top-4 cursor-pointer"
                                :class="{ 'left-2': locale == 'ar', 'right-2': locale == 'en' }">
                                <UIcon v-if="isShowPass" id="pass-icon" name="i-heroicons-eye-slash-16-solid"
                                    class="size-5" />
                                <UIcon v-else id="pass-icon" name="i-heroicons-eye-16-solid" class="size-5" />
                            </button>
                        </div>
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-state" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Admin role') }}
                        </label>
                        <select v-model="newUserData.role"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                            <option v-for="item in optionsRoleAddEdit" :key="item.value" :value="item.value"
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

    <!-- edit admin data -->
    <UModal v-model:open="openEdit">
        <template #content>
            <div class="bg-box-gray p-5 overflow-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Edit admin data') }}
                    </div>
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="editAdmin" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-full-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('fullName') }}
                        </label>
                        <input id="edit-full-name" type="text" v-model="editUserData.fullName" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-email" class="text-black font-bold! text-[14px]/8">
                            {{ $t('email') }}
                        </label>
                        <input id="edit-email" type="email" v-model="editUserData.email" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-user-name" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Admin name') }}
                        </label>
                        <input id="edit-user-name" type="text" v-model="editUserData.userName" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="edit-phone-number" class="text-black font-bold! text-[14px]/8">
                            {{ $t('phoneNumber') }}
                        </label>
                        <input id="user-phone-number" type="number" v-model="editUserData.mobilePhone" required
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-state" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Admin status') }}
                        </label>
                        <select v-model="editUserData.status"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                            <option value="active" class="text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                                {{ $t('active') }}
                            </option>
                            <option value="suspended" class="text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                                {{ $t('suspended') }}
                            </option>
                            <option value="blocked" class="text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                                {{ $t('blocked') }}
                            </option>
                        </select>
                    </div>
                    <div class="flex flex-col gap-2 mb-5">
                        <label for="user-state" class="text-black font-bold! text-[14px]/8">
                            {{ $t('Admin role') }}
                        </label>
                        <select v-model="editUserData.role"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                            <option v-for="item in optionsRoleAddEdit" :key="item.value" :value="item.value"
                                class="text-black font-bold! text-[12px]/5 sm:text-[16px]/8">
                                {{ item.label }}
                            </option>
                        </select>
                    </div>
                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateEdit.loading"
                            :disabled="(stateEdit.loading) || (checkLastEdit.email == editUserData.email && checkLastEdit.fullName == editUserData.fullName && checkLastEdit.mobilePhone == editUserData.mobilePhone && checkLastEdit.role == editUserData.role && checkLastEdit.status == editUserData.status && checkLastEdit.userName == editUserData.userName)"
                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t('Edit') }}
                        </UButton>
                    </div>
                </form>
            </div>
        </template>
    </UModal>

    <!-- delete user -->
    <UModal v-model:open="openDelete">
        <template #content>
            <div class="bg-box-gray p-5">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t('Delete admin') }}
                    </div>
                    <div>
                        <button @click="openDelete = !openDelete" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>
                </div>
                <form @submit.prevent="deleteAdmin" :class="{ 'ar-dir': locale == 'ar' }">
                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t('Are you sure you want to delete this admin?') }}
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
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});


const toast = useToast();
const state = ref({
    loading: false,
    error: false,
    msg: {
        en: "",
        ar: ""
    }
});

const dateInput = ref(null);
const selectedDate = ref('');

const openDatePicker = () => {
    dateInput.value.showPicker();
}

const displayDate = computed(() => {
    if (!selectedDate.value) return t('date');

    const date = new Date(selectedDate.value)
    const localeLan = locale.value === 'ar' ? 'ar-EG' : 'en-US';
    const options = {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    };
    if (locale.value === "ar") {
        options.numberingSystem = "arab";
    }
    return date.toLocaleDateString(localeLan, options);
});

function formatDateOnly(value) {
    if (!value) return "-------";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return "-------";
    const localeLan = locale.value === "ar" ? "ar-EG" : "en-US";
    const options = {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
    };
    if (locale.value === "ar") {
        options.numberingSystem = "arab";
    }
    return date.toLocaleDateString(localeLan, options);
}

function formatDateTime(value) {
    if (!value) return "-------";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return "-------";
    const localeLan = locale.value === "ar" ? "ar-EG" : "en-US";
    const options = {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
    };
    if (locale.value === "ar") {
        options.numberingSystem = "arab";
    }
    return date.toLocaleString(localeLan, options);
}

const newUserData = ref({
    fullName: "",
    email: "",
    userName: "",
    mobilePhone: "",
    password: "",
    role: "",
});

const editUserData = ref({
    fullName: "",
    email: "",
    status: "",
    userName: "",
    mobilePhone: "",
    role: "",
    id: ""
});

const checkLastEdit = ref({
    fullName: "",
    email: "",
    status: "",
    userName: "",
    mobilePhone: "",
    role: "",
    id: ""
});

const openAdd = ref(false);
const openEdit = ref(false);
const openDelete = ref(false);

function showDeleteModal(item) {
    openDelete.value = true;
    deleteAdminItem.value.id = item._id;
}

async function showAddModal() {
    if (roles.value?.length == 0) {
        stateAdd.value.error = false;
        stateAdd.value.msg = {
            ar: "يرجى إضافة دور واحد على الأقل قبل إضافة مسؤول جديد.",
            en: "Please add at least one role before adding a new admin"
        };
        await nextTick();
        stateAdd.value.error = true;
        return;
    }
    newUserData.value = {
        fullName: "",
        email: "",
        mobilePhone: "",
        userName: "",
        password: "",
        role: "",
    };
    openAdd.value = true;
}

function showEditModal(item) {
    editUserData.value = {
        fullName: item.fullName,
        email: item.email,
        mobilePhone: Number(item.mobilePhone),
        userName: item.userName,
        status: item.status,
        role: item?.role?._id,
        id: item._id
    };

    checkLastEdit.value = {
        fullName: item.fullName,
        email: item.email,
        mobilePhone: Number(item.mobilePhone),
        userName: item.userName,
        status: item.status,
        role: item?.role?._id,
        id: item._id
    };
    openEdit.value = true;
}

const showDropdownState = ref(false);
const showDropdownRole = ref(false);
const selectedOptionState = ref('');
const selectedOptionRole = ref('');

const search = ref({
    state: "",
    role: "",
    userName: "",
});

const optionsState = computed(() => [
    { value: '', label: t('All status') },
    { value: 'active', label: t('active') },
    // { value: 'suspended', label: t('suspended') },
    { value: 'blocked', label: t('blocked') }
])

const optionsRole = ref([
    { value: "", label: t('All roles') }
]);

const optionsRoleAddEdit = ref([]);

const toggleDropdownState = () => {
    showDropdownState.value = !showDropdownState.value;
}

const toggleDropdownRole = () => {
    showDropdownRole.value = !showDropdownRole.value;
}

const selectOptionState = (option) => {
    search.value.state = option.value;
    selectedOptionState.value = option.label;
    showDropdownState.value = false;
}

const selectOptionRole = (option) => {
    search.value.role = option.value;
    selectedOptionRole.value = option.label;
    showDropdownRole.value = false;
}

const handleClickOutside = (event) => {
    if (!event.target.closest('.relative')) {
        showDropdownState.value = false
        showDropdownRole.value = false
    }
}

const admins = ref([]);
const roles = ref([]);
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

    state.value.msg = {
        ar: "",
        en: ""
    };
    getAllRoles().then(res => {
        if (res?.length > 0) {
            roles.value = res;
            optionsRole.value = [
                { value: "", label: t('All roles') }
            ];
            optionsRoleAddEdit.value = [];
            res.forEach(ele => {
                const myItem = {
                    value: ele._id,
                    label: ele.name
                };
                optionsRole.value.push(myItem);
                // Filtering (optionsRole) can show every role - only the
                // assign-to-an-admin dropdown needs restricting. Mirrors the
                // backend's ceiling check: a non-super-admin can't assign a
                // role that carries a permission they don't hold themselves.
                const rolePermissionCodeNames = (ele.permissions || []).map(p => p.codeName);
                const isAssignable = store.getIsSuperAdmin ||
                    rolePermissionCodeNames.every(codeName => store.getPermissions.includes(codeName));
                if (isAssignable) {
                    optionsRoleAddEdit.value.push(myItem);
                }
            });
        }
    }).then(() => {
        getAllAdmins().then(res => {
            if (res) {
                admins.value = res.admins;
                totalPages.value = Math.ceil(res.adminsCount / 10);
            }
        }).then(() => {
            state.value.loading = false;
        });
    });
}

async function getAllAdmins() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/admins/all-admins-inside-the-page`;

    let myPrarms = {
        pageNumber: page.value,
        pageSize: 10
    };

    if (search.value.state != "") {
        myPrarms.status = search.value.state;
    }

    if (search.value.role != "") {
        myPrarms.role = search.value.role;
    }

    if (search.value.userName != "") {
        myPrarms.userName = search.value.userName;
    }


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

const stateAdd = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const isValidSyrianPhone = (num) => {
    const cleanNum = String(num).replace(/[\s-_]/g, '');
    return /^9639[986543]\d{7}$/.test(cleanNum);
};

const isStrongPassword = (password) => {

    if (password.length < 8) return false;

    const hasUpperCase = /[A-Z]/.test(password);
    const hasLowerCase = /[a-z]/.test(password);
    const hasNumber = /\d/.test(password);
    const hasSpecialChar = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);

    return hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar;
};

async function getMyAdmins() {
    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    state.value.msg = {
        ar: "",
        en: ""
    };
    getAllAdmins().then(res => {
        if (res) {
            admins.value = res.admins;
            totalPages.value = Math.ceil(res.adminsCount / 10);
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function addNewAdmin() {

    newUserData.value.mobilePhone = String(newUserData.value.mobilePhone);
    if (!isValidSyrianPhone(newUserData.value.mobilePhone)) {
        stateAdd.value.msg = {
            ar: "رقم الهاتف غير صالح",
            en: "Phone number is not valid"
        }
        toast.add({
            title: locale.value == 'en' ? `Failed` : `فشل`,
            description: locale.value == 'en' ? stateAdd.value.msg.en : stateAdd.value.msg.ar,
            color: "error"
        });
        return;
    }

    if (!isStrongPassword(newUserData.value.password)) {
        stateAdd.value.msg = {
            ar: "يجب ان تحتوي كلمة المرور على رقم واحد على الاقل وحرف واحد صغير على الاقل وحرف واحد كبير على الاقل ورمز واحد عىل الاقل وان يكون طولها 8 محارف",
            en: "The password must contain at least one number, at least one lowercase letter, at least one uppercase letter, and at least one symbol, and must be at least 8 characters long."
        }
        toast.add({
            title: locale.value == 'en' ? `Failed` : `فشل`,
            description: locale.value == 'en' ? stateAdd.value.msg.en : stateAdd.value.msg.ar,
            color: "error"
        });
        return;
    }

    if (newUserData.value.role == "") {
        stateAdd.value.msg = {
            ar: "يجب ان تختار دور",
            en: "You must choose a role"
        }
        toast.add({
            title: locale.value == 'en' ? `Failed` : `فشل`,
            description: locale.value == 'en' ? stateAdd.value.msg.en : stateAdd.value.msg.ar,
            color: "error"
        });
        return;
    }

    // Change state loading to loading
    stateAdd.value.loading = true;

    // clean status for new request
    stateAdd.value.error = false;
    stateAdd.value.success = false;
    stateAdd.value.msg = {
        ar: "",
        en: ""
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/admins/create`;

    const data = {
        email: newUserData.value.email,
        password: newUserData.value.password,
        fullName: newUserData.value.fullName,
        userName: newUserData.value.userName,
        mobilePhone: `+${newUserData.value.mobilePhone}`,
        role: newUserData.value.role
    };


    try {
        const response = await axios.post(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
        });


        stateAdd.value.loading = false;

        if (!response.data.error) {
            // opreation succeeded
            stateAdd.value.success = true;
            stateAdd.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
        }
        else {
            // opreation failed
            stateAdd.value.error = true;
            stateAdd.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
            return;
        }

        getMyAdmins();
        openAdd.value = false;
    }
    catch (error) {
        stateAdd.value.loading = false;
        stateAdd.value.error = true;

        const errorMessage = handelErrorType(error);
        stateAdd.value.msg = {
            en: errorMessage,
            ar: errorMessage
        }
    }
}

const stateEdit = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

async function editAdmin() {

    editUserData.value.mobilePhone = String(editUserData.value.mobilePhone);
    if (!isValidSyrianPhone(editUserData.value.mobilePhone)) {
        stateEdit.value.msg = {
            ar: "رقم الهاتف غير صالح",
            en: "Phone number is not valid"
        }
        toast.add({
            title: locale.value == 'en' ? `Failed` : `فشل`,
            description: locale.value == 'en' ? stateEdit.value.msg.en : stateEdit.value.msg.ar,
            color: "error"
        });
        return;
    }

    if (editUserData.value.role == "") {
        stateEdit.value.msg = {
            ar: "يجب ان تختار دور",
            en: "You must choose a role"
        }
        toast.add({
            title: locale.value == 'en' ? `Failed` : `فشل`,
            description: locale.value == 'en' ? stateEdit.value.msg.en : stateEdit.value.msg.ar,
            color: "error"
        });
        return;
    }

    // Change state loading to loading
    stateEdit.value.loading = true;

    // clean status for new request
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = {
        ar: "",
        en: ""
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/admins/update/${editUserData.value.id}`;


    let data = {};

    if (checkLastEdit.value.email != editUserData.value.email)
        data.email = editUserData.value.email;

    if (checkLastEdit.value.fullName != editUserData.value.fullName)
        data.fullName = editUserData.value.fullName;

    if (checkLastEdit.value.status != editUserData.value.status)
        data.status = editUserData.value.status;

    if (checkLastEdit.value.userName != editUserData.value.userName)
        data.userName = editUserData.value.userName;

    if (checkLastEdit.value.mobilePhone != editUserData.value.mobilePhone)
        data.mobilePhone = `+${editUserData.value.mobilePhone}`;

    if (checkLastEdit.value.role != editUserData.value.role)
        data.role = editUserData.value.role;


    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
        });


        stateEdit.value.loading = false;

        if (!response.data.error) {
            // opreation succeeded
            stateEdit.value.success = true;
            stateEdit.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
        }
        else {
            // opreation failed
            stateEdit.value.error = true;
            stateEdit.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
            return;
        }

        getMyAdmins();
        openEdit.value = false;
    }
    catch (error) {
        stateEdit.value.loading = false;
        stateEdit.value.error = true;

        const errorMessage = handelErrorType(error);
        stateEdit.value.msg = {
            en: errorMessage,
            ar: errorMessage
        }
    }
}

const stateDelete = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});
const deleteAdminItem = ref({
    id: ""
});

async function deleteAdmin() {

    // Change state loading to loading
    stateDelete.value.loading = true;

    // clean status for new request
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = {
        ar: "",
        en: ""
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/admins/delete/${deleteAdminItem.value.id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
        });


        stateDelete.value.loading = false;

        if (!response.data.error) {
            // opreation succeeded
            stateDelete.value.success = true;
            stateDelete.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
        }
        else {
            // opreation failed
            stateDelete.value.error = true;
            stateDelete.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
            return;
        }

        page.value = 1;
        getMyAdmins();
        openDelete.value = false;
    }
    catch (error) {
        stateDelete.value.loading = false;
        stateDelete.value.error = true;

        const errorMessage = handelErrorType(error);
        stateDelete.value.msg = {
            en: errorMessage,
            ar: errorMessage
        }
    }
}

watch(
    () => page.value,
    () => {
        getMyAdmins();
    }
);

watch(
    () => search.value.state,
    () => {
        getMyAdmins();
    }
);

watch(
    () => search.value.role,
    () => {
        getMyAdmins();
    }
);

watch(
    () => search.value.userName,
    () => {
        getMyAdmins();
    }
);

const isShowPass = ref(false);

function switchIcon(ele) {
    let inputEle = document.getElementById(ele);

    if (inputEle.type == 'password') {
        inputEle.type = "text";
        isShowPass.value = true;
    }
    else {
        inputEle.type = "password";
        isShowPass.value = false;
    }
}


onMounted(() => {
    document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside)
})
</script>