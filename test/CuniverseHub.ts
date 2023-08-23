import {loadFixture} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import {anyValue} from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import {expect} from "chai";
import {ethers} from "hardhat";

describe("CuniverseHub", async function () {
  async function deployCuniverseHubFixture() {
    const [owner, addr1] = await ethers.getSigners();

    const CuniverseHubFactory = await ethers.getContractFactory("CuniverseHub");
    const CuniverseHub = await CuniverseHubFactory.deploy();

    return {CuniverseHub, owner, addr1};
  }

  describe("deployment", function () {
    it("CuniverseHub 확인", async function () {
      const {CuniverseHub} = await loadFixture(deployCuniverseHubFixture);
    });
  });

  describe("Hash Verify", function () {
    it("verify", async function () {
      const {CuniverseHub} = await loadFixture(deployCuniverseHubFixture);

      await expect(
        await CuniverseHub._verify(
          "0xeabe9cca94687c530725994811910031ba4018ff7c8614517dd23a0388aa118b",
          "0xd9e96a6d7b6e8b651ef6eb9a4df01b592b46d359",
          "0xf3e98ce29d753f8dd48898d511c0635e3d5339b7",
          2,
          BigInt(10 ** 18)
        )
      ).to.true;
    });
  });
});
