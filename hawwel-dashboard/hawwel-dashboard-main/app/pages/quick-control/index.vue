<template>

    <ClientOnly>
        <div>
            <use-toast v-if="stateEditTrans.error" head="Failed"
                :body="locale == 'en' ? stateEditTrans.msg.en : stateEditTrans.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditTrans.success" head="Success"
                :body="locale == 'en' ? stateEditTrans.msg.en : stateEditTrans.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateEditMain.error" head="Failed"
                :body="locale == 'en' ? stateEditMain.msg.en : stateEditMain.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditMain.success" head="Success"
                :body="locale == 'en' ? stateEditMain.msg.en : stateEditMain.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateEditRate.error" head="Failed"
                :body="locale == 'en' ? stateEditRate.msg.en : stateEditRate.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditRate.success" head="Success"
                :body="locale == 'en' ? stateEditRate.msg.en : stateEditRate.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateEditPay.error" head="Failed"
                :body="locale == 'en' ? stateEditPay.msg.en : stateEditPay.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditPay.success" head="Success"
                :body="locale == 'en' ? stateEditPay.msg.en : stateEditPay.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateDeletePay.error" head="Failed"
                :body="locale == 'en' ? stateDeletePay.msg.en : stateDeletePay.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateDeletePay.success" head="Success"
                :body="locale == 'en' ? stateDeletePay.msg.en : stateDeletePay.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateEditWallet.error" head="Failed"
                :body="locale == 'en' ? stateEditWallet.msg.en : stateEditWallet.msg.ar" color="error"
                icon="i-heroicons-exclamation-circle-16-solid">
            </use-toast>

            <use-toast v-if="stateEditWallet.success" head="Success"
                :body="locale == 'en' ? stateEditWallet.msg.en : stateEditWallet.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <use-toast v-if="stateCopy.active" head="Success"
                :body="locale == 'en' ? stateCopy.msg.en : stateCopy.msg.ar" color="success"
                icon="i-heroicons-check-badge-16-solid">
            </use-toast>

            <div>
                <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">
                    <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                        :class="{ 'ar-dir': locale == 'ar' }">

                        <HeaderPage />

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
                        <!-- content -->
                        <div v-else class="pb-10">
                            <div class="bg-box-green quick-card quick-card-compact mb-10">
                                <div class="flex justify-between items-center gap-20 mb-2 px-5">
                                    <div class="text-black sm:text-[16px]/8 text-[12px]/6 font-bold!">
                                        {{ $t('stopSendingOperations') }}
                                    </div>
                                    <div class="en-dir">
                                        <USwitch :loading="stateEditTrans.loading"
                                            :model-value="systemSettings.isTransferDisabled"
                                            @update:model-value="editSystemSettings('trans')" :ui="{
                                                base: systemSettings.isTransferDisabled == true ? 'bg-[#C6C6C6]!' : 'bg-[#B7B7B7]!',
                                                thumb: systemSettings.isTransferDisabled == true ? 'bg-[#F5F5F5]!' : 'bg-[#999696]!',
                                            }" />
                                    </div>
                                </div>

                                <div class="border-b border-black w-full mb-2"></div>

                                <div class="flex justify-between items-center gap-20 px-5">
                                    <div class="flex flex-col">
                                        <div class="text-black sm:text-[16px]/8 text-[12px]/6 font-bold!">
                                            {{ $t('maintenanceMode') }}
                                        </div>
                                        <div class="text-[#F6F6F6] sm:text-[12px]/8 text-[10px]/5">
                                            {{ $t('maintenanceDescription') }}
                                        </div>
                                    </div>
                                    <div class="en-dir">
                                        <USwitch :loading="stateEditMain.loading"
                                            v-model="systemSettings.isMaintenanceMode"
                                            @update:model-value="editSystemSettings('main')" :ui="{
                                                base: systemSettings.isMaintenanceMode == true ? 'bg-[#C6C6C6]!' : 'bg-[#B7B7B7]!',
                                                thumb: systemSettings.isMaintenanceMode == true ? 'bg-[#F5F5F5]!' : 'bg-[#999696]!',
                                            }" />
                                    </div>
                                </div>
                            </div>

                            <!-- second box -->
                            <form @submit.prevent="editRate" class="bg-box-green quick-card quick-card-compact mb-10">
                                <div class="text-black sm:text-[16px]/8 text-[12px]/6 font-bold! mb-4">
                                    {{ $t('editUSDTPrice') }}
                                </div>

                                <div class="mb-3">
                                    <div class="flex justify-between gap-5">
                                        <div
                                            class="border border-[#6B1F2A] rounded-2xl flex flex-row-reverse items-center sm:px-3 sm:py-2 px-2 py-1 gap-2">
                                            <div class="text-white font-bold! sm:text-[16px]/8 text-[12px]/6"> USDT
                                            </div>
                                            <div>
                                                <input type="number" v-model="exchangeRates.USDT"
                                                    class="p-1 w-20 text-black font-bold! sm:text-[16px]/8 text-[12px]/6" />
                                            </div>
                                        </div>

                                        <div
                                            class="border border-[#6B1F2A] rounded-2xl flex flex-row-reverse items-center sm:px-3 sm:py-2 px-2 py-1 gap-2">
                                            <div class="text-white font-bold! sm:text-[16px]/8 text-[12px]/6"> USDC
                                            </div>
                                            <div>
                                                <input type="number" v-model="exchangeRates.USDC"
                                                    class="p-1 w-20 text-black font-bold! sm:text-[16px]/8 text-[12px]/6" />
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex justify-center">
                                    <UButton type="submit" :loading="stateEditRate.loading"
                                        :disabled="stateEditRate.loading"
                                        class="bg-[#B9A779] sm:text-[13px]/8 text-[11px]/5 text-black px-4 py-1 rounded-2xl font-bold! w-fit cursor-pointer">
                                        {{ $t('saveEdit') }}
                                    </UButton>
                                </div>
                            </form>

                            <div v-if="paymentMethods.length > 0">
                                <div class="flex justify-center mb-2">
                                    <div class="sm:text-[16px]/8 text-[12px]/6 text-black font-bold!">
                                        {{ $t('editCommission') }}
                                    </div>
                                </div>
                                <!-- third box -->
                                <div class="bg-box-green quick-card mb-5">
                                    <div class="flex sm:gap-10 gap-5">
                                        <!-- first col -->
                                        <div class="flex flex-col gap-4">
                                            <!-- main table title -->
                                            <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                {{ $t('entity') }}
                                            </div>

                                            <div v-for="item in paymentMethods" :key="item._id"
                                                class="h-7 flex justify-center items-center">
                                                <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                    {{ locale == 'en' ? item.name.en : item.name.ar }}
                                                </div>
                                            </div>
                                        </div>

                                        <!-- second col -->
                                        <div class="flex flex-col gap-4 items-center">
                                            <!-- main table title -->
                                            <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                {{ $t('currentCommission') }}
                                            </div>

                                            <div v-for="item in paymentMethods" :key="item._id"
                                                class="h-7 flex justify-center items-center">
                                                <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                    {{ item.fee }}%
                                                </div>
                                            </div>

                                        </div>

                                        <!-- third col -->
                                        <div class="flex flex-col gap-4 items-center">
                                            <!-- main table title -->
                                            <div class="text-black sm:text-[14px]/8 text-[11px]/5 font-bold!">
                                                {{ $t('actions') }}
                                            </div>

                                            <!-- Repeatable action buttons -->
                                            <div class="flex gap-2 items-center justify-center h-7"
                                                v-for="item in paymentMethods" :key="item._id">
                                                <!-- delete -->
                                                <button @click="showDeletePayModel(item)" class="cursor-pointer"
                                                    :title="$t('delete')">
                                                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                                                            fill="#FB0F0F" />
                                                    </svg>
                                                </button>

                                                <!-- edit -->
                                                <button @click="showEditPayModel(item)" class="cursor-pointer"
                                                    :title="$t('edit')">
                                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                            fill="black" />
                                                    </svg>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex justify-center my-3">
                                    <nuxt-link to="/payment-methods"
                                        class="text-blue-500 underline text-[14px]/5 font-bold!">
                                        {{ $t("See all payment methods") }}
                                    </nuxt-link>
                                </div>
                            </div>

                            <div v-else class="flex justify-center mx-3 my-10">
                                <div class="text-black text-[14px]/5 sm:text-[16px]/8 font-bold!">
                                    {{ $t("There are no payment methods yet") }}
                                </div>
                            </div>

                            <div class="flex justify-center mb-2">
                                <div class="sm:text-[16px]/8 text-[12px]/6 text-black font-bold!">
                                    {{ $t('Main Wallet Addresses') }}
                                </div>
                            </div>

                            <div>
                                    <div class="bg-box-green quick-card mb-5">

                                    <div v-for="item in wallets" :key="item._id"
                                        class="flex gap-4 items-center justify-between"
                                        :class="{ 'flex-row-reverse': locale == 'ar' }">
                                        <div class="flex flex-col gap-2" :class="{ 'items-end': locale == 'ar' }">
                                            <div class="text-black text-[16px]/8 font-bold!">
                                                {{ item.symbol }} ({{ item.network }})
                                            </div>
                                            <div class="text-white text-[11px]/8 font-bold!">
                                                {{ item.address }}
                                            </div>
                                        </div>
                                        <div class="flex gap-3">
                                            <button @click="showEditWalletModal(item)" class="cursor-pointer">
                                                <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path
                                                        d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                        fill="black" />
                                                </svg>
                                            </button>
                                            <button @click="copyToClipboard(item.address)" class="cursor-pointer">
                                                <svg width="21" height="23" viewBox="0 0 21 23" fill="none"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path
                                                        d="M16.2306 10.1384C16.2306 7.26647 16.2306 5.83052 15.3384 4.93833C14.4462 4.04614 13.0103 4.04614 10.1384 4.04614H7.09223C4.22035 4.04614 2.78441 4.04614 1.8922 4.93833C0.999989 5.83052 0.999989 7.26647 0.999989 10.1384V15.2153C0.999989 18.0871 0.999989 19.5231 1.8922 20.4153C2.78441 21.3075 4.22035 21.3075 7.09223 21.3075H10.1384C13.0103 21.3075 14.4462 21.3075 15.3384 20.4153C16.2306 19.5231 16.2306 18.0871 16.2306 15.2153V10.1384Z"
                                                        stroke="black" stroke-width="2" />
                                                    <path
                                                        d="M16.2306 18.2613C17.9129 18.2613 19.2767 16.8976 19.2767 15.2152V9.12299C19.2767 5.29377 19.2767 3.37917 18.0871 2.18958C16.8975 1 14.9829 1 11.1537 1H7.09222C5.40985 1 4.0461 2.3638 4.0461 4.04612"
                                                        stroke="black" stroke-width="2" />
                                                </svg>
                                            </button>
                                        </div>
                                    </div>

                                    <div v-if="!wallets.length" class="flex justify-center">
                                        <UButton @click="showCreateWalletModal('central')"
                                            class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                            {{ $t('Add central wallet') }}
                                        </UButton>
                                    </div>

                                </div>
                            </div>

                            <div v-if="myDataInfo?.networkFeeFundingBlockchainWallets">
                                <div class="flex justify-center my-2">
                                    <div class="sm:text-[16px]/8 text-[12px]/6 text-black font-bold!">
                                        {{ $t('Network Fee Funding Blockchain Wallet Addresses') }}
                                    </div>
                                </div>

                                <div>
                                    <div class="bg-box-green quick-card">

                                        <div v-for="item in myDataInfo.networkFeeFundingBlockchainWallets"
                                            :key="item._id" class="flex gap-4 items-center justify-between"
                                            :class="{ 'flex-row-reverse': locale == 'ar' }">
                                            <div class="flex flex-col gap-2" :class="{ 'items-end': locale == 'ar' }">
                                                <div class="text-black text-[16px]/8 font-bold!">
                                                    {{ item.symbol }} ({{ item.network }})
                                                </div>
                                                <div class="text-white text-[11px]/5 font-bold!">
                                                    {{ item.address }}
                                                </div>
                                                <div class="text-white text-[11px]/5 font-bold!">
                                                    {{ $t("Private key:") }} {{ item.privateKey }}
                                                </div>
                                            </div>
                                            <div class="flex gap-3">
                                                <button @click="showEditWalletModalFee(item)" class="cursor-pointer">
                                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M2 15.9706H3.41421L12.7279 6.65685L11.3137 5.24264L2 14.5564V15.9706ZM18 17.9706H0V13.7279L13.435 0.29289C13.8256 -0.09763 14.4587 -0.09763 14.8492 0.29289L17.6777 3.12132C18.0682 3.51184 18.0682 4.14501 17.6777 4.53553L6.24264 15.9706H18V17.9706ZM12.7279 3.82843L14.1421 5.24264L15.5563 3.82843L14.1421 2.41421L12.7279 3.82843Z"
                                                            fill="black" />
                                                    </svg>
                                                </button>
                                                <button @click="copyToClipboard(item.address)" class="cursor-pointer">
                                                    <svg width="21" height="23" viewBox="0 0 21 23" fill="none"
                                                        xmlns="http://www.w3.org/2000/svg">
                                                        <path
                                                            d="M16.2306 10.1384C16.2306 7.26647 16.2306 5.83052 15.3384 4.93833C14.4462 4.04614 13.0103 4.04614 10.1384 4.04614H7.09223C4.22035 4.04614 2.78441 4.04614 1.8922 4.93833C0.999989 5.83052 0.999989 7.26647 0.999989 10.1384V15.2153C0.999989 18.0871 0.999989 19.5231 1.8922 20.4153C2.78441 21.3075 4.22035 21.3075 7.09223 21.3075H10.1384C13.0103 21.3075 14.4462 21.3075 15.3384 20.4153C16.2306 19.5231 16.2306 18.0871 16.2306 15.2153V10.1384Z"
                                                            stroke="black" stroke-width="2" />
                                                        <path
                                                            d="M16.2306 18.2613C17.9129 18.2613 19.2767 16.8976 19.2767 15.2152V9.12299C19.2767 5.29377 19.2767 3.37917 18.0871 2.18958C16.8975 1 14.9829 1 11.1537 1H7.09222C5.40985 1 4.0461 2.3638 4.0461 4.04612"
                                                            stroke="black" stroke-width="2" />
                                                    </svg>
                                                </button>
                                            </div>
                                        </div>

                                        <div v-if="!myDataInfo.networkFeeFundingBlockchainWallets.length"
                                            class="flex justify-center">
                                            <UButton @click="showCreateWalletModal('network-fee-funding')"
                                                class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                                {{ $t('Add network fee funding wallet') }}
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

            <!-- modal for edit payment method -->
            <UModal v-model:open="openEditPay">
                <template #content>
                    <div class="bg-box-gray p-5 overflow-auto">
                        <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                            :class="{ 'flex-row-reverse': locale == 'ar' }">
                            <div class="text-black text-[16px]/8 font-bold!">
                                {{ $t('Edit commission rate') }}
                            </div>
                            <div>
                                <button @click="openEditPay = !openEditPay" class="cursor-pointer">
                                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                                </button>
                            </div>
                        </div>
                        <form @submit.prevent="editPay" :class="{ 'ar-dir': locale == 'ar' }">
                            <div class="flex flex-col gap-2 mb-5">
                                <label for="city-name" class="text-black font-bold! text-[14px]/8">
                                    {{ $t('Commission rate') }}
                                </label>
                                <input id="city-name" type="text" v-model="editPayData.fee" required
                                    class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                            </div>
                            <div class="flex justify-center">
                                <UButton type="submit" :loading="stateEditPay.loading" :disabled="stateEditPay.loading"
                                    class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                    {{ $t('Edit') }}
                                </UButton>
                            </div>
                        </form>
                    </div>
                </template>
            </UModal>

            <!-- modal for creating the system wallets (central / network fee funding) -->
            <UModal v-model:open="openCreateWallet">
                <template #content>
                    <div class="bg-box-gray p-5 overflow-auto">
                        <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                            :class="{ 'flex-row-reverse': locale == 'ar' }">
                            <div class="text-black text-[16px]/8 font-bold!">
                                {{ createWalletData.type == 'central' ? $t('Add central wallet') : $t('Add network fee funding wallet') }}
                            </div>
                            <div>
                                <button @click="openCreateWallet = !openCreateWallet" class="cursor-pointer">
                                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                                </button>
                            </div>
                        </div>
                        <form @submit.prevent="createWallet" :class="{ 'ar-dir': locale == 'ar' }">
                            <div class="flex flex-col gap-2 mb-5">
                                <label for="create-wallet-value" class="text-black font-bold! text-[14px]/8">
                                    {{ createWalletData.type == 'central' ? $t('Type address') : $t('Type Private Key') }}
                                </label>
                                <input id="create-wallet-value" v-model="createWalletData.value" required
                                    :type="createWalletData.type == 'central' ? 'text' : 'password'" autocomplete="off"
                                    class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                                <div class="text-black text-[12px]/5">
                                    {{ $t('This wallet is used for USDT and USDC on all supported networks') }}
                                </div>
                            </div>
                            <div class="flex justify-center">
                                <UButton type="submit" :loading="stateEditWallet.loading"
                                    :disabled="stateEditWallet.loading"
                                    class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                    {{ $t('Add') }}
                                </UButton>
                            </div>
                        </form>
                    </div>
                </template>
            </UModal>

            <!-- modal for edit wallet -->
            <UModal v-model:open="openEditWallet">
                <template #content>
                    <div class="bg-box-gray p-5 overflow-auto">
                        <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                            :class="{ 'flex-row-reverse': locale == 'ar' }">
                            <div class="text-black text-[16px]/8 font-bold!">
                                {{ $t('Edit wallet') }}
                            </div>
                            <div>
                                <button @click="openEditWallet = !openEditWallet" class="cursor-pointer">
                                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                                </button>
                            </div>
                        </div>
                        <form @submit.prevent="editWallet()" :class="{ 'ar-dir': locale == 'ar' }">
                            <div class="flex flex-col gap-2 mb-5">
                                <label for="wallet-address" class="text-black font-bold! text-[14px]/8">
                                    {{ $t('Type address') }}
                                </label>
                                <input id="wallet-address" type="text" v-model="editWalletItem.address" required
                                    class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                            </div>
                            <div class="flex justify-center">
                                <UButton type="submit" :loading="stateEditWallet.loading"
                                    :disabled="stateEditWallet.loading"
                                    class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                    {{ $t('Edit') }}
                                </UButton>
                            </div>
                        </form>
                    </div>
                </template>
            </UModal>

            <!-- modal for edit wallet -->
            <UModal v-model:open="openEditWalletFee">
                <template #content>
                    <div class="bg-box-gray p-5 overflow-auto">
                        <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                            :class="{ 'flex-row-reverse': locale == 'ar' }">
                            <div class="text-black text-[16px]/8 font-bold!">
                                {{ $t('Edit wallet') }}
                            </div>
                            <div>
                                <button @click="openEditWalletFee = !openEditWalletFee" class="cursor-pointer">
                                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                                </button>
                            </div>
                        </div>
                        <form @submit.prevent="editWallet('Fee')" :class="{ 'ar-dir': locale == 'ar' }">
                            <div class="flex flex-col gap-2 mb-5">
                                <label for="wallet-address" class="text-black font-bold! text-[14px]/8">
                                    {{ $t('Type Private Key') }}
                                </label>
                                <input id="wallet-address" type="text" v-model="editWalletItemFee.privateKey" required
                                    class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[12px]/5 sm:text-[16px]/8" />
                            </div>
                            <div class="flex justify-center">
                                <UButton type="submit" :loading="stateEditWallet.loading"
                                    :disabled="stateEditWallet.loading"
                                    class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                    {{ $t('Edit') }}
                                </UButton>
                            </div>
                        </form>
                    </div>
                </template>
            </UModal>

            <!-- modal for delete payment method -->
            <UModal v-model:open="openDeletePay">

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
                                <button @click="openDeletePay = !openDeletePay" class="cursor-pointer">
                                    <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                                </button>
                            </div>

                        </div>

                        <form @submit.prevent="deletePay" :class="{ 'ar-dir': locale == 'ar' }">

                            <div class="flex flex-col gap-2 mb-5">
                                <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                                    {{ $t("Are you sure you want to delete this payment method?") }}
                                </div>
                            </div>

                            <div class="flex justify-center">
                                <UButton type="submit" :loading="stateDeletePay.loading"
                                    :disabled="stateDeletePay.loading"
                                    class="text-[#6B1F2A] text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                                    {{ $t("Delete") }}
                                </UButton>
                            </div>

                        </form>

                    </div>

                </template>
            </UModal>
        </div>
        <template #fallback>
            <div class="flex justify-center items-center min-h-screen">
                <LoadingIcon />
            </div>
        </template>
    </ClientOnly>

