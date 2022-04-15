/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require("@nomiclabs/hardhat-waffle");
 require("@nomiclabs/hardhat-ethers");
 require("@nomiclabs/hardhat-truffle5");
 require("@nomiclabs/hardhat-etherscan");
 require("hardhat-deploy");
 
 require("dotenv").config();
 
 const MAINNET_RPC_URL = process.env.MAINNET_RPC_URL;
 const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL;
 const MNEMONIC = process.env.MNEMONIC;
 const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
 
 module.exports = {
   defaultNetwork: "rinkeby",
   networks: {
     hardhat: {
       forking: {
         url: MAINNET_RPC_URL,
         accounts: {
           mnemonic: MNEMONIC,
         },
         saveDeployments: true,
       },
     },
     rinkeby: {
       url: RINKEBY_RPC_URL,
       accounts: {
         mnemonic: MNEMONIC,
       },
       saveDeployments: true,
     },
   },
   solidity: {
     version: "0.8.7",
     settings: {
       optimizer: {
         enabled: true,
         runs: 200,
       },
     },
   },
   etherscan: {
     // Your API key for Etherscan
     // Obtain one at https://etherscan.io/
     apiKey: ETHERSCAN_API_KEY,
   },
   namedAccounts: {
     deployer: {
       default: 0, // here this will by default take the first account as deployer
       1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
     },
     feeCollector: {
       default: 1,
     },
   },
   paths: {
     sources: "./contracts",
     tests: "./test",
     cache: "./cache",
     artifacts: "./artifacts",
   },
   mocha: {
     timeout: 20000,
   },
 };