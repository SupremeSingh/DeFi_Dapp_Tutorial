// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract singlePathSwapper {

    ISwapRouter public immutable swapRouter;

    address public tokenOne;
    address public tokenTwo;

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

    constructor(ISwapRouter _swapRouter, address _tokenTwoAddress) {
        swapRouter = _swapRouter;
        tokenTwo = _tokenTwoAddress;   
    }

    function swapExactInputSingle(uint256 amountIn, address _tokenOneAddress) external returns (uint256 amountOut) {
        tokenOne = _tokenOneAddress;

        TransferHelper.safeTransferFrom(tokenOne, msg.sender, address(this), amountIn);
        TransferHelper.safeApprove(tokenOne, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenOne,
                tokenOut: tokenTwo,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
    }


    function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum, address _tokenOneAddress) external returns (uint256 amountIn) {
        tokenOne = _tokenOneAddress;
        
        TransferHelper.safeTransferFrom(tokenOne, msg.sender, address(this), amountInMaximum);
        TransferHelper.safeApprove(tokenOne, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: tokenOne,
                tokenOut: tokenTwo,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = swapRouter.exactOutputSingle(params);

        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(tokenOne, address(swapRouter), 0);
            TransferHelper.safeTransfer(tokenOne, msg.sender, amountInMaximum - amountIn);
        }
    }
}