</template>


<script setup>
definePageMeta({
    ssr: false
})
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const editPayData = ref({
    fee: "",
    _id: ""
});

const deletePayData = ref({
    _id: ""
});

const openEditPay = ref(false);

function showEditPayModel(item) {
    editPayData.value.fee = item.fee;
    editPayData.value._id = item._id;
    openEditPay.value = true;
}

const openDeletePay = ref(false);

function showDeletePayModel(item) {
    deletePayData.value._id = item._id;
    openDeletePay.value = true;
}

const state = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEditPay = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateDeletePay = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEditWallet = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const myDataInfo = ref(null);

const systemSettings = ref({
    isTransferDisabled: true,
    isMaintenanceMode: true
});

const exchangeRates = ref({
    USDT: 0,
    USDC: 0
});

const wallets = ref([]);

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

    try {
        const res = await getControleInfo();
        if (!res) return;

        myDataInfo.value = res;
        systemSettings.value = {
            isTransferDisabled: res.systemSettings?.isTransferDisabled ?? false,
            isMaintenanceMode: res.systemSettings?.isMaintenanceMode ?? false
        };

        exchangeRates.value.USDT = 0;
        exchangeRates.value.USDC = 0;
        (res.exchangeRates || []).forEach(ele => {
            if (ele.baseSymbol == "USDT")
                exchangeRates.value.USDT = ele.rate;
            else if (ele.baseSymbol == "USDC")
                exchangeRates.value.USDC = ele.rate;
        });

        wallets.value = res.centralBlockchainWallets || [];
        paymentMethods.value = res.paymentMethods || [];
    }
    finally {
        // always stop loader even if response shape is incomplete
        state.value.loading = false;
    }
}

