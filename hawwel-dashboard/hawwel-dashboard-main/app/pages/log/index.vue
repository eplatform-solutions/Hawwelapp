<template>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div>

                    <!-- search bar -->
                    <div class="flex justify-between">
                        <div class="mx-2 sm:mx-10 mb-10">
                            <input type="text" :class="{ 'en-dir': locale == 'en' }" v-model="search.userName"
                                class="w-full rounded-xl bg-white py-3 px-3 md:px-10 text-black text-[14px]/5 sm:text-[20px]/8 font-bold!"
                                :placeholder="$t('User name')">
                        </div>

                        <div class="mx-2 sm:mx-10 mb-10">
                            <input type="text" :class="{ 'en-dir': locale == 'en' }" v-model="search.ipAddress"
                                class="w-full rounded-xl bg-white py-3 px-3 md:px-10 text-black text-[14px]/5 sm:text-[20px]/8 font-bold!"
                                :placeholder="$t('IP Address')">
                        </div>
                    </div>

                    <!-- search bar -->
                    <div class="flex justify-between" :class="{ 'flex-row-reverse': locale == 'en' }">
                        <div class="mx-2 sm:mx-10 mb-10">
                            <div class="text-center text-[12px]/5 sm:text-[16px]/8 font-bold! text-black mb-2">
                                {{ $t("Date from") }}
                            </div>
                            <input type="date" :class="{ 'en-dir': locale == 'en' }" v-model="search.fromDate"
                                class="w-full rounded-xl bg-white py-3 px-3 md:px-10 text-black text-[14px]/5 sm:text-[20px]/8 font-bold!">
                        </div>

                        <div class="mx-2 sm:mx-10 mb-10">
                            <div class="text-center text-[12px]/5 sm:text-[16px]/8 font-bold! text-black mb-2">
                                {{ $t("Date to") }}
                            </div>
                            <input type="date" :class="{ 'en-dir': locale == 'en' }" v-model="search.toData"
                                class="w-full rounded-xl bg-white py-3 px-3 md:px-10 text-black text-[14px]/5 sm:text-[20px]/8 font-bold!">
                        </div>
                    </div>

                    <div class="flex justify-center mb-5">
                        <button @click="page = 1; getAllInfo()"
                            class="bg-stone-300 cursor-pointer px-5 py-1 rounded-xl text-[12px]/5 sm:text-[16px]/8 font-bold!">
                            {{ $t("Search") }}
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
                    <div v-else>
                        <div class="mx-5 sm:mx-10 overflow-auto">

                            <table class="bg-white lg:table-fixed w-full rounded-xl">

                                <thead>
                                    <tr>
                                        <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center whitespace-nowrap border-b border-black py-2 px-4"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("user name") }}
                                        </th>
                                        <th class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center whitespace-nowrap border-b border-black py-2 px-4"
                                            :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ $t("IP Address") }}
                                        </th>
                                        <th
                                            class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center whitespace-nowrap border-b border-black py-2 px-4">
                                            {{ $t("Date and Time") }}
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr v-for="(item, index) in logs" :key="item._id">
                                        <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center whitespace-nowrap border-black py-2 px-4"
                                            :class="{ 'border-b': index + 1 != logs.length, 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                            {{ item.user.userName }}
                                        </td>
                                        <td :class="{ 'border-b': index + 1 != logs.length, 'border-l': locale == 'ar', 'border-r': locale == 'en' }"
                                            class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center whitespace-nowrap border-black py-2 px-4">
                                            {{ item.ipAddress }}
                                        </td>
                                        <td :class="{ 'border-b': index + 1 != logs.length }"
                                            class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! text-center whitespace-nowrap border-black py-2 px-4 en-dir">
                                            {{ formatToLocalTime(item.createdAt) }}
                                        </td>
                                    </tr>
                                </tbody>

                            </table>

                        </div>
                        <div v-if="!state.error" class="py-10 flex justify-center"
                            :class="{ 'en-dir': locale == 'ar' }">
                            <UPagination v-model:page="page" :total="totalPages" />
                        </div>
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
    loading: false,
    error: false,
    msg: {
        ar: "",
        en: ""
    }
});


const logs = ref([]);
const totalPages = ref(0);
const page = ref(1);

const search = ref({
    fromDate: "",
    toData: "",
    ipAddress: "",
    userName: ""
});

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
    getAllLogs().then(res => {
        if (res) {
            logs.value = res.logs;
            totalPages.value = res.logsCount;
        }
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllLogs() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/login-logs/all-logs-inside-the-page`;

    let myPrarms = {
        pageNumber: page.value,
        pageSize: 10
    };

    if (search.value.userName != "") {
        myPrarms.userName = search.value.userName;
    }

    if (search.value.ipAddress != "") {
        myPrarms.ipAddress = search.value.ipAddress;
    }

    if (search.value.fromDate != "") {
        myPrarms.fromDate = search.value.fromDate;
    }

    if (search.value.toData != "") {
        myPrarms.toData = search.value.toData;
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

const formatToLocalTime = (dateString) => {
    if (!dateString) return '----/--/-- / --:--:--';
    
    const date = new Date(dateString);
    if (isNaN(date.getTime())) return '----/--/-- / --:--:--';
    
    const year = date.getFullYear(); 

    const month = String(date.getMonth() + 1).padStart(2, '0');
    
    const day = String(date.getDate()).padStart(2, '0');
    
    const hours = String(date.getHours()).padStart(2, '0');
    
    const minutes = String(date.getMinutes()).padStart(2, '0');
    
    const seconds = String(date.getSeconds()).padStart(2, '0');
    
    return `${year}-${month}-${day} / ${hours}:${minutes}:${seconds}`;
};

watch(
    () => page.value,
    () => {
        getAllInfo();
    }
);

</script>