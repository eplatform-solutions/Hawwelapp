// Central switch for features that are hidden from the UI on purpose but
// kept in the codebase so they can be turned back on with a single flag
// flip instead of re-writing the screens. Every email-related UI element
// (profile email field, email as a 2FA/reset-password channel, etc.) is
// gated behind this flag even though the backend it talks to already
// works - the decision to hide it was a product one, not a readiness one.
const bool kEmailFeaturesEnabled = false;
