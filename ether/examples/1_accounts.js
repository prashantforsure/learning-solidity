const { ethers } = require("ethers");

const provider = new ethers.providers.JsonRpcProvider(`https://sepolia.infura.io/v3/8b1caa7cf4d34341a66b199e6632d2f9`)

const address = '0xF922B9AF45a062DD19EF16b74Ff9d0b6E616EE34'

const main = async () => {
    const balance = await provider.getBalance(address)
    console.log(`\nETH Balance of ${address} --> ${ethers.utils.formatEther(balance)} ETH\n`)
}

main()