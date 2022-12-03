require('dotenv').config();
require('@nomiclabs/hardhat-waffle');

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.9',
  networks: {
    polygon_mainnet: {
      url: 'https://polygon-rpc.com/',
      chainId: 137,
      confirmations: 3,
      gasLimit: 120000000,
      accounts: [process.env.PPK],
    },
    polygon_testnet: {
      url: 'https://matic-mumbai.chainstacklabs.com',
      chainId: 80001,
      accounts: [process.env.PPK],
    },
  },
  etherscan: {
    apiKey: process.env['BSC_API_KEY'],
  },
};
