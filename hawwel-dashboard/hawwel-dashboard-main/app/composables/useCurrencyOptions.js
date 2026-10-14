// Both the dedicated Payment Methods page and the embedded "add payment
// method" section on the Countries & Cities page need the same list of
// active fiat currencies for their currency dropdown - this used to be
// fetched and shaped identically in both places.
export const useCurrencyOptions = () => {
    const { axios, store, BASE_URL } = useUtils();

    const currencyOptions = ref([]);
    const loading = ref(false);

    async function refresh() {
        loading.value = true;
        const token = store.getToken;
        try {
            const response = await axios.get(`${BASE_URL}/currencies/all`, {
                headers: { 'Authorization': `Bearer ${token}` },
            });
            currencyOptions.value = response.data.error ? [] : (response.data.data || []);
        } catch (_) {
            currencyOptions.value = [];
        } finally {
            loading.value = false;
        }
    }

    onMounted(refresh);

    return { currencyOptions, loading, refresh };
};
