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

    <div>

        <div class="lg:flex" :class="{ 'flex-row-reverse': locale == 'en' }">

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen pb-10"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

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
                    <div class="flex sm:flex-row flex-col sm:gap-10 gap-2 px-5 items-center mb-10">

                        <div class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold! sm:text-start text-center">
                            {{ $t("Contact numbers:") }}
                        </div>

                        <div v-if="pageContent?.contactInfo?.mobilePhones?.length > 0"
                            class="flex flex-wrap sm:gap-10 gap-3 mb-5">

                            <div v-for="item in pageContent?.contactInfo.mobilePhones" :key="item"
                                class="bg-[#B9A779] px-7 py-3 en-dir">
                                <a class="text-black text-[12px]/5 sm:text-[16px]/8 font-bold!" :href="`tel:${item}`">
                                    {{ item }}
                                </a>
                            </div>

                        </div>

                        <div v-else class="text-center mx-5 text-gray-600 text-[12px]/5 sm:text-[16px]/8 font-bold!">
                            {{ $t("There are no any contact numbers yet") }}
                        </div>

                    </div>

                    <div class="flex justify-center mx-auto my-10">
                        <button @click="showEditModal"
                            class="bg-[#097F6E] hover:bg-[#097F6E]/70 duration-200 rounded-xl px-4 py-2 text-white text-[12px]/5 sm:text-[16px]/8 font-bold! cursor-pointer">
                            {{ $t("Edit contact information") }}
                        </button>
                    </div>

                    <!-- Frequently Asked Questions section -->
                    <div class="mb-10">

                        <div
                            class="text-[#6B1F2A] text-[16px]/5 sm:text-[20px]/8 text-center font-bold! tracking-[2px] mb-10">
                            {{ $t("Frequently Asked Questions section") }}
                        </div>

                        <div class="px-5">

                            <div v-if="pageContent?.faqs && pageContent?.faqs.length == 0"
                                class="text-[#773640] text-[12px]/5 sm:text-[16px]/8 text-center font-bold! tracking-[2px]">
                                {{ $t("There are no FAQs yet") }}
                            </div>
                            <div v-else>
                                <my-qus v-for="item in pageContent.faqs" :key="item._id" :my-item="item"
                                    @refresh="getAllInfo">
                                </my-qus>
                            </div>

                        </div>

                    </div>

                    <div class="flex justify-center">
                        <button @click="showAddModal"
                            class="text-white text-[12px]/5 sm:text-[16px]/8 bg-[#097F6E] rounded-2xl px-9 py-2 tracking-[2حء] cursor-pointer">
                            {{ $t("Add a question") }}
                        </button>
                    </div>
                </div>

            </div>

            <!-- navbar / slide menu -->
            <MyNavbar></MyNavbar>

        </div>

    </div>

    <!-- modal for add new question -->
    <UModal v-model:open="openAdd">

        <template #content>

            <div class="bg-box-gray p-5" :class="{ 'ar-dir': locale == 'ar' }">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Add a new question") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openAdd = !openAdd" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="addFAQ" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-black font-bold! text-[14px]/8">
                            {{ $t("Type the title") }}
                        </div>
                        <input type="text" v-model="newFAQData.questionAr" :placeholder="$t('Type question in arabic')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
                        <input type="text" v-model="newFAQData.questionEn" :placeholder="$t('Type question in english')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
                    </div>

                    <div class="flex flex-col gap-2 mb-4">
                        <div class="text-black font-bold! text-[14px]/8">
                            {{ $t("Type the answer") }}
                        </div>
                        <input type="text" v-model="newFAQData.answerAr" :placeholder="$t('Type answer in arabic')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
                        <input type="text" v-model="newFAQData.answerEn" :placeholder="$t('Type answer in english')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
                    </div>

                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateAdd.loading" :disabled="stateAdd.loading"
                            class="text-black text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t("Add") }}
                        </UButton>
                    </div>

                </form>

            </div>

        </template>
    </UModal>


    <!-- modal for edit contact info -->
    <UModal v-model:open="openEdit">

        <template #content>

            <div class="bg-box-gray p-5" :class="{ 'ar-dir': locale == 'ar' }">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Edit contact information") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="editConInfo" :class="{ 'ar-dir': locale == 'ar' }">

                    <div class="flex flex-col gap-2 mb-4">
                        <div class="text-black font-bold! text-[14px]/8">
                            {{ $t("Contact numbers") }}
                        </div>
                        <!-- <input v-for="item in editContactInfo.mobilePhones" :key="item" type="text"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" /> -->

                        <div v-for="(phone, index) in editContactInfo.mobilePhones" :key="index"
                            class="flex items-center gap-2">

                            <input v-model="phone.number" type="text" required
                                class="bg-[#B9A779] rounded-xl py-2 px-4 flex-1 text-black text-[11px]/8"
                                :placeholder="$t('Enter phone number')" />

                            <button v-if="editContactInfo.mobilePhones.length > 0" @click="removePhone(index)"
                                class="bg-red-500 hover:bg-red-600 text-white rounded-xl px-3 py-2 text-sm transition-colors"
                                type="button" :title="$t('Delete')">
                                <span class="text-lg">🗑️</span>
                            </button>
                        </div>

                        <!-- button for Add new number -->
                        <button @click="addNewPhone" v-if="editContactInfo.mobilePhones.length < 2"
                            class="bg-green-600 hover:bg-green-700 text-white rounded-xl py-2 px-4 text-sm transition-colors flex items-center justify-center gap-2"
                            type="button">
                            <span class="text-lg">➕</span>
                            {{ $t("Add new number") }}
                        </button>
                    </div>

                    <div class="flex justify-center">
                        <UButton type="submit" :loading="stateEdit.loading" :disabled="stateEdit.loading"
                            class="text-black text-[12px]/8 font-bold! px-5 py-0.5 bg-main-color-page cursor-pointer">
                            {{ $t("Edit") }}
                        </UButton>
                    </div>

                </form>

            </div>

        </template>
    </UModal>

