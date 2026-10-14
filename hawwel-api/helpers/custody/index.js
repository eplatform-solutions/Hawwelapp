// The custody seam.
//
// Where a client's funds land is the single fact that decides whether this
// platform is performing a licensed activity. Today the platform generates the
// key itself ("self"), which is custody of client crypto-assets and requires
// CASP authorisation under MiCA. Under an agency arrangement with a licensed
// custodian the deposit address belongs to the partner, we never see a private
// key, and the regulated act happens on their licence.
//
// Everything that differs between those two worlds is behind this interface so
// that signing a partner is an adapter implementation plus a config change,
// not a rewrite of the money path.
//
// A provider implements:
//
//   async createDepositAddresses({ userId, transferId, networks, currency })
//     -> [{ network, address, custodian, privateKey?, partnerReference? }]
//
// Select with CUSTODY_PROVIDER. Default is "self", i.e. today's behaviour.

const PROVIDER = String(process.env.CUSTODY_PROVIDER || "self").trim().toLowerCase();

function getCustodyProviderName() {
    return PROVIDER;
}

function isPartnerCustody() {
    return PROVIDER === "partner";
}

/**
 * Guard for startup and for the admin dashboard: report whether the configured
 * custody arrangement is one that requires us to hold a licence ourselves.
 *
 * Self-custody is not "broken" - it is simply the arrangement that carries the
 * authorisation requirement, and saying so plainly here keeps the fact visible
 * to whoever reads the config next.
 */
function describeCustodyPosture() {
    if (isPartnerCustody()) {
        return {
            provider: "partner",
            holdsClientFunds: false,
            note: "Deposit addresses are issued by the licensed custodian; no private keys are held by this platform.",
        };
    }
    return {
        provider: "self",
        holdsClientFunds: true,
        note: "This platform generates and stores the private keys for client deposit addresses, and sweeps balances to its own central wallet. That is custody and transfer of crypto-assets on behalf of clients, which requires CASP authorisation under MiCA.",
    };
}

/**
 * Partner adapter.
 *
 * Intentionally unimplemented: the request/response shape is defined by
 * whichever licensed custodian is signed, and guessing it would produce code
 * that looks finished but silently mis-maps their fields. Implement against
 * the partner's real API documentation, return the shape above, and store no
 * private key.
 */
async function createDepositAddressesWithPartner() {
    throw new Error(
        "CUSTODY_PROVIDER=partner is selected but no partner adapter is implemented. " +
        "Implement createDepositAddressesWithPartner() against the custodian's API before enabling it."
    );
}

module.exports = {
    getCustodyProviderName,
    isPartnerCustody,
    describeCustodyPosture,
    createDepositAddressesWithPartner,
};
