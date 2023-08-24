import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  const CuniverseHub = await ethers.deployContract("CuniverseHub", []);
  await CuniverseHub.waitForDeployment();

  console.log("contract address:", await CuniverseHub.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
