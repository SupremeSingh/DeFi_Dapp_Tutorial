// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./myToken.sol";
import "./singlePathSwapper.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vendor is Ownable {

  IERC20 myTokenInstance;
  singlePathSwapper simpleSwapper;

  mapping(address => uint256) public inTokenWhiteList;
  uint256 public ENTRY_COST = 1 * 10 ** 10; 
  uint256 public GIANT_SUPPLY = 1000 * 10 ** 18; 

  event loadedWithEth(uint256 indexed _currentBalance);
  event BuyTokens(address indexed buyer, uint256 amountIn, uint256 amountOfmyTokenInstances);

  constructor(address _myTokenInstanceAddress, address _swapperAddress) {
    myTokenInstance = IERC20(_myTokenInstanceAddress);
    simpleSwapper = singlePathSwapper(_swapperAddress);
  }

  function buyTokens(uint256 _maxAmountIn, address _tokenIn) public payable returns (uint256 tokenAmount) {
    require(inTokenWhiteList[_tokenIn] == 1);
    
    IERC20 thisTokenInstance = IERC20(_tokenIn);
    thisTokenInstance.transferFrom(msg.sender, address(this), _maxAmountIn);

    uint256 amountOut = simpleSwapper.swapExactInputSingle(_maxAmountIn, _tokenIn);

    myTokenInstance.transfer(msg.sender, amountOut);

    emit BuyTokens(msg.sender, _maxAmountIn, amountOut);

    tokenAmount = amountOut;
  }

  function loadContractWithEth(uint256 _amount) external payable onlyOwner() {
    require(msg.value >= _amount, "Incorrect amount");
    emit loadedWithEth(address(this).balance);
  }

  function addTokensToWhitelist(address _tokenIn) external onlyOwner() {
    require(inTokenWhiteList[_tokenIn] == 0, "Has been approved already");
    inTokenWhiteList[_tokenIn] = 1;  

    IERC20 thisTokenInstance = IERC20(_tokenIn);
    thisTokenInstance.approve(address(simpleSwapper), GIANT_SUPPLY); 
  }

  function removeTokensFromWhitelist(address _tokenIn) external onlyOwner() {
    require(inTokenWhiteList[_tokenIn] == 1, "Is Not Included");
    inTokenWhiteList[_tokenIn] = 0;  

    IERC20 thisTokenInstance = IERC20(_tokenIn);
    thisTokenInstance.approve(address(simpleSwapper), 0); 
  }

}
