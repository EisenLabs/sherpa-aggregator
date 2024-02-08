// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library GenericErrors {
    error DiffError(uint256 errorCode, uint256 stdValue, uint256 realValue); // 0dd10eb1
    error GenericError(uint256 errorCode); // 948ac503
    uint256 public constant ALREADY_INITIALIZED = 1;
    uint256 public constant CANNOT_AUTHORIZE_SELF = 2;
    uint256 public constant CANNOT_BRIDGE_TO_SAME_NETWORK = 3;
    uint256 public constant CONTRACT_CALL_NOT_ALLOWED = 4;
    uint256 public constant WITHDRAW_FAILED = 5;
    uint256 public constant EXTERNAL_CALL_FAILED = 6;
    uint256 public constant INFORMATION_MISMATCH = 7;
    uint256 public constant ZERO_AMOUNT = 8;
    uint256 public constant INVALID_AMOUNT = 9;
    uint256 public constant INSUFFICIENT_VALUE = 10;
    uint256 public constant INSUFFICIENT_TOKEN = 11;
    uint256 public constant INSUFFICIENT_BALANCE = 12;

    uint256 public constant INVALID_DESTINATION_CHAIN = 13;
    uint256 public constant INVALID_FALLBACK_ADDRESS = 14;
    uint256 public constant INVALID_RECEIVER = 15;
    uint256 public constant INVALID_SENDING_TOKEN = 16;
    uint256 public constant NATIVE_ASSET_NOT_SUPPORTED = 17;
    uint256 public constant NATIVE_ASSET_TRANSFER_FAILED = 18;
    uint256 public constant NO_SWAP_DATA_PROVIDED = 19;
    uint256 public constant NO_SWAP_FROM_ZERO_BALANCE = 20;
    uint256 public constant NOT_A_CONTRACT = 21;
    uint256 public constant NOT_INITIALIZED = 22;
    uint256 public constant NO_TRANSFER_TO_NULL_ADDRESS = 23;
    uint256 public constant NULL_ADDR_IS_NOT_AN_ERC20_TOKEN = 24;
    uint256 public constant NULL_ADDR_IS_NOT_A_VALID_SPENDER = 25;
    uint256 public constant ONLY_CONTRACT_OWNER = 26;
    uint256 public constant RECOVERY_ADDRESS_CANNOT_BE_ZERO = 27;
    uint256 public constant REENTRANCY_ERROR = 28;
    uint256 public constant TOKEN_NOT_SUPPORTED = 29;
    uint256 public constant REENTRANCY_LOCKED = 30;
    uint256 public constant UNSUPPORTED_CHAIN_ID = 31;
    uint256 public constant UN_AUTHORIZED = 32;

    uint256 public constant INVALID_CALL_DATA = 33;
    uint256 public constant INVALID_CONFIG = 34;
    uint256 public constant INVALID_CALLER = 35;
    uint256 public constant INVALID_CONTRACT = 36;
    uint256 public constant INVALID_BIPS = 37;
    uint256 public constant INVALID_PARAMS = 38;
    uint256 public constant INVALID_INITIATOR = 39;
    uint256 public constant INVALID_POOL = 40;
    uint256 public constant INVALID_TOKEN = 41;
    uint256 public constant INVALID_INPUT_TOKEN = 42;
    uint256 public constant INVALID_PATH = 43;
    uint256 public constant INVALID_BATCH_PATH = 44;
    uint256 public constant INVALID_FEE_AMOUNT = 45;
    uint256 public constant DEADLINE = 46;
    uint256 public constant LENGTH_MISMATCH = 47;
    uint256 public constant OVERFLOW_UNDERFLOW = 48;
    uint256 public constant FROM_ADDR_IS_NOT_OWNER = 49;

    uint256 public constant UNI3_SLICE_OUT_OF_BOUNDS = 50;
    uint256 public constant UNI3_SLICE_OVERFLOW = 51;
    uint256 public constant UNI3_NO_SLICE = 52;
    uint256 public constant UNI3_TO_UINT24_OUT_OF_BOUNDS = 53;
    uint256 public constant UNI3_TO_UINT24_OVERFLOW = 54;
    uint256 public constant UNI3_TO_ADDRESS_OVERFLOW = 55;
    uint256 public constant UNI3_TO_ADDRESS_OUT_OF_BOUNDS = 56;

    uint256 public constant MAVERICK_TO_UINT256_OVERFLOW = 60;
    uint256 public constant MAVERICK_TO_UINT256_OUT_OF_BOUNDS = 61;

    uint256 public constant MAVERICK_TO_INT256_OVERFLOW = 62;
    uint256 public constant MAVERICK_TO_INT256_OUT_OF_BOUNDS = 63;
    uint256 public constant SLIPPAGE = 101;
}
