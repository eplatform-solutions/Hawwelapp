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

                    <div class="lg:grid md:flex grid-flow-col gap-4 px-5 justify-center pb-10 mb-5">
                        <div class="flex gap-5 sm:gap-10 items-center justify-center">
                            <div class="bg-box-bray-2 py-5 md:py-3 px-2 md:px-3 min-h-50 min-w-56.25">
                                <div class="mb-7 text-black text-[16px]/8 font-bold! text-center">
                                    {{ $t("Total payments") }}
                                </div>
                                <div class="mb-2 text-black text-[22px]/8 font-bold! text-center">
                                    {{ myData.totalPaid }}
                                </div>
                                <div class="flex justify-center">
                                    <svg width="184" height="74" viewBox="0 0 184 74" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path
                                            d="M1.52344 49.4742C8.48326 49.4742 8.48326 30.2421 15.4431 30.2421C22.4029 30.2421 22.4029 16.7796 29.3627 16.7796C36.3225 16.7796 36.3225 72.5528 43.2823 72.5528C50.2422 72.5528 50.2422 45.6278 57.202 45.6278C64.1618 45.6278 64.1618 62.9367 71.1216 62.9367C78.0814 62.9367 78.0814 53.3206 85.0413 53.3206C92.0011 53.3206 92.0011 39.8581 98.9609 39.8581C105.921 39.8581 105.921 20.626 112.881 20.626C119.84 20.626 119.84 1.39386 126.8 1.39386C133.76 1.39386 133.76 12.9331 140.72 12.9331C147.68 12.9331 147.68 22.5492 154.639 22.5492C161.599 22.5492 161.599 11.0099 168.559 11.0099C175.519 11.0099 175.519 59.0903 182.479 59.0903M182.479 59.0903V59.0903Z"
                                            stroke="#222222" />
                                        <path
                                            d="M1.52246 48.5804C1.76482 48.5805 2.00347 48.6537 2.19238 48.7962C2.38163 48.939 2.54383 49.174 2.54395 49.474C2.54395 49.774 2.38161 50.0089 2.19238 50.1517C2.00345 50.2943 1.76487 50.3684 1.52246 50.3685C1.27988 50.3685 1.04062 50.2944 0.851562 50.1517C0.662335 50.0089 0.5 49.774 0.5 49.474C0.500113 49.174 0.662316 48.939 0.851562 48.7962C1.0406 48.6536 1.27993 48.5804 1.52246 48.5804Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M15.4424 29.3482C15.6847 29.3483 15.9234 29.4215 16.1123 29.564C16.3016 29.7068 16.4638 29.9418 16.4639 30.2418C16.4639 30.5418 16.3015 30.7766 16.1123 30.9195C15.9234 31.0621 15.6848 31.1362 15.4424 31.1363C15.1998 31.1363 14.9605 31.0622 14.7715 30.9195C14.5823 30.7766 14.4199 30.5418 14.4199 30.2418C14.42 29.9418 14.5822 29.7068 14.7715 29.564C14.9605 29.4214 15.1999 29.3482 15.4424 29.3482Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M29.3623 15.8857C29.6047 15.8858 29.8433 15.9591 30.0322 16.1016C30.2215 16.2444 30.3837 16.4793 30.3838 16.7793C30.3838 17.0793 30.2215 17.3142 30.0322 17.457C29.8433 17.5996 29.6047 17.6737 29.3623 17.6738C29.1197 17.6738 28.8805 17.5997 28.6914 17.457C28.5022 17.3142 28.3398 17.0793 28.3398 16.7793C28.34 16.4793 28.5022 16.2444 28.6914 16.1016C28.8804 15.959 29.1198 15.8857 29.3623 15.8857Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M43.2803 71.6589C43.5226 71.659 43.7613 71.7322 43.9502 71.8748C44.1394 72.0176 44.3016 72.2525 44.3018 72.5525C44.3018 72.8525 44.1394 73.0874 43.9502 73.2302C43.7613 73.3728 43.5227 73.4469 43.2803 73.447C43.0377 73.447 42.7984 73.3729 42.6094 73.2302C42.4201 73.0874 42.2578 72.8525 42.2578 72.5525C42.2579 72.2525 42.4201 72.0176 42.6094 71.8748C42.7984 71.7322 43.0377 71.6589 43.2803 71.6589Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M57.2002 44.7339C57.4426 44.734 57.6812 44.8073 57.8701 44.9498C58.0594 45.0926 58.2216 45.3275 58.2217 45.6275C58.2217 45.9275 58.0593 46.1624 57.8701 46.3052C57.6812 46.4478 57.4426 46.5219 57.2002 46.522C56.9576 46.522 56.7184 46.4479 56.5293 46.3052C56.3401 46.1624 56.1777 45.9275 56.1777 45.6275C56.1778 45.3275 56.3401 45.0926 56.5293 44.9498C56.7183 44.8072 56.9577 44.7339 57.2002 44.7339Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M71.1201 62.0429C71.3625 62.043 71.6011 62.1162 71.79 62.2587C71.9793 62.4015 72.1415 62.6365 72.1416 62.9364C72.1416 63.2364 71.9793 63.4713 71.79 63.6142C71.6011 63.7567 71.3625 63.8309 71.1201 63.831C70.8775 63.831 70.6383 63.7568 70.4492 63.6142C70.26 63.4713 70.0977 63.2364 70.0977 62.9364C70.0978 62.6365 70.26 62.4015 70.4492 62.2587C70.6383 62.1161 70.8776 62.0429 71.1201 62.0429Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M85.042 52.4268C85.2844 52.4269 85.523 52.5001 85.7119 52.6426C85.9012 52.7854 86.0634 53.0204 86.0635 53.3203C86.0635 53.6204 85.9011 53.8552 85.7119 53.9981C85.523 54.1406 85.2844 54.2148 85.042 54.2149C84.7994 54.2149 84.5601 54.1407 84.3711 53.9981C84.1819 53.8552 84.0195 53.6204 84.0195 53.3203C84.0196 53.0204 84.1818 52.7854 84.3711 52.6426C84.5601 52.5 84.7995 52.4268 85.042 52.4268Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M98.96 38.9643C99.2023 38.9644 99.441 39.0376 99.6299 39.1801C99.8191 39.3229 99.9813 39.5579 99.9814 39.8579C99.9814 40.1579 99.8191 40.3927 99.6299 40.5356C99.441 40.6782 99.2024 40.7523 98.96 40.7524C98.7174 40.7524 98.4781 40.6783 98.2891 40.5356C98.0998 40.3927 97.9375 40.1579 97.9375 39.8579C97.9376 39.5579 98.0998 39.3229 98.2891 39.1801C98.4781 39.0375 98.7174 38.9643 98.96 38.9643Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M112.88 19.7321C113.122 19.7322 113.361 19.8055 113.55 19.948C113.739 20.0908 113.901 20.3257 113.901 20.6257C113.901 20.9257 113.739 21.1606 113.55 21.3034C113.361 21.446 113.122 21.5201 112.88 21.5202C112.637 21.5202 112.398 21.4461 112.209 21.3034C112.02 21.1606 111.857 20.9257 111.857 20.6257C111.858 20.3257 112.02 20.0908 112.209 19.948C112.398 19.8054 112.637 19.7321 112.88 19.7321Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M126.8 0.5C127.042 0.500098 127.281 0.573313 127.47 0.71582C127.659 0.858621 127.821 1.09359 127.821 1.39355C127.821 1.69357 127.659 1.92842 127.47 2.07129C127.281 2.21385 127.042 2.28799 126.8 2.28809C126.557 2.28809 126.318 2.21394 126.129 2.07129C125.94 1.92842 125.777 1.69357 125.777 1.39355C125.777 1.09359 125.94 0.858621 126.129 0.71582C126.318 0.573216 126.557 0.5 126.8 0.5Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M140.72 12.0393C140.962 12.0394 141.201 12.1126 141.39 12.2551C141.579 12.3979 141.741 12.6329 141.741 12.9329C141.741 13.2329 141.579 13.4677 141.39 13.6106C141.201 13.7532 140.962 13.8273 140.72 13.8274C140.477 13.8274 140.238 13.7533 140.049 13.6106C139.86 13.4677 139.697 13.2329 139.697 12.9329C139.697 12.6329 139.86 12.3979 140.049 12.2551C140.238 12.1125 140.477 12.0393 140.72 12.0393Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M154.638 21.6554C154.88 21.6555 155.119 21.7287 155.308 21.8712C155.497 22.014 155.659 22.249 155.659 22.5489C155.659 22.849 155.497 23.0838 155.308 23.2267C155.119 23.3692 154.88 23.4434 154.638 23.4435C154.395 23.4435 154.156 23.3693 153.967 23.2267C153.778 23.0838 153.615 22.8489 153.615 22.5489C153.615 22.249 153.778 22.014 153.967 21.8712C154.156 21.7286 154.395 21.6554 154.638 21.6554Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M168.558 10.1161C168.8 10.1162 169.039 10.1894 169.228 10.3319C169.417 10.4747 169.579 10.7097 169.579 11.0096C169.579 11.3097 169.417 11.5445 169.228 11.6874C169.039 11.8299 168.8 11.9041 168.558 11.9042C168.315 11.9042 168.076 11.83 167.887 11.6874C167.697 11.5445 167.535 11.3097 167.535 11.0096C167.535 10.7097 167.697 10.4747 167.887 10.3319C168.076 10.1893 168.315 10.1161 168.558 10.1161Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                        <path
                                            d="M182.479 58.1964C182.722 58.1965 182.961 58.2698 183.149 58.4123C183.339 58.5551 183.501 58.79 183.501 59.09C183.501 59.39 183.339 59.6249 183.149 59.7677C182.96 59.9103 182.722 59.9844 182.479 59.9845C182.237 59.9845 181.998 59.9104 181.809 59.7677C181.619 59.6249 181.457 59.39 181.457 59.09C181.457 58.79 181.619 58.5551 181.809 58.4123C181.998 58.2697 182.237 58.1964 182.479 58.1964Z"
                                            fill="#222222" stroke="#F4F4F4" />
                                    </svg>
                                </div>
                            </div>

                        </div>
                        <div class="row-start-1 my-5 sm:my-0">
                            <div class="flex justify-center items-center h-full">
                                <div class="py-5 md:py-8 px-2 md:px-5 lg:px-10">
                                    <div class="mb-10 text-black text-[13px]/8 font-bold! text-center">
                                        💰 {{ $t("Distribution of the general system balance") }}
                                    </div>
                                    <div>
                                        <svg width="300" height="300" viewBox="0 0 300 300">
                                            <defs>
                                                <path id="textPathLeft" d="M 150,45 A 105,105 0 0,1 150,255"
                                                    fill="none" />
                                                <path id="textPathRight" d="M 150,255 A 105,105 0 0,1 150,45"
                                                    fill="none" />
                                            </defs>

                                            <g transform="rotate(-90 150 150)">
                                                <circle cx="150" cy="150" r="110" fill="none" stroke="#0F766E"
                                                    stroke-width="30" stroke-dasharray="345 345"
                                                    stroke-dashoffset="0" />
                                                <circle cx="150" cy="150" r="110" fill="none" stroke="#2563EB"
                                                    stroke-width="30" stroke-dasharray="345 345"
                                                    stroke-dashoffset="-345" />
                                            </g>

                                            <text font-size="20" font-weight="900" fill="black">
                                                <textPath href="#textPathLeft" startOffset="50%" text-anchor="middle">
                                                    {{ myData.sypPercentage }}% — {{ $t("Syrian pound") }}
                                                </textPath>
                                            </text>

                                            <text font-size="20" font-weight="700" fill="black">
                                                <textPath href="#textPathRight" startOffset="50%" text-anchor="middle">
                                                    {{ myData.usdPercentage }}% — {{ $t("VSP") }}
                                                </textPath>
                                            </text>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="flex gap-5 sm:gap-10 items-center justify-center">
                            <div class="bg-box-bray-2 py-5 md:py-8 px-2 md:px-5 lg:px-10 min-h-50 min-w-56.25">
                                <div class="mb-9 text-black text-[16px]/8 font-bold! text-center">
                                    {{ $t("Total commissions collected") }}
                                </div>
                                <div class="mb-2 text-black text-[22px]/8 font-bold! text-center">
                                    {{ myData.totalCommissions }}
                                </div>
                            </div>
                            <!-- <div class="bg-box-bray-2 min-h-50">
                                <div class="py-5 md:py-8 px-2 md:px-5 lg:px-10 min-w-56.25">
                                    <div class="mb-7 text-black text-[16px]/8 font-bold! text-center">
                                        {{ $t("Total transfers") }}
                                    </div>
                                    <div class="mb-2 text-black text-[22px]/8 font-bold! text-center">
                                        1500 USD
                                    </div>
                                </div>
                            </div> -->
                            <!-- <div class="bg-box-bray-2">
                                <div class="py-5 md:py-8 px-2 md:px-5 lg:px-10 min-w-56.25">
                                    <div class="mb-3 text-black text-[16px]/8 font-bold! text-center">
                                        {{ $t("Net profit") }}
                                    </div>
                                    <div class="mb-6 text-black text-[16px]/8 font-bold! text-center">
                                        {{ $t("Total expenses") }}
                                    </div>
                                    <div class="text-black text-[22px]/8 font-bold! text-center">
                                        2,500 USD
                                    </div>
                                </div>
                            </div> -->
                        </div>
                    </div>

                    <div v-if="stateFinUsers.loading" class="flex justify-center items-center py-10">
                        <div>
                            <LoadingIcon />
                        </div>
                    </div>
                    <div v-else-if="stateFinUsers.error" class="flex justify-center flex-col gap-4 items-center py-10">
                        <div class="text-[16px]/8 text-red-500 font-bold!">
                            <span v-if="locale == 'ar'"> {{ $t(stateFinUsers.msg.ar) }} </span>
                            <span v-else> {{ $t(stateFinUsers.msg.en) }} </span>
                        </div>
                        <div class="flex justify-center">
                            <button
                                class="bg-[#B9A779] rounded-xl px-4 py-2 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer"
                                @click="getMyFinUsers">
                                {{ $t("Refresh") }}
                            </button>
                        </div>
                    </div>
                    <div v-else-if="finUsers?.length > 0">
                        <div class="px-3 md:px-10 pb-10">
                            <div class="overflow-auto">
                                <table class="bg-table-green-2 w-full overflow-auto">
                                    <thead>
                                        <tr>
                                            <th
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                🧍 {{ $t("User") }}
                                            </th>
                                            <th
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                💸 {{ $t("Number of operations") }}
                                            </th>
                                            <th
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                💰 {{ $t("Total amount") }}
                                            </th>
                                            <th
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                📈 {{ $t("Activity rate") }}
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="item in finUsers" :key="item._id">
                                            <td
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                {{ item.name }} {{ item.fatherName }} {{ item.nickname }}
                                            </td>
                                            <td
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                {{ item.transfersCount }}
                                            </td>
                                            <td
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                {{ item.totalPaid }}
                                            </td>
                                            <td
                                                class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center px-3 py-2 whitespace-nowrap">
                                                {{ item.activityRate }}%
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="flex justify-center px-2 py-5">
                            <UPagination v-model:page="page" :total="totalPages * 10"
                                :class="{ 'en-dir': locale == 'ar' }" />
                        </div>
                    </div>

                    <div v-else class="text-center mx-3 text-black text-[12px]/5 sm:text-[16px]/8 font-bold! pb-5">
                        {{ $t("There are no any financial restrictions users") }}
                    </div>

                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

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

