const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Deploying Bafoka Community Contract...");
  
  // Get the contract factory
  const BafokaCommunityContract = await ethers.getContractFactory("BafokaCommunityContract");
  
  // Deploy the contract
  const bafokaContract = await BafokaCommunityContract.deploy();
  
  // Wait for deployment to finish
  await bafokaContract.deployed();
  
  console.log("✅ Bafoka Community Contract deployed successfully!");
  console.log("📍 Contract Address:", bafokaContract.address);
  console.log("🌐 Network:", network.name);
  
  // Verify the deployment
  console.log("\n🔍 Verifying contract deployment...");
  
  try {
    // Wait a bit for the deployment to be indexed
    console.log("⏳ Waiting for deployment to be indexed...");
    await new Promise(resolve => setTimeout(resolve, 30000));
    
    // Verify on Etherscan (if on a public network)
    if (network.name !== "hardhat" && network.name !== "localhost") {
      console.log("🔍 Verifying on Etherscan...");
      await hre.run("verify:verify", {
        address: bafokaContract.address,
        constructorArguments: [],
      });
      console.log("✅ Contract verified on Etherscan!");
    }
  } catch (error) {
    console.log("⚠️  Verification failed:", error.message);
  }
  
  // Display initial community information
  console.log("\n🏘️  Initial Communities Created:");
  console.log("1. Fondjomenkwet (Fonjoka)");
  console.log("2. Banja (Banjika)");
  console.log("3. Bafouka (Bafouka)");
  
  console.log("\n💰 Initial Bafoka Distribution: 1000 per user");
  console.log("🔒 Community Isolation: Exchanges only within same community");
  console.log("🏪 Backer System: Local businesses can recharge accounts");
  
  // Save deployment info
  const deploymentInfo = {
    contractName: "BafokaCommunityContract",
    address: bafokaContract.address,
    network: network.name,
    deployer: (await ethers.getSigners())[0].address,
    deploymentTime: new Date().toISOString(),
    features: [
      "Community-based service exchanges",
      "Local currency variants (Fonjoka, Banjika, Bafouka)",
      "Automatic 1000 Bafoka distribution",
      "Community isolation",
      "Backer recharge system",
      "Reputation management",
      "Smart contract escrow"
    ]
  };
  
  console.log("\n📋 Deployment Summary:");
  console.log(JSON.stringify(deploymentInfo, null, 2));
  
  console.log("\n🎉 Deployment Complete! Your Bafoka Community Contract is ready!");
  console.log("\n📱 Next Steps:");
  console.log("1. Update your WhatsApp bot to use this contract");
  console.log("2. Test user registration in different communities");
  console.log("3. Test service exchange flow");
  console.log("4. Test backer recharge system");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
