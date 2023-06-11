// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721ABurnable {
    function burn(uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

// Contract that burns 0xGlasses NFTs in batch. Requires being approved by the caller
contract MultiCall {
    event BatchBurned(address indexed user, uint256[] tokenIds);
    
    IERC721ABurnable public oxGlassesContract;

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
        
        // can be omitted if unused
        emit BatchBurned(msg.sender, tokenIds);
    }
    
    // can be omitted if unused elsewhere
    function isSenderOwnerOf(uint256 tokenId) public view returns (bool) {
        return oxGlassesContract.ownerOf(tokenId) == msg.sender;
    }
}
