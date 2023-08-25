import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("CuniverseHub", async function () {
  async function deployCuniverseHubFixture() {
    const [NFTDeployer, contractOwner] = await ethers.getSigners();

    const CuniverseHubFactory = await ethers.getContractFactory("CuniverseHub");
    const CuniverseHub = await CuniverseHubFactory.deploy(
      "0x9E43e12263DAF3E9AaCDf968E0C0dB65A61354Fe",
      "250"
    );

    return { CuniverseHub, NFTDeployer, contractOwner };
  }

  describe("deployment", function () {
    it("CuniverseHub 확인", async function () {
      const { CuniverseHub } = await loadFixture(deployCuniverseHubFixture);
    });
  });

  describe("Hash Verify", function () {
    it("verify", async function () {
      const { CuniverseHub } = await loadFixture(deployCuniverseHubFixture);

      //   await expect(
      //     await CuniverseHub.transfer(
      //       "0xa0f96f8a55a1847a3c066d9d79f6e20655c1e70611979c49cb9211f012ffd1fc",
      //       "0xd9e96a6d7b6e8b651ef6eb9a4df01b592b46d359",
      //       "0xf3e98ce29d753f8dd48898d511c0635e3d5339b7",
      //       BigInt(1),
      //       BigInt(0.23231 * 10 ** 18),
      //       1692839100,
      //       1692893220
      //     )
      //   ).to.emit(CuniverseHub, "Transfer");
    });
  });
});
