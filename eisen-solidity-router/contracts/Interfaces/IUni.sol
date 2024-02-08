// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

interface IUniswapV3Viewer {
    struct Tick {
        uint128 liquidityGross;
        int128 liquidityNet;
        uint256 feeGrowthOutside0X128;
        uint256 feeGrowthOutside1X128;
        int24 tick;
    }

    struct UniV3PoolParamsResponse {
        address pool;
        int24 tickSpacing;
        uint24 fee;
        uint128 maxLiquidityPerTick;
        address factory;
        address[] tokenList;
    }

    struct UniV3PoolStateResponse {
        uint160 sqrtPriceX96;
        uint32 blockTimestamp;
        uint32 feeProtocol;
        int24 tick;
        uint16 observationIndex;
        uint16 observationCardinality;
        uint128 liquidity;
        uint16 observationCardinalityNext;
    }

    function uniV3GetTicks(IUniswapV3Pool pool, int24 tickRange) external view returns (Tick[] memory ticks);

    function uniV3PoolParams(address pool) external view returns (UniV3PoolParamsResponse memory);

    function uniV3PoolState(address pool) external view returns (UniV3PoolStateResponse memory);
}

interface IUniswapV2Viewer {
    struct UniV2PoolParamsResponse {
        uint256[] fees;
        // fee, fee precision
        address pool;
        address factory;
        address[] tokenList;
    }

    struct UniV2PoolStateResponse {
        uint256[] balances;
        uint256 totalSupply;
        bool paused;
    }

    function uniV2PoolParams(address pool) external view returns (UniV2PoolParamsResponse memory);

    function uniV2PoolState(address pool) external view returns (UniV2PoolStateResponse memory);

    function uniV2PoolNum(address factory) external view returns (uint256);

    function uniV2Pools(address factory, uint256 start, uint256 end) external view returns (address[] memory);
}

interface Router {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
}

interface IBiswap {
    function swapFee() external view returns (uint32);
}

interface IBabyDogeSwap {
    function router() external view returns (address);
}
