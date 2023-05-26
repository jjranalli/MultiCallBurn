const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MultiCall", function () {
  let MultiCall, multiCall, ERC721A, erc721A, owner, addr1, addr2;

  beforeEach(async function () {
    ERC721A = await ethers.getContractFactory("ERC721A");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    erc721A = await ERC721A.deploy("Token", "TKN");
    await erc721A.deployed();

    MultiCall = await ethers.getContractFactory("MultiCall");
    multiCall = await MultiCall.deploy(erc721A.address);
    await multiCall.deployed();
  });

  describe("Deployment", function () {
    it("Should set the right roles upon deployment", async function () {
      expect(await multiCall.hasRole(multiCall.DEFAULT_ADMIN_ROLE(), owner.address)).to.equal(true);
      expect(await multiCall.hasRole(multiCall.BURNER_ROLE(), owner.address)).to.equal(true);
    });
  });

  describe("Batch burn", function () {
    it("Should not allow users without BURNER_ROLE to batch burn", async function () {
      await expect(multiCall.connect(addr1).batchBurn([0, 1, 2])).to.be.revertedWith("Must have burner role to burn tokens");
    });

    it("Should allow users with BURNER_ROLE to batch burn", async function () {
      await multiCall.grantRole(multiCall.BURNER_ROLE(), owner.address);
      await expect(multiCall.connect(owner).batchBurn([0, 1, 2])).to.emit(multiCall, "BatchBurned").withArgs(owner.address, [0, 1, 2]);
    });

    it("Should emit Burned event for each token burned", async function () {
      await multiCall.grantRole(multiCall.BURNER_ROLE(), owner.address);
      await expect(multiCall.connect(owner).batchBurn([0, 1,Here's the continuation of the test suite:

```javascript
    2])).to.emit(multiCall, "Burned").withArgs(owner.address, 0)
        .and.to.emit(multiCall, "Burned").withArgs(owner.address, 1)
        .and.to.emit(multiCall, "Burned").withArgs(owner.address, 2);
    });
  });
});