async function getAllPaymentMethods() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/all-payment-methods-inside-the-page`;

    const myParams = {
        pageNumber: pagePay.value,
        pageSize: pageSize.value,
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

async function getControleInfo() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/quick-control/system-overview`;

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

const paymentMethods = ref([]);

const stateEditTrans = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

const stateEditMain = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

async function editSystemSettings(params) {

    let data = {
        isTransferDisabled: systemSettings.value.isTransferDisabled,
        isMaintenanceMode: systemSettings.value.isMaintenanceMode,
    };

    if (params == "trans") {
        data.isTransferDisabled = !data.isTransferDisabled;
        stateEditTrans.value = {
            loading: true,
            error: false,
            success: false,
            msg: {
                ar: "",
                en: ""
            }
        }
    }

    else {
        // data.isMaintenanceMode = !data.isMaintenanceMode;
        stateEditMain.value = {
            loading: true,
            error: false,
            success: false,
            msg: {
                ar: "",
                en: ""
            }
        }
    }


    const token = store.getToken;
    const apiUrl = `${BASE_URL}/quick-control/update-system-settings`;

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            if (params == "trans")
                stateEditTrans.value = {
                    loading: false,
                    error: true,
                    success: false,
                    msg: {
                        ar: response.data.msg.ar,
                        en: response.data.msg.en
                    }
                }
            else
                stateEditMain.value = {
                    loading: false,
                    error: true,
                    success: false,
                    msg: {
                        ar: response.data.msg.ar,
                        en: response.data.msg.en
                    }
                }
            return;
        }

        if (params == "trans")
            stateEditTrans.value = {
                loading: false,
                error: false,
                success: true,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
        else
            stateEditMain.value = {
                loading: false,
                error: false,
                success: true,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
        getAllInfo();
    }
    catch (error) {

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        if (params = "trans")
            stateEditTrans.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: errorMessage,
                    en: errorMessage
                }
            }
        else
            stateEditMain.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: errorMessage,
                    en: errorMessage
                }
            }
    }
}

