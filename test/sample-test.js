import { BigNumber } from "ethers";
import chai, { expect } from "chai";
import { Contract, Wallet, providers } from "ethers";
import { solidity, deployContract } from "ethereum-waffle";
import { ethers, waffle, network, deployments } from "hardhat";
import { Fixture } from "ethereum-waffle";

describe("A Sample Lottery", function () {

  before(async function () {

    [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

    // DEPLOY ALL THE CONTRACTS HERE, LIKE A WAFFLE FIXTURE, eg. -
    const myTokenContract = await (await ethers.getContractFactory("myToken")).attach("0x770Ff783e55BD7eEF84DBdADa32Ac3b87e3ffaCA");
    const swapperContract = await (await ethers.getContractFactory("singlePathSwapper")).attach("0x66f50d11192Dcb8041cCc79949868F83553aDa74");
    const vendorContract = await (await ethers.getContractFactory("tokenVendor")).attach("0x9d7e1d2A21216Cd40e1ccf4f78996e0B181dDCDe");
    const lotteryContract = await (await ethers.getContractFactory("simpleLottery")).attach("0xdfad69c8477b17fdd26dD902906C41198A0a7676");

  });


  describe("Token contract", function () {
    // it("Deployment should assign the total supply of tokens to the owner", async function () {
    //   const [owner] = await ethers.getSigners();

    //   const Token = await ethers.getContractFactory("myToken");

    //   const hardhatToken = await Token.deploy();

    //   const ownerBalance = await hardhatToken.balanceOf(owner.address);
    //   expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    // });
  });

  describe("Swapping contract", function () {
  });

  describe("Vendor contract", function () {
  });

  describe("Lottery contract", function () {
  });
});
