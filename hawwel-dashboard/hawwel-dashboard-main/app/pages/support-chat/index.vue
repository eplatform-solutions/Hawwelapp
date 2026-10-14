<template>

    <div>

        <div class="lg:flex flex-container-fix" :class="{ 'flex-row-reverse': locale == 'en' }"
            style="display: -webkit-box !important;">

            <MyNavbar v-if="locale == 'en'"></MyNavbar>

            <div class="basis-full lg:basis-[85%] bg-main-color-page min-h-screen"
                :class="{ 'ar-dir': locale == 'ar' }">

                <HeaderPage />

                <div class="mx-5 mb-6">
                    <div class="text-black text-[16px]/8 sm:text-[22px]/9 font-black! text-center mb-4">
                        {{ $t('Support chat') }}
                    </div>

                    <div v-if="socketError" class="flex justify-center mb-4">
                        <div class="text-red-500 text-[12px]/5 sm:text-[14px]/7 font-bold!">
                            {{ $t('Connection lost - retrying...') }}
                        </div>
                    </div>

                    <div class="chat-shell">

                        <!-- ── Conversation list ─────────────────────────── -->
                        <div class="chat-list">
                            <div v-if="conversationsLoading" class="flex justify-center py-8">
                                <LoadingIcon />
                            </div>
                            <div v-else-if="conversationsError" class="flex flex-col items-center gap-3 py-8">
                                <div class="text-red-500 text-[12px]/5 font-bold!">
                                    {{ $t('Balance unavailable') }}
                                </div>
                                <button @click="getConversations()" class="brand-btn text-[12px]/5 px-4 cursor-pointer">
                                    {{ $t('Refresh') }}
                                </button>
                            </div>
                            <div v-else-if="conversations.length === 0" class="flex justify-center py-8 text-[13px]/6 font-bold! text-black/50">
                                {{ $t('No results found') }}
                            </div>
                            <button v-for="conv in conversations" :key="conv._id" @click="selectConversation(conv)"
                                class="chat-list-item" :class="{ 'chat-list-item--active': selectedConversation?._id === conv._id }">
                                <div class="flex items-center justify-between gap-2">
                                    <span class="chat-list-item__name">{{ customerDisplayName(conv) }}</span>
                                    <span v-if="conv.unreadByAdmin" class="chat-unread-dot"></span>
                                </div>
                                <div class="chat-list-item__preview">{{ conv.lastMessagePreview || '-' }}</div>
                                <div class="chat-list-item__time en-dir">{{ formatDateTime(conv.lastMessageAt || conv.createdAt) }}</div>
                            </button>
                        </div>

                        <!-- ── Thread ─────────────────────────────────────── -->
                        <div class="chat-thread">
                            <div v-if="!selectedConversation" class="flex items-center justify-center h-full text-[13px]/6 font-bold! text-black/40">
                                {{ $t('Select a conversation') }}
                            </div>
                            <template v-else>
                                <div class="chat-thread__header">
                                    <div class="text-black font-black! text-[14px]/6 sm:text-[16px]/7">
                                        {{ customerDisplayName(selectedConversation) }}
                                    </div>
                                    <div class="text-black/50 text-[11px]/5 en-dir">
                                        {{ selectedConversation.customer?.mobilePhone }}
                                    </div>
                                </div>

                                <div class="chat-thread__messages" ref="messagesEl">
                                    <div v-if="messagesLoading" class="flex justify-center py-8">
                                        <LoadingIcon />
                                    </div>
                                    <div v-for="msg in messages" :key="msg._id"
                                        class="chat-bubble-row" :class="{ 'chat-bubble-row--mine': msg.senderType === 'admin' }">
                                        <div class="chat-bubble" :class="msg.senderType === 'admin' ? 'chat-bubble--mine' : 'chat-bubble--theirs'">
                                            <div v-if="msg.senderType === 'admin' && msg.senderName" class="chat-bubble__sender">
                                                {{ msg.senderName }}
                                            </div>
                                            <div class="chat-bubble__body">{{ msg.body }}</div>
                                            <div class="chat-bubble__time en-dir">
                                                {{ formatTime(msg.createdAt) }}
                                                <!-- ✓ delivered / ✓✓ read by the customer (admin messages only) -->
                                                <span v-if="msg.senderType === 'admin'"
                                                    class="chat-bubble__ticks"
                                                    :class="{ 'chat-bubble__ticks--read': msg.readAt }"
                                                    :title="msg.readAt ? $t('Read') : $t('Delivered')">
                                                    {{ msg.readAt ? '✓✓' : '✓' }}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <form @submit.prevent="sendMessage" class="chat-thread__composer">
                                    <input v-model="messageInput" type="text" :placeholder="$t('Type a message')"
                                        class="chat-composer-input" :disabled="sending" />
                                    <button type="submit" :disabled="sending || !messageInput.trim()"
                                        class="brand-btn cursor-pointer px-5 disabled:opacity-50">
                                        {{ $t('Send') }}
                                    </button>
                                </form>
                            </template>
                        </div>

                    </div>
                </div>

            </div>

            <MyNavbar v-if="locale == 'ar'"></MyNavbar>

        </div>

    </div>

