const { Web3 } = require("web3");

const { ADDRESSES, APIS } = require("../../../constants/blockchain/contracts");

const { USDT_CONTRACT_ADDRESS_ON_POLYGON, USDT_CONTRACT_ADDRESS_ON_BSC, USDC_CONTRACT_ADDRESS_ON_POLYGON, USDC_CONTRACT_ADDRESS_ON_BSC } = ADDRESSES;

const { USDT_CONTRACT_ABI_ON_POLYGON, USDT_CONTRACT_ABI_ON_BSC, USDC_CONTRACT_ABI_ON_POLYGON, USDC_CONTRACT_ABI_ON_BSC } = APIS;

const BigNumber = require("bignumber.js")

function getNodeForNetwork(network) {
    if (network === "MATIC") {
        return new Web3(`${process.env.POLYGON_NODE_BASE_API_URL}/${process.env.POLYGON_NODE_API_KEY}`);
    }
    if (network === "BSC") {
        return new Web3(`${process.env.BINANCE_SMART_CHAIN_NODE_BASE_API_URL}`);
    }
    throw new Error("Sorry, Invalid Network Name !!");
}

function getTokenContract(network, token, web3) {
    if (network === "MATIC") {
        if (token === "USDT") return { contract: new web3.eth.Contract(USDT_CONTRACT_ABI_ON_POLYGON, USDT_CONTRACT_ADDRESS_ON_POLYGON), decimals: 6 };
        if (token === "USDC") return { contract: new web3.eth.Contract(USDC_CONTRACT_ABI_ON_POLYGON, USDC_CONTRACT_ADDRESS_ON_POLYGON), decimals: 6 };
    }
    if (network === "BSC") {
        if (token === "USDT") return { contract: new web3.eth.Contract(USDT_CONTRACT_ABI_ON_BSC, USDT_CONTRACT_ADDRESS_ON_BSC), decimals: 18 };
        if (token === "USDC") return { contract: new web3.eth.Contract(USDC_CONTRACT_ABI_ON_BSC, USDC_CONTRACT_ADDRESS_ON_BSC), decimals: 18 };
    }
    throw new Error("Sorry, Invalid Token Name !!");
}

// Read-only balance checks used by the failed-withdrawal reconciliation job
// to verify what's actually on-chain before retrying anything - never trust
// the stored withdrawStatus alone, since a "failed" step can still have
// landed on-chain after the app gave up waiting for its confirmation.
async function getTokenBalance(network, token, address) {
    const web3 = getNodeForNetwork(network);
    const { contract, decimals } = getTokenContract(network, token, web3);
    const rawBalance = await contract.methods.balanceOf(address).call();
    return new BigNumber(String(rawBalance)).dividedBy(new BigNumber(10 ** decimals)).toNumber();
}

async function getNativeBalance(network, address) {
    const web3 = getNodeForNetwork(network);
    const rawBalance = await web3.eth.getBalance(address);
    return Number(web3.utils.fromWei(rawBalance, "ether"));
}

