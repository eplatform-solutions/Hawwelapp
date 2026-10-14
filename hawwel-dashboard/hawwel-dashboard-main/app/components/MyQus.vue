<template>

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

    <div class="flex justify-between gap-5 mb-5">

        <div class="flex flex-col gap-2">

            <div class="text-[16px]/5 sm:text-[22px]/8 text-black font-bold!">
                {{ locale == 'en' ? props.myItem.question.en : props.myItem.question.ar }}
            </div>

            <div class="text-[10px]/5 sm:text-[13px]/8 text-[#0000008F] font-bold! tracking-[2px]">
                {{ locale == 'en' ? props.myItem.answer.en : props.myItem.answer.ar }}
            </div>

        </div>

        <div class="flex gap-3 items-center">

            <!-- delete -->
            <button class="cursor-pointer" @click="openDelete = !openDelete">
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M15 4H20V6H18V19C18 19.5523 17.5523 20 17 20H3C2.44772 20 2 19.5523 2 19V6H0V4H5V1C5 0.44772 5.44772 0 6 0H14C14.5523 0 15 0.44772 15 1V4ZM16 6H4V18H16V6ZM7 9H9V15H7V9ZM11 9H13V15H11V9ZM7 2V4H13V2H7Z"
                        fill="#FB0F0F" />
                </svg>
            </button>

            <!-- edit -->
            <button class="cursor-pointer" @click="openEditModal">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M5 18.89H6.41421L15.7279 9.57628L14.3137 8.16207L5 17.4758V18.89ZM21 20.89H3V16.6473L16.435 3.21232C16.8256 2.8218 17.4587 2.8218 17.8492 3.21232L20.6777 6.04075C21.0682 6.43127 21.0682 7.06444 20.6777 7.45496L9.24264 18.89H21V20.89ZM15.7279 6.74786L17.1421 8.16207L18.5563 6.74786L17.1421 5.33364L15.7279 6.74786Z"
                        fill="black" />
                </svg>
            </button>

        </div>

    </div>


    <!-- modal for edit -->
    <UModal v-model:open="openEdit">

        <template #content>

            <div class="bg-box-gray p-5" :class="{ 'ar-dir': locale == 'ar' }">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Edit the question") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openEdit = !openEdit" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="editQus" :class="{ 'ar-dir': locale == ar }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-black font-bold! text-[14px]/8">
                            {{ $t("Edit title") }}
                        </div>
                        <input type="text" v-model="myData.question.ar" :placeholder="$t('Type question in arabic')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
                        <input type="text" v-model="myData.question.en" :placeholder="$t('Type question in english')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
                    </div>

                    <div class="flex flex-col gap-2 mb-4">
                        <div class="text-black font-bold! text-[14px]/8">
                            {{ $t("Edit the answer") }}
                        </div>
                        <input type="text" v-model="myData.answer.ar" :placeholder="$t('Type answer in arabic')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
                        <input type="text" v-model="myData.answer.en" :placeholder="$t('Type answer in english')"
                            class="bg-[#B9A779] rounded-xl py-2 px-4 w-full text-black text-[11px]/8" />
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


    <!-- modal for delete -->
    <UModal v-model:open="openDelete">

        <template #content>

            <div class="bg-box-gray p-5" :class="{ 'ar-dir': locale == 'ar' }">

                <div class="flex justify-between items-center pb-2 border-b border-dashed border-black mb-5">

                    <!-- title -->
                    <div class="text-black text-[16px]/8 font-bold!">
                        {{ $t("Delete the question") }}
                    </div>

                    <!-- close icon -->
                    <div>
                        <button @click="openDelete = !openDelete" class="cursor-pointer">
                            <UIcon class="size-10" name="i-heroicons-x-mark-solid" />
                        </button>
                    </div>

                </div>

                <form @submit.prevent="deleteQus" :class="{ 'ar-dir': locale == ar }">

                    <div class="flex flex-col gap-2 mb-5">
                        <div class="text-red-500 font-bold! text-[20px]/8 text-center">
                            {{ $t("Are you sure you want to delete the question?") }}
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

</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { locale, locales, setLocale, t } = useI18n();
const emit = defineEmits(['refresh'])

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});


const props = defineProps({
    myItem: {
        type: Object,
        required: true
    }
});

const myData = ref({
    question: "",
    answer: ""
});

onMounted(() => {
    myData.value = JSON.parse(JSON.stringify({
        question: props.myItem.question,
        answer: props.myItem.answer
    }));
});

const openEdit = ref(false);
const openDelete = ref(false);

function openEditModal() {
    myData.value = JSON.parse(JSON.stringify({
        question: props.myItem.question,
        answer: props.myItem.answer
    }));
    openEdit.value = true;
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

const stateDelete = ref({
    loading: false,
    error: false,
    success: false,
    msg: {
        en: "",
        ar: ""
    }
});

async function editQus() {

    stateEdit.value.loading = true;
    stateEdit.value.error = false;
    stateEdit.value.success = false;
    stateEdit.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/faqs/update/${props.myItem._id}`;

    const data = {
        question: {
            ar: myData.value.question.ar,
            en: myData.value.question.en
        },
        answer: {
            ar: myData.value.answer.ar,
            en: myData.value.answer.en
        }
    }

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

        openEdit.value = false;
        setTimeout(() => {
            emit('refresh');
        }, 1);
    }
    catch (error) {
        stateEdit.value.loading = false;
        stateEdit.value.error = true;
        stateEdit.value.success = false;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized" || errorMessage == "Forbidden") {
            store.updateToken(null);
            router.push("/login");
        }

        stateEdit.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

async function deleteQus() {

    stateDelete.value.loading = true;
    stateDelete.value.error = false;
    stateDelete.value.success = false;
    stateDelete.value.msg = {
        en: "",
        ar: "",
    };

    const token = store.getToken;
    const apiUrl = `${BASE_URL}/faqs/delete/${props.myItem._id}`;

    try {
        const response = await axios.delete(apiUrl, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

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

        openDelete.value = false;
        setTimeout(() => {
            emit('refresh');
        }, 1);
    }
    catch (error) {
        stateDelete.value.loading = false;
        stateDelete.value.error = true;
        stateDelete.value.success = false;

        const errorMessage = handelErrorType(error);
        if (errorMessage == "Unauthorized" || errorMessage == "Forbidden") {
            store.updateToken(null);
            router.push("/login");
        }

        stateDelete.value.msg = {
            ar: errorMessage,
            en: errorMessage
        };
    }
}

watch(
    () => { openEdit.value },
    () => {
        myData.value = {
            question: props.myItem.question,
            answer: props.myItem.answer
        };
    }
)

</script>