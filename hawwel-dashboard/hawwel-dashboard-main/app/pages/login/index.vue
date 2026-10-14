<template>

    <use-toast v-if="state.error" head="Failed" :body="locale == 'en' ? state.msg.en : state.msg.ar" color="error"
        icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateResent.error" head="Failed" :body="locale == 'en' ? stateResent.msg.en : stateResent.msg.ar"
        color="error" icon="i-heroicons-exclamation-circle-16-solid">
    </use-toast>

    <use-toast v-if="stateResent.success" head="Success"
        :body="locale == 'en' ? stateResent.msg.en : stateResent.msg.ar" color="success"
        icon="i-heroicons-check-badge-16-solid">
    </use-toast>

    <div v-if="!isAuth.loading">

        <div class="flex">

            <div class="basis-full bg-main-color-page min-h-screen" :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div class="flex justify-center pb-10">
                    <ClientOnly>
                        <form v-show="step == 1" @submit.prevent="login"
                            class="bg-[#B9A779] p-5 w-[95%] sm:w-5/6 md:w-3/4 lg:w-1/2">

                            <div class="text-center text-black font-bold! text-[20px]/5 sm:text-[25px]/10 mb-10">
                                {{ $t("Welcome back") }}
                            </div>

                            <div class="flex flex-col gap-2 mb-5">

                                <div class="text-black font-bold! text-[16px]/8">
                                    {{ $t("Email") }}
                                </div>

                                <div>
                                    <input v-model="loginData.email" type="email"
                                        class="px-2 py-1 rounded-xl bg-white w-full" />
                                </div>

                            </div>

                            <div class="flex flex-col gap-2 mb-10">

                                <div class="text-black font-bold! text-[16px]/8">
                                    {{ $t("Password") }}
                                </div>

                                <div class="relative">
                                    <input v-model="loginData.password" id="pass-input" type="password"
                                        class="px-2 py-1 rounded-xl bg-white w-full" />
                                    <button type="button" @click="switchIcon" class="absolute top-2 cursor-pointer"
                                        :class="{ 'left-2': locale == 'ar', 'right-2': locale == 'en' }">
                                        <UIcon v-if="isShowPass" id="pass-icon" name="i-heroicons-eye-slash-16-solid"
                                            class="size-5" />
                                        <UIcon v-else id="pass-icon" name="i-heroicons-eye-16-solid" class="size-5" />
                                    </button>
                                </div>

                            </div>

                            <div class="flex justify-center">
                                <UButton :loading="state.loading"
                                    :disabled="(state.loading) || (loginData.email == '' || loginData.password == '')"
                                    type="sumbit"
                                    class="bg-stone-500 disabled:bg-stone-500 hover:bg-stone-500 text-black font-bold! text-[14px]/8 px-5 py-1.5 border border-[#B9A779]/90 cursor-pointer">
                                    {{ $t("Login") }}
                                </UButton>
                            </div>

                        </form>

                        <form v-show="step == 2" @submit.prevent="loginVerification"
                            class="bg-[#B9A779] p-5 w-[95%] sm:w-5/6 md:w-3/4 lg:w-1/2">

                            <div class="flex flex-col gap-2 mb-5">

                                <div class="text-black font-bold! text-[16px]/8">
                                    {{ $t("Enter the code we sent you") }}
                                </div>

                                <div>
                                    <input v-model="verData.code" type="text"
                                        class="px-2 py-1 rounded-xl bg-white w-full" />
                                </div>

                                <div>
                                    <span class="text-black text-[14px]/5 font-bold! pe-2">
                                        {{ $t("didn't get code yet?") }}
                                    </span>
                                    <UButton type="button" @click="resentCode" :loading="stateResent.loading"
                                        :disabled="stateResent.loading"
                                        class="text-blue-700 underline text-[14px]/5 font-bold! cursor-pointer bg-transparent hover:bg-transparent">
                                        {{ $t("Resent code") }}
                                    </UButton>
                                </div>

                            </div>

                            <div class="flex justify-center">
                                <UButton :loading="stateVer.loading" :disabled="stateVer.loading" type="sumbit"
                                    class="bg-stone-500 disabled:bg-stone-500 hover:bg-stone-500 text-black font-bold! text-[14px]/8 px-5 py-1.5 border border-[#B9A779]/90 cursor-pointer">
                                    {{ $t("confirme") }}
                                </UButton>
                            </div>
                        </form>
                    </ClientOnly>
                </div>

            </div>

        </div>

    </div>

    <div v-else>
    </div>