async function sendMoneyOnBlockChain(network, token, senderAddress, receiverAddress, amount, senderPrivateKey) {
    try {
        if (network === "MATIC") {
            const web3 = new Web3(`${process.env.POLYGON_NODE_BASE_API_URL}/${process.env.POLYGON_NODE_API_KEY}`);
            const gasPriceInWei = await web3.eth.getGasPrice();
            switch (token) {
                case "MATIC": {
                    const signedTx = await web3.eth.accounts.signTransaction({
                        from: senderAddress,
                        to: receiverAddress,
                        value: web3.utils.toWei(String(amount), "ether"),
                        gasPrice: gasPriceInWei,
                        gas: 21000
                    }, senderPrivateKey);
                    const transactionResult = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
                    return {
                        msg: `Sending Money On Blockchain By Network: ${network}, token: ${token} Process Has Been Successfully !!`,
                        error: false,
                        data: transactionResult
                    }
                }
                case "USDT": {
                    let usdTContractObject = new web3.eth.Contract(USDT_CONTRACT_ABI_ON_POLYGON, USDT_CONTRACT_ADDRESS_ON_POLYGON);
                    if (!senderPrivateKey.startsWith("0x")) {
                        senderPrivateKey = "0x" + senderPrivateKey;
                    }
                    web3.eth.accounts.wallet.add(senderPrivateKey);
                    const tx = usdTContractObject.methods.transfer(receiverAddress, new BigNumber(String(amount)).multipliedBy(new BigNumber(10 ** 6)).toFixed());
                    await tx.call({
                        from: senderAddress,
                        gas: 100000,
                        gasPrice: gasPriceInWei
                    });
                    const transactionResult = await tx
                        .send({
                            from: senderAddress,
                            gas: 100000,
                            gasPrice: gasPriceInWei,
                        });
                    return {
                        msg: `Sending Money On Blockchain By Network: ${network}, token: ${token} Process Has Been Successfully !!`,
                        error: false,
                        data: transactionResult
                    }
                }
                case "USDC": {
                    let usdcTContractObject = new web3.eth.Contract(USDC_CONTRACT_ABI_ON_POLYGON, USDC_CONTRACT_ADDRESS_ON_POLYGON);
                    if (!senderPrivateKey.startsWith("0x")) {
                        senderPrivateKey = "0x" + senderPrivateKey;
                    }
                    web3.eth.accounts.wallet.add(senderPrivateKey);
                    const tx = usdcTContractObject.methods.transfer(receiverAddress, new BigNumber(String(amount)).multipliedBy(new BigNumber(10 ** 6)).toFixed());
                    await tx.call({
                        from: senderAddress,
                        gas: 100000,
                        gasPrice: gasPriceInWei
                    });
                    const transactionResult = await tx
                        .send({
                            from: senderAddress,
                            gas: 100000,
                            gasPrice: gasPriceInWei,
                        });
                    return {
                        msg: `Sending Money On Blockchain By Network: ${network}, token: ${token} Process Has Been Successfully !!`,
                        error: false,
                        data: transactionResult
                    }
                }
                default: {
                    return {
                        msg: "Sorry, Invalid Token Name !!",
                        error: true,
                        data: {}
                    }
                }
            }
        }
        if (network === "BSC") {
            const web3 = new Web3(`${process.env.BINANCE_SMART_CHAIN_NODE_BASE_API_URL}`);
            const gasPriceInWei = await web3.eth.getGasPrice();
            switch (token) {
                case "BNB": {
                    const signedTx = await web3.eth.accounts.signTransaction({
                        from: senderAddress,
                        to: receiverAddress,
                        value: web3.utils.toWei(String(amount), "ether"),
                        gasPrice: gasPriceInWei,
                        gas: 21000
                    }, senderPrivateKey);
                    const transactionResult = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
                    return {
                        msg: `Sending Money On Blockchain By Network: ${network}, token: ${token} Process Has Been Successfully !!`,
                        error: false,
                        data: transactionResult
                    }
                }
                case "USDT": {
                    let usdTContractObject = new web3.eth.Contract(USDT_CONTRACT_ABI_ON_BSC, USDT_CONTRACT_ADDRESS_ON_BSC);
                    if (!senderPrivateKey.startsWith("0x")) {
                        senderPrivateKey = "0x" + senderPrivateKey;
                    }
                    web3.eth.accounts.wallet.add(senderPrivateKey);
                    const tx = usdTContractObject.methods.transfer(receiverAddress, new BigNumber(String(amount)).multipliedBy(new BigNumber(10 ** 18)).toFixed());
                    await tx.call({
                        from: senderAddress,
                        gas: 100000,
                        gasPrice: gasPriceInWei
                    });
                    const transactionResult = await tx
                        .send({
                            from: senderAddress,
                            gas: 100000,
                            gasPrice: gasPriceInWei,
                        });
                    return {
                        msg: `Sending Money On Blockchain By Network: ${network}, token: ${token} Process Has Been Successfully !!`,
                        error: false,
                        data: transactionResult
                    }
                }
                case "USDC": {
                    let usdcTContractObject = new web3.eth.Contract(USDC_CONTRACT_ABI_ON_BSC, USDC_CONTRACT_ADDRESS_ON_BSC);
                    if (!senderPrivateKey.startsWith("0x")) {
                        senderPrivateKey = "0x" + senderPrivateKey;
                    }
                    web3.eth.accounts.wallet.add(senderPrivateKey);
                    const tx = usdcTContractObject.methods.transfer(receiverAddress, new BigNumber(String(amount)).multipliedBy(new BigNumber(10 ** 18)).toFixed());
                    await tx.call({
                        from: senderAddress,
                        gas: 100000,
                        gasPrice: gasPriceInWei
                    });
                    const transactionResult = await tx
                        .send({
                            from: senderAddress,
                            gas: 100000,
                            gasPrice: gasPriceInWei,
                        });
                    return {
                        msg: `Sending Money On Blockchain By Network: ${network}, token: ${token} Process Has Been Successfully !!`,
                        error: false,
                        data: transactionResult
                    }
                }
                default: {
                    return {
                        msg: "Sorry, Invalid Token Name !!",
                        error: true,
                        data: {}
                    }
                }
            }
        }
        return {
            msg: "Sorry, Invalid Network Name !!",
            error: true,
            data: {}
        }
    }
    catch (err) {
        throw Error(err);
    }
}

module.exports = {
    sendMoneyOnBlockChain,
    getTokenBalance,
    getNativeBalance,
}