<template>

    <use-toast v-if="stateReview.error" head="Failed" :body="locale == 'en' ? stateReview.msg.en : stateReview.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateReview.success" head="Success"
        :body="locale == 'en' ? stateReview.msg.en : stateReview.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <!-- Summary counters -->
                <div class="flex flex-wrap gap-3 justify-center md:justify-start px-2 sm:px-10 mb-5">
                    <div class="bg-white rounded-xl px-4 py-2 min-w-40">
                        <div class="text-[#4A4949] text-[12px]/5 sm:text-[14px]/6 font-bold!">{{ $t("Open alerts") }}</div>
                        <div class="text-black text-[20px]/8 font-bold!">{{ stats.open }}</div>
                    </div>
                    <div class="bg-white rounded-xl px-4 py-2 min-w-40"
                        :class="{ 'ring-2 ring-red-500': stats.openHighSeverity > 0 }">
                        <div class="text-[#4A4949] text-[12px]/5 sm:text-[14px]/6 font-bold!">{{ $t("Open high severity") }}</div>
                        <div class="text-[20px]/8 font-bold!"
                            :class="stats.openHighSeverity > 0 ? 'text-red-600' : 'text-black'">
                            {{ stats.openHighSeverity }}
                        </div>
                    </div>
                    <div class="bg-white rounded-xl px-4 py-2 min-w-40">
                        <div class="text-[#4A4949] text-[12px]/5 sm:text-[14px]/6 font-bold!">{{ $t("Cleared") }}</div>
                        <div class="text-black text-[20px]/8 font-bold!">{{ stats.cleared }}</div>
                    </div>
                    <div class="bg-white rounded-xl px-4 py-2 min-w-40">
                        <div class="text-[#4A4949] text-[12px]/5 sm:text-[14px]/6 font-bold!">{{ $t("Confirmed") }}</div>
                        <div class="text-black text-[20px]/8 font-bold!">{{ stats.confirmed }}</div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="flex flex-wrap justify-center md:justify-between gap-5 items-center mb-5 sm:mb-10 px-2 sm:px-10">

                    <div class="flex flex-wrap gap-3 items-center">
                        <select v-model="search.status" @change="resetAndReload"
                            class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! rounded-xl px-3 py-2 cursor-pointer min-w-40">
                            <option value="">{{ $t("All statuses") }}</option>
                            <option v-for="option in statusOptions" :key="option" :value="option">
                                {{ $t(option) }}
                            </option>
                        </select>

                        <select v-model="search.type" @change="resetAndReload"
                            class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! rounded-xl px-3 py-2 cursor-pointer min-w-52">
                            <option value="">{{ $t("All alert types") }}</option>
                            <option v-for="option in typeOptions" :key="option" :value="option">
                                {{ $t(option) }}
                            </option>
                        </select>

                        <select v-model="search.severity" @change="resetAndReload"
                            class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! rounded-xl px-3 py-2 cursor-pointer min-w-40">
                            <option value="">{{ $t("All severities") }}</option>
                            <option v-for="option in severityOptions" :key="option" :value="option">
                                {{ $t(option) }}
                            </option>
                        </select>

                        <input type="date" v-model="search.date" @change="resetAndReload"
                            class="bg-white text-[12px]/5 sm:text-[16px]/8 font-bold! rounded-xl px-3 py-2 cursor-pointer" />

                        <button v-if="hasAnyFilter" @click="clearFilters"
                            class="text-[#6B1F2A] text-[12px]/5 sm:text-[16px]/8 font-bold! px-3 py-2 cursor-pointer">
                            {{ $t("Clear filters") }}
                        </button>
                    </div>

                </div>

                <div class="px-2 sm:px-10 pb-10">

                    <div v-if="state.loading" class="flex justify-center py-10">
                        <loading-icon></loading-icon>
                    </div>

                    <div v-else-if="alerts.length == 0"
                        class="bg-white rounded-xl text-center py-10 text-black text-[14px]/6 sm:text-[18px]/8 font-bold!">
                        {{ $t("No compliance alerts") }}
                    </div>

                    <div v-else class="overflow-x-auto bg-white rounded-xl p-2 sm:p-5">
                        <table class="w-full">
                            <thead>
                                <tr>
                                    <th v-for="head in tableHeads" :key="head"
                                        class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t(head) }}
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <tr v-for="item in alerts" :key="item._id">

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <span class="px-2 py-1 rounded-lg" :class="severityClass(item.severity)">
                                            {{ $t(item.severity) }}
                                        </span>
                                    </td>

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t(item.type) }}
                                    </td>

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <div>{{ item.user?.name || $t("Unknown customer") }}</div>
                                        <div v-if="item.user?.mobilePhone" class="en-dir text-[10px]/4 sm:text-[12px]/5 text-gray-500">
                                            {{ item.user.mobilePhone }}
                                        </div>
                                    </td>

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <span v-if="item.partyType">{{ $t(item.partyType) }}</span>
                                        <span v-else>-</span>
                                    </td>

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <span v-if="typeof item.matchScore === 'number'" class="en-dir">
                                            {{ item.matchScore.toFixed(2) }}
                                        </span>
                                        <span v-else>-</span>
                                    </td>

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        <span v-if="item.blockedTransfer" class="text-red-600">{{ $t("Blocked") }}</span>
                                        <span v-else class="text-gray-500">{{ $t("Flagged only") }}</span>
                                    </td>

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap en-dir"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ item.createdAt.split('T')[0] }}
                                    </td>

                                    <td class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap"
                                        :class="{ 'border-l': locale == 'ar', 'border-r': locale == 'en' }">
                                        {{ $t(item.status) }}
                                    </td>

                                    <td
                                        class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! border-black border-b text-center px-4 py-2 whitespace-nowrap">
                                        <div class="flex justify-center gap-3">
                                            <button @click="openDetails(item)"
                                                class="hover:text-blue-800 cursor-pointer duration-200 underline">
                                                {{ $t("Details") }}
                                            </button>
                                            <button v-if="item.status == 'open'" @click="openReviewModal(item)"
                                                class="hover:text-blue-800 cursor-pointer duration-200 underline">
                                                {{ $t("Review") }}
                                            </button>
                                        </div>
                                    </td>

                                </tr>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <div class="flex flex-wrap justify-center items-center mt-5"
                            :class="{ 'flex-row-reverse': locale == 'en' }">

                            <div class="flex gap-2 text-[#4A4949] text-[16px]/8 font-bold! mx-5">
                                <div>{{ $t("Number") }}</div>
                                <div class="en-dir">{{ totalNumberOfFields }}</div>
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

            <MyNavbar></MyNavbar>

        </div>

    </div>

    <!-- Details -->
    <UModal v-model:open="openDetailsModal">
        <template #content>
            <div class="bg-box-gray p-5 max-h-[80vh] overflow-y-auto">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!" :class="{ 'ar-dir': locale == 'ar' }">
                        {{ $t("Alert details") }}
                    </div>
                    <button @click="openDetailsModal = false" class="cursor-pointer">
                        <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                    </button>
                </div>

                <div v-if="detailsItem" class="flex flex-col gap-3" :class="{ 'ar-dir': locale == 'ar' }">

                    <div v-for="row in detailRows" :key="row.label" class="flex justify-between gap-3 border-b border-dashed border-gray-300 pb-1">
                        <div class="text-[#4A4949] text-[14px]/6 font-bold!">{{ $t(row.label) }}</div>
                        <div class="text-black text-[14px]/6 font-bold!" :class="{ 'en-dir': row.ltr }">{{ row.value }}</div>
                    </div>

                    <div v-if="detailsItem.details" class="mt-2">
                        <div class="text-[#4A4949] text-[14px]/6 font-bold! mb-1">{{ $t("Details") }}</div>
                        <div class="text-black text-[13px]/6 bg-white rounded-lg p-2 break-words">
                            {{ detailsItem.details }}
                        </div>
                    </div>

                    <div v-if="detailsItem.matches && detailsItem.matches.length" class="mt-2">
                        <div class="text-[#4A4949] text-[14px]/6 font-bold! mb-1">{{ $t("List matches") }}</div>
                        <div v-for="match in detailsItem.matches" :key="match.entityId"
                            class="bg-white rounded-lg p-2 mb-2">
                            <div class="text-black text-[13px]/6 font-bold!">{{ match.caption }}</div>
                            <div class="text-gray-600 text-[12px]/5 en-dir">
                                {{ match.entityId }} &middot; {{ Number(match.score).toFixed(2) }}
                            </div>
                            <div v-if="match.datasets && match.datasets.length"
                                class="text-gray-600 text-[12px]/5 en-dir break-words">
                                {{ match.datasets.join(", ") }}
                            </div>
                        </div>
                    </div>

                    <div v-if="detailsItem.reviewNote" class="mt-2">
                        <div class="text-[#4A4949] text-[14px]/6 font-bold! mb-1">{{ $t("Review note") }}</div>
                        <div class="text-black text-[13px]/6 bg-white rounded-lg p-2 break-words">
                            {{ detailsItem.reviewNote }}
                        </div>
                    </div>

                </div>
            </div>
        </template>
    </UModal>

    <!-- Review decision -->
    <UModal v-model:open="openReview">
        <template #content>
            <div class="bg-box-gray p-5">
                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5"
                    :class="{ 'flex-row-reverse': locale == 'ar' }">
                    <div class="text-black text-[16px]/8 font-bold!" :class="{ 'ar-dir': locale == 'ar' }">
                        {{ $t("Review alert") }}
                    </div>
                    <button @click="openReview = false" class="cursor-pointer">
                        <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                    </button>
                </div>

                <form @submit.prevent="submitReview" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="mb-4">
                        <div class="text-black text-[14px]/6 font-bold! mb-2">{{ $t("Decision") }}</div>
                        <select v-model="reviewData.status"
                            class="bg-white w-full text-[14px]/6 font-bold! rounded-xl px-3 py-2 cursor-pointer">
                            <option value="cleared">{{ $t("cleared") }}</option>
                            <option value="confirmed">{{ $t("confirmed") }}</option>
                        </select>
                    </div>

                    <div class="text-[12px]/5 text-[#4A4949] mb-4 bg-white rounded-lg p-2">
                        <template v-if="reviewData.status == 'cleared'">
                            {{ $t("Clearing marks this as a false positive. The same name will not be raised again for this customer.") }}
                        </template>
                        <template v-else>
                            {{ $t("Confirming records a true match. It does not block the customer - do that from the users page.") }}
                        </template>
                    </div>

                    <div class="mb-4">
                        <div class="text-black text-[14px]/6 font-bold! mb-2">{{ $t("Review note") }}</div>
                        <textarea v-model="reviewData.reviewNote" rows="3" maxlength="1000"
                            class="bg-white w-full text-[14px]/6 rounded-xl px-3 py-2"
                            :placeholder="$t('Why did you reach this decision?')"></textarea>
                    </div>

                    <div class="text-red-500 text-[13px]/6 font-bold! mb-3">
                        {{ $t("A decision cannot be changed later.") }}
                    </div>

                    <div class="flex justify-center">
                        <UButton type="submit" :disabled="stateReview.loading"
                            class="cursor-pointer brand-btn px-8 py-2 text-[16px]/8 font-bold!">
                            <loading-icon-sec v-if="stateReview.loading"></loading-icon-sec>
                            <span v-else>{{ $t("Save") }}</span>
                        </UButton>
                    </div>

                </form>
            </div>
        </template>
    </UModal>

