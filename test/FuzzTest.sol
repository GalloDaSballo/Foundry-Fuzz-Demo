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

    address[] tokens = [
            0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B,
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            0x090185f2135308BaD17527004364eBcC2D37e5F6,
            0xdBdb4d16EdA451D0503b854CF79D55697F90c8DF,
            0x9D79d5B61De59D882ce90125b18F74af650acB93,
            0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0,
            0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0, 
            0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32,
            0xc7283b66Eb1EB5FB86327f08e1B5816b0720212B, 
            0x8207c1FfC5B6804F6024322CcF34F29c3541Ae26, 
            0xa3BeD4E1c75D00fa6f4E5E6922DB7261B5E9AcD2,
            0x31429d1856aD1377A8A0079410B297e1a9e214c2,
            0xCdF7028ceAB81fA0C6971208e83fa7872994beE5,
            0xa693B19d2931d498c5B318dF961919BB4aee87a5, 
            0xB620Be8a1949AA9532e6a3510132864EF9Bc3F82,
            0x6243d8CEA23066d098a15582d81a598b4e8391F4,
            0x3Ec8798B81485A254928B70CDA1cf0A2BB0B74D7,
            0xAf5191B0De278C7286d6C7CC6ab6BB8A73bA2Cd6,
            0xdB25f211AB05b1c97D595516F45794528a807ad8,
            0x674C6Ad92Fd080e4004b2312b45f796a192D27a0,
            0xFEEf77d3f69374f66429C91d732A244f074bdf74,
            0x41D5D79431A913C4aE7d69a668ecdfE5fF9DFB68,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            0xC0c293ce456fF0ED870ADd98a0828Dd4d2903DBF,
            0x616e8BfA43F920657B3497DBf40D6b1A02D4608d,
            0x3472A5A71965499acd81997a54BBA8D852C6E53d,
            0x30D20208d987713f46DFD34EF128Bb16C404D10f,
            0x888888435FDe8e7d4c54cAb67f206e4199454c60,
            0xEd1480d12bE41d92F36f5f7bDd88212E381A3677,
            0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32,
            0xDEf1CA1fb7FBcDC777520aa7f396b4E015F497aB,
            0x6810e776880C02933D47DB1b9fc05908e5386b96,
            0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B,
            0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F,
            0xc7283b66Eb1EB5FB86327f08e1B5816b0720212B,
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
            0x0000000000085d4780B73119b644AE5ecd22b376,
            0xAf5191B0De278C7286d6C7CC6ab6BB8A73bA2Cd6,
            0x01BA67AAC7f75f647D94220Cc98FB30FCc5105Bf,
            0xE80C0cd204D654CEbe8dd64A4857cAb6Be8345a3,
            0x3Ec8798B81485A254928B70CDA1cf0A2BB0B74D7,
            0xdB25f211AB05b1c97D595516F45794528a807ad8,
            0x798D1bE841a82a273720CE31c822C61a67a601C3,
            0xBA485b556399123261a5F9c95d413B4f93107407
        ];

    function getToken(uint256 index) public view returns(address) {
        uint256 adjusted = index % tokens.length;

        return tokens[adjusted];
    }

    function setUp() public{
        // NOTE: Update after local deploy or new deploy
        // https://etherscan.io/address/0x2dc7693444acd1eca1d6de5b3d0d8584f3870c49#code
        pricer = OnChainPricing(0x2DC7693444aCd1EcA1D6dE5B3d0d8584F3870c49);
    }

    function testFuzzPricer(uint256 indexIn, uint256 indexOut, uint256 amount) public {
        address tokenIn = getToken(indexIn);
        address tokenOut = getToken(indexOut);

        vm.assume(tokenIn != address(0));
        vm.assume(tokenOut != address(0));
        vm.assume(tokenOut != tokenIn);

        Quote memory quote = pricer.findOptimalSwap(tokenIn, tokenOut, amount);
        require(quote.amountOut >= 0);
    }

}