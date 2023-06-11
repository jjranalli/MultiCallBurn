// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721ABurnable {
    function burn(uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract MultiCall {
    IERC721ABurnable public oxGlassesContract;

    event BatchBurned(address indexed user, uint256[] tokenIds);

    constructor(address _oxGlassesContract) {
        oxGlassesContract = IERC721ABurnable(_oxGlassesContract);
    }

    function batchBurn(uint256[] memory tokenIds) external {
        uint256 tokensLength = tokenIds.length;

        unchecked {
            for (uint256 i; i < tokensLength; ++i) {
                oxGlassesContract.burn(tokenIds[i]);
            }
        }

        emit BatchBurned(msg.sender, tokenIds);
    }

    function isSenderOwnerOf(uint256 tokenId) public view returns (bool) {
        return oxGlassesContract.ownerOf(tokenId) == msg.sender;
    }
}
