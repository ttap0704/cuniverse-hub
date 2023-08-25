// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ICuniverseHub {
  // Transfer Event
  event Transfer(address from, address to, uint256 tokenId);

  // Function for settransfer fee info
  function setFeeInfo(address payable _receiver, uint96 _feeFraction) external;

  // Function for transfer NFT & ether
  function proceedOrder(
    bytes32 _signiture,
    address _owner,
    address _contractAddress,
    uint256 _tokenId,
    uint256 _price,
    uint256 _startTime,
    uint256 _endTime
  ) external payable;
}
