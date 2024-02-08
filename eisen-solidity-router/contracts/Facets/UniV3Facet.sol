// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import {LibPayments, Recipient, Payer} from "contracts/Libraries/LibPayments.sol";

import {LibAllowList} from "contracts/Libraries/LibAllowList.sol";
import {GenericErrors} from "contracts/Errors/GenericErrors.sol";
import {Constants} from "contracts/Libraries/Constants.sol";

import {UniV3Path, BytesLib} from "contracts/Libraries/UniV3Path.sol";
import {SafeCastLib} from "contracts/Libraries/SafeCastLib.sol";
import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {IUniswapV3Factory} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import {IUniswapV3SwapCallback} from "@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

import {UniERC20} from "contracts/Libraries/UniERC20.sol";
import {IUniswapV3Viewer} from "contracts/Interfaces/IUni.sol";

/// @title UniV3Facet
/// @author Eisen (https://app.eisenfinance.com)
/// @notice Provides functionality for UniswapV3 protocol
/// @custom:version 1.0.0
contract UniV3Facet is IUniswapV3Viewer, IUniswapV3SwapCallback {
    using UniV3Path for bytes;
    using SafeCastLib for uint256;
    using BytesLib for bytes;
    using UniERC20 for address;
    using LibPayments for Payer;
    using LibPayments for Recipient;
    using Address for address;

    int24 private constant _MIN_TICK = -887272;
    int24 private constant _MAX_TICK = -_MIN_TICK;

    /// @dev Used as the placeholder value for maxAmountIn, because the computed amount in for an exact output swap
    /// can never actually be this value
    uint256 private constant DEFAULT_MAX_AMOUNT_IN = type(uint256).max;

    /// @dev Transient storage variable used for checking slippage
    uint256 private constant maxAmountInCached = DEFAULT_MAX_AMOUNT_IN;

    /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
    uint160 internal constant MIN_SQRT_RATIO = 4295128739;

    /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
    uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

    /// @notice Performs a Uniswap v3 exact input swap
    /// @dev  To Use Uni swap with ETH, the ETH must be wrapped before calling it
    /// @param amountIn The amount of input tokens for the trade
    /// @param path The path of the trade as a bytes string
    /// abi.encodePacked in this order [token-factory-fee(uint24)-token(-factory-fee(uint24)-token)]
    /// @param recipient The recipient of the output tokens
    /// @param payer The address that will be paying the input
    /// @return inputToken The address of input token
    /// @return outputToken The address of output token
    /// @return amountOut The amount of output tokens for the trade
    function uniV3SwapExactInput(
        uint256 amountIn,
        bytes memory path,
        Recipient recipient,
        Payer payer
    ) public payable returns (address inputToken, address outputToken, uint256 amountOut) {
        // use amountIn == Constants.CONTRACT_BALANCE as a flag to swap the entire balance of the contract
        inputToken = path.decodeFirstToken();
        payer = payer.payerMap();
        recipient = recipient.map();
        if (amountIn == Constants.CONTRACT_BALANCE) {
            amountIn = inputToken.uniBalanceOf(address(this));
        }

        while (true) {
            bool hasMultiplePools = path.hasMultiplePools();

            // the outputs of prior swaps become the inputs to subsequent ones
            (int256 amount0Delta, int256 amount1Delta, bool zeroForOne) = _uniV3Swap(
                amountIn.toInt256(),
                true,
                path.getFirstPool(), // only the first pool is needed
                hasMultiplePools ? Recipient.wrap(address(this)) : recipient, // for intermediate swaps, this contract custodies
                payer // for intermediate swaps, this contract custodies
            );

            amountIn = uint256(-(zeroForOne ? amount1Delta : amount0Delta));

            // decide whether to continue or terminate
            if (hasMultiplePools) {
                payer = Payer.wrap(address(this));
                path.skipBulk();
            } else {
                outputToken = path.decodeLastToken();
                amountOut = amountIn;
                break;
            }
        }

        if (amountOut == 0) revert GenericErrors.GenericError(GenericErrors.OVERFLOW_UNDERFLOW);
    }

    /// @notice Performs a callback function of uniswapV3 pool
    /// @param amount0Delta The amount change of token0 from the view of pool side
    /// @param amount1Delta The amount change of token1 from the view of pool side
    /// @param data The path of the trade as a bytes
    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {
        _uniV3BaseSwapCallback(amount0Delta, amount1Delta, data);
    }

    /// View Methods ///

    /// @notice Get uniV3 pool param info using pool address

    function uniV3PoolParams(address pool) external view override returns (UniV3PoolParamsResponse memory) {
        UniV3PoolParamsResponse memory response;
        response.pool = pool;
        response.tickSpacing = IUniswapV3Pool(pool).tickSpacing();
        response.fee = IUniswapV3Pool(pool).fee();
        response.maxLiquidityPerTick = IUniswapV3Pool(pool).maxLiquidityPerTick();
        response.factory = IUniswapV3Pool(pool).factory();

        response.tokenList = new address[](2);
        response.tokenList[0] = IUniswapV3Pool(pool).token0();
        response.tokenList[1] = IUniswapV3Pool(pool).token1();
        return response;
    }

    /// @notice Get uniV3 pool state info using pool address

    function uniV3PoolState(address pool) external view override returns (UniV3PoolStateResponse memory) {
        UniV3PoolStateResponse memory response;

        response.blockTimestamp = uint32(block.timestamp);

        bytes memory result = pool.functionStaticCall(abi.encodeWithSelector(0x3850c7bd)); // slot0 call
        (
            response.sqrtPriceX96,
            response.tick,
            response.observationIndex,
            response.observationCardinality,
            response.observationCardinalityNext,
            response.feeProtocol,

        ) = abi.decode(result, (uint160, int24, uint16, uint16, uint16, uint32, bool));

        response.liquidity = IUniswapV3Pool(pool).liquidity();

        return response;
    }

    /// @notice Get uniV3 pool tick info using pool address and tick range

    function uniV3GetTicks(IUniswapV3Pool pool, int24 tickRange) external view override returns (Tick[] memory ticks) {
        int24 tickSpacing = pool.tickSpacing();
        bytes memory result = address(pool).functionStaticCall(abi.encodeWithSelector(0x3850c7bd)); // slot0 call
        (, int24 tick, , , , , ) = abi.decode(result, (uint160, int24, uint16, uint16, uint16, uint32, bool));
        tickRange *= tickSpacing;
        int24 fromTick = tick - tickRange;
        int24 toTick = tick + tickRange;
        if (fromTick < _MIN_TICK) {
            fromTick = _MIN_TICK;
        }
        if (toTick > _MAX_TICK) {
            toTick = _MAX_TICK;
        }

        int24[] memory initTicks = new int24[](uint256(int256((toTick - fromTick + 1) / tickSpacing)) + 1);

        uint256 counter = 0;
        int16 pos = int16((fromTick / tickSpacing) >> 8);
        int16 endPos = int16((toTick / tickSpacing) >> 8);
        for (; pos <= endPos; pos++) {
            uint256 bm = pool.tickBitmap(pos);

            while (bm != 0) {
                uint8 bit = _leastSignificantBit(bm);
                bm ^= 1 << bit;
                int24 extractedTick = ((int24(pos) << 8) | int24(uint24(bit))) * tickSpacing;
                if (extractedTick >= fromTick && extractedTick <= toTick) {
                    initTicks[counter++] = extractedTick;
                }
            }
        }

        ticks = new Tick[](counter);
        for (uint256 i = 0; i < counter; i++) {
            (
                uint128 liquidityGross,
                int128 liquidityNet,
                uint256 feeGrowthOutside0X128,
                uint256 feeGrowthOutside1X128, // int56 tickCumulativeOutside, // secondsPerLiquidityOutsideX128 // uint32 secondsOutside // init
                ,
                ,
                ,

            ) = pool.ticks(initTicks[i]);

            ticks[i].liquidityGross = liquidityGross;
            ticks[i].liquidityNet = liquidityNet;
            ticks[i].feeGrowthOutside0X128 = feeGrowthOutside0X128;
            ticks[i].feeGrowthOutside1X128 = feeGrowthOutside1X128;
            ticks[i].tick = initTicks[i];
        }
    }

    /// Internal Methods ///

    ///@dev swap callback function for uniswapV3 and pancakeV3
    function _uniV3BaseSwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) internal {
        if (amount0Delta <= 0 && amount1Delta <= 0) revert GenericErrors.GenericError(GenericErrors.INVALID_AMOUNT); // swaps entirely within 0-liquidity regions are not supported
        (bytes memory path, Payer payer) = abi.decode(data, (bytes, Payer));

        // because exact output swaps are executed in reverse order, in this case tokenOut is actually tokenIn
        (address tokenIn, address tokenOut, address factory, uint24 fee) = path.decodeFirstPool();

        if (!LibAllowList.contractIsAllowed(factory)) revert GenericErrors.GenericError(GenericErrors.UN_AUTHORIZED);

        if (IUniswapV3Factory(factory).getPool(tokenIn, tokenOut, fee) != msg.sender)
            revert GenericErrors.GenericError(GenericErrors.INVALID_CALLER);

        (bool isExactInput, uint256 amountToPay) = amount0Delta > 0
            ? (tokenIn < tokenOut, uint256(amount0Delta))
            : (tokenOut < tokenIn, uint256(amount1Delta));

        if (isExactInput) {
            // Pay the pool (msg.sender)
            LibPayments.payOrPermit2Transfer(tokenIn, payer, Recipient.wrap(msg.sender), amountToPay);
        } else {
            // either initiate the next swap or pay
            if (path.hasMultiplePools()) {
                // this is an intermediate step so the payer is actually this contract
                path.skipBulk();
                _uniV3Swap(-amountToPay.toInt256(), false, path, Recipient.wrap(msg.sender), payer);
            } else {
                if (amountToPay > maxAmountInCached) revert GenericErrors.GenericError(GenericErrors.SLIPPAGE);
                // note that because exact output swaps are executed in reverse order, tokenOut is actually tokenIn
                LibPayments.payOrPermit2Transfer(tokenOut, payer, Recipient.wrap(msg.sender), amountToPay);
            }
        }
    }

    /// @dev Performs a single swap for both exactIn and exactOut
    /// For exactIn, `amount` is `amountIn`. For exactOut, `amount` is `-amountOut`
    function _uniV3Swap(
        int256 amount,
        bool isExactIn,
        bytes memory path,
        Recipient recipient,
        Payer payer
    ) private returns (int256 amount0Delta, int256 amount1Delta, bool zeroForOne) {
        (address tokenIn, address tokenOut, address factory, uint24 fee) = path.decodeFirstPool();

        zeroForOne = isExactIn ? tokenIn < tokenOut : tokenOut < tokenIn;
        (amount0Delta, amount1Delta) = IUniswapV3Pool(IUniswapV3Factory(factory).getPool(tokenIn, tokenOut, fee)).swap(
            Recipient.unwrap(recipient),
            zeroForOne,
            amount,
            (zeroForOne ? MIN_SQRT_RATIO + 1 : MAX_SQRT_RATIO - 1), // sqrt_limit
            abi.encode(path, Payer.unwrap(payer))
        );
    }

    /// @dev Gets the least significant bit
    function _leastSignificantBit(uint256 x) private pure returns (uint8 r) {
        require(x > 0, "x is 0");
        x = x & (~x + 1);

        if (x >= 0x100000000000000000000000000000000) {
            x >>= 128;
            r += 128;
        }
        if (x >= 0x10000000000000000) {
            x >>= 64;
            r += 64;
        }
        if (x >= 0x100000000) {
            x >>= 32;
            r += 32;
        }
        if (x >= 0x10000) {
            x >>= 16;
            r += 16;
        }
        if (x >= 0x100) {
            x >>= 8;
            r += 8;
        }
        if (x >= 0x10) {
            x >>= 4;
            r += 4;
        }
        if (x >= 0x4) {
            x >>= 2;
            r += 2;
        }
        if (x >= 0x2) r += 1;
    }
}
