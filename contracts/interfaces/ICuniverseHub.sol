// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ICuniverseHub {
  // Transfer Event
  event Transfer(
    address saler,
    address buyer,
    address contractAddress,
    uint256 tokenId,
    uint256 price
  );

  // Approval Event
  event ApprovalBalance(address saler, uint256 balance);

  function setFeeInfo(address payable _receiver, uint96 _feeFraction) external;

  // Function For NFT Transfer
  function transfer(
    bytes32 _signiture,
    address _owner,
    address _contractAddress,
    uint256 _tokenId,
    uint256 _price,
    uint256 _startTime,
    uint256 _endTime
  ) external payable;
}
