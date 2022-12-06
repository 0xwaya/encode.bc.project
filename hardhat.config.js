require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require('hardhat-deploy');

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  gasReporter: {
    currency: "USD",
  },
  networks: {
    goerli: {
      url: "https://goerli.infura.io/v3/5c9455ae8b8049adb216cee1b856dfce",
      accounts: [""] // private key
    }
  },
  namedAccounts: {
    account0: 0
  },
  etherscan: {
    apiKey: "5M7BDS1A5EIMV69HXVZS15EQM59ZS1YJI8"
  },
};