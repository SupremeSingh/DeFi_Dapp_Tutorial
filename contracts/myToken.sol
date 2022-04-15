// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract myToken is ERC20 {
    
    uint256 public immutable _totalSupply = 1000 * 10 ** 18; 
    uint256 public _initialSupply = 100 * 10 ** 18;
    uint256 public _minerReward = 10 * 10 ** 18;

    modifier capOnSupplyMet(uint256 _amount) {
        require(ERC20.totalSupply() + _amount <= _totalSupply, "Cannot Mint More Tokens");
        _;
    }

    event minerFeeChanged(uint256 changedValue);
    event minerRewardEmitted(address _recipient, uint256 indexed _blockNumber);
    event tokensTransferred(address indexed _from, address indexed _to, uint256 _amount);

    constructor() ERC20("MyToken", "MTN") {
        _mint(msg.sender, _initialSupply);
    }

    function mintToMiner() internal capOnSupplyMet(_minerReward){
        _mint(block.coinbase, _minerReward);
        emit minerRewardEmitted(block.coinbase, block.number);
    }

    function _transfer(address from, address to, uint256 value) internal override {
        mintToMiner();
        super._transfer(from, to, value);
        emit tokensTransferred(from, to, value);
    }

    function decreaseMinerReward(uint256 _changeAmount) external {
        require(_minerReward - _changeAmount > 0, "Cannot do this");
        _minerReward -= _changeAmount;
        emit minerFeeChanged(_minerReward);
    }
}