import axios from "axios";
import { useDataStore } from "~/../stores/data.js";

export const usePermissions = () => {
  const store = useDataStore();

  function hasPermission(codeName) {
    if (!codeName) return true;
    if (store.getIsSuperAdmin) return true;
    return store.getPermissions.includes(codeName);
  }

  // The first nav item (in useNavItems' fixed order) this admin actually has
  // permission for - used as the post-login/redirect landing page instead of
  // a hardcoded route that may not apply to this admin's role.
  function getLandingPath() {
    if (store.getIsSuperAdmin) return "/quick-control";
    const { adminItems } = useNavItems();
    const firstAllowed = adminItems.find((item) => hasPermission(item.permission));
    return firstAllowed ? firstAllowed.to : "/quick-control";
  }

  // Fetches the current admin's own role/permissions and caches them in the
  // store, so the sidebar can hide tabs the admin has no access to. Safe to
  // call for employee accounts too - GET /admins/info simply won't find a
  // matching admin document and this resolves as a no-op.
  async function syncPermissions() {
    const token = store.getToken;
    if (!token) return;

    const config = useRuntimeConfig();
    const apiUrl = `${config.public.BASE_URL}/admins/info`;

    try {
      const response = await axios.get(apiUrl, {
        headers: { Authorization: `Bearer ${token}` },
      });
      if (response.data.error) return;
      const admin = response.data.data;
      store.updatePermissions(admin.permissions || [], admin.isSuperAdmin);
    } catch (error) {
      // Non-fatal: the sidebar simply keeps whatever permissions were
      // already cached (or shows none) until the next successful sync.
    }
  }

  return {
    hasPermission,
    getLandingPath,
    syncPermissions,
  };
};
