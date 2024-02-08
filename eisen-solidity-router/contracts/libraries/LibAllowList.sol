// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {GenericErrors} from "contracts/Errors/GenericErrors.sol";

/// @title Lib Allow List
/// @author Eisen (https://app.eisenfinance.com)
/// @notice Library for managing and accessing the conract address allow list
library LibAllowList {
    /// Storage ///
    bytes32 internal constant NAMESPACE = bytes32(0x82575affb1260ff4d62c8d3716a55adbfb4f4834d17f4cc760b67cccbcb7ac69);
    // bytes32(uint256(bytes32(keccak256("com.eisen.library.allow.list")))-1);

    struct AllowListStorage {
        mapping(address => bool) allowlist;
        mapping(address => uint256) fees;
        mapping(bytes4 => bool) selectorAllowList;
        address[] contracts;
    }

    /// @dev Adds a contract address to the allow list
    /// @param _contract the contract address to add
    function addAllowedContract(address _contract) internal {
        _checkAddress(_contract);

        AllowListStorage storage als = _getStorage();

        if (als.allowlist[_contract]) return;

        als.allowlist[_contract] = true;
        als.contracts.push(_contract);
    }

    /// @dev Adds a factory address and fee pair to the allow list
    /// @param _contract the contract address to add
    /// @param _fee the fee to charge for the factory
    function addAllowedContract(address _contract, uint256 _fee) internal {
        _checkAddress(_contract);

        AllowListStorage storage als = _getStorage();

        if (als.allowlist[_contract]) {
            als.fees[_contract] = _fee;
        } else {
            als.allowlist[_contract] = true;
            als.fees[_contract] = _fee;
            als.contracts.push(_contract);
        }
    }

    /// @dev Checks whether a contract address has been added to the allow list
    /// @param _contract the contract address to check
    function contractIsAllowed(address _contract) internal view returns (bool) {
        return _getStorage().allowlist[_contract];
    }

    /// @dev Checks the fee for a contract address
    /// @param _contract the contract address to check
    function getFee(address _contract) internal view returns (uint256) {
        return _getStorage().fees[_contract];
    }

    /// @dev Remove a contract address from the allow list
    /// @param _contract the contract address to remove
    function removeAllowedContract(address _contract) internal {
        AllowListStorage storage als = _getStorage();

        if (!als.allowlist[_contract]) {
            return;
        }

        als.allowlist[_contract] = false;
        if (als.fees[_contract] > 0) {
            als.fees[_contract] = 0;
        }

        uint256 length = als.contracts.length;
        // Find the contract in the list
        for (uint256 i = 0; i < length; i++) {
            if (als.contracts[i] == _contract) {
                // Move the last element into the place to delete
                als.contracts[i] = als.contracts[length - 1];
                // Remove the last element
                als.contracts.pop();
                break;
            }
        }
    }

    /// @dev Fetch contract addresses from the allow list
    function getAllowedContracts() internal view returns (address[] memory) {
        return _getStorage().contracts;
    }

    /// @dev Add a selector to the allow list
    /// @param _selector the selector to add
    function addAllowedSelector(bytes4 _selector) internal {
        _getStorage().selectorAllowList[_selector] = true;
    }

    /// @dev Removes a selector from the allow list
    /// @param _selector the selector to remove
    function removeAllowedSelector(bytes4 _selector) internal {
        _getStorage().selectorAllowList[_selector] = false;
    }

    /// @dev Returns if selector has been added to the allow list
    /// @param _selector the selector to check
    function selectorIsAllowed(bytes4 _selector) internal view returns (bool) {
        return _getStorage().selectorAllowList[_selector];
    }

    /// @dev Fetch local storage struct
    function _getStorage() internal pure returns (AllowListStorage storage als) {
        bytes32 position = NAMESPACE;
        // solhint-disable-next-line no-inline-assembly
        assembly ("memory-safe") {
            als.slot := position
        }
    }

    /// @dev Contains business logic for validating a contract address.
    /// @param _contract address of the dex to check
    function _checkAddress(address _contract) private view {
        if (_contract == address(0)) revert GenericErrors.GenericError(GenericErrors.INVALID_CONTRACT);

        if (_contract.code.length == 0) revert GenericErrors.GenericError(GenericErrors.INVALID_CONTRACT);
    }
}