</template>

<script setup>
const { /* variables */ axios, router, route, store, authUser, BASE_URL } = useUtils();
const { /* functions */ handelErrorType } = useHandelError();
const { syncPermissions, getLandingPath } = usePermissions();
const { locale, locales, setLocale, t } = useI18n();

const isAuth = ref({
    loading: true,
    value: false
});

onBeforeRouteUpdate(() => {
    const token = store.getToken;
    if (token != null) {
        return navigateTo("/quick-control");
    }
    else {
        isAuth.value = false;
    }
});

onBeforeMount(() => {
    const token = store.getToken;
    if (token != null) {
        return navigateTo("/quick-control");
    }
    else {
        isAuth.value = false;
    }
});

onMounted(() => {
    let myLan = store.getLanguage;
    setLocale(myLan);
});

const loginData = ref({
    email: "",
    password: ""
});

const verData = ref({
    session: "",
    code: ""
});

const myToken = ref(store.getToken);

const toast = useToast();
const value = ref(true);

const state = ref({
    loading: false,
    success: false,
    error: false,
    msg: {
        ar: "",
        en: "",
    }
});

const stateResent = ref({
    loading: false,
    success: false,
    error: false,
    msg: {
        ar: "",
        en: "",
    }
});

const stateVer = ref({
    loading: false,
    success: false,
    error: false,
    msg: {
        ar: "",
        en: "",
    }
});

const step = ref(1);

const isShowPass = ref(false);

function switchIcon() {
    let inputEle = document.getElementById("pass-input");

    if (inputEle.type == 'password') {
        inputEle.type = "text";
        isShowPass.value = true;
    }
    else {
        inputEle.type = "password";
        isShowPass.value = false;
    }
}

async function resentCode() {

    // Change state loading to loading
    stateResent.value.loading = true;

    // clean status for new request
    stateResent.value.error = false;
    stateResent.value.success = false;
    stateResent.value.msg = "";

    const apiUrl = `${BASE_URL}/verification-codes/send`;

    const data = {
        email: loginData.value.email,
        typeOfUse: "login"
    }

    try {
        const response = await axios.post(apiUrl, data, {});

        // opreation failed
        if (response.data.error) {
            stateResent.value.loading = false;
            stateResent.value.error = true;
            stateResent.value.success = false;
            stateResent.value.msg = {
                ar: response.data.msg.ar,
                en: response.data.msg.en,
            }
        }

        // opreation succeeded
        else {
            stateResent.value.loading = false;
            stateResent.value.error = false;
            stateResent.value.success = true;
            stateResent.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
        }
    }
    catch (error) {
        stateResent.value.loading = false;
        stateResent.value.error = true;
        stateResent.value.success = false;

        const errorMessage = handelErrorType(error);
        stateResent.value.msg = {
            en: errorMessage,
            ar: errorMessage
        }
    }
}

