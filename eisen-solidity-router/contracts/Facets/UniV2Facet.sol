// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import {LibPayments, Recipient, Payer} from "contracts/Libraries/LibPayments.sol";

import {LibAllowList} from "contracts/Libraries/LibAllowList.sol";
import {GenericErrors} from "contracts/Errors/GenericErrors.sol";
import {Constants} from "contracts/Libraries/Constants.sol";

import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "contracts/Interfaces/IUni.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

import {UniERC20} from "contracts/Libraries/UniERC20.sol";

/// @title UniV2Facet
/// @author Eisen (https://app.eisenfinance.com)
/// @notice Provides functionality for UniswapV2 protocol
/// @custom:version 1.0.0
contract UniV2Facet is IUniswapV2Viewer {
    using UniERC20 for address;
    using LibPayments for Payer;
    using LibPayments for Recipient;

    /// @notice Performs a Uniswap v2 exact input swap
    /// @dev  To Use Uni swap with ETH, the ETH must be wrapped before calling it
    /// @param amountIn The amount of input tokens for the trade
    /// @param router The address of router if address(0) uses pair directly
    /// @param path The path of the trade as an array of token [-token] addresses
    /// @param recipient The recipient of the output tokens
    /// @param payer The address that will be paying the input
    /// @return inputToken The address of input token
    /// @return outputToken The address of output token
    /// @return amountOut The amount of output tokens for the trade
    function uniV2SwapExactInput(
        uint256 amountIn,
        address router,
        address[] memory path,
        Recipient recipient,
        Payer payer
    ) public payable returns (address inputToken, address outputToken, uint256 amountOut) {
        inputToken = path[0];
        payer = payer.payerMap();
        recipient = recipient.map();
        if (router == address(0)) {
            if (path.length < 3) revert GenericErrors.GenericError(GenericErrors.INVALID_PATH);
            address firstPair = IUniswapV2Factory(path[1]).getPair(inputToken, path[2]);
            if (
                amountIn != Constants.ALREADY_PAID // amountIn of 0 to signal that the pair already has the tokens
            ) {
                LibPayments.payOrPermit2Transfer(inputToken, payer, Recipient.wrap(firstPair), amountIn);
            }

            outputToken = path[path.length - 1];

            uint256 balanceBefore = outputToken.uniBalanceOf(Recipient.unwrap(recipient));
            _v2Swap(path, recipient, firstPair);

            amountOut = outputToken.uniBalanceOf(Recipient.unwrap(recipient)) - balanceBefore;
        } else {
            if (
                amountIn != Constants.ALREADY_PAID // amountIn of 0 to signal that the pair already has the tokens
            ) {
                LibPayments.payOrPermit2Transfer(inputToken, payer, Recipient.wrap(address(this)), amountIn);
            }

            if (!LibAllowList.contractIsAllowed(router)) revert GenericErrors.GenericError(GenericErrors.UN_AUTHORIZED);

            inputToken.uniApproveMax(router, amountIn);
            outputToken = path[path.length - 1];
            uint256[] memory amountOuts = Router(router).swapExactTokensForTokens(
                amountIn,
                1,
                path,
                Recipient.unwrap(recipient),
                type(uint256).max
            );

            amountOut = amountOuts[amountOuts.length - 1];
        }
        if (amountOut == 0) revert GenericErrors.GenericError(GenericErrors.OVERFLOW_UNDERFLOW);
    }

    /// View Methods ///

    /// @notice Get deployed pair num from factory
    function uniV2PoolNum(address factory) external view override returns (uint256) {
        return IUniswapV2Factory(factory).allPairsLength();
    }

    /// @notice Get deployed pair addresses by indexing
    function uniV2Pools(address factory, uint256 start, uint256 end) external view override returns (address[] memory) {
        uint256 maxEnd = IUniswapV2Factory(factory).allPairsLength();
        if (end > maxEnd) {
            end = maxEnd;
        }
        uint256 length = end - start;
        address[] memory _pools = new address[](length);
        for (uint256 i = 0; i < length; i++) {
            _pools[i] = IUniswapV2Factory(factory).allPairs(start + i);
        }
        return _pools;
    }

    /// @notice Get uniV2 pool param info using pool address
    function uniV2PoolParams(address pool) external view override returns (UniV2PoolParamsResponse memory) {
        UniV2PoolParamsResponse memory response;
        response.pool = pool;
        response.factory = IUniswapV2Pair(pool).factory();
        response.tokenList = new address[](2);
        response.tokenList[0] = IUniswapV2Pair(pool).token0();
        response.tokenList[1] = IUniswapV2Pair(pool).token1();
        response.fees = new uint256[](3);
        // uniswapV2 is 3000
        response.fees[0] = LibAllowList.getFee(response.factory);
        // response.fees[1] is fee denominator
        response.fees[1] = 1000000;
        // response.fees[2] is on-off switch of UniswapV2 fee
        response.fees[2] = IUniswapV2Factory(response.factory).feeTo() == address(0) ? 0 : 1;

        return response;
    }

    /// @notice Get uniV2 pool state info using pool address
    function uniV2PoolState(address pool) external view override returns (UniV2PoolStateResponse memory) {
        UniV2PoolStateResponse memory response;
        response.balances = new uint256[](2);
        (response.balances[0], response.balances[1], ) = IUniswapV2Pair(pool).getReserves();
        response.totalSupply = ERC20(pool).totalSupply();

        if (response.balances[0] == 0 || response.balances[1] == 0) {
            response.paused = true;
        }
        return response;
    }

    ///@dev Swap tokens on Uniswap v2
    function _v2Swap(address[] memory path, Recipient recipient, address pair) private {
        unchecked {
            // cached to save on duplicate operations
            (address token0, ) = UniswapV2Library.sortTokens(path[0], path[2]);
            uint256 pathUltiIndex = path.length - 3;
            for (uint256 i; i < path.length - 1; i = i + 2) {
                (address input, address output) = (path[i], path[i + 2]);

                (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair).getReserves();
                (uint256 reserveInput, uint256 reserveOutput) = input == token0
                    ? (reserve0, reserve1)
                    : (reserve1, reserve0);

                uint256 amountInput = ERC20(input).balanceOf(pair) - reserveInput;
                uint256 amountOutput = getAmountOut(path[i + 1], amountInput, reserveInput, reserveOutput);
                (uint256 amount0Out, uint256 amount1Out) = input == token0
                    ? (uint256(0), amountOutput)
                    : (amountOutput, uint256(0));

                address nextPair;
                (nextPair, token0) = i < pathUltiIndex
                    ? UniswapV2Library.pairAndToken0For(path[i + 3], output, path[i + 4])
                    : (Recipient.unwrap(recipient), address(0));

                IUniswapV2Pair(pair).swap(amount0Out, amount1Out, nextPair, new bytes(0));
                pair = nextPair;
            }
        }
    }

    ///@dev Calculate the amount of output tokens for a given input amount and pair info
    ///@param factory The address of the Uniswap v2 factory
    ///@param amountIn The amount of input tokens for the trade
    ///@param reserveIn The amount of input tokens in the pair
    ///@param reserveOut The amount of output tokens in the pair
    ///@return amountOut The amount of output tokens for the trade
    function getAmountOut(
        address factory,
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) private view returns (uint256 amountOut) {
        if (reserveIn == 0 || reserveOut == 0) revert GenericErrors.GenericError(GenericErrors.INVALID_PATH);

        uint256 fee = LibAllowList.getFee(factory);
        if (!LibAllowList.contractIsAllowed(factory)) revert GenericErrors.GenericError(GenericErrors.UN_AUTHORIZED);

        if (fee % 1000 == 0) {
            uint256 amountInWithFee = amountIn * (1000 - fee / 1000);
            uint256 numerator = reserveOut * amountInWithFee;
            uint256 denominator = (reserveIn * 1000) + amountInWithFee;
            amountOut = numerator / denominator;
        } else if (fee % 100 == 0) {
            uint256 amountInWithFee = amountIn * (10000 - fee / 100);
            uint256 numerator = amountInWithFee * reserveOut;
            uint256 denominator = reserveIn * 10000 + amountInWithFee;
            amountOut = numerator / denominator;
        } else {
            uint256 amountInWithFee = amountIn * (100000 - fee / 10);
            uint256 numerator = amountInWithFee * reserveOut;
            uint256 denominator = reserveIn * 100000 + amountInWithFee;
            amountOut = numerator / denominator;
        }
    }
}

