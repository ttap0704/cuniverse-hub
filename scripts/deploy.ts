import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("deployer:", deployer);

  const CuniverseHub = await ethers.deployContract("CuniverseHub", [
    "0x9E43e12263DAF3E9AaCDf968E0C0dB65A61354Fe",
    "250",
  ]);
  await CuniverseHub.waitForDeployment();

  console.log("contract address:", await CuniverseHub.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
