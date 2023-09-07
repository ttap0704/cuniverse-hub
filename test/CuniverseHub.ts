import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
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

  describe("Verify Order", function () {
    it("verify", async function () {
      const { CuniverseHub } = await loadFixture(deployCuniverseHubFixture);

      // const domain = {
      //   name: "Cuniverse",
      //   version: "1.0",
      //   chainId: BigInt(31337).toString(),
      //   verifyingContract: await CuniverseHub.getAddress(),
      // };

      // const value = {
      //   owner: "0xD9e96a6D7b6e8B651eF6Eb9a4DF01b592b46d359",
      //   contractAddress: "0xc6a2a083ea2804826bcf6acae6d6dc2f53f5801a",
      //   tokenId: BigInt(1).toString(),
      //   price: BigInt(1 * 10 ** 18).toString(),
      //   startTime: 1693981245,
      //   endTime: 1701206400,
      // };

      // const types = {
      //   EIP712Domain: [
      //     { name: "name", type: "string" },
      //     { name: "version", type: "string" },
      //     { name: "chainId", type: "uint256" },
      //     { name: "verifyingContract", type: "address" },
      //   ],
      //   Order: [
      //     { name: "owner", type: "address" },
      //     { name: "contractAddress", type: "address" },
      //     { name: "tokenId", type: "uint256" },
      //     { name: "price", type: "uint256" },
      //     { name: "startTime", type: "uint256" },
      //     { name: "endTime", type: "uint256" },
      //   ],
      // };

      await expect(
        await CuniverseHub._verifyOrder(
          "0xD9e96a6D7b6e8B651eF6Eb9a4DF01b592b46d359",
          {
            owner: "0xD9e96a6D7b6e8B651eF6Eb9a4DF01b592b46d359",
            contractAddress: "0xa47f0ce9eb46bb8f9dd6c88f77eccea88b8843f0",
            tokenId: BigInt(1).toString(),
            price: BigInt(222000000000000000).toString(),
            startTime: 1693880752,
            endTime: 1694712360,
          },
          BigInt(28).toString(),
          "0xb922d10e3ade3e9eef74af9403d3b5e3d115d78d81fafd2f6ba67200ebb35d40",
          "0x1192e38072a843ef137ff107121adb6f5830cacacc695f2b1a34165da1be2961"
        )
      ).to.equal(false);
    });
  });
});