/// @title Uniswap v2 Helper Library
/// @notice Calculates the recipient address for a command
library UniswapV2Library {
    /// @notice Calculates the v2 address for a pair without making any external calls
    /// @param factory The address of the v2 factory
    /// @param tokenA One of the tokens in the pair
    /// @param tokenB The other token in the pair
    /// @return pair The resultant v2 pair address
    function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
        pair = IUniswapV2Factory(factory).getPair(tokenA, tokenB);
    }

    /// @notice Calculates the v2 address for a pair and the pair's token0
    /// @param factory The address of the v2 factory
    /// @param tokenA One of the tokens in the pair
    /// @param tokenB The other token in the pair
    /// @return pair The resultant v2 pair address
    /// @return token0 The token considered token0 in this pair
    function pairAndToken0For(
        address factory,
        address tokenA,
        address tokenB
    ) internal view returns (address pair, address token0) {
        address token1;
        (token0, token1) = sortTokens(tokenA, tokenB);
        pair = IUniswapV2Factory(factory).getPair(tokenA, tokenB);
    }

    /// @notice Sorts two tokens to return token0 and token1
    /// @param tokenA The first token to sort
    /// @param tokenB The other token to sort
    /// @return token0 The smaller token by address value
    /// @return token1 The larger token by address value
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    }

    // fetches and sorts the reserves for a pair
    function getReserves(
        address factory,
        address tokenA,
        address tokenB
    ) internal view returns (uint reserveA, uint reserveB) {
        (address token0, ) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1, ) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }
}
