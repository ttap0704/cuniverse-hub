// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract CuniverseHub {
  function _verify(bytes32 _signiture, address _owner, address _contractAddress, uint256 _tokenId, uint256 _price) public pure returns (bool) {
    return _signiture == keccak256(abi.encodePacked(_owner, _contractAddress, _tokenId, _price));
  }
}
