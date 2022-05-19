const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");

describe("GLDToken Test", function(){
    let gldToken;
    let owner;
    let addr1;
    let addr2;
    let addrs;
    let GLDToken; 

    beforeEach(async function(){
        GLDToken = await hre.ethers.getContractFactory("GLDToken");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        gldToken = await GLDToken.deploy("10000");
        
    })
    it("Return Token's name", async function(){
        console.log("Token name");
        const nameTest = "Gold";
        expect(await gldToken.name()).to.equal(nameTest);
    })
    it("Return Token's Symbol", async function(){
        const symbolTest = "GLD";
        console.log("Symbol: " + symbolTest);
        expect(await gldToken.symbol()).to.equal(symbolTest);
    })
    it("Return owner's account", async function(){
        expect(await gldToken.owner()).to.equal(owner.address);
    })
    it("Return Total Supply", async function(){
        const ownerBalances = await gldToken.balanceOf(owner.address);
        expect(await gldToken.totalSupply()).to.equal(ownerBalances);
    })
    it("Claim Token, should return balances of claimed address", async function(){
        await gldToken.transfer(addr1.address, 50);
        expect(await gldToken.balanceOf(addr1.address)).to.equal(50);
    })
})