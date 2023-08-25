// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/ICuniverseHub.sol";

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract CuniverseHub is ICuniverseHub, Ownable {
  struct FeeInfo {
    address payable receiver;
    uint96 feeFraction;
  }

  fallback() external payable {}

  receive() external payable {}

  using Address for address;
  using SafeMath for uint256;
  using ERC165Checker for address;

  FeeInfo private _feeInfo;
  mapping(address => uint256) _approvedBalances;

  bytes4 private constant ERC2981_INTERFACE_ID = type(IERC2981).interfaceId;
  bytes4 private constant ERC721_INTERFACE_ID = type(IERC721).interfaceId;

  // bytes4 private constant ERC1155_INTERFACE_ID = type(IERC1155).interfaceId;

  constructor(address payable receiver_, uint96 feeFraction_) {
    setFeeInfo(receiver_, feeFraction_);
  }

  function setFeeInfo(address payable _receiver, uint96 _feeFraction)
    public
    override
    onlyOwner
  {
    _setFeeInfo(_receiver, _feeFraction);
  }

  function _setFeeInfo(address payable _receiver, uint96 _feeFraction)
    internal
    onlyOwner
  {
    _feeInfo = FeeInfo(_receiver, _feeFraction);
  }

  function proceedOrder(
    bytes32 _signiture,
    address _owner,
    address _contractAddress,
    uint256 _tokenId,
    uint256 _price,
    uint256 _startTime,
    uint256 _endTime
  ) public payable {
    require(
      _verifySignature(
        _signiture,
        _owner,
        _contractAddress,
        _tokenId,
        _price,
        _startTime,
        _endTime
      ),
      "CuniverseHub: invaild signature"
    );

    require(msg.value == _price, "CuniverseHub: msg.value came in wrong");

    require(
      !Address.isContract(msg.sender),
      "CuniverseHub: msg.sender is not wallet address"
    );

    require(
      _checkStartTime(_startTime),
      "CuniverseHub: it is not time for sale yet"
    );

    require(_checkEndTime(_endTime), "CuniverseHub: this sale has ended");

    require(
      _isERC721(_contractAddress),
      "CuniverseHub: not supported contract"
    );

    require(
      _isOwner(_owner, _contractAddress, _tokenId),
      "CuniverseHub: owner does not have this token"
    );

    require(
      _checkApproval(_owner, _contractAddress),
      "CuniverseHub: no approval for transfer"
    );

    uint256 feeAmount = _getFeeAmount(_price);
    (address creatorAddress, uint256 creatorAmount) = _calculationCreatorFee(
      _contractAddress,
      _tokenId,
      _price
    );
    uint256 totalEarning = _totalEarning(_price, feeAmount, creatorAmount);

    _sendAmount(_feeInfo.receiver, feeAmount);
    _sendAmount(_owner, totalEarning);
    if (creatorAddress != address(0) && creatorAmount != 0) {
      _sendAmount(creatorAddress, creatorAmount);
    }

    _transferFrom(_owner, _contractAddress, _tokenId);
  }

  function _transferFrom(
    address _owner,
    address _contractAddress,
    uint256 _tokenId
  ) internal {
    IERC721 currentERC721 = IERC721(_contractAddress);

    currentERC721.safeTransferFrom(_owner, msg.sender, _tokenId);
    emit Transfer(_owner, msg.sender, _tokenId);
  }

  function _sendAmount(address _receiver, uint256 _balance) internal {
    payable(_receiver).transfer(_balance);
  }

  function _getFeeAmount(uint256 _price) internal view returns (uint256) {
    return (_price * _feeInfo.feeFraction) / _feeDenominator();
  }

  function _checkStartTime(uint256 _startTime) internal view returns (bool) {
    return _startTime < block.timestamp;
  }

  function _checkEndTime(uint256 _endTime) internal view returns (bool) {
    return _endTime > block.timestamp;
  }

  function _verifySignature(
    bytes32 _signiture,
    address _owner,
    address _contractAddress,
    uint256 _tokenId,
    uint256 _price,
    uint256 _startTime,
    uint256 _endTime
  ) public pure virtual returns (bool) {
    require(
      _contractAddress != address(0),
      "CuniverseHub: smart contract address not to be zero"
    );

    bytes32 checkHash = keccak256(
      abi.encodePacked(
        _owner,
        _contractAddress,
        _tokenId,
        _price,
        _startTime,
        _endTime
      )
    );
    return _signiture == checkHash;
  }

  function _isERC721(address _contractAddress) internal view returns (bool) {
    return
      ERC165Checker.supportsInterface(_contractAddress, ERC721_INTERFACE_ID);
  }

  function _isOwner(
    address _owner,
    address _contractAddress,
    uint256 _tokenId
  ) internal view returns (bool) {
    IERC721 currentERC721 = IERC721(_contractAddress);
    return _owner == currentERC721.ownerOf(_tokenId);
  }

  function _checkApproval(address _owner, address _contractAddress)
    internal
    view
    returns (bool)
  {
    IERC721 currentERC721 = IERC721(_contractAddress);
    return currentERC721.isApprovedForAll(_owner, address(this));
  }

  // function _isERC1155(address _contractAddress) public view returns (bool) {
  //   return
  //     ERC165Checker.supportsInterface(_contractAddress, ERC1155_INTERFACE_ID);
  // }

  function _calculationCreatorFee(
    address _contractAddress,
    uint256 _tokenId,
    uint256 _price
  ) internal view returns (address, uint256) {
    bool supportERC165 = ERC165Checker.supportsERC165(_contractAddress);

    if (supportERC165) {
      bool supportERC2981 = ERC165Checker.supportsInterface(
        _contractAddress,
        ERC2981_INTERFACE_ID
      );
      if (supportERC2981) {
        return IERC2981(_contractAddress).royaltyInfo(_tokenId, _price);
      } else {
        return (address(0), 0);
      }
    } else {
      return (address(0), 0);
    }
  }

  function _totalEarning(
    uint256 _price,
    uint256 _fee,
    uint256 _creatorAmount
  ) internal pure returns (uint256) {
    return SafeMath.sub(SafeMath.sub(_price, _fee), _creatorAmount);
  }

  function _feeDenominator() internal pure virtual returns (uint96) {
    return 10000;
  }
}
