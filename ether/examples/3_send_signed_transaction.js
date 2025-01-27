const { ethers } = require("ethers");
const privateKey1 = '0x4d85a7345e07998b4bf9a81e67a4af98160e87abfb98c9d1e614fa56271a658e';

const provider = new ethers.providers.JsonRpcProvider(`https://sepolia.infura.io/v3/8b1caa7cf4d34341a66b199e6632d2f9`);

const account1 = '0xF922B9AF45a062DD19EF16b74Ff9d0b6E616EE34'; 
const account2 = '0xEb31f3f7390485D6BCbd7764834D053B51eb35DF';

const wallet = new ethers.Wallet(privateKey1, provider);

const main = async () => {
    try {
        if (wallet.address.toLowerCase() !== account1.toLowerCase()) {
            throw new Error(`Private key does not correspond to account1. Derived address: ${wallet.address}`);
        }

        const senderBalanceBefore = await provider.getBalance(account1);
        const receiverBalanceBefore = await provider.getBalance(account2);

        console.log(`\nSender balance before: ${ethers.utils.formatEther(senderBalanceBefore)} ETH`);
        console.log(`Receiver balance before: ${ethers.utils.formatEther(receiverBalanceBefore)} ETH\n`);

        // Check if sender has enough balance
        const amount = ethers.utils.parseEther("0.025");
        const gasPrice = await provider.getGasPrice();
        const estimatedGasLimit = 21000; // Standard gas limit for ETH transfer
        const totalCost = amount.add(gasPrice.mul(estimatedGasLimit));

        if (senderBalanceBefore.lt(totalCost)) {
            throw new Error(`Insufficient balance. Required: ${ethers.utils.formatEther(totalCost)} ETH, Available: ${ethers.utils.formatEther(senderBalanceBefore)} ETH`);
        }

        const tx = await wallet.sendTransaction({
            to: account2,
            value: amount,
            gasLimit: estimatedGasLimit,
            gasPrice: gasPrice
        });

        console.log("Transaction sent. Waiting for confirmation...");
        await tx.wait();
        console.log("Transaction confirmed:", tx);

        const senderBalanceAfter = await provider.getBalance(account1);
        const receiverBalanceAfter = await provider.getBalance(account2);

        console.log(`\nSender balance after: ${ethers.utils.formatEther(senderBalanceAfter)} ETH`);
        console.log(`Receiver balance after: ${ethers.utils.formatEther(receiverBalanceAfter)} ETH\n`);
    } catch (error) {
        console.error("An error occurred:", error);
    }
};

main();
