// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

enum SwapType { 
    CURVE, //0
    UNIV2, //1
    SUSHI, //2
    UNIV3, //3
    UNIV3WITHWETH, //4 
    BALANCER, //5
    BALANCERWITHWETH //6 
}

// Onchain Pricing Interface
struct Quote {
    SwapType name;
    uint256 amountOut;
    bytes32[] pools; // specific pools involved in the optimal swap path
    uint256[] poolFees; // specific pool fees involved in the optimal swap path, typically in Uniswap V3
}

interface OnChainPricing {
  function findOptimalSwap(address tokenIn, address tokenOut, uint256 amountIn) external returns (Quote memory);
}

contract FuzzTest is Test {
    OnChainPricing pricer;

    function setUp() public{
        pricer = OnChainPricing(0xd27448046354839A1384D70f30e2f9528E361b03);
    }

    function testFuzzPricer(address tokenIn, address tokenOut, uint256 amount) public{
        vm.assume(tokenIn != address(0));
        vm.assume(tokenOut != address(0));
        vm.assume(tokenIn != tokenOut);

        Quote memory quote = pricer.findOptimalSwap(tokenIn, tokenOut, amount);
        require(quote.amountOut >= 0);
    }

}