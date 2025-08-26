const hre = require("hardhat");

async function main() {
  console.log("Deploying Greeter contract to Sepolia testnet...");

  const Greeter = await hre.ethers.getContractFactory("Greeter");
  const greeter = await Greeter.deploy("Hello from Troc-Service!");

  await greeter.waitForDeployment();

  const address = await greeter.getAddress();
  console.log("Greeter deployed to:", address);

  // Test the contract
  const greeting = await greeter.greet();
  console.log("Initial greeting:", greeting);

  return address;
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 