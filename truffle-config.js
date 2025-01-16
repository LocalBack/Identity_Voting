require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    sepolia: {
      provider: () => {
        if (!process.env.MNEMONIC || !process.env.ALCHEMY_API_URL) {
          throw new Error('Please set your MNEMONIC and ALCHEMY_API_URL in a .env file');
        }
        return new HDWalletProvider({
          mnemonic: {
            phrase: process.env.MNEMONIC
          },
          providerOrUrl: process.env.ALCHEMY_API_URL,
          pollingInterval: 30000,
          networkCheckTimeout: 120000,
          timeoutBlocks: 500
        });
      },
      network_id: 11155111,
      gas: 3000000,
      maxFeePerGas: 15000000000, // 15 gwei
      maxPriorityFeePerGas: 2000000000, // 2 gwei
      confirmations: 2,
      timeoutBlocks: 500,
      skipDryRun: false
    }
  },
  compilers: {
    solc: {
      version: "0.8.17",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  },
  plugins: ['@truffle/plugin-verify'],

  api_keys: {

    etherscan: process.env.ETHERSCAN_API_KEY
  }
};