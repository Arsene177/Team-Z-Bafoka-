const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Bafoka Community Contract", function () {
  let bafokaContract;
  let owner;
  let user1, user2, user3;
  let backer1;
  
  const COMMUNITY_FONDJOMENKWET = 1;
  const COMMUNITY_BANJA = 2;
  const COMMUNITY_BAFOUKA = 3;
  
  beforeEach(async function () {
    // Get signers
    [owner, user1, user2, user3, backer1] = await ethers.getSigners();
    
    // Deploy contract
    const BafokaCommunityContract = await ethers.getContractFactory("BafokaCommunityContract");
    bafokaContract = await BafokaCommunityContract.deploy();
    await bafokaContract.deployed();
  });
  
  describe("Community Creation", function () {
    it("Should create initial communities with correct names and currency names", async function () {
      const community1 = await bafokaContract.getCommunity(COMMUNITY_FONDJOMENKWET);
      const community2 = await bafokaContract.getCommunity(COMMUNITY_BANJA);
      const community3 = await bafokaContract.getCommunity(COMMUNITY_BAFOUKA);
      
      expect(community1.name).to.equal("Fondjomenkwet");
      expect(community1.currencyName).to.equal("Fonjoka");
      expect(community1.exists).to.be.true;
      
      expect(community2.name).to.equal("Banja");
      expect(community2.currencyName).to.equal("Banjika");
      expect(community2.exists).to.be.true;
      
      expect(community3.name).to.equal("Bafouka");
      expect(community3.currencyName).to.equal("Bafouka");
      expect(community3.exists).to.be.true;
    });
    
    it("Should have correct community IDs", async function () {
      expect(await bafokaContract.nextCommunityId()).to.equal(4); // 3 communities + 1
    });
  });
  
  describe("User Registration", function () {
    it("Should register user in Fondjomenkwet community", async function () {
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      
      const profile = await bafokaContract.getUserProfile(user1.address);
      expect(profile.communityId).to.equal(COMMUNITY_FONDJOMENKWET);
      expect(profile.username).to.equal("Alice");
      expect(profile.isRegistered).to.be.true;
      expect(profile.reputation).to.equal(50);
      expect(profile.isBacker).to.be.false;
    });
    
    it("Should distribute 1000 Bafoka to new user", async function () {
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      
      const balance = await bafokaContract.getCommunityBalance(user1.address, COMMUNITY_FONDJOMENKWET);
      expect(balance).to.equal(1000);
    });
    
    it("Should update community member count", async function () {
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      
      const community = await bafokaContract.getCommunity(COMMUNITY_FONDJOMENKWET);
      expect(community.totalMembers).to.equal(1);
    });
    
    it("Should prevent double registration", async function () {
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      
      await expect(
        bafokaContract.connect(user1).registerUser(COMMUNITY_BANJA, "Alice2")
      ).to.be.revertedWith("User already registered");
    });
    
    it("Should prevent registration in non-existent community", async function () {
      await expect(
        bafokaContract.connect(user1).registerUser(999, "Alice")
      ).to.be.revertedWith("Community does not exist");
    });
  });
  
  describe("Exchange Creation", function () {
    beforeEach(async function () {
      // Register users in different communities
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      await bafokaContract.connect(user2).registerUser(COMMUNITY_FONDJOMENKWET, "Bob");
      await bafokaContract.connect(user3).registerUser(COMMUNITY_BANJA, "Charlie");
    });
    
    it("Should create exchange agreement between users in same community", async function () {
      const deadline = Math.floor(Date.now() / 1000) + 3600; // 1 hour from now
      
      await bafokaContract.connect(user1).createExchange(
        user2.address,
        "Couture service",
        100,
        deadline
      );
      
      const exchange = await bafokaContract.getExchangeAgreement(1);
      expect(exchange.provider).to.equal(user1.address);
      expect(exchange.receiver).to.equal(user2.address);
      expect(exchange.communityId).to.equal(COMMUNITY_FONDJOMENKWET);
      expect(exchange.serviceDescription).to.equal("Couture service");
      expect(exchange.bafokaAmount).to.equal(100);
      expect(exchange.isConfirmed).to.be.false;
    });
    
    it("Should reserve Bafoka when creating exchange", async function () {
      const deadline = Math.floor(Date.now() / 1000) + 3600;
      
      await bafokaContract.connect(user1).createExchange(
        user2.address,
        "Couture service",
        100,
        deadline
      );
      
      const balance = await bafokaContract.getCommunityBalance(user1.address, COMMUNITY_FONDJOMENKWET);
      expect(balance).to.equal(900); // 1000 - 100
    });
    
    it("Should prevent exchange between users in different communities", async function () {
      const deadline = Math.floor(Date.now() / 1000) + 3600;
      
      await expect(
        bafokaContract.connect(user1).createExchange(
          user3.address,
          "Couture service",
          100,
          deadline
        )
      ).to.be.revertedWith("Users must be in same community");
    });
    
    it("Should prevent exchange with insufficient Bafoka", async function () {
      const deadline = Math.floor(Date.now() / 1000) + 3600;
      
      await expect(
        bafokaContract.connect(user1).createExchange(
          user2.address,
          "Couture service",
          1500,
          deadline
        )
      ).to.be.revertedWith("Insufficient Bafoka");
    });
  });
  
  describe("Exchange Flow", function () {
    let exchangeId;
    
    beforeEach(async function () {
      // Register users and create exchange
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      await bafokaContract.connect(user2).registerUser(COMMUNITY_FONDJOMENKWET, "Bob");
      
      const deadline = Math.floor(Date.now() / 1000) + 3600;
      exchangeId = await bafokaContract.connect(user1).createExchange(
        user2.address,
        "Couture service",
        100,
        deadline
      );
    });
    
    it("Should confirm exchange when receiver calls confirm", async function () {
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      
      const exchange = await bafokaContract.getExchangeAgreement(exchangeId);
      expect(exchange.isConfirmed).to.be.true;
    });
    
    it("Should mark exchange as completed", async function () {
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      await bafokaContract.connect(user1).markExchangeCompleted(exchangeId);
      
      const exchange = await bafokaContract.getExchangeAgreement(exchangeId);
      expect(exchange.isCompleted).to.be.true;
    });
    
    it("Should finalize exchange with ratings", async function () {
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      await bafokaContract.connect(user1).markExchangeCompleted(exchangeId);
      await bafokaContract.connect(user1).finalizeExchange(exchangeId, 5, 4);
      
      const exchange = await bafokaContract.getExchangeAgreement(exchangeId);
      expect(exchange.isFinalized).to.be.true;
      expect(exchange.providerRating).to.equal(5);
      expect(exchange.receiverRating).to.equal(4);
    });
    
    it("Should transfer Bafoka to provider after finalization", async function () {
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      await bafokaContract.connect(user1).markExchangeCompleted(exchangeId);
      await bafokaContract.connect(user1).finalizeExchange(exchangeId, 5, 4);
      
      const balance = await bafokaContract.getCommunityBalance(user1.address, COMMUNITY_FONDJOMENKWET);
      expect(balance).to.equal(1000); // 900 + 100
    });
    
    it("Should update user statistics after finalization", async function () {
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      await bafokaContract.connect(user1).markExchangeCompleted(exchangeId);
      await bafokaContract.connect(user1).finalizeExchange(exchangeId, 5, 4);
      
      const profile1 = await bafokaContract.getUserProfile(user1.address);
      const profile2 = await bafokaContract.getUserProfile(user2.address);
      
      expect(profile1.totalExchanges).to.equal(1);
      expect(profile2.totalExchanges).to.equal(1);
    });
  });
  
  describe("Backer System", function () {
    beforeEach(async function () {
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      await bafokaContract.connect(backer1).registerUser(COMMUNITY_FONDJOMENKWET, "Local Shop");
    });
    
    it("Should register backer", async function () {
      await bafokaContract.connect(backer1).registerBacker(COMMUNITY_FONDJOMENKWET, "Local Shop");
      
      const backer = await bafokaContract.getBacker(backer1.address);
      expect(backer.businessName).to.equal("Local Shop");
      expect(backer.communityId).to.equal(COMMUNITY_FONDJOMENKWET);
      expect(backer.isActive).to.be.true;
      
      const profile = await bafokaContract.getUserProfile(backer1.address);
      expect(profile.isBacker).to.be.true;
    });
    
    it("Should allow backer to recharge user account", async function () {
      await bafokaContract.connect(backer1).registerBacker(COMMUNITY_FONDJOMENKWET, "Local Shop");
      
      const initialBalance = await bafokaContract.getCommunityBalance(user1.address, COMMUNITY_FONDJOMENKWET);
      expect(initialBalance).to.equal(1000);
      
      await bafokaContract.connect(backer1).rechargeBafoka(user1.address, 500);
      
      const newBalance = await bafokaContract.getCommunityBalance(user1.address, COMMUNITY_FONDJOMENKWET);
      expect(newBalance).to.equal(1500);
    });
    
    it("Should update backer statistics after recharge", async function () {
      await bafokaContract.connect(backer1).registerBacker(COMMUNITY_FONDJOMENKWET, "Local Shop");
      await bafokaContract.connect(backer1).rechargeBafoka(user1.address, 500);
      
      const backer = await bafokaContract.getBacker(backer1.address);
      expect(backer.totalRecharges).to.equal(1);
      expect(backer.totalVolume).to.equal(500);
    });
    
    it("Should prevent non-backer from recharging", async function () {
      await expect(
        bafokaContract.connect(user1).rechargeBafoka(user2.address, 500)
      ).to.be.revertedWith("Not an active backer");
    });
  });
  
  describe("Reputation System", function () {
    beforeEach(async function () {
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      await bafokaContract.connect(user2).registerUser(COMMUNITY_FONDJOMENKWET, "Bob");
    });
    
    it("Should start with neutral reputation (50)", async function () {
      const profile = await bafokaContract.getUserProfile(user1.address);
      expect(profile.reputation).to.equal(50);
    });
    
    it("Should increase reputation for high ratings", async function () {
      const deadline = Math.floor(Date.now() / 1000) + 3600;
      const exchangeId = await bafokaContract.connect(user1).createExchange(
        user2.address,
        "Service",
        100,
        deadline
      );
      
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      await bafokaContract.connect(user1).markExchangeCompleted(exchangeId);
      await bafokaContract.connect(user1).finalizeExchange(exchangeId, 5, 4);
      
      const profile = await bafokaContract.getUserProfile(user1.address);
      expect(profile.reputation).to.equal(51);
    });
    
    it("Should decrease reputation for low ratings", async function () {
      const deadline = Math.floor(Date.now() / 1000) + 3600;
      const exchangeId = await bafokaContract.connect(user1).createExchange(
        user2.address,
        "Service",
        100,
        deadline
      );
      
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      await bafokaContract.connect(user1).markExchangeCompleted(exchangeId);
      await bafokaContract.connect(user1).finalizeExchange(exchangeId, 2, 4);
      
      const profile = await bafokaContract.getUserProfile(user1.address);
      expect(profile.reputation).to.equal(49);
    });
  });
  
  describe("Community Statistics", function () {
    beforeEach(async function () {
      await bafokaContract.connect(user1).registerUser(COMMUNITY_FONDJOMENKWET, "Alice");
      await bafokaContract.connect(user2).registerUser(COMMUNITY_FONDJOMENKWET, "Bob");
    });
    
    it("Should track total users across all communities", async function () {
      expect(await bafokaContract.totalUsers()).to.equal(2);
    });
    
    it("Should track community member count", async function () {
      const community = await bafokaContract.getCommunity(COMMUNITY_FONDJOMENKWET);
      expect(community.totalMembers).to.equal(2);
    });
    
    it("Should track community transaction count", async function () {
      const deadline = Math.floor(Date.now() / 1000) + 3600;
      const exchangeId = await bafokaContract.connect(user1).createExchange(
        user2.address,
        "Service",
        100,
        deadline
      );
      
      await bafokaContract.connect(user2).confirmExchange(exchangeId);
      await bafokaContract.connect(user1).markExchangeCompleted(exchangeId);
      await bafokaContract.connect(user1).finalizeExchange(exchangeId, 5, 4);
      
      const community = await bafokaContract.getCommunity(COMMUNITY_FONDJOMENKWET);
      expect(community.totalTransactions).to.equal(1);
    });
  });
});
