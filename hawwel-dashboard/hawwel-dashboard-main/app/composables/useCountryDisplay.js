// Every page that lists countries/cities needs to turn a stored ISO2 code
// back into a display name/flag. vue-tel-input already ships that lookup
// table, so this composable mounts one hidden instance and exposes a
// getCountryByCode(code) helper instead of every page repeating the same
// hidden-input + countriesList wiring.
export const useCountryDisplay = () => {
    const telInputRef = ref(null);
    const countriesList = ref([]);

    function initCountriesList() {
        countriesList.value = telInputRef.value?.$props?.allCountries || [];
    }

    function getCountryByCode(code) {
        return countriesList.value.find((country) => country.iso2 === code);
    }

    return {
        telInputRef,
        countriesList,
        initCountriesList,
        getCountryByCode,
    };
};