const stateFinUsers = ref({
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

const myData = ref(null);
const finUsers = ref([]);

onMounted(() => {
    getAllInfo();
});

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
        getFinUsers().then(res => {
            if (res?.users) {
                finUsers.value = res.users;
                totalPages.value = Math.ceil(res.usersCount / 10);
            }
        }).then(() => {
            state.value.loading = false;
            stateFinUsers.value.loading = false;
        });
    });
}

async function getAllData() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/accounting/financial-restrictions/global-stats`;

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

const page = ref(1);
const totalPages = ref(1);

function getMyFinUsers() {

    // Change state loading to loading
    stateFinUsers.value.loading = true;

    // clean error state
    stateFinUsers.value.error = false;

    getFinUsers().then(res => {
        if (res) {
            finUsers.value = res.users;
            totalPages.value = res.usersCount;
        }
    }).then(() => {
        stateFinUsers.value.loading = false;
    });
}

async function getFinUsers() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/accounting/financial-restrictions/users-stats`;

    let myParams = {
        pageNumber: page.value,
        pageSize: 10
    };

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
            stateFinUsers.value.error = true;
            stateFinUsers.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        return response.data.data;
    }
    catch (error) {
        stateFinUsers.value.loading = false;
        stateFinUsers.value.error = true;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateFinUsers.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

watch(
    () => page.value,
    () => {
        getMyFinUsers();
    }
)

watch(
    () => ({ ...search.value }),
    () => {
        page.value = 1;
        getAllInfo();
    }
)

</script>