</template>

<script setup>
import { io } from "socket.io-client";

const { axios, store, CHAT_API_URL } = useUtils();
const { locale, setLocale } = useI18n();

onMounted(() => {
    setLocale(store.getLanguage);
    connectSocket();
    getConversations();
});

onUnmounted(() => {
    socketInstance?.disconnect();
});

const conversations = ref([]);
const conversationsLoading = ref(false);
const conversationsError = ref(false);
const socketError = ref(false);

const selectedConversation = ref(null);
const messages = ref([]);
const messagesLoading = ref(false);
const messageInput = ref("");
const sending = ref(false);
const messagesEl = ref(null);

let socketInstance = null;

// Chat lives on the customer-facing backend (hawwel-api), not this
// dashboard's own admin API - it's the only repo that talks to both the
// mobile app and (for this feature) the browser dashboard. CHAT_API_URL
// already points there.
function connectSocket() {
    const token = store.getToken;
    socketInstance = io(`${CHAT_API_URL}/chat/admin`, {
        auth: { token },
        transports: ["websocket"],
    });

    socketInstance.on("connect", () => { socketError.value = false; });
    socketInstance.on("connect_error", () => { socketError.value = true; });
    socketInstance.on("disconnect", () => { socketError.value = true; });

    socketInstance.on("message:new", (msg) => {
        if (selectedConversation.value && msg.conversation === selectedConversation.value._id) {
            messages.value.push(msg);
            scrollToBottom();
            if (msg.senderType === "customer") markRead();
        }
        getConversations(false);
    });

    socketInstance.on("conversation:updated", () => getConversations(false));

    // The customer opened the chat: every admin message they could have
    // seen is now read - flip ✓ to ✓✓ on the open thread.
    socketInstance.on("conversation:read", (payload) => {
        if (payload?.by !== "customer") return;
        if (!selectedConversation.value || payload.conversationId !== selectedConversation.value._id) return;
        const now = new Date().toISOString();
        messages.value.forEach((m) => {
            if (m.senderType === "admin" && !m.readAt) m.readAt = now;
        });
    });
}

async function getConversations(showLoading = true) {
    if (showLoading) conversationsLoading.value = true;
    conversationsError.value = false;
    try {
        const token = store.getToken;
        const response = await axios.get(`${CHAT_API_URL}/chat/conversations`, {
            headers: { Authorization: `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 50, language: locale.value },
        });
        if (response.data.error) {
            conversationsError.value = true;
            return;
        }
        conversations.value = response.data.data.conversations;
    }
    catch (error) {
        conversationsError.value = true;
    }
    finally {
        if (showLoading) conversationsLoading.value = false;
    }
}

async function selectConversation(conv) {
    selectedConversation.value = conv;
    messages.value = [];
    messagesLoading.value = true;

    socketInstance.emit("conversation:join", { conversationId: conv._id }, async (ack) => {
        if (ack?.error) {
            messagesLoading.value = false;
            return;
        }
        await loadHistory(conv._id);
        markRead();
        scrollToBottom();
    });
}

async function loadHistory(conversationId) {
    try {
        const token = store.getToken;
        const response = await axios.get(`${CHAT_API_URL}/chat/conversations/${conversationId}/messages`, {
            headers: { Authorization: `Bearer ${token}` },
            params: { pageNumber: 1, pageSize: 50, language: locale.value },
        });
        if (!response.data.error) messages.value = response.data.data.messages;
    }
    catch (error) {
        // Thread just stays empty; the retry is picking the conversation again.
    }
    finally {
        messagesLoading.value = false;
    }
}

function markRead() {
    if (!selectedConversation.value) return;
    socketInstance.emit("message:read", { conversationId: selectedConversation.value._id });
    const item = conversations.value.find((c) => c._id === selectedConversation.value._id);
    if (item) item.unreadByAdmin = false;
}

function sendMessage() {
    const body = messageInput.value.trim();
    if (!body || !selectedConversation.value) return;
    sending.value = true;
    socketInstance.emit("message:send", { conversationId: selectedConversation.value._id, body }, (ack) => {
        sending.value = false;
        if (!ack?.error) {
            messageInput.value = "";
        }
    });
}

function scrollToBottom() {
    nextTick(() => {
        if (messagesEl.value) messagesEl.value.scrollTop = messagesEl.value.scrollHeight;
    });
}

function customerDisplayName(conv) {
    const customer = conv?.customer;
    if (!customer) return "-";
    return customer.name || customer.mobilePhone || "-";
}

const formatDateTime = (value) => {
    if (!value) return "-";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return "-";
    const datePart = date.toLocaleDateString("en-CA");
    const timePart = date.toLocaleTimeString("en-GB", { hour: "2-digit", minute: "2-digit", hour12: false });
    return `${datePart} ${timePart}`;
};

const formatTime = (value) => {
    if (!value) return "-";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return "-";
    return date.toLocaleTimeString("en-GB", { hour: "2-digit", minute: "2-digit", hour12: false });
};
</script>
