const { Web3 } = require("web3");

const { CONTRACTS } = require("../../../constants/blockchain");

const { ADDRESSES, APIS } = CONTRACTS;

const { USDT_CONTRACT_ADDRESS_ON_POLYGON, USDT_CONTRACT_ADDRESS_ON_BSC, USDC_CONTRACT_ADDRESS_ON_POLYGON, USDC_CONTRACT_ADDRESS_ON_BSC } = ADDRESSES;

const { USDT_CONTRACT_ABI_ON_POLYGON, USDT_CONTRACT_ABI_ON_BSC, USDC_CONTRACT_ABI_ON_POLYGON, USDC_CONTRACT_ABI_ON_BSC } = APIS;

// This repo (unlike dasco-backend) never signs or sends blockchain
// transactions - these are read-only balance lookups for the admin
// dashboard, so a public RPC endpoint is an acceptable default. An env
// override is still honored for anyone who wants a dedicated node.
function getNodeForNetwork(network) {
    if (network === "MATIC") {
        return new Web3(process.env.POLYGON_RPC_URL || "https://polygon-bor-rpc.publicnode.com");
    }
    if (network === "BSC") {
        return new Web3(process.env.BSC_RPC_URL || "https://bsc-rpc.publicnode.com");
    }
    throw new Error("Sorry, Invalid Network Name !!");
}

function getTokenContract(network, symbol, web3) {
    if (network === "MATIC") {
        if (symbol === "USDT") return { contract: new web3.eth.Contract(USDT_CONTRACT_ABI_ON_POLYGON, USDT_CONTRACT_ADDRESS_ON_POLYGON), decimals: 6 };
        if (symbol === "USDC") return { contract: new web3.eth.Contract(USDC_CONTRACT_ABI_ON_POLYGON, USDC_CONTRACT_ADDRESS_ON_POLYGON), decimals: 6 };
    }
    if (network === "BSC") {
        if (symbol === "USDT") return { contract: new web3.eth.Contract(USDT_CONTRACT_ABI_ON_BSC, USDT_CONTRACT_ADDRESS_ON_BSC), decimals: 18 };
        if (symbol === "USDC") return { contract: new web3.eth.Contract(USDC_CONTRACT_ABI_ON_BSC, USDC_CONTRACT_ADDRESS_ON_BSC), decimals: 18 };
    }
    throw new Error("Sorry, Invalid Token Symbol !!");
}

async function getTokenBalance(network, symbol, address) {
    const web3 = getNodeForNetwork(network);
    const { contract, decimals } = getTokenContract(network, symbol, web3);
    const rawBalance = await contract.methods.balanceOf(address).call();
    return Number(rawBalance) / 10 ** decimals;
}

async function getNativeBalance(network, address) {
    const web3 = getNodeForNetwork(network);
    const rawBalance = await web3.eth.getBalance(address);
    return Number(web3.utils.fromWei(rawBalance, "ether"));
}

module.exports = {
    getTokenBalance,
    getNativeBalance,
};
