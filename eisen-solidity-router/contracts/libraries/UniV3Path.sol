// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import {BytesLib} from "./BytesLib.sol";

/// @title Functions for manipulating path data for multihop swaps
library UniV3Path {
    using BytesLib for bytes;

    /// @dev The length of the bytes encoded address
    uint256 private constant ADDR_SIZE = 20;

    /// @dev The length of the bytes encoded fee
    uint256 private constant FEE_SIZE = 3;

    /// @dev The offset of a single token address, a factory address, and pool fee
    uint256 private constant NEXT_OFFSET = 2 * ADDR_SIZE + FEE_SIZE;

    /// @dev The offset of an encoded pool key
    uint256 private constant POP_OFFSET = NEXT_OFFSET + ADDR_SIZE;

    /// @dev The minimum length of an encoding that contains 2 or more pools
    uint256 private constant MULTIPLE_POOLS_MIN_LENGTH = POP_OFFSET + NEXT_OFFSET;

    /// @notice Returns true iff the path contains two or more pools
    /// @param path The encoded swap path
    /// @return True if path contains two or more pools, otherwise false
    function hasMultiplePools(bytes memory path) internal pure returns (bool) {
        return path.length >= MULTIPLE_POOLS_MIN_LENGTH;
    }

    /// @notice Decodes the first pool in path
    /// @param path The bytes encoded swap path
    /// @return tokenA The first token of the given pool
    /// @return tokenB The second token of the given pool
    /// @return factory The factory of the pool
    /// @return fee The fee level of the pool
    function decodeFirstPool(
        bytes memory path
    ) internal pure returns (address tokenA, address tokenB, address factory, uint24 fee) {
        uint256 bytesLength = path.length;
        tokenA = path.toAddress(0, bytesLength);
        factory = path.toAddress(ADDR_SIZE, bytesLength);
        fee = path.toUint24(2 * ADDR_SIZE, bytesLength);
        tokenB = path.toAddress(NEXT_OFFSET, bytesLength);
    }

    /// @notice Gets the segment corresponding to the first pool in the path
    /// @param path The bytes encoded swap path
    /// @return The segment containing all data necessary to target the first pool in the path
    function getFirstPool(bytes memory path) internal pure returns (bytes memory) {
        return path.slicePool();
    }

    function decodeFirstToken(bytes memory path) internal pure returns (address tokenA) {
        tokenA = path.toAddress(0, path.length);
    }

    function decodeLastToken(bytes memory path) internal pure returns (address tokenA) {
        tokenA = path.toAddress(NEXT_OFFSET, path.length);
    }

    /// @notice Skips a token + factory + fee element from the buffer in place
    /// @param path The swap path
    function skipBulk(bytes memory path) internal pure {
        path.inPlaceSliceBulk(path.length - NEXT_OFFSET);
    }
}
