const { post, delete: del } = require("axios");

const { USDT_CONTRACT_ADDRESSES, USDC_CONTRACT_ADDRESSES } = require("../../../constants/blockchain/contracts/addresses");

// Function to create a Tatum API subscription for blockchain networks and wallet operations tracking
async function createNewSubscriptionInTatumNotificationsService(eventType, address, chain) {
    try {
        const res = await post(`${process.env.TATUM_BASE_API_URL}/subscription?type=mainnet`, {
            type: eventType,
            attr: {
                address,
                chain,
                url: `${process.env.BASE_API_URL}/deposits/external`
            },
        }, {
            headers: {
                "Content-Type": "application/json",
                "x-api-key": process.env.TATUM_API_KEY
            }
        });
        return res.data.id;
    }
    catch (err) {
        throw Error(err);
    }
}

function getSuitableNetworkByTatum(chain) {
    switch (chain) {
        case "polygon-mainnet": return "MATIC";
        case "bsc-mainnet": return "BSC";
        default: return "chain-not-correct";
    }
}

function getSuitableCurrencyNameByTatum(contractAddress) {
    if (USDT_CONTRACT_ADDRESSES.includes(contractAddress)) {
        return "USDT";
    }
    else if (USDC_CONTRACT_ADDRESSES.includes(contractAddress)) {
        return "USDC";
    }
    else return null;
}

async function deleteTatumSubscription(subscriptionId) {
    try {
        await del(`${process.env.TATUM_BASE_API_URL}/subscription/${subscriptionId}?type=mainnet`, {
            headers: {
                "x-api-key": process.env.TATUM_API_KEY
            }
        });
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    createNewSubscriptionInTatumNotificationsService,
    getSuitableNetworkByTatum,
    getSuitableCurrencyNameByTatum,
    deleteTatumSubscription,
}