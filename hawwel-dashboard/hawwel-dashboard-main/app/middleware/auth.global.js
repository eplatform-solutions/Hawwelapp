import { useDataStore } from "../../stores/data";

// Reads the JWT's exp claim without verifying the signature (that's the
// backend's job) - just enough to catch an expired token proactively
// instead of letting the admin work in a page for a while and only finding
// out on their next API call, mid-edit, with no warning.
function isTokenExpired(token) {
  try {
    const payload = JSON.parse(atob(token.split(".")[1].replace(/-/g, "+").replace(/_/g, "/")));
    if (!payload?.exp) return false;
    return Date.now() >= payload.exp * 1000;
  } catch (e) {
    return false;
  }
}

export default defineNuxtRouteMiddleware(async (to, from) => {

  if (process.server) {
    return;
  }

  await nextTick();

  // admin data
  const authStore = useDataStore();

  let token = authStore.getToken;

  if (to.path.startsWith("/app-preview")) {
    return;
  }

  if (token != null && isTokenExpired(token)) {
    authStore.updateToken(null);
    token = null;
  }

  if (token != null) {
    // auth

    if (
      to.fullPath == "/login" ||
      to.fullPath == "/"
    ) {
      if (authStore.getIsEmployee) {
        return navigateTo("/employee-transfers");
      }
      const { getLandingPath } = usePermissions();
      return navigateTo(getLandingPath());
    }

    // The sidebar (MyNavbar/MySlideover) already hides tabs an admin has no
    // permission for, but that only ever controlled which links are shown -
    // nothing stopped an admin from typing a URL directly and reaching the
    // full CRUD UI for a page their role can't use, before the backend
    // rejects the first API call. Enforce the same nav-item -> permission
    // mapping here too, for every path that's actually a known admin page.
    if (!authStore.getIsEmployee && !authStore.getIsSuperAdmin) {
      const { hasPermission, getLandingPath } = usePermissions();
      const { adminItems, accountingItem, accountingChildren } = useNavItems();

      const matchedItem = adminItems.find(
        (item) => to.path === item.to || to.path.startsWith(item.to + "/")
      );
      const matchedAccounting =
        to.path === accountingItem.to || to.path.startsWith(accountingItem.to + "/")
          ? accountingItem
          : accountingChildren.find(
              (child) => to.path === child.path || to.path.startsWith(child.path + "/")
            )
          ? accountingItem
          : null;

      const requiredPermission = matchedItem?.permission || matchedAccounting?.permission;
      if (requiredPermission && !hasPermission(requiredPermission)) {
        return navigateTo(getLandingPath());
      }
    }
  } else {
    //  unAuth

    if (
      !(
        to.fullPath == "/login" ||
        to.fullPath == "/" 
      )
    ) {
      return navigateTo("/login");
    }
  }
});