const stateEditRate = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        ar: "",
        en: ""
    }
});

async function editRate() {

    stateEditRate.value = {
        loading: true,
        error: false,
        success: false,
        msg: {
            ar: "",
            en: ""
        }
    }

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/exchange-rates/update`;

    let data = {
        USDT_RATE: exchangeRates.value.USDT,
        USDC_RATE: exchangeRates.value.USDC,
    };

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateEditRate.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
            return;
        }

        stateEditRate.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en
            }
        }
        getAllInfo();
    }
    catch (error) {

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditRate.value = {
            loading: false,
            error: true,
            success: false,
            msg: {
                ar: errorMessage,
                en: errorMessage
            }
        }
    }
}

async function editPay() {

    stateEditPay.value = {
        loading: true,
        error: false,
        success: false,
        msg: {
            ar: "",
            en: ""
        }
    }

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/update/${editPayData.value._id}`;

    let data = {
        fee: Number(editPayData.value.fee)
    };

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (response.data.error) {
            stateEditPay.value = {
                loading: false,
                error: true,
                success: false,
                msg: {
                    ar: response.data.msg.ar,
                    en: response.data.msg.en
                }
            }
            return;
        }

        stateEditPay.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en
            }
        }
        getAllInfo();
        openEditPay.value = false;
    }
    catch (error) {

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditPay.value = {
            loading: false,
            error: true,
            success: false,
            msg: {
                ar: errorMessage,
                en: errorMessage
            }
        }
    }
}

