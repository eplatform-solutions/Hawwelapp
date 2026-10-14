const INITIAL_PERMISSIONS = [
    {
        codeName: "quick_control_managment",
        name: "Quick Control Managment",
        appLabel: "quick control"
    },
    {
        codeName: "overview_managment",
        name: "Overview Managment",
        appLabel: "overview"
    },
    {
        codeName: "roles_managment",
        name: "Roles Managment",
        appLabel: "roles"
    },
    {
        codeName: "users_managment",
        name: "Users Managment",
        appLabel: "users"
    },
    {
        codeName: "countries_and_cities_managment",
        name: "Countries And Cities Managment",
        appLabel: "countries and cities"
    },
    {
        codeName: "payment_methods_managment",
        name: "Payment Methods Managment",
        appLabel: "payment methods"
    },
    {
        codeName: "regions_managment",
        name: "Regions Managment",
        appLabel: "regions"
    },
    {
        codeName: "currencies_managment",
        name: "Currencies Managment",
        appLabel: "currencies"
    },
    {
        codeName: "transfers_managment",
        name: "Transfers Managment",
        appLabel: "transfers"
    },
    {
        codeName: "login_logs_managment",
        name: "Login Logs Managment",
        appLabel: "login logs"
    },
    {
        codeName: "accounting_managment",
        name: "Accounting Managment",
        appLabel: "accounting"
    },
    {
        codeName: "technical_support_managment",
        name: "Technical Support Managment",
        appLabel: "technical support"
    },
    {
        codeName: "blockchain_wallets_managment",
        name: "Blockchain Wallets Managment",
        appLabel: "blockchain wallets"
    },
    {
        codeName: "kycs_managment",
        name: "kycs Managment",
        appLabel: "kycs"
    },
    {
        codeName: "compliance_managment",
        name: "Compliance Managment",
        appLabel: "compliance"
    },
    {
        codeName: "employees_managment",
        name: "Employees Managment",
        appLabel: "employees"
    },
];

const INITIAL_PERMISSION_CODE_NAMES = INITIAL_PERMISSIONS.map((permission) => permission.codeName);

const INITIAL_PERMISSION_NAMES = INITIAL_PERMISSIONS.map((permission) => permission.name);

const INITIAL_PERMISSION_APP_LABELS = INITIAL_PERMISSIONS.map((permission) => permission.appLabel);

// "roles_managment" gates both role definitions AND admin account/role assignment
// (see repositories/admins/index.js), so granting or holding it is equivalent to
// full administrative control. Only a real Super Admin may grant it to a role or
// touch a role that already has it - a regular admin holding it must never be
// able to spread it further, or the permission ceiling check alone wouldn't stop
// self-escalation via a second, differently-named admin account.
const SUPER_ADMIN_ONLY_PERMISSIONS = ["roles_managment"];

module.exports = {
    INITIAL_PERMISSIONS,
    INITIAL_PERMISSION_CODE_NAMES,
    INITIAL_PERMISSION_NAMES,
    INITIAL_PERMISSION_APP_LABELS,
    SUPER_ADMIN_ONLY_PERMISSIONS
}