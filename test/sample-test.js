import { BigNumber } from "ethers";
import chai, { expect } from "chai";
import { Contract, Wallet, providers } from "ethers";
import { solidity, deployContract } from "ethereum-waffle";
import { ethers, waffle, network, deployments } from "hardhat";
import { Fixture } from "ethereum-waffle";

describe("A Sample Lottery", function () {

  before(async function () {

    Token = await ethers.getContractFactory("Token");
    [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

    // DEPLOY ALL THE CONTRACTS HERE, LIKE DEPLOY FILE 
  });


  describe("Token contract", function () {
    it("Deployment should assign the total supply of tokens to the owner", async function () {
      const [owner] = await ethers.getSigners();

      const Token = await ethers.getContractFactory("myToken");

      const hardhatToken = await Token.deploy();

      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Swapping contract", function () {
    it("Deployment should assign the total supply of tokens to the owner", async function () {
      const [owner] = await ethers.getSigners();

      const Token = await ethers.getContractFactory("myToken");

      const hardhatToken = await Token.deploy();

      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Vendor contract", function () {
    it("Deployment should assign the total supply of tokens to the owner", async function () {
      const [owner] = await ethers.getSigners();

      const Token = await ethers.getContractFactory("myToken");

      const hardhatToken = await Token.deploy();

      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Lottery contract", function () {
    it("Deployment should assign the total supply of tokens to the owner", async function () {
      const [owner] = await ethers.getSigners();

      const Token = await ethers.getContractFactory("myToken");

      const hardhatToken = await Token.deploy();

      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });
});