</template>

<script setup>
const { axios, router, store, BASE_URL } = useUtils();
const { handelErrorType } = useHandelError();
const { locale, setLocale, t } = useI18n();

onMounted(() => {
    setLocale(store.getLanguage);
});

const tableHeads = [
    "Severity",
    "Alert type",
    "Customer",
    "Party",
    "Match score",
    "Effect",
    "Raised on",
    "Status",
    "Actions",
];

// Kept in step with constants/compliance in dasco-backend-dashboard; the API
// rejects anything else, so these are the only values worth offering.
const statusOptions = ["open", "cleared", "confirmed"];
const typeOptions = [
    "sanctions-hit",
    "sanctions-review",
    "screening-unavailable",
    "velocity-breach",
    "edd-required",
];
const severityOptions = ["high", "medium", "low"];

const state = ref({ loading: false, error: false, msg: { ar: "", en: "" } });
const stateReview = ref({ loading: false, error: false, success: false, msg: { ar: "", en: "" } });

const alerts = ref([]);
const stats = ref({ open: 0, cleared: 0, confirmed: 0, openHighSeverity: 0 });

const search = ref({ status: "", type: "", severity: "", date: "" });

const numberOfFieldsInOnePage = ref(25);
const totalNumberOfFields = ref(0);
const currentPage = ref(1);