async function deletePay() {

    stateDeletePay.value.loading = true;
    stateDeletePay.value.error = false;
    stateDeletePay.value.success = false;
    stateDeletePay.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/payment-methods/delete/${deletePayData.value._id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateDeletePay.value.loading = false;
            stateDeletePay.value.error = true;
            stateDeletePay.value.success = false;
            stateDeletePay.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateDeletePay.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getAllInfo();
        openDeletePay.value = false;
    }
    catch (error) {
        stateDeletePay.value.loading = false;
        stateDeletePay.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateDeletePay.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

const openEditWallet = ref(false);
const editWalletItem = ref({
    address: "",
    _id: ""
});

const openEditWalletFee = ref(false);
const editWalletItemFee = ref({
    privateKey: "",
    _id: ""
});

function showEditWalletModal(item) {
    editWalletItem.value = {
        address: item.address,
        _id: item._id
    };
    openEditWallet.value = true;
}

function showEditWalletModalFee(item) {
    editWalletItemFee.value = {
        privateKey: item.privateKey,
        _id: item._id
    };
    openEditWalletFee.value = true;
}

async function editWallet(type = '') {

    stateEditWallet.value.loading = true;
    stateEditWallet.value.error = false;
    stateEditWallet.value.success = false;
    stateEditWallet.value.msg = {
        en: "",
        ar: "",
    };

    let data = {};
    let apiUrl = '';

    if (type == '') {
        data.address = editWalletItem.value.address;
        apiUrl = `${BASE_URL}/blockchain-wallets/update/${editWalletItem.value._id}`;
    }
    else {
        data.privateKey = editWalletItemFee.value.privateKey;
        apiUrl = `${BASE_URL}/blockchain-wallets/update/${editWalletItemFee.value._id}`;
    }

    const token = store.getToken;

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateEditWallet.value.loading = false;
            stateEditWallet.value.error = true;
            stateEditWallet.value.success = false;
            stateEditWallet.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateEditWallet.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getAllInfo();
        if (type == '')
            openEditWallet.value = false;
        else
            openEditWalletFee.value = false;
    }
    catch (error) {
        stateEditWallet.value.loading = false;
        stateEditWallet.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditWallet.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

const openCreateWallet = ref(false);
const createWalletData = ref({
    type: "central",
    value: ""
});

function showCreateWalletModal(type) {
    createWalletData.value = { type, value: "" };
    openCreateWallet.value = true;
}

async function createWallet() {
    stateEditWallet.value.loading = true;
    stateEditWallet.value.error = false;
    stateEditWallet.value.success = false;
    stateEditWallet.value.msg = { en: "", ar: "" };

    const { type, value } = createWalletData.value;
    const data = type == "central" ? { type, address: value.trim() } : { type, privateKey: value.trim() };
    const token = store.getToken;

    try {
        const response = await axios.post(`${BASE_URL}/blockchain-wallets/create-system-wallets`, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        stateEditWallet.value = {
            loading: false,
            error: !!response.data.error,
            success: !response.data.error,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };
        if (response.data.error) {
            return;
        }

        // Do not keep a typed private key in memory longer than needed.
        createWalletData.value.value = "";
        openCreateWallet.value = false;
        getAllInfo();
    }
    catch (error) {
        stateEditWallet.value.loading = false;
        stateEditWallet.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEditWallet.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

const stateCopy = ref({
    active: false,
    msg: {
        ar: "تم نسخ عنوان المحفظة إلى الحافظة",
        en: "Wallet address copyed to clipboard"
    }
});
const copyToClipboard = async (text) => {
    stateCopy.value.active = false;
    navigator.clipboard.writeText(text);
    await nextTick();
    stateCopy.value.active = true;
}

</script>