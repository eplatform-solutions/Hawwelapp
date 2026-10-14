// The backend's error responses carry msg as a bilingual { ar, en }
// object (see getSuitableTranslations server-side). Every caller here
// used to forward that object straight through as if it were a string,
// which every page then wrapped in another { ar, en } object and handed
// to <UseToast :body>, a String prop - rendering as "[object Object]"
// instead of the actual message.
function extractLocalizedMessage(msg, locale) {
    if (msg && typeof msg === "object") {
        return (locale === "ar" ? msg.ar : msg.en) || msg.en || msg.ar || "";
    }
    return String(msg ?? "");
}

export const useHandelError = () => {
    const { locale } = useI18n();

    const handelErrorType = (error) => {
        // console.log(error);
        if (error.response) {
            if (error.response.status == 400) {
                return extractLocalizedMessage(error.response.data?.msg, locale.value);
            }
            if (error.response.status == 401) {
                return "Unauthorized";
            }
            else if (error.response.status == 403) {
                return "Forbidden";
            }
            else if (error.response.status == 404) {
                return "Data Not Found";
            }
            else if (error.response.status == 429) {
                return "Too Many Requestes";
            }
            else if (error.response.status >= 500) {
                return "Server out";
            }
            else {
                return extractLocalizedMessage(error.response.data?.msg, locale.value);
            }
        } else if (error.request) {
            // console.log('Request Error:', error.request);
            return "Bad network, check your internet";
        } else {
            // console.log('Error:', error.message);
            return "Something went wrong";
        }
    }

    return {
        handelErrorType,
    }
}