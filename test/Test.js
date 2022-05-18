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
    // let totalSupply = 

    beforeEach(async function(){
        GLDToken = await hre.ethers.getContractFactory("GLDToken");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        gldToken = await GLDToken.deploy("10000000000000000000000");
        
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
        expect("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4").to.equal(owner.address);
    })
    it("Return Total Supply", async function(){
        const ownerBalances = await gldToken.balanceOf(owner.address);
        expect(await gldToken.totalSupply()).to.equal(ownerBalances);
    })
})