const SUPPORTED_NETWORKS = [
    "MATIC",
    "BSC",
];

const SUPPORTED_NETWORKS_IN_TATUM = [
    "polygon-mainnet",
    "bsc-mainnet",
];

const TATUM_SUBSCRIPTION_TYPES = [
    "INCOMING_FUNGIBLE_TX"
];

const DEFAULT_TATUM_SUBSCRIPTION_TYPE = TATUM_SUBSCRIPTION_TYPES[0];

const CONTRACTS = require("./contracts");

const BLOCKCHAIN_WALLET_TYPES = ["central", "network-fee-funding"];

const DEFAULT_BLOCKCHAIN_WALLET_TYPE = BLOCKCHAIN_WALLET_TYPES[0];

// Who controls the private key for a deposit address. Today every address is
// "self": the platform generates and stores the key, which means the platform
// takes custody of client funds - a service that requires authorisation under
// MiCA. "partner" is the target arrangement, where a licensed custodian issues
// the address and holds the key, and we only ever read the reference.
const CUSTODIANS = ["self", "partner"];

const DEFAULT_CUSTODIAN = CUSTODIANS[0];

module.exports = {
    CUSTODIANS,
    DEFAULT_CUSTODIAN,
    SUPPORTED_NETWORKS,
    SUPPORTED_NETWORKS_IN_TATUM,
    TATUM_SUBSCRIPTION_TYPES,
    DEFAULT_TATUM_SUBSCRIPTION_TYPE,
    CONTRACTS,
    BLOCKCHAIN_WALLET_TYPES,
    DEFAULT_BLOCKCHAIN_WALLET_TYPE
}