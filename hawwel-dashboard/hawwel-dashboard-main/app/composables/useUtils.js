import axios from "axios";
import { useDataStore } from "~/../stores/data.js";

export const useUtils = () => {
  // site data
  const store = useDataStore();

  // router
  const router = useRouter();

  // route
  const route = useRoute();

  const token = store.getToken;
  const authUser = ref(true);
  
  if (token == null) {
    authUser.value = false;
  }

  // Base url api
  const config = useRuntimeConfig();
  const BASE_URL = config.public.BASE_URL;
  const URL_FILES = config.public.URL_FILES;
  const CHAT_API_URL = config.public.CHAT_API_URL;

  return {
    axios,
    store,
    router,
    route,
    authUser,
    BASE_URL,
    URL_FILES,
    CHAT_API_URL
  };
};
