import { defineStore } from "pinia";

export const useDataStore = defineStore("dashboradData", {
  state: () => {
    return {
      // all these properties will have their type inferred automatically
      token: null,
      language: "en",
      isEmployee: false,
      permissions: [],
      isSuperAdmin: false,
    };
  },
  getters: {
    getToken() {
      return this.token;
    },
    getLanguage() {
      return ["en", "ar"].includes(this.language) ? this.language : "en";
    },
    getIsEmployee() {
      return this.isEmployee;
    },
    getPermissions() {
      return this.permissions;
    },
    getIsSuperAdmin() {
      return this.isSuperAdmin;
    },
  },
  actions: {
    updateToken(newToken) {
      this.token = newToken;
    },
    updateLanguage(newLanguage) {
      this.language = ["en", "ar"].includes(newLanguage) ? newLanguage : "en";
    },
    updateIsEmployee(value) {
      this.isEmployee = !!value;
    },
    updatePermissions(permissions, isSuperAdmin) {
      this.permissions = Array.isArray(permissions) ? permissions : [];
      this.isSuperAdmin = !!isSuperAdmin;
    },
  },
  persist: {
    storage: piniaPluginPersistedstate.localStorage(),
  },
});