async function login() {
    // store.updateToken("any thing");

    // Change state loading to loading
    state.value.loading = true;

    // clean status for new request
    state.value.error = false;
    state.value.success = false;
    state.value.msg = "";

    const apiUrl = `${BASE_URL}/auth/login`;

    const data = {
        email: loginData.value.email,
        password: loginData.value.password
    }

    try {
        const response = await axios.post(apiUrl, data, {});

        // opreation succeeded
        state.value.loading = false;
        state.value.success = true;
        state.value.msg = {
            en: response.data.msg.en,
            ar: response.data.msg.ar
        }

        if (response.data.data?.token) {
            store.updateToken(response.data.data.token);
            const tokenPayload = JSON.parse(atob(response.data.data.token.split('.')[1]));
            const isEmp = !!tokenPayload.isEmployee;
            store.updateIsEmployee(isEmp);
            if (!isEmp) {
                await syncPermissions();
            }
            toast.add({
                title: locale.value == 'en' ? `Login Complete` : `تم تسجيل الدخول بنجاح`,
                description: locale.value == 'en' ? state.value.msg.en : state.value.msg.ar,
                icon: "i-heroicons-check-badge-20-solid",
                color: "success"
            });
            router.push(isEmp ? "/employee-transfers" : getLandingPath());
            return;
        }

        verData.value.session = response.data.data.session;
        if (state.value.msg.en == "Sorry, Can't Login Now, Beacause You Activate 2FA !!") {
            step.value = 2;
            toast.add({
                title: locale.value == 'en' ? `Complete the login process` : `اكمل عملية تسجيل الدخول`,
                description: locale.value == 'en' ? state.value.msg.en : state.value.msg.ar,
            });
        }
        else {
            toast.add({
                title: locale.value == 'en' ? `Error` : `خطأ`,
                description: locale.value == 'en' ? state.value.msg.en : state.value.msg.ar,
            });
        }
    }
    catch (error) {
        state.value.loading = false;
        state.value.error = true;

        const errorMessage = handelErrorType(error);
        state.value.msg = {
            en: errorMessage,
            ar: errorMessage
        }
    }
}

async function loginVerification() {

    if (verData.value.code.toString().length != 4) {
        toast.add({
            title: locale.value == 'en' ? `Error` : `خطأ`,
            description: locale.value == 'en' ? 'Code must be 4 digits' : 'يجب أن يتكون الرمز من 4 أرقام',
            icon: 'i-heroicons-x-circle-16-solid',
            color: "error"
        });
        return;
    }

    // Change state loading to loading
    stateVer.value.loading = true;

    // clean status for new request
    stateVer.value.error = false;
    stateVer.value.success = false;
    stateVer.value.msg = "";

    const apiUrl = `${BASE_URL}/verification-codes/verify`;

    const data = {
        session: verData.value.session,
        code: `${verData.value.code}`
    }

    try {
        const response = await axios.post(apiUrl, data, {});

        // opreation succeeded
        stateVer.value.loading = false;
        if (!response.data.error) {
            stateVer.value.success = true;
            stateVer.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
            store.updateToken(response.data.data.token);
            const tokenPayloadVer = JSON.parse(atob(response.data.data.token.split('.')[1]));
            const isEmpVer = !!tokenPayloadVer.isEmployee;
            store.updateIsEmployee(isEmpVer);
            if (!isEmpVer) {
                await syncPermissions();
            }
            toast.add({
                title: locale.value == 'en' ? `Login Complete` : `تم تسجيل الدخول بنجاح`,
                description: locale.value == 'en' ? stateVer.value.msg.en : stateVer.value.msg.ar,
                icon: "i-heroicons-check-badge-20-solid",
                color: "success"
            });
            router.push(isEmpVer ? "/employee-transfers" : getLandingPath());
        }
        else {
            stateVer.value.success = false;
            stateVer.value.msg = {
                en: response.data.msg.en,
                ar: response.data.msg.ar
            }
            store.updateToken(response.data.data.token);
            toast.add({
                title: locale.value == 'en' ? `Login failed` : `فشل تسجيل الدخول`,
                description: locale.value == 'en' ? stateVer.value.msg.en : stateVer.value.msg.ar,
                icon: 'i-heroicons-x-circle-16-solid',
                color: "error"
            });
        }
    }
    catch (error) {
        stateVer.value.loading = false;
        stateVer.value.error = true;

        const errorMessage = handelErrorType(error);
        stateVer.value.msg = {
            en: errorMessage,
            ar: errorMessage
        }
    }
}

</script>