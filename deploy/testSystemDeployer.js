let { networkConfig } = require('../hardhat-helper-config')
require('dotenv').config()

const { expect } = require('chai');
const hre = require("hardhat");
const { BigNumber } = require('ethers');

module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId
}) => {

  const { deploy, log } = deployments
  const { deployer } = await ethers.getSigners()
  const chainId = await getChainId()
  // If we are on Rinkeby, we proceed with deployement!
  if (chainId == 4) {

    log("Rinkeby detected! Deploying contracts...")

    let SMALL_BALANCE = ethers.utils.parseUnits("1", 10);
    let MEDIUM_BALANCE = ethers.utils.parseUnits("5", 18);
    let GIANT_BALANCE = ethers.utils.parseUnits("10", 18);


    log("--------------------- Deploying My Token Contract ----------------------")

    const MyToken = await ethers.getContractFactory("myToken");
    const myToken = await MyToken.deploy();
    await myToken.deployed();
    
    log("--------------------- Deploying Mock WETH Contract ----------------------")

    const myWETH = await ethers.getContractAt("contracts/IERC20.sol:IERC20", networkConfig[chainId]["weth"]);;
    await myWETH.deployed();
    
    log("--------------------- Deploying Single Path Swapper ----------------------")

    const MockSwapper = await ethers.getContractFactory("singlePathSwapper");
    const mockSwapper = await MockSwapper.deploy(networkConfig[chainId]["swapRouter"], myToken.address);
    await mockSwapper.deployed();

    await myToken.approve(mockSwapper.address, GIANT_BALANCE);
    await myWETH.approve(mockSwapper.address, GIANT_BALANCE);

    log("--------------------- Deploying Token Vendor ----------------------")

    const MockVendor = await ethers.getContractFactory("Vendor");
    const mockVendor = await MockVendor.deploy(myToken.address, mockSwapper.address);
    await mockVendor.deployed();

    await myToken.approve(mockVendor.address, GIANT_BALANCE);
    await myWETH.approve(mockVendor.address, GIANT_BALANCE);

    await mockVendor.addTokensToWhitelist(myWETH.address);
    await mockVendor.loadContractWithEth(SMALL_BALANCE, {value: SMALL_BALANCE});

    log("--------------------- Deploying The Lottery Contract ----------------------")

    const MockLottery = await ethers.getContractFactory("simpleLottery");
    const mockLottery = await MockLottery.deploy(myToken.address, networkConfig[chainId]["vrfCoordinator"], networkConfig[chainId]["linkToken"], networkConfig[chainId]["fee"], networkConfig[chainId]["keyHash"]);
    await mockLottery.deployed();

    await myToken.approve(mockLottery.address, GIANT_BALANCE);

    log("--------------------- Setting up the lottery ----------------------")

    await mockLottery.startLottery(SMALL_BALANCE, {value: SMALL_BALANCE}); 

    log("--------------------- Just Checking Up To Here ----------------------")
        
    log("Approval Balance Now:\t" + GIANT_BALANCE);
    log("My Token Address:\t" + myToken.address);
    log("WETH deployed at:\t" + myWETH.address);

    log("Mock Swapper deployed at:\t" + mockSwapper.address);
    log("Token Vendor deployed at:\t" + mockVendor.address);
    log("Lottery Contract deployed at:\t" + mockLottery.address);

    log("Lottery is in a state of:\t" + await mockLottery.lottery_state());
    log("Total prize of:\t" + await mockLottery.awardAmount());
    log("Submit:\t" + await mockLottery.awardAmount() + "\t MTN Tokens to Play");
  
    log("Verify above addresses with: npx hardhat verify --network <network> DEPLOYED_CONTRACT_ADDRESS <'Constructor argument 1'>")

    log("--------------------- Yowza - everything is now set up ----------------------")

  }
}