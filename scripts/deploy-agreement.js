const hre = require("hardhat");

async function main() {
  console.log("Deploying AgreementContract to Sepolia testnet...");

  const AgreementContract = await hre.ethers.getContractFactory("AgreementContract");
  const agreementContract = await AgreementContract.deploy();

  await agreementContract.waitForDeployment();

  const address = await agreementContract.getAddress();
  console.log("AgreementContract deployed to:", address);

  // Test the contract
  const agreementCount = await agreementContract.getAgreementCount();
  console.log("Initial agreement count:", agreementCount.toString());

  return address;
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 