</template>

<script setup>
import { tr } from '@nuxt/ui/runtime/locale/index.js';

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

const openAdd = ref(false);
const openEdit = ref(false);
const pageContent = ref(null);

const editContactInfo = ref({
    mobilePhones: [
        { number: '' }
    ]
})

function showEditModal() {
    editContactInfo.value.mobilePhones = [
        { number: '' }
    ];
    if (pageContent.value?.contactInfo?.mobilePhones?.length > 0) {
        editContactInfo.value.mobilePhones = [];
        pageContent.value?.contactInfo?.mobilePhones.forEach(ele => {
            const x = {
                number: ele
            };
            editContactInfo.value.mobilePhones.push(x);
        });
    }
    openEdit.value = true;
}

const addNewPhone = () => {
    editContactInfo.value.mobilePhones.push({ number: '' })
}

const removePhone = (index) => {
    editContactInfo.value.mobilePhones.splice(index, 1)
}

onMounted(() => {
    getAllInfo();
});

async function getAllInfo() {

    // Change state loading to loading
    state.value.loading = true;

    // clean error state
    state.value.error = false;

    getAllContent().then(res => {
        if (res)
            pageContent.value = res;
    }).then(() => {
        state.value.loading = false;
    });
}

async function getAllContent() {

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/technical-support/page-content`;

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
        en: "",
        ar: ""
    }
});

const stateDelete = ref({
    loading: false,
    error: false,
    msg: {
        en: "",
        ar: ""
    }
});

async function addFAQ() {

    stateAdd.value.loading = true;
    stateAdd.value.error = false;
    stateAdd.value.success = false;
    stateAdd.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/faqs/create`;

    const data = {
        question: {
            ar: newFAQData.value.questionAr,
            en: newFAQData.value.questionEn
        },
        answer: {
            ar: newFAQData.value.answerAr,
            en: newFAQData.value.answerEn
        }
    }

    try {
        const response = await axios.post(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });


        // if there is error
        if (response.data.error) {
            stateAdd.value.loading = false;
            stateAdd.value.error = true;
            stateAdd.value.success = false;
            stateAdd.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
            return;
        }

        stateAdd.value = {
            loading: false,
            error: false,
            success: true,
            msg: {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        };

        getAllInfo();
        openAdd.value = false;
    }
    catch (error) {
        stateAdd.value.loading = false;
        stateAdd.value.error = true;
        stateAdd.value.success = false;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized") {
            store.updateToken(null);
            router.push("/login");
        }

        stateAdd.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

const stateEdit = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

async function editConInfo() {

    stateEdit.value.loading = true;
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = {
        en: "",
        ar: "",
    };


    // Email support channel is retired; the stored value (if any) is
    // cleared so older app builds stop showing it.
    let data = {
        email: "",
        mobilePhones: []
    };

    if (editContactInfo.value.mobilePhones.length > 0) {
        editContactInfo.value.mobilePhones.forEach(ele => {
            const myNumner = ele.number;
            data.mobilePhones.push(myNumner);
        });
    }


    const token = store.getToken;
    const apiUrl = `${BASE_URL}/contact-info/update`;

    try {
        const response = await axios.put(apiUrl, data, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

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
        stateEdit.value.success = false;

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

const newFAQData = ref({
    questionAr: "",
    questionEn: "",
    answerAr: "",
    answerEn: "",
});

function showAddModal() {
    newFAQData.value = {
        question: "",
        answer: "",
    };
    openAdd.value = true;
}

</script>