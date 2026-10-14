<template>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

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

                <div v-else>

                    <div class="flex justify-center gap-5 mb-5">
                        <div class="flex flex-col gap-2">
                            <div class="text-black text-[12px]/5 font-bold!">
                                {{ $t("Start date") }}
                            </div>
                            <div>
                                <input type="date" v-model="search.fromDate"
                                    class="bg-[#D9D9D9] sm:px-3 sm:py-2 px-2 py-1 w-36 sm:w-full" />
                            </div>
                        </div>
                        <div class="flex flex-col gap-2">
                            <div class="text-black text-[12px]/5 font-bold!">
                                {{ $t("End date") }}
                            </div>
                            <div>
                                <input type="date" v-model="search.toDate"
                                    class="bg-[#D9D9D9] sm:px-3 sm:py-2 px-2 py-1 w-36 sm:w-full" />
                            </div>
                        </div>
                    </div>

                    <!-- search bar -->
                    <!-- <div class="mb-10 flex justify-center rounded-full px-10">

                        <div>
                            <input type="text"
                                class="bg-[#E3E3E3] text-black font-bold! text-[12px]/8 px-2 py-1 w-40 md:w-80 border-black"
                                :class="{'rounded-tr-full rounded-br-full border-l': locale == 'ar' , 'rounded-tl-full rounded-bl-full border-r' :locale == 'en'}"
                                :placeholder="t('Search for the customer\'s name')">
                        </div>

                        <div>
                            <select
                                class="bg-[#E3E3E3] text-black font-bold! text-[12px]/8 px-2 py-2 w-40 md:w-80"
                                :class="{'rounded-tl-full rounded-bl-full': locale == 'ar' , 'rounded-tr-full rounded-br-full' :locale == 'en'}">
                                <option disabled hidden selected
                                    class="text-black font-bold! text-[12px]/8 bg-[#B9A779]">
                                    {{ $t("Type of movement") }}
                                </option>
                                <option class="text-black font-bold! text-[12px]/8 bg-[#B9A779]">
                                    {{ $t("income") }}
                                </option>
                                <option class="text-black font-bold! text-[12px]/8 bg-[#B9A779]">
                                    {{ $t("out") }}
                                </option>
                            </select>
                        </div>

                    </div> -->

                    <div class="lg:grid sm:flex grid-flow-col gap-4 px-5 lg:px-10 justify-center pb-10">
                        <div class="flex flex-wrap gap-5 sm:gap-10 justify-center">
                            <div v-if="myData?.lastTransfer?.createdAt"
                                class="bg-white py-5 md:py-8 px-2 md:px-5 lg:px-10 transition-all duration-500 hover:shadow-2xl hover-custom-gradient w-60 sm:w-80">
                                <div
                                    class="mb-10 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Main system") }}
                                </div>
                                <div
                                    class="mb-2 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Current balance") }} : {{ myData.totals.totalPaidAmount }} USD
                                </div>
                                <div v-if="myData?.lastTransfer?.createdAt"
                                    class="text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Last transfer") }} : {{ myData.lastTransfer.createdAt.split('T')[0] }}
                                </div>
                                <div v-else
                                    class="text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("There is no any transfers yet") }}
                                </div>
                            </div>
                            <div v-else
                                class="bg-white py-5 md:py-8 px-2 md:px-5 lg:px-10 transition-all duration-500 hover:shadow-2xl hover-custom-gradient w-60 sm:w-80">
                                <div
                                    class="mb-10 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Main system") }}
                                </div>
                                <div
                                    class="mb-2 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Current balance") }} : {{ myData.totals.totalPaidAmount }} USD
                                </div>
                                <div v-if="myData?.lastTransfer?.createdAt"
                                    class="text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Last transfer") }} : {{ myData.lastTransfer.createdAt.split('T')[0] }}
                                </div>
                                <div v-else
                                    class="text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("There is no any transfers yet") }}
                                </div>
                            </div>
                            <div
                                class="bg-white py-5 md:py-8 px-2 md:px-5 lg:px-10 transition-all duration-500 hover:shadow-2xl hover-custom-gradient w-60 sm:w-80">
                                <div
                                    class="mb-10 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Commission calculation") }}
                                </div>
                                <div
                                    class="mb-2 text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                    {{ $t("Total commissions earned") }} :{{ myData.totals.totalCommissions }} USD
                                </div>
                            </div>
                        </div>
                        <!-- <div class="row-start-1 my-5 sm:my-0">
                            <div class="flex justify-center items-center h-full">
                                <div @click="openModal3 = true"
                                    class="bg-white py-5 md:py-8 px-2 md:px-5 lg:px-10 cursor-pointer transition-all duration-500 hover:shadow-2xl hover-custom-gradient">
                                    <div
                                        class="mb-10 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                        {{ $t("Service provider account") }}
                                    </div>
                                    <div
                                        class="mb-2 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                        {{ $t("Current balance for each service provider:") }}
                                    </div>
                                    <div class="text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                        آخر عملية : 10/11/2025 - دخل 500 USD
                                    </div>
                                </div>
                            </div>
                        </div> -->
                        <div class="row-start-1 flex flex-col gap-5 sm:gap-10">
                            <!-- <div class="bg-white">
                                <div @click="openModal2 = true"
                                    class="bg-white py-5 md:py-8 px-2 md:px-5 lg:px-10 cursor-pointer transition-all duration-500 hover:shadow-2xl hover-custom-gradient">
                                    <div
                                        class="mb-10 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                        {{ $t("Each customer's account") }}
                                    </div>
                                    <div
                                        class="mb-2 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                        الرصيد الحالي : 1500 USD
                                    </div>
                                    <div class="text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                        آخر عملية : 10/11/2025 - دخل 500 USD
                                    </div>
                                </div>
                            </div> -->
                            <!-- <div class="bg-white">
                                <div @click="openModal4 = true"
                                    class="bg-white py-5 md:py-8 px-2 md:px-5 lg:px-10 cursor-pointer transition-all duration-500 hover:shadow-2xl hover-custom-gradient">
                                    <div
                                        class="mb-10 text-black text-[16px]/8 font-bold! text-center group-hover:text-white">
                                        {{ $t("Operating expenses") }}
                                    </div>
                                    <div
                                        class="mb-2 text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                        إجمالي المصاريف :2,500 USD
                                    </div>
                                    <div class="text-black text-[13px]/8 font-bold! text-center group-hover:text-white">
                                        آخر حركة : 10/11/2025 -500 USD
                                    </div>
                                </div>
                            </div> -->
                        </div>
                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

    <!-- modal for Main System -->
    <UModal v-model:open="openModal1" class="max-w-full md:max-w-[85%] lg:max-w-[75%]">

        <template #content>

            <div class="bg-green-2 p-5 w-full overflow-auto">

                <div
                    class="flex justify-between items-center pb-2 flex-row-reverse border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Main system") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openModal1 = !openModal1" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <!-- table -->
                <div class="flex justify-center overflow-auto">

                    <table class="ar-dir list-item overflow-auto pb-10">
                        <thead>
                            <tr>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Date") }}
                                </th>
                                <!-- <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Type of movement") }}
                                </th> -->
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("The amount") }}
                                </th>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("The related account") }}
                                </th>
                                <!-- <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Description / Note") }}
                                </th> -->
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ myData.lastTransfer.createdAt.split('T')[0] }}
                                </td>
                                <!-- <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    خرج
                                </td> -->
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ myData.lastTransfer.rate * myData.lastTransfer.paid }} SYP
                                </td>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ myData.lastTransfer.receiver.fullName }}
                                </td>
                                <!-- <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    هذا الحساب دخل وخرج ووو
                                </td> -->
                            </tr>
                        </tbody>
                    </table>

                </div>

            </div>

        </template>
    </UModal>


    <!-- modal for Account for each client -->
    <UModal v-model:open="openModal2" class="max-w-full md:max-w-[75%] lg:max-w-[50%]">

        <template #content>

            <div class="bg-green-2 p-5 w-full overflow-auto">

                <div
                    class="flex justify-between items-center pb-2 flex-row-reverse border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Each customer's account") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openModal2 = !openModal2" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <!-- table -->
                <div class="flex justify-center overflow-auto">

                    <table class="ar-dir list-item overflow-auto pb-10">
                        <thead>
                            <tr>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Customer name") }}
                                </th>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("ID") }}
                                </th>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Last operation") }}
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    Ahmad Ahmad Ahmad
                                </td>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    1024
                                </td>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    2026-1-1
                                </td>
                            </tr>
                        </tbody>
                    </table>

                </div>

            </div>

        </template>
    </UModal>

    <!-- modal for Service provider account -->
    <UModal v-model:open="openModal3" class="max-w-full md:max-w-[55%] lg:max-w-[40%]">

        <template #content>

            <div class="bg-green-2 p-5 w-full overflow-auto">

                <div
                    class="flex justify-between items-center pb-2 flex-row-reverse border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Service provider account") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openModal3 = !openModal3" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <!-- table -->
                <div class="flex justify-center overflow-auto">

                    <table class="ar-dir list-item overflow-auto pb-10">
                        <thead>
                            <tr>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Provider name") }}
                                </th>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Last operation") }}
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    Ahmad Ahmad Ahmad
                                </td>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    2026-1-1
                                </td>
                            </tr>
                        </tbody>
                    </table>

                </div>

            </div>

        </template>
    </UModal>

    <!-- modal for Service Operating expenses -->
    <UModal v-model:open="openModal4" class="max-w-full md:max-w-[75%] lg:max-w-[60%]">

        <template #content>

            <div class="bg-green-2 p-5 w-full overflow-auto">

                <div
                    class="flex justify-between items-center pb-2 flex-row-reverse border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Operating expenses") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openModal4 = !openModal4" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <!-- table -->
                <div class="flex justify-center overflow-auto">

                    <table class="ar-dir list-item overflow-auto pb-10">
                        <thead>
                            <tr>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Date") }}
                                </th>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Type of movement") }}
                                </th>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("The amount") }}
                                </th>
                                <th
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    {{ $t("Description / Note") }}
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    2026-1-1
                                </td>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    خرج
                                </td>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    55,000,000
                                </td>
                                <td
                                    class="text-black text-[13px]/8 sm:text-[20px]/8 font-bold! p-2 sm:px-5 whitespace-nowrap text-center">
                                    هذا هنا نص مثالي
                                </td>
                            </tr>
                        </tbody>
                    </table>

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
    loading: true,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});

const search = ref({
    fromDate: "",
    toDate: ""
});

const openModal1 = ref(false);
const openModal2 = ref(false);
const openModal3 = ref(false);
const openModal4 = ref(false);

onMounted(() => {
    getAllInfo();
});

const myData = ref(null);

async function getAllInfo() {

    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    getAllData().then(res => {
        if (res) {
            myData.value = res;
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllData() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/accounting/accounting-restrictions`;

    let myParams = {};

    if (search.value.fromDate != "")
        myParams.fromDate = search.value.fromDate;
    if (search.value.fromDate != "")
        myParams.fromDate = search.value.fromDate;

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

watch(
    () => ({ ...search.value }),
    () => {
        getAllInfo();
    }
)

</script>