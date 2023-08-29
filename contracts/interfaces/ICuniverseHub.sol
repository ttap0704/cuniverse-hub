// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ICuniverseHub {
  struct Order {
    address owner;
    address contractAddress;
    uint256 tokenId;
    uint256 price;
    uint256 startTime;
    uint256 endTime;
  }

  // Transfer Event
  event Transfer(address from, address to, uint256 tokenId);

  // Function for settransfer fee info
  function setFeeInfo(address payable _receiver, uint96 _feeFraction) external;

  // Function for transfer NFT & ether
  function proceedOrder(
    address _owner,
    address _contractAddress,
    uint256 _tokenId,
    uint256 _price,
    uint256 _startTime,
    uint256 _endTime,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external payable;
}
