import { useDataStore } from "../../stores/data";

// Re-syncs the current admin's permissions from the server on every fresh
// app boot (hard refresh / new tab), not just at login - so if a super
// admin changes someone's role while they're already logged in elsewhere,
// the sidebar reflects it the next time that tab is reloaded.
export default defineNuxtPlugin(async () => {
  const store = useDataStore();
  if (!store.getToken || store.getIsEmployee) return;

  const { syncPermissions } = usePermissions();
  await syncPermissions();
});
