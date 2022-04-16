// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./myToken.sol";

contract simpleLottery is VRFConsumerBase, Ownable {

    address payable[] public players;
    address payable public recentWinner;
    uint256 public awardAmount;

    IERC20 myTokenInstance;
    uint256 public ENTRY_COST = 1 * 10 ** 10; 
    uint256 public GIANT_SUPPLY = 1000 * 10 ** 18; 

    enum LOTTERY_STATE {
        OPEN,
        CLOSED,
        PROCESSING
    }

    LOTTERY_STATE public lottery_state;

    modifier isInCorrectState(LOTTERY_STATE desired_state) {
        require(lottery_state == desired_state, "Not in correct state");
        _;
    }

    uint256 public randomness;
    uint256 public fee;
    bytes32 public keyhash;

    event RequestedRandomness(bytes32 requestId);
    event WinningPlayerDeclared(address indexed winner, uint256 winnings);

    constructor(
        address _myTokenInstanceAddress,
        address _vrfCoordinator,
        address _link,
        uint256 _fee,
        bytes32 _keyhash
    ) VRFConsumerBase(_vrfCoordinator, _link) {
        
        myTokenInstance = IERC20(_myTokenInstanceAddress);

        lottery_state = LOTTERY_STATE.CLOSED;
        fee = _fee;
        keyhash = _keyhash;
    }

    function enter() public payable isInCorrectState(LOTTERY_STATE.OPEN){
        myTokenInstance.transferFrom(msg.sender, address(this), ENTRY_COST);
        players.push(payable(msg.sender));
    }

    function startLottery(uint256 _amount) public payable onlyOwner isInCorrectState(LOTTERY_STATE.CLOSED){
        require(awardAmount <= 0, "Value has already been set");
        require(msg.value >= _amount, "Insufficient Ether Transferred");
        awardAmount = _amount;
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner {
        lottery_state = LOTTERY_STATE.PROCESSING;
        bytes32 requestId = requestRandomness(keyhash, fee);
        emit RequestedRandomness(requestId);
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
        internal
        override
        isInCorrectState(LOTTERY_STATE.PROCESSING)
    {
        require(_randomness > 0, "random-not-found");
        uint256 indexOfWinner = _randomness % players.length;
        recentWinner = players[indexOfWinner];
        recentWinner.transfer(awardAmount);
        emit WinningPlayerDeclared(recentWinner, awardAmount);

        // Reset
        players = new address payable[](0);
        awardAmount = 0;
        lottery_state = LOTTERY_STATE.CLOSED;
        randomness = _randomness;
    }
}