const hasAnyFilter = computed(() =>
    Boolean(search.value.status || search.value.type || search.value.severity || search.value.date)
);

const openDetailsModal = ref(false);
const detailsItem = ref(null);

const openReview = ref(false);
const reviewData = ref({ _id: "", status: "cleared", reviewNote: "" });

const detailRows = computed(() => {
    const item = detailsItem.value;
    if (!item) return [];
    const rows = [
        { label: "Alert type", value: t(item.type) },
        { label: "Severity", value: t(item.severity) },
        { label: "Status", value: t(item.status) },
        { label: "Customer", value: item.user?.name || t("Unknown customer") },
    ];
    if (item.user?.mobilePhone) rows.push({ label: "Mobile phone", value: item.user.mobilePhone, ltr: true });
    if (item.user?.country) rows.push({ label: "Country", value: item.user.country, ltr: true });
    if (item.partyType) rows.push({ label: "Party", value: t(item.partyType) });
    if (item.screenedName) rows.push({ label: "Screened name", value: item.screenedName, ltr: true });
    if (typeof item.matchScore === "number") rows.push({ label: "Match score", value: item.matchScore.toFixed(2), ltr: true });
    if (item.transfer?.transferNumber) {
        rows.push({ label: "Transfer number", value: item.transfer.transferNumber, ltr: true });
        rows.push({ label: "Amount", value: `${item.transfer.amount} ${item.transfer.currencyName || ""}`.trim(), ltr: true });
    }
    rows.push({ label: "Effect", value: item.blockedTransfer ? t("Blocked") : t("Flagged only") });
    rows.push({ label: "Raised on", value: String(item.createdAt).split("T")[0], ltr: true });
    if (item.reviewedAt) rows.push({ label: "Reviewed on", value: String(item.reviewedAt).split("T")[0], ltr: true });
    return rows;
});

