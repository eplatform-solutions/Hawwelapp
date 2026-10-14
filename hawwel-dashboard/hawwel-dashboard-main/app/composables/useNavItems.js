// Single source of truth for the dashboard sidebar/menu items, shared by
// MyNavbar.vue (desktop) and MySlideover.vue (mobile) so both always show
// the exact same set of tabs. `permission` is the codeName enforced by the
// matching page's own API calls on the backend (see helpers/permissions
// `authorizeAdmin` in hawwel-admin-api) - a tab with no `permission`
// value is always visible to any authenticated admin.
export const useNavItems = () => {
  const adminItems = [
    { to: "/quick-control", label: "quickControl", icon: "i-heroicons-bolt-16-solid", permission: "quick_control_managment" },
    { to: "/app-visual-identity", label: "App visual identity", icon: "i-heroicons-swatch-16-solid", permission: "quick_control_managment" },
    { to: "/currencies", label: "currencies", icon: "i-heroicons-banknotes-16-solid", permission: "currencies_managment" },
    { to: "/overview", label: "overview", icon: "i-heroicons-chart-bar-16-solid", permission: "quick_control_managment" },
    { to: "/roles", label: "roles", icon: "i-heroicons-shield-check-16-solid", permission: "roles_managment" },
    { to: "/admins", label: "admins", icon: "i-heroicons-identification-16-solid", permission: "roles_managment" },
    { to: "/employees", label: "employees", icon: "i-heroicons-briefcase-16-solid", permission: "employees_managment" },
    { to: "/users", label: "users", icon: "i-heroicons-users-16-solid", permission: "users_managment" },
    { to: "/quick-setup", label: "quickSetup", icon: "i-heroicons-rocket-launch-16-solid", permission: "countries_and_cities_managment" },
    { to: "/countries-and-cites", label: "countriesAndCities", icon: "i-heroicons-globe-alt-16-solid", permission: "countries_and_cities_managment" },
    { to: "/payment-methods", label: "paymentMethods", icon: "i-heroicons-credit-card-16-solid", permission: "payment_methods_managment" },
    { to: "/regions", label: "regions", icon: "i-heroicons-map-16-solid", permission: "regions_managment" },
    { to: "/remittances", label: "remittances", icon: "i-heroicons-arrows-right-left-16-solid", permission: "transfers_managment" },
    { to: "/log", label: "log", icon: "i-heroicons-clipboard-document-list-16-solid", permission: "login_logs_managment" },
    { to: "/technical-support", label: "technicalSupport", icon: "i-heroicons-wrench-screwdriver-16-solid", permission: "technical_support_managment" },
    { to: "/wallets-management", label: "Wallets management", icon: "i-heroicons-wallet-16-solid", permission: "blockchain_wallets_managment" },
    { to: "/kycs", label: "Kycs", icon: "i-heroicons-check-badge-16-solid", permission: "kycs_managment" },
    { to: "/compliance", label: "Compliance", icon: "i-heroicons-shield-exclamation-16-solid", permission: "compliance_managment" },
    { to: "/support-chat", label: "Support chat", icon: "i-heroicons-chat-bubble-left-right-16-solid" },
  ];

  const accountingItem = {
    to: "/accounting",
    label: "accounting",
    icon: "i-heroicons-calculator-16-solid",
    permission: "accounting_managment",
  };

  const accountingChildren = [
    { path: "/accounting/daily-restrictions", label: "dailyRestrictions" },
    { path: "/accounting/accounting-restrictions", label: "accountingRestrictions" },
    { path: "/accounting/financial-constraints", label: "financialConstraints" },
  ];

  const employeeItems = [
    { to: "/employee-transfers", label: "Employee transfers", icon: "i-heroicons-arrows-right-left-16-solid" },
  ];

  return {
    adminItems,
    accountingItem,
    accountingChildren,
    employeeItems,
  };
};
