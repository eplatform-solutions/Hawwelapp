<template>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />
                <vue-tel-input ref="telInputRef" v-model="phone" class="hidden!"></vue-tel-input>

                <!-- City name header -->
                <div v-if="cityName" class="flex justify-center mb-5">
                    <div class="bg-[#008E79] text-white px-5 py-2 rounded-xl font-bold! text-[14px] sm:text-[18px]">
                        {{ $t("Transfers for city") }}: {{ locale == 'ar' ? cityName.ar : cityName.en }}
                    </div>
                </div>

                <div class="flex justify-center px-2 mb-10">
                    <div class="bg-[#F5F5F5] px-3 py-2 w-[95%] md:w-[90%] lg:w-[80%]">

                        <div class="sm:flex justify-between mb-5">

                            <div class="flex flex-wrap justify-center sm:justify-start items-center gap-5 mb-4 sm:mb-0">
                                <div>
                                    <button @click="search.status = 'active'"
                                        class="cursor-pointer text-black text-[12px]/5 sm:text-[16px]/8 font-bold!"
                                        :class="{ 'text-[#008E79]!': search.status == 'active' }">
                                        {{ $t("Active transfers") }}
                                    </button>
                                </div>
                                <div>
                                    <button @click="search.status = 'unresolved'"
                                        class="cursor-pointer text-black text-[12px]/5 sm:text-[16px]/8 font-bold!"
                                        :class="{ 'text-[#008E79]!': search.status == 'unresolved' }">
                                        {{ $t("Awaiting resolution") }}
                                    </button>
                                </div>
                                <div>
                                    <button @click="search.status = 'dispute'"
                                        class="cursor-pointer text-black text-[12px]/5 sm:text-[16px]/8 font-bold!"
                                        :class="{ 'text-[#008E79]!': search.status == 'dispute' }">
                                        {{ $t("dispute") }}
                                    </button>
                                </div>
                                <div>
                                    <select v-model="search.status"
                                        class="bg-[#D9D9D9] text-black text-[11px] sm:text-[13px] font-bold! rounded-md px-2 py-1 cursor-pointer">
                                        <option value="active">{{ $t("All specific statuses") }}</option>
                                        <option value="full-paid">{{ $t("full-paid") }}</option>
                                        <option value="under-paid">{{ $t("under-paid") }}</option>
                                        <option value="over-paid">{{ $t("over-paid") }}</option>
                                        <option value="preparing-address">{{ $t("preparing-address") }}</option>
                                        <option value="can-receive">{{ $t("can-receive") }}</option>
                                        <option value="received">{{ $t("received") }}</option>
                                        <option value="cancelled">{{ $t("cancelled") }}</option>
                                    </select>
                                </div>
                            </div>

                            <div class="flex justify-center sm:justify-start gap-5">
                                <div class="flex flex-col gap-2">
                                    <div class="text-black text-[12px]/5 font-bold!">
                                        {{ $t("Start date") }}
                                    </div>
                                    <div>
                                        <input type="date" v-model="search.fromDate" lang="ar"
                                            class="bg-[#D9D9D9] sm:px-3 sm:py-2 px-2 py-1 w-36 sm:w-full" />
                                    </div>
                                </div>
                                <div class="flex flex-col gap-2">
                                    <div class="text-black text-[12px]/5 font-bold!">
                                        {{ $t("End date") }}
                                    </div>
                                    <div>
                                        <input type="date" v-model="search.toDate" lang="ar"
                                            class="bg-[#D9D9D9] sm:px-3 sm:py-2 px-2 py-1 w-36 sm:w-full" />
                                    </div>
                                </div>
                            </div>

                        </div>

                    </div>
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
                <div v-else class="w-full">
                    <div class="lg:max-w-[84vw] overflow-auto w-full grid">
                        <div class="bg-[#F5F5F5]">
                            <table class="overflow-auto w-full transfer-table">
                                <thead>
                                    <tr>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Transfer number") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Customer name") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Sender country") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Recipient") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Recipient's phone number") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Transfer to country") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Recipient city/area") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Currency") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Currency Delivery") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Commission") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Payment method") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("The amount") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Amount paid") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Net amount") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Date") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Exchange rate for the transfer") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Payment date") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("State") }}
                                        </th>
                                        <th
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ $t("Actions") }}
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr v-for="item in transfers" :key="item._id" @click="openDetailsPage(item)">
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.transferNumber }}
                                        </td>
                                        <td class="px-3 sm:px-5 text-center py-2 whitespace-nowrap">
                                            <template v-if="item.sender">
                                                <span class="text-black font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                    {{ item.sender.name }}
                                                    {{ item.sender.nickname }}
                                                </span>
                                            </template>
                                            <span v-else class="text-red-500 font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                {{ $t("Deleted user") }}
                                            </span>
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.sender ? item.sender.country : '-' }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.receiver ? item.receiver.fullName : $t("Deleted user") }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap en-dir">
                                            {{ item.receiver ? item.receiver.mobilePhone : '-' }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap en-dir">
                                            {{ getCountryByCode(item.toCountry)?.name || item.toCountry }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            <span v-if="item.city">
                                                {{ locale == 'ar' ? item.city.ar : item.city.en }}
                                            </span>
                                            <span v-if="item.area">
                                                / {{ locale == 'ar' ? item.area.ar : item.area.en }}
                                            </span>
                                            <span v-if="!item.city && !item.area">-</span>
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.currencyName }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.paymentMethod.symbol }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.fee }}%
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ locale == 'en' ? item.paymentMethod.name.en : item.paymentMethod.name.ar }}
                                        </td>
                                        <td class="px-3 sm:px-5 text-center py-2 whitespace-nowrap en-dir">
                                            <div v-if="item.paymentMethod.symbol == 'SYP'"
                                                class="text-black font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                {{ item.amount }}
                                                USD =
                                                {{ item.amount * item.rate }}
                                                {{ item.paymentMethod.symbol }}
                                            </div>
                                            <div v-else class="text-black font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                {{ item.amount }} {{ item.paymentMethod.symbol }}
                                            </div>
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap en-dir">
                                            <div v-if="item.paymentMethod.symbol == 'SYP'"
                                                class="text-black font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                {{ item.paid }}
                                                USD =
                                                {{ item.paid * item.rate }}
                                                {{ item.paymentMethod.symbol }}
                                            </div>
                                            <div v-else class="text-black font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                {{ item.paid }} {{ item.paymentMethod.symbol }}
                                            </div>
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap en-dir">
                                            <div v-if="item.paymentMethod.symbol == 'SYP'"
                                                class="text-black font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                {{ item.netAmount }}
                                                USD =
                                                {{ item.netAmount * item.rate }}
                                                {{ item.paymentMethod.symbol }}
                                            </div>
                                            <div v-else class="text-black font-bold! text-[10px]/5 sm:text-[16px]/8">
                                                {{ item.netAmount }} {{ item.paymentMethod.symbol }}
                                            </div>
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap en-dir">
                                            {{ formatDateTime(item.createdAt) }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.rate }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            {{ item.paidAt ? item.paidAt.split('T')[0] : '-' }}
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-black font-bold! text-[10px]/5 sm:text-[16px]/8 text-center py-2 whitespace-nowrap">
                                            <span class="transfer-status-pill" :style="{ background: statusColor(item.status) }">
                                                <span class="dot"></span>{{ $t(item.status) }}
                                            </span>
                                        </td>
                                        <td
                                            class="px-3 sm:px-5 text-center py-2 whitespace-nowrap">
                                            <div class="transfer-actions">
                                                <button
                                                    v-if="primaryAction(item.status) === 'preparing-address'"
                                                    class="transfer-actions-primary-btn" style="background:#3B82F6"
                                                    @click.stop="updateTransferStatus(item, 'preparing-address')"
                                                >{{ $t("preparing-address") }}</button>
                                                <button
                                                    v-else-if="primaryAction(item.status) === 'can-receive'"
                                                    class="transfer-actions-primary-btn" style="background:#F59E0B"
                                                    @click.stop="openProofModalForCanReceive(item)"
                                                >{{ $t("can-receive") }}</button>
                                                <button
                                                    v-else-if="primaryAction(item.status) === 'received'"
                                                    class="transfer-actions-primary-btn" style="background:#16A34A"
                                                    @click.stop="openProofModalForReceived(item)"
                                                >{{ $t("received") }}</button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="py-10 flex justify-center" :class="{ 'en-dir': locale == 'ar' }">
                        <UPagination v-model:page="page" :total="totalPages" />
                    </div>
                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

    <UModal v-model:open="openProofModal" class="md:max-w-3/4 lg:max-w-1/2">
        <template #content>
            <div class="bg-white rounded-2xl shadow-[0_16px_40px_rgba(31,35,40,0.16)] border border-[#E3DDCC] p-5" :class="{ 'ar-dir': locale == 'ar' }" @paste="onProofPaste">
                <div class="flex justify-between items-center border-b border-[#E3DDCC] pb-3 mb-4">
                    <div class="text-[#6B1F2A] text-[15px]/5 sm:text-[17px]/8 font-bold!">
                        {{ proofPendingStatus === 'can-receive' ? $t("Receiving place") : $t("Payment proof") }}
                    </div>
                    <button @click="closeProofModal" class="cursor-pointer text-[#6B6F6C] hover:text-[#6B1F2A]">
                        <UIcon class="size-7" name="i-heroicons-x-mark-solid" />
                    </button>
                </div>

                <div class="flex flex-col gap-4">
                    <textarea
                        v-model="proofForm.note"
                        class="bg-[#FBF9F4] border border-[#E3DDCC] focus:outline-2 focus:outline-[#097F6E] focus:outline-offset-1 px-3 py-3 text-[12px] sm:text-[14px] rounded-xl min-h-[90px]"
                        :placeholder="$t('Add note')"
                    />
                    <div
                        class="rounded-xl border-2 border-dashed border-[#097F6E]/35 bg-[#097F6E]/8 p-4 text-center"
                        @dragover.prevent
                        @drop.prevent="onProofDrop"
                    >
                        <div class="text-[12px] sm:text-[14px] text-[#1F2328] mb-2 font-bold!">
                            {{ proofPendingStatus === 'can-receive' ? $t("Upload receiving place image") : $t("Upload proof image") }}
                        </div>
                        <div class="text-[11px] sm:text-[13px] text-[#6B6F6C] mb-3">
                            {{ $t("Drag and drop image here") }} — {{ $t("Paste image from clipboard") }}
                        </div>
                        <input
                            ref="proofFileInputRef"
                            type="file"
                            accept="image/png,image/jpeg,image/webp"
                            class="hidden"
                            @change="onProofImageSelected($event)"
                        />
                        <button
                            class="brand-btn"
                            type="button"
                            @click="openProofFilePicker"
                        >
                            {{ $t("Choose image") }}
                        </button>
                    </div>
                    <div v-if="proofForm.existingUrl && !proofForm.previewUrl" class="text-center">
                        <div class="text-[12px] text-[#6B6F6C] mb-1">{{ $t("Current image") }}</div>
                        <img :src="proofForm.existingUrl" class="max-h-64 w-auto mx-auto rounded-xl border border-[#E3DDCC] object-contain" />
                    </div>
                    <div v-if="proofForm.previewUrl" class="text-center">
                        <div class="text-[12px] text-[#097F6E] font-bold! mb-1">
                            {{ $t("Selected image") }}: {{ proofForm.fileName }}
                        </div>
                        <img :src="proofForm.previewUrl" class="max-h-64 w-auto mx-auto rounded-xl border border-[#097F6E]/40 object-contain" />
                    </div>
                    <button
                        class="brand-btn w-full justify-center text-[13px] sm:text-[15px] py-3!"
                        @click="submitTransferPaymentProof"
                    >
                        {{ proofPendingStatus === 'can-receive' ? $t("Save receiving place and continue") : (proofPendingStatus ? $t("Save proof and continue") : $t("Save note & image")) }}
                    </button>
                </div>
            </div>
        </template>
    </UModal>

    <!-- Full Transfer Details Modal -->
    <UModal v-model:open="openDetails" class="md:max-w-3/4 lg:max-w-2/3">
        <template #content>
            <div v-if="detailsItem" class="bg-white p-5 overflow-auto" :class="{ 'ar-dir': locale == 'ar' }">

                <div class="flex justify-between items-center pb-3 border-b-2 border-[#008E79] mb-5">
                    <div class="text-[#008E79] text-[18px]/8 font-bold!">
                        {{ $t("Transfer details") }} #{{ detailsItem.transferNumber }}
                    </div>
                    <button @click="openDetails = false" class="cursor-pointer">
                        <UIcon class="size-8" name="i-heroicons-x-mark-solid" />
                    </button>
                </div>

                <!-- Status Badge -->
                <div class="flex justify-center mb-5">
                    <span class="px-5 py-2 rounded-full text-white font-bold! text-[14px]"
                        :class="{
                            'bg-yellow-500': detailsItem.status == 'pending',
                            'bg-green-600': detailsItem.status == 'full-paid' || detailsItem.status == 'received',
                            'bg-red-500': detailsItem.status == 'cancelled' || detailsItem.status == 'expired',
                            'bg-[#7C3AED]': detailsItem.status == 'dispute',
                            'bg-blue-500': !['pending','full-paid','received','cancelled','expired','dispute'].includes(detailsItem.status)
                        }">
                        {{ $t(detailsItem.status) }}
                    </span>
                </div>

                <!-- Sender Info -->
                <div class="bg-[#F5F5F5] rounded-xl p-4 mb-4">
                    <div class="text-[#6B1F2A] font-bold! text-[16px]/8 mb-3 border-b border-[#6B1F2A] pb-2">
                        {{ $t("Sender information") }}
                    </div>
                    <div v-if="detailsItem.sender" class="grid grid-cols-2 md:grid-cols-3 gap-3">
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Name") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ detailsItem.sender.name }} {{ detailsItem.sender.nickname }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Mobile number") }}</div>
                            <div class="text-black font-bold! text-[14px] en-dir">{{ detailsItem.sender.mobilePhone }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Country") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ detailsItem.sender.country }}</div>
                        </div>
                    </div>
                    <div v-else class="text-red-500 font-bold!">{{ $t("Deleted user") }}</div>
                </div>

                <!-- Receiver Info -->
                <div class="bg-[#F5F5F5] rounded-xl p-4 mb-4">
                    <div class="text-[#6B1F2A] font-bold! text-[16px]/8 mb-3 border-b border-[#6B1F2A] pb-2">
                        {{ $t("Recipient information") }}
                    </div>
                    <div v-if="detailsItem.receiver" class="grid grid-cols-2 md:grid-cols-3 gap-3">
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Name") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ detailsItem.receiver.fullName }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Mobile number") }}</div>
                            <div class="text-black font-bold! text-[14px] en-dir">{{ detailsItem.receiver.mobilePhone }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Country") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ getCountryByCode(detailsItem.toCountry)?.name || detailsItem.toCountry }}</div>
                        </div>
                        <div v-if="detailsItem.city">
                            <div class="text-gray-500 text-[12px]">{{ $t("Governorate") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ locale == 'ar' ? detailsItem.city.ar : detailsItem.city.en }}</div>
                        </div>
                        <div v-if="detailsItem.area">
                            <div class="text-gray-500 text-[12px]">{{ $t("Center") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ locale == 'ar' ? detailsItem.area.ar : detailsItem.area.en }}</div>
                        </div>
                    </div>
                    <div v-else class="text-red-500 font-bold!">{{ $t("Deleted user") }}</div>
                </div>

                <!-- Financial Info -->
                <div class="bg-[#F5F5F5] rounded-xl p-4 mb-4">
                    <div class="text-[#6B1F2A] font-bold! text-[16px]/8 mb-3 border-b border-[#6B1F2A] pb-2">
                        {{ $t("Financial details") }}
                    </div>
                    <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("The amount") }}</div>
                            <div class="text-black font-bold! text-[14px] en-dir">{{ detailsItem.amount }} {{ detailsItem.paymentMethod?.symbol }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Amount paid") }}</div>
                            <div class="text-black font-bold! text-[14px] en-dir">{{ detailsItem.paid }} {{ detailsItem.paymentMethod?.symbol }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Net amount") }}</div>
                            <div class="text-black font-bold! text-[14px] en-dir">{{ detailsItem.netAmount }} {{ detailsItem.paymentMethod?.symbol }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Commission") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ detailsItem.fee }}%</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Exchange rate for the transfer") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ detailsItem.rate }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Payment method") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ locale == 'en' ? detailsItem.paymentMethod?.name?.en : detailsItem.paymentMethod?.name?.ar }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Currency") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ detailsItem.currencyName }}</div>
                        </div>
                    </div>
                </div>

                <!-- Dates -->
                <div class="bg-[#F5F5F5] rounded-xl p-4 mb-4">
                    <div class="text-[#6B1F2A] font-bold! text-[16px]/8 mb-3 border-b border-[#6B1F2A] pb-2">
                        {{ $t("Dates") }}
                    </div>
                    <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Date") }}</div>
                            <div class="text-black font-bold! text-[14px] en-dir">{{ formatDateTime(detailsItem.createdAt) }}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-[12px]">{{ $t("Payment date") }}</div>
                            <div class="text-black font-bold! text-[14px]">{{ detailsItem.paidAt ? detailsItem.paidAt.split('T')[0] : '-' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="transfer-modal-actions mt-4">
                    <button
                        v-if="primaryAction(detailsItem.status) === 'preparing-address'"
                        style="background:#3B82F6"
                        @click="updateTransferStatus(detailsItem, 'preparing-address')"
                    >{{ $t("preparing-address") }}</button>
                    <button
                        v-else-if="primaryAction(detailsItem.status) === 'can-receive'"
                        style="background:#F59E0B"
                        @click="openProofModalForCanReceive(detailsItem)"
                    >{{ $t("can-receive") }}</button>
                    <button
                        v-else-if="primaryAction(detailsItem.status) === 'received'"
                        style="background:#16A34A"
                        @click="openProofModalForReceived(detailsItem)"
                    >{{ $t("received") }}</button>
                    <a v-if="detailsItem.receivingPlaceImagePath" :href="`${BASE_URL}/${detailsItem.receivingPlaceImagePath}`" target="_blank"
                        style="background:#0B7A8F; text-decoration:none;">
                        {{ $t("View receiving place image") }}
                    </a>
                    <a v-if="detailsItem.paymentProofImagePath" :href="`${BASE_URL}/${detailsItem.paymentProofImagePath}`" target="_blank"
                        style="background:#008E79; text-decoration:none;">
                        {{ $t("View uploaded image") }}
                    </a>

                    <button v-if="canCancelTransfer(detailsItem.status)" style="background:#DC2626" @click="cancelTransfer(detailsItem)">{{ $t("Cancel transfer") }}</button>
                    <button v-if="canOpenDispute(detailsItem.status)" style="background:#7C3AED" @click="openDispute(detailsItem)">{{ $t("Open dispute") }}</button>

                    <button style="background:#3B82F6" @click="copyTransferInfo(detailsItem)">
                        {{ copySuccess == detailsItem._id ? $t("Copied!") : $t("Copy info") }}
                    </button>
                    <button style="background:#B9A779; color:#1F2328" @click="printReceipt(detailsItem)">
                        <UIcon name="i-heroicons-printer" class="size-5" />
                        {{ $t("Print receipt") }}
                    </button>
                </div>

            </div>
        </template>
    </UModal>

</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();

const {
    statusColor,
    primaryAction,
    canCancelTransfer,
    canOpenDispute,
    updateTransferStatus,
    cancelTransfer,
    openDispute,
} = useTransferActions({ axios, store, t, locale, BASE_URL, handelErrorType });

import { VueTelInput } from 'vue-tel-input'
import 'vue-tel-input/vue-tel-input.css'

const state = ref({
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const transfers = ref([]);
const totalPages = ref(0);
const page = ref(1);
const cityName = ref(null);
const openProofModal = ref(false);
const proofFileInputRef = ref(null);
const defaultCanReceiveNote = "يرجى اصطحاب الهوية الشخصية";
const proofPendingStatus = ref("");
const proofTargetTransfer = ref(null);
const proofForm = ref({
    note: "",
    file: null,
    fileName: "",
    previewUrl: "",
    existingUrl: "",
});

const search = ref({
    status: "active",
    fromDate: "",
    toDate: ""
});

const phone = ref("");
const telInputRef = ref(null);
const countriesList = ref([]);

const getCountryByCode = (code) => {
    return countriesList.value.find(c => c.iso2 === code)
}

// Date plus the exact time of day, in the viewer's local time - used for
// the transfer creation date specifically, where knowing when in the day
// something happened matters (e.g. telling an expired attempt apart from
// one still inside its window).
function formatDateTime(value) {
    if (!value) return "-";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return String(value).split("T")[0] || "-";
    const datePart = date.toLocaleDateString("en-CA");
    const timePart = date.toLocaleTimeString("en-GB", { hour: "2-digit", minute: "2-digit", hour12: false });
    return `${datePart} ${timePart}`;
}

onMounted(() => {
    setLocale(store.getLanguage);

    // Redirect non-employees to quick-control
    if (!store.getIsEmployee) {
        router.push("/quick-control");
        return;
    }

    countriesList.value = telInputRef.value.$props.allCountries;
    getAllInfo();
});

async function getAllInfo() {
    state.value.loading = true;
    state.value.error = false;
    state.value.msg = { ar: "", en: "" };

    getMyTransfers().then(res => {
        if (res) {
            transfers.value = [];
            if (res.city) {
                cityName.value = res.city;
            }
            res.transfers.forEach(ele => {
                if (ele.sender) {
                    const myCoun = getCountryByCode(ele.sender.country);
                    ele.sender.country = myCoun ? myCoun.name : ele.sender.country;
                }
                transfers.value.push(ele);
            });
            totalPages.value = res.transfersCount;
        }
    }).then(() => {
        state.value.loading = false;
    });
}

function setProofImageFile(file) {
    if (!file) return;
    const allowedTypes = ["image/png", "image/jpeg", "image/webp"];
    if (!allowedTypes.includes(file.type)) {
        state.value.msg = {
            ar: "يرجى اختيار صورة بصيغة PNG أو JPG أو WEBP",
            en: "Please select a PNG, JPG, or WEBP image",
        };
        alert(locale.value == "ar" ? state.value.msg.ar : state.value.msg.en);
        return;
    }
    proofForm.value.file = file;
    proofForm.value.fileName = file.name;
    if (proofForm.value.previewUrl) URL.revokeObjectURL(proofForm.value.previewUrl);
    proofForm.value.previewUrl = URL.createObjectURL(file);
}

function onProofImageSelected(event) {
    const file = event.target?.files?.[0];
    setProofImageFile(file);
}

function onProofDrop(event) {
    const file = event.dataTransfer?.files?.[0];
    setProofImageFile(file);
}

function onProofPaste(event) {
    const items = event.clipboardData?.items || [];
    for (const item of items) {
        if (!item.type?.startsWith("image/")) continue;
        const file = item.getAsFile();
        setProofImageFile(file);
        event.preventDefault();
        break;
    }
}

function openProofFilePicker() {
    proofFileInputRef.value?.click();
}

function resetProofForm() {
    if (proofForm.value.previewUrl) URL.revokeObjectURL(proofForm.value.previewUrl);
    proofForm.value.file = null;
    proofForm.value.fileName = "";
    proofForm.value.previewUrl = "";
    proofForm.value.existingUrl = "";
}

function closeProofModal() {
    openProofModal.value = false;
    proofPendingStatus.value = "";
    proofTargetTransfer.value = null;
    resetProofForm();
}

function openProofModalForCanReceive(item) {
    proofPendingStatus.value = "can-receive";
    const existingNote = String(item.paymentProofNote || "").trim();
    proofForm.value.note = existingNote || defaultCanReceiveNote;
    proofTargetTransfer.value = item;
    resetProofForm();
    proofForm.value.existingUrl = item.receivingPlaceImagePath ? `${BASE_URL}/${item.receivingPlaceImagePath}` : "";
    openProofModal.value = true;
}

function openProofModalForReceived(item) {
    proofPendingStatus.value = "received";
    proofForm.value.note = String(item.paymentProofNote || "").trim();
    proofTargetTransfer.value = item;
    resetProofForm();
    proofForm.value.existingUrl = item.paymentProofImagePath ? `${BASE_URL}/${item.paymentProofImagePath}` : "";
    openProofModal.value = true;
}

async function getMyTransfers() {
    const token = store.getToken;
    const apiUrl = `${BASE_URL}/employees/my-transfers`;

    let myParams = {
        pageNumber: page.value,
        pageSize: 10
    };

    if (search.value.status != "") {
        myParams.status = search.value.status;
    }

    if (search.value.fromDate != "") {
        myParams.fromDate = search.value.fromDate;
    }

    if (search.value.toDate != "") {
        myParams.toDate = search.value.toDate;
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

async function submitTransferPaymentProof() {
    const item = proofTargetTransfer.value;
    if (!item) return;
    const token = store.getToken;
    const file = proofForm.value.file;
    const note = String(proofForm.value.note || "").trim();
    const isReceivingPlace = proofPendingStatus.value === "can-receive";
    if (!file) {
        state.value.msg = isReceivingPlace
            ? { ar: "يرجى اختيار صورة مكان الاستلام أولاً", en: "Please select a receiving place image first" }
            : { ar: "يرجى اختيار صورة الإثبات أولاً", en: "Please select a proof image first" };
        alert(locale.value == "ar" ? state.value.msg.ar : state.value.msg.en);
        return;
    }
    if (!note) {
        state.value.msg = {
            ar: "يرجى إدخال ملاحظة",
            en: "Please add a note",
        };
        alert(locale.value == "ar" ? state.value.msg.ar : state.value.msg.en);
        return;
    }

    try {
        const apiUrl = `${BASE_URL}/transfers/${isReceivingPlace ? "receiving-place" : "payment-proof"}/${item._id}`;
        const formData = new FormData();
        formData.append("paymentProofNote", note);
        formData.append(isReceivingPlace ? "receivingPlaceImage" : "paymentProofImage", file);
        const response = await axios.put(apiUrl, formData, {
            headers: {
                Authorization: `Bearer ${token}`,
                "Content-Type": "multipart/form-data",
            },
        });

        if (response.data?.error) {
            state.value.msg = {
                ar: response.data.msg?.ar ?? String(response.data.msg ?? ""),
                en: response.data.msg?.en ?? String(response.data.msg ?? ""),
            };
            alert(locale.value == "ar" ? state.value.msg.ar : state.value.msg.en);
            return;
        }

        const updated = response.data?.data?.transfer;
        if (updated) {
            item.paymentProofNote = updated.paymentProofNote;
            item.paymentProofImagePath = updated.paymentProofImagePath;
            item.receivingPlaceImagePath = updated.receivingPlaceImagePath;
        }
        const pendingStatus = proofPendingStatus.value;
        if (pendingStatus) {
            await updateTransferStatus(item, pendingStatus, note);
        }
        closeProofModal();
    } catch (error) {
        const errorMessage = handelErrorType(error);
        state.value.msg = {
            ar: errorMessage,
            en: errorMessage,
        };
        alert(locale.value == "ar" ? state.value.msg.ar : state.value.msg.en);
    }
}

const isResettingPage = ref(false);

watch(
    () => ({ ...search.value }),
    async () => {
        isResettingPage.value = true;
        page.value = 1;
        await nextTick();
        getAllInfo();
        isResettingPage.value = false;
    },
    { deep: true }
)

watch(
    () => page.value,
    () => {
        if (!isResettingPage.value) {
            getAllInfo()
        }
    }
)

// ===== Copy, Details & Print =====
const copySuccess = ref(null);
const openDetails = ref(false);
const detailsItem = ref(null);
function copyTransferInfo(item) {
    const senderName = item.sender
        ? `${item.sender.name} ${item.sender.nickname}`.trim()
        : '-';
    const senderPhone = item.sender?.mobilePhone || '-';
    const receiverName = item.receiver?.fullName || '-';
    const receiverPhone = item.receiver?.mobilePhone || '-';
    const symbol = item.paymentMethod?.symbol || '';
    const payMethodName = item.paymentMethod
        ? (locale.value == 'ar' ? item.paymentMethod.name.ar : item.paymentMethod.name.en)
        : '-';
    const toCountry = getCountryByCode(item.toCountry)?.name || item.toCountry || '-';
    const cityName = item.city ? (locale.value == 'ar' ? item.city.ar : item.city.en) : '';
    const areaName = item.area ? (locale.value == 'ar' ? item.area.ar : item.area.en) : '';
    const address = [toCountry, cityName, areaName].filter(Boolean).join(' / ');

    const amountLine = item.paymentMethod?.symbol == 'SYP'
        ? `${item.amount} USD = ${item.amount * item.rate} SYP`
        : `${item.amount} ${symbol}`;

    const lines = [
        `━━━━━━━━━━━━━━━━━━━━`,
        `📋 Hawwel - #${item.transferNumber}`,
        `━━━━━━━━━━━━━━━━━━━━`,
        ``,
        `👤 ${locale.value == 'ar' ? 'المرسل' : 'Sender'}: ${senderName}`,
        `📱 ${locale.value == 'ar' ? 'هاتف المرسل' : 'Sender phone'}: ${senderPhone}`,
        ``,
        `👤 ${locale.value == 'ar' ? 'المستلم' : 'Recipient'}: ${receiverName}`,
        `📱 ${locale.value == 'ar' ? 'هاتف المستلم' : 'Recipient phone'}: ${receiverPhone}`,
        ``,
        `💰 ${locale.value == 'ar' ? 'المبلغ' : 'Amount'}: ${amountLine}`,
        `💳 ${locale.value == 'ar' ? 'طريقة الدفع' : 'Payment'}: ${payMethodName}`,
        `📊 ${locale.value == 'ar' ? 'العمولة' : 'Fee'}: ${item.fee}%`,
        `💵 ${locale.value == 'ar' ? 'صافي المبلغ' : 'Net'}: ${item.netAmount} ${symbol}`,
        `📈 ${locale.value == 'ar' ? 'سعر الصرف' : 'Rate'}: ${item.rate}`,
        ``,
        `📍 ${locale.value == 'ar' ? 'العنوان' : 'Address'}: ${address}`,
        `📅 ${locale.value == 'ar' ? 'التاريخ' : 'Date'}: ${item.createdAt?.split('T')[0] || '-'}`,
        `📌 ${locale.value == 'ar' ? 'الحالة' : 'Status'}: ${item.status}`,
        `━━━━━━━━━━━━━━━━━━━━`,
    ];

    const text = lines.join('\n');

    navigator.clipboard.writeText(text).then(() => {
        copySuccess.value = item._id;
        setTimeout(() => { copySuccess.value = null; }, 2000);
    });
}

function openDetailsPage(item) {
    detailsItem.value = item;
    openDetails.value = true;
}

function printReceipt(item) {
    const dir = locale.value == 'ar' ? 'rtl' : 'ltr';
    const lang = locale.value;
    const t = (key) => {
        const translations = {
            'Transfer receipt': lang == 'ar' ? 'إيصال حوالة' : 'Transfer Receipt',
            'Transfer number': lang == 'ar' ? 'رقم الحوالة' : 'Transfer Number',
            'Date': lang == 'ar' ? 'التاريخ' : 'Date',
            'Payment date': lang == 'ar' ? 'تاريخ الدفع' : 'Payment Date',
            'Status': lang == 'ar' ? 'الحالة' : 'Status',
            'Sender information': lang == 'ar' ? 'معلومات المرسل' : 'Sender Information',
            'Name': lang == 'ar' ? 'الاسم' : 'Name',
            'Phone': lang == 'ar' ? 'الهاتف' : 'Phone',
            'Country': lang == 'ar' ? 'الدولة' : 'Country',
            'Recipient information': lang == 'ar' ? 'معلومات المستلم' : 'Recipient Information',
            'City': lang == 'ar' ? 'المدينة' : 'City',
            'Area': lang == 'ar' ? 'المنطقة' : 'Area',
            'Financial details': lang == 'ar' ? 'التفاصيل المالية' : 'Financial Details',
            'Amount': lang == 'ar' ? 'المبلغ' : 'Amount',
            'Amount paid': lang == 'ar' ? 'المبلغ المدفوع' : 'Amount Paid',
            'Net amount': lang == 'ar' ? 'صافي المبلغ' : 'Net Amount',
            'Commission': lang == 'ar' ? 'العمولة' : 'Commission',
            'Exchange rate': lang == 'ar' ? 'سعر الصرف' : 'Exchange Rate',
            'Payment method': lang == 'ar' ? 'طريقة الدفع' : 'Payment Method',
            'Deleted user': lang == 'ar' ? 'مستخدم محذوف' : 'Deleted user',
            'pending':            lang == 'ar' ? 'قيد الانتظار'       : 'Pending',
            'full-paid':          lang == 'ar' ? 'مدفوعة'             : 'Paid',
            'under-paid':         lang == 'ar' ? 'مدفوعة جزئياً'      : 'Under Paid',
            'over-paid':          lang == 'ar' ? 'مدفوعة زيادة'       : 'Over Paid',
            'preparing-address':  lang == 'ar' ? 'جار إعداد العنوان'  : 'Preparing Address',
            'can-receive':        lang == 'ar' ? 'يمكنك الاستلام'     : 'You Can Receive',
            'received':           lang == 'ar' ? 'تم التسليم'         : 'Received',
            'cancelled':          lang == 'ar' ? 'ملغاة'              : 'Cancelled',
            'expired':            lang == 'ar' ? 'منتهية الصلاحية'    : 'Expired',
        };
        return translations[key] || key;
    };

    const senderName = item.sender
        ? `${item.sender.name} ${item.sender.nickname}`
        : t('Deleted user');
    const senderPhone = item.sender?.mobilePhone || '-';
    const senderCountry = item.sender?.country || '-';
    const receiverName = item.receiver?.fullName || t('Deleted user');
    const receiverPhone = item.receiver?.mobilePhone || '-';
    const toCountry = getCountryByCode(item.toCountry)?.name || item.toCountry;
    const cityText = item.city ? (lang == 'ar' ? item.city.ar : item.city.en) : '-';
    const areaText = item.area ? (lang == 'ar' ? item.area.ar : item.area.en) : '-';
    const payMethodName = item.paymentMethod ? (lang == 'en' ? item.paymentMethod.name.en : item.paymentMethod.name.ar) : '-';
    const symbol = item.paymentMethod?.symbol || '';

    const html = `<!DOCTYPE html>
<html lang="${lang}" dir="${dir}">
<head>
<meta charset="UTF-8">
<title>${t('Transfer receipt')} #${item.transferNumber}</title>
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', Tahoma, Arial, sans-serif; background: #f0f0f0; padding: 20px; direction: ${dir}; }
    .receipt { max-width: 700px; margin: 0 auto; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
    .header { background: linear-gradient(135deg, #008E79, #006B5A); color: white; padding: 30px; text-align: center; }
    .header h1 { font-size: 22px; margin-bottom: 8px; }
    .header .number { font-size: 16px; opacity: 0.9; }
    .status { text-align: center; padding: 15px; }
    .status span { display: inline-block; padding: 6px 24px; border-radius: 20px; color: white; font-weight: bold; font-size: 14px; }
    .status .pending { background: #EAB308; }
    .status .paid { background: #16A34A; }
    .status .cancelled { background: #DC2626; }
    .status .other { background: #3B82F6; }
    .section { padding: 0 25px 20px; }
    .section-title { font-size: 15px; font-weight: bold; color: #6B1F2A; border-bottom: 2px solid #6B1F2A; padding-bottom: 8px; margin-bottom: 12px; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; }
    .field label { font-size: 11px; color: #888; display: block; margin-bottom: 2px; }
    .field value, .field div { font-size: 14px; font-weight: bold; color: #222; }
    .footer { text-align: center; padding: 20px; border-top: 1px dashed #ccc; color: #999; font-size: 12px; }
    @media print {
        body { background: white; padding: 0; }
        .receipt { box-shadow: none; }
        .no-print { display: none !important; }
    }
</style>
</head>
<body>
<div class="receipt">
    <div class="header">
        <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAABAAAAAQACAIAAADwf7zUAACcZ2NhQlgAAJxnanVtYgAAAB5qdW1kYzJwYQARABCAAACqADibcQNjMnBhAAAANvpqdW1iAAAAR2p1bWRjMm1hABEAEIAAAKoAOJtxA3VybjpjMnBhOmE0ZTYyN2NmLTBjOTYtNDkxOS1iYTYxLThiOTY0N2Q1OGNlMgAAAAHBanVtYgAAAClqdW1kYzJhcwARABCAAACqADibcQNjMnBhLmFzc2VydGlvbnMAAAAA5Wp1bWIAAAApanVtZGNib3IAEQAQgAAAqgA4m3EDYzJwYS5hY3Rpb25zLnYyAAAAALRjYm9yoWdhY3Rpb25zgqNmYWN0aW9ubGMycGEuY3JlYXRlZG1zb2Z0d2FyZUFnZW50v2RuYW1lZkdQVC00b/9xZGlnaXRhbFNvdXJjZVR5cGV4Rmh0dHA6Ly9jdi5pcHRjLm9yZy9uZXdzY29kZXMvZGlnaXRhbHNvdXJjZXR5cGUvdHJhaW5lZEFsZ29yaXRobWljTWVkaWGhZmFjdGlvbm5jMnBhLmNvbnZlcnRlZAAAAKtqdW1iAAAAKGp1bWRjYm9yABEAEIAAAKoAOJtxA2MycGEuaGFzaC5kYXRhAAAAAHtjYm9ypWpleGNsdXNpb25zgaJlc3RhcnQYIWZsZW5ndGgZNyxkbmFtZW5qdW1iZiBtYW5pZmVzdGNhbGdmc2hhMjU2ZGhhc2hYIFmuCfoBtZd2bOngs1Qa2PLfAi8mSH1oMwbSE0j0VhFiY3BhZEgAAAAAAAAAAAAAAe1qdW1iAAAAJ2p1bWRjMmNsABEAEIAAAKoAOJtxA2MycGEuY2xhaW0udjIAAAABvmNib3Kmamluc3RhbmNlSUR4LHhtcDppaWQ6Mjc4OTg3YzktMzMwMC00YmUzLWFhN2EtZDU4ODAyM2QzYWVmdGNsYWltX2dlbmVyYXRvcl9pbmZvv2RuYW1lZ0NoYXRHUFR3b3JnLmNvbnRlbnRhdXRoLmMycGFfcnNlMC4wLjD/aXNpZ25hdHVyZXhNc2VsZiNqdW1iZj0vYzJwYS91cm46YzJwYTphNGU2MjdjZi0wYzk2LTQ5MTktYmE2MS04Yjk2NDdkNThjZTIvYzJwYS5zaWduYXR1cmVyY3JlYXRlZF9hc3NlcnRpb25zgqJjdXJs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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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KACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKAPj7VPEuuLqV2q61qYUTOABdyYAyfes7nE5O+5THijXlYFdb1QEHP/H3J/jRcOZ9z3j4RfExfECJpGuSKmrqMRSnA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DH1rTBMpnt1/ej7yj+L/AOvXPWpc3vR3NITtoznGrjNzovC//HpN/wBdP6CuzDfCzGrubNdBkFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFAHh958C5ri6mmGvxr5jl8fZCcZOf79TymHsfMh/wCFCz/9DDH/AOAZ/wDi6OUXsPMb/wAKEn/6GKP/AMAz/wDF0coew8w/4UJP/wBDFH/4Bn/4ujlD2HmA+Ak//Qwx/wDgGf8A4ulyj9j5i/8AChJv+hij/wDAM/8AxdPlF7DzD/hQk/8A0MMX/gGf/i6OUPYeY0/AO4/6GKL/AMAz/wDF0co/Y+Z7lYwG2sreAtuMUapuxjOBjNUbonoAKACgAoAKACgAoAKACgAoAKACgAoAKAMrUNHjuZfMjfymP3uMg+9YVKKk7o0jUtoWNLsjYwuhcPubdnGO1XTp8isKcuZl2tCAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgAoAKACgD/9kAAAXmanVtYgAAACxqdW1kY2JvcgARABCAAACqADibcQNjMnBhLmluZ3JlZGllbnQudjMAAAAFsmNib3KobHJlbGF0aW9uc2hpcGhwYXJlbnRPZmhkYzp0aXRsZWlpbWFnZS5wbmdpZGM6Zm9ybWF0Y3BuZ3F2YWxpZGF0aW9uUmVzdWx0c6FuYWN0aXZlTWFuaWZlc3SjZ3N1Y2Nlc3OFo2Rjb2RleB1jbGFpbVNpZ25hdHVyZS5pbnNpZGVWYWxpZGl0eWN1cmx4TXNlbGYjanVtYmY9L2MycGEvdXJuOmMycGE6YTRlNjI3Y2YtMGM5Ni00OTE5LWJhNjEtOGI5NjQ3ZDU4Y2UyL2MycGEuc2lnbmF0dXJla2V4cGxhbmF0aW9udWNsYWltIHNpZ25hdHVyZSB2YWxpZKNkY29kZXgYY2xhaW1TaWduYXR1cmUudmFsaWRhdGVkY3VybHhNc2VsZiNqdW1iZj0vYzJwYS91cm46YzJwYTphNGU2MjdjZi0wYzk2LTQ5MTktYmE2MS04Yjk2NDdkNThjZTIvYzJwYS5zaWduYXR1cmVrZXhwbGFuYXRpb251Y2xhaW0gc2lnbmF0dXJlIHZhbGlko2Rjb2RleBlhc3NlcnRpb24uaGFzaGVkVVJJLm1hdGNoY3VybHhec2VsZiNqdW1iZj0vYzJwYS91cm46YzJwYTphNGU2MjdjZi0wYzk2LTQ5MTktYmE2MS04Yjk2NDdkNThjZTIvYzJwYS5hc3NlcnRpb25zL2MycGEuYWN0aW9ucy52MmtleHBsYW5hdGlvbng+aGFzaGVkIHVyaSBtYXRjaGVkOiBzZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmFjdGlvbnMudjKjZGNvZGV4GWFzc2VydGlvbi5oYXNoZWRVUkkubWF0Y2hjdXJseF1zZWxmI2p1bWJmPS9jMnBhL3VybjpjMnBhOmE0ZTYyN2NmLTBjOTYtNDkxOS1iYTYxLThiOTY0N2Q1OGNlMi9jMnBhLmFzc2VydGlvbnMvYzJwYS5oYXNoLmRhdGFrZXhwbGFuYXRpb254PWhhc2hlZCB1cmkgbWF0Y2hlZDogc2VsZiNqdW1iZj1jMnBhLmFzc2VydGlvbnMvYzJwYS5oYXNoLmRhdGGjZGNvZGV4GGFzc2VydGlvbi5kYXRhSGFzaC5tYXRjaGN1cmx4XXNlbGYjanVtYmY9L2MycGEvdXJuOmMycGE6YTRlNjI3Y2YtMGM5Ni00OTE5LWJhNjEtOGI5NjQ3ZDU4Y2UyL2MycGEuYXNzZXJ0aW9ucy9jMnBhLmhhc2guZGF0YWtleHBsYW5hdGlvbm9kYXRhIGhhc2ggdmFsaWRtaW5mb3JtYXRpb25hbIBnZmFpbHVyZYBqaW5zdGFuY2VJRHgseG1wOmlpZDpiNWNjZTJiNy00MDNmLTQ4ZGMtODVjNS03NjgzYjYyODI2N2VuYWN0aXZlTWFuaWZlc3SjY3VybHg+c2VsZiNqdW1iZj0vYzJwYS91cm46YzJwYTphNGU2MjdjZi0wYzk2LTQ5MTktYmE2MS04Yjk2NDdkNThjZTJjYWxnZnNoYTI1NmRoYXNoWCDLXsxCmHCmCVByoWxsOM973/H7tLCCLpEXGWgyw4Ek3G5jbGFpbVNpZ25hdHVyZaNjdXJseE1zZWxmI2p1bWJmPS9jMnBhL3VybjpjMnBhOmE0ZTYyN2NmLTBjOTYtNDkxOS1iYTYxLThiOTY0N2Q1OGNlMi9jMnBhLnNpZ25hdHVyZWNhbGdmc2hhMjU2ZGhhc2hYIHLmbyf4moCcxQvQ1U/LckEXYQHdz0Ai3+O/wb0tGaSqaXRodW1ibmFpbKJjdXJseDRzZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLnRodW1ibmFpbC5pbmdyZWRpZW50ZGhhc2hYIOrNHgBhvpGDPww7r3wtXtjXz3bScunH4GCClc7SQEiaAAAAzGp1bWIAAAApanVtZGNib3IAEQAQgAAAqgA4m3EDYzJwYS5hY3Rpb25zLnYyAAAAAJtjYm9yoWdhY3Rpb25zgaJmYWN0aW9ua2MycGEub3BlbmVkanBhcmFtZXRlcnO/a2luZ3JlZGllbnRzgaJjdXJseC1zZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmluZ3JlZGllbnQudjNkaGFzaFggTygmm3d0HYHn1hYEekxy1L4LLlMnvou3YBn6EvXzNlv/AAAArWp1bWIAAAAoanVtZGNib3IAEQAQgAAAqgA4m3EDYzJwYS5oYXNoLmRhdGEAAAAAfWNib3KlamV4Y2x1c2lvbnOBomVzdGFydBghZmxlbmd0aBmcc2RuYW1lbmp1bWJmIG1hbmlmZXN0Y2FsZ2ZzaGEyNTZkaGFzaFggWa4J+gG1l3Zs6eCzVBrY8t8CLyZIfWgzBtITSPRWEWJjcGFkSgAAAAAAAAAAAAAAAAK/anVtYgAAACdqdW1kYzJjbAARABCAAACqADibcQNjMnBhLmNsYWltLnYyAAAAApBjYm9yp2ppbnN0YW5jZUlEeCx4bXA6aWlkOjM2NzMzZDA1LTlkMzktNGJjOC1iNzM1LTIwYzg4Y2NkNGMzN3RjbGFpbV9nZW5lcmF0b3JfaW5mb79kbmFtZWdDaGF0R1BUd29yZy5jb250ZW50YXV0aC5jMnBhX3JzZTAuMC4w/2lzaWduYXR1cmV4TXNlbGYjanVtYmY9L2MycGEvdXJuOmMycGE6ZjFlZjJhMDMtM2NlNC00NzI3LThlZDMtMDRhZGYzNmM1YTRjL2MycGEuc2lnbmF0dXJlcmNyZWF0ZWRfYXNzZXJ0aW9uc4SiY3VybHg0c2VsZiNqdW1iZj1jMnBhLmFzc2VydGlvbnMvYzJwYS50aHVtYm5haWwuaW5ncmVkaWVudGRoYXNoWCDqzR4AYb6Rgz8MO698LV7Y18920nLpx+BggpXO0kBImqJjdXJseC1zZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmluZ3JlZGllbnQudjNkaGFzaFggTygmm3d0HYHn1hYEekxy1L4LLlMnvou3YBn6EvXzNluiY3VybHgqc2VsZiNqdW1iZj1jMnBhLmFzc2VydGlvbnMvYzJwYS5hY3Rpb25zLnYyZGhhc2hYIGyPL+DufuC2N9/YonNz0S6j7v+R2torbue/EjlMOYXIomN1cmx4KXNlbGYjanVtYmY9YzJwYS5hc3NlcnRpb25zL2MycGEuaGFzaC5kYXRhZGhhc2hYIJPA2SP8qVBMpDKE0BHy67VyUWStjVtcb7bDYNFakxEpaGRjOnRpdGxlaWltYWdlLnBuZ3NyZWRh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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD2WECfQxBfV6I/L+gwjBHMTb8wdSTIcZrUQZzRdHsBkegixiJZq6y0ASCciywc/DAeWglAw7DNbzqC/hi/2ElaWqpBI53zUAAAq9hJREFUeJzt/VmwLdl52PmtL/c599Z8695bcxVmoFAFQNTQemlJrZZsU2zpod3RHYp22C9+cLTDD45wSyIpYi4MBRRQAAiCoyS3wnY42j3IVoQlkQSJkQALAAGQADFRothuCwRIAgQEkW2g7jk7Pz/ktMbMlbn3OWfnWf9fnbpnDzntvTPP/r61vpUpdV0bAAAAAJeNuP8Yo6rGHO20OGOM0d02CwAAAMCZcaJ1MUYXJwDE/QAAAMD6LE4AAAAAAKyDWr+ri9wQAAAAAOdHDAkAAAAAUBQSAAAAAKAIzWl8SAAAAACAS8k/bY8aIyQAAAAAwOUVOXUnZwECAAAALjH17tADAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkA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BAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAACkICAAAAABSEBAAAAAAoCAkAAAAAUBASAAAAAKAgJAAAAABAQUgAAAAAgIKQAAAAAAAFIQEAAAAASiDGiJAAAAAAAAWQ/gYJAAAAAFAQEgAAAACgICQAAAAAQEFIAAAAAIDLrx8EQAIAAAAAXG5i/yIBAAAAAApydNEbAAAAAOBMafu/McaY/z+yU4U/Cl912AAAAABJRU5ErkJggg==" alt="Hawwel" style="height:60px;object-fit:contain;margin-bottom:10px;" />
        <div class="number">${t('Transfer receipt')} #${item.transferNumber}</div>
    </div>

    <div class="status">
        <span class="${item.status == 'pending' ? 'pending' : ['full-paid','received'].includes(item.status) ? 'paid' : ['cancelled','expired'].includes(item.status) ? 'cancelled' : 'other'}">
            ${t('Status')}: ${item.status}
        </span>
    </div>

    <div class="section">
        <div class="section-title">${t('Sender information')}</div>
        <div class="grid">
            <div class="field"><label>${t('Name')}</label><div>${senderName}</div></div>
            <div class="field"><label>${t('Phone')}</label><div style="direction:ltr;text-align:${dir == 'rtl' ? 'right' : 'left'}">${senderPhone}</div></div>
            <div class="field"><label>${t('Country')}</label><div>${senderCountry}</div></div>
        </div>
    </div>

    <div class="section">
        <div class="section-title">${t('Recipient information')}</div>
        <div class="grid">
            <div class="field"><label>${t('Name')}</label><div>${receiverName}</div></div>
            <div class="field"><label>${t('Phone')}</label><div style="direction:ltr;text-align:${dir == 'rtl' ? 'right' : 'left'}">${receiverPhone}</div></div>
            <div class="field"><label>${t('Country')}</label><div>${toCountry}</div></div>
            <div class="field"><label>${t('City')}</label><div>${cityText}</div></div>
            <div class="field"><label>${t('Area')}</label><div>${areaText}</div></div>
        </div>
    </div>

    <div class="section">
        <div class="section-title">${t('Financial details')}</div>
        <div class="grid-3">
            <div class="field"><label>${t('Amount')}</label><div>${item.amount} ${symbol}</div></div>
            <div class="field"><label>${t('Amount paid')}</label><div>${item.paid} ${symbol}</div></div>
            <div class="field"><label>${t('Net amount')}</label><div>${item.netAmount} ${symbol}</div></div>
            <div class="field"><label>${t('Commission')}</label><div>${item.fee}%</div></div>
            <div class="field"><label>${t('Exchange rate')}</label><div>${item.rate}</div></div>
            <div class="field"><label>${t('Payment method')}</label><div>${payMethodName}</div></div>
        </div>
    </div>

    <div class="section">
        <div class="grid">
            <div class="field"><label>${t('Date')}</label><div>${item.createdAt?.split('T')[0] || '-'}</div></div>
            <div class="field"><label>${t('Payment date')}</label><div>${item.paidAt ? item.paidAt.split('T')[0] : '-'}</div></div>
        </div>
    </div>

    <div class="footer">
        Hawwel &copy; ${new Date().getFullYear()}
    </div>
</div>

<div class="no-print" style="text-align:center;margin-top:20px;">
    <button onclick="window.print()" style="background:#008E79;color:white;border:none;padding:10px 40px;border-radius:8px;font-size:16px;cursor:pointer;font-weight:bold;">
        ${t('Transfer receipt')}
    </button>
</div>
</body>
</html>`;

    const printWindow = window.open('', '_blank');
    printWindow.document.write(html);
    printWindow.document.close();
}

</script>