function severityClass(severity) {
    if (severity === "high") return "bg-red-100 text-red-700";
    if (severity === "medium") return "bg-amber-100 text-amber-700";
    return "bg-gray-100 text-gray-700";
}

function openDetails(item) {
    detailsItem.value = item;
    openDetailsModal.value = true;
}

function openReviewModal(item) {
    reviewData.value = { _id: item._id, status: "cleared", reviewNote: "" };
    openReview.value = true;
}

function clearFilters() {
    search.value = { status: "", type: "", severity: "", date: "" };
    resetAndReload();
}

// Any filter change invalidates the current page number: staying on page 3 of
// a result set that now has one page shows an empty table.
function resetAndReload() {
    currentPage.value = 1;
    getAllInfo();
}

function nextPage() {
    if ((currentPage.value * numberOfFieldsInOnePage.value) >= totalNumberOfFields.value) return;
    currentPage.value += 1;
    getAllInfo();
}

function previousPage() {
    if (currentPage.value <= 1) return;
    currentPage.value -= 1;
    getAllInfo();
}

onMounted(() => {
    getAllInfo();
    getStats();
});

function applyError(error) {
    state.value.error = true;
    const errorMessage = handelErrorType(error);
    if (errorMessage == "Unauthorized") {
        store.updateToken(null);
        router.push("/login");
    }
    state.value.msg = { ar: errorMessage, en: errorMessage };
}

async function getAllInfo() {
    state.value.loading = true;
    state.value.error = false;
    state.value.msg = { ar: "", en: "" };

    const result = await getAlerts();
    // The API answers "page not found" with error:true for an empty result,
    // so an empty list is a normal outcome here, not a failure to surface.
    alerts.value = result?.alerts ?? [];
    totalNumberOfFields.value = result?.alertsCount ?? 0;
    state.value.loading = false;
}

async function getAlerts() {
    const token = store.getToken;
    const apiUrl = `${BASE_URL}/compliance/all-alerts-inside-the-page`;

    const myParams = {
        pageNumber: currentPage.value,
        pageSize: numberOfFieldsInOnePage.value,
    };

    if (search.value.status != "") myParams.status = search.value.status;
    if (search.value.type != "") myParams.type = search.value.type;
    if (search.value.severity != "") myParams.severity = search.value.severity;
    if (search.value.date != "") {
        myParams.fromDate = search.value.date;
        myParams.toDate = search.value.date;
    }

    try {
        const response = await axios.get(apiUrl, {
            headers: { Authorization: `Bearer ${token}` },
            params: myParams,
        });
        return response.data.data;
    }
    catch (error) {
        applyError(error);
        return null;
    }
}

async function getStats() {
    const token = store.getToken;
    try {
        const response = await axios.get(`${BASE_URL}/compliance/alerts-stats`, {
            headers: { Authorization: `Bearer ${token}` },
        });
        if (response.data.error) return;
        stats.value = {
            open: response.data.data.open ?? 0,
            cleared: response.data.data.cleared ?? 0,
            confirmed: response.data.data.confirmed ?? 0,
            openHighSeverity: response.data.data.openHighSeverity ?? 0,
        };
    }
    catch (error) {
        // Counters are informational; the table below is the source of truth.
    }
}

async function submitReview() {
    stateReview.value.loading = true;
    stateReview.value.error = false;
    stateReview.value.success = false;

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/compliance/alerts/${reviewData.value._id}/resolve`;

    try {
        const response = await axios.put(apiUrl, {
            status: reviewData.value.status,
            reviewNote: reviewData.value.reviewNote,
        }, {
            headers: { Authorization: `Bearer ${token}` },
        });

        if (response.data.error) {
            stateReview.value.error = true;
            stateReview.value.msg = response?.data?.msg?.ar
                ? { ar: response.data.msg.ar, en: response.data.msg.en }
                : { ar: response.data.msg, en: response.data.msg };
            stateReview.value.loading = false;
            return;
        }

        stateReview.value.success = true;
        stateReview.value.msg = response?.data?.msg?.ar
            ? { ar: response.data.msg.ar, en: response.data.msg.en }
            : { ar: response.data.msg, en: response.data.msg };
        openReview.value = false;
        await getAllInfo();
        await getStats();
    }
    catch (error) {
        stateReview.value.error = true;
        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }
        stateReview.value.msg = { ar: errorMessage, en: errorMessage };
    }
    stateReview.value.loading = false;
}
</script>
