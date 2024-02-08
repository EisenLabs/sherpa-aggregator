// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "./SafeTransferLib.sol";

library UniERC20 {
    using SafeTransferLib for address;
    address internal constant ZERO_ADDRESS = address(0);
    address internal constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    address internal constant MATIC_ADDRESS = address(0x0000000000000000000000000000000000001010);

    function uniApprove(address token, address to, uint256 amount) internal {
        if (!isETH(token)) {
            if (amount == 0) {
                token.safeApproveWithRetry(to, 0);
            } else {
                uint256 allowance = ERC20(token).allowance(address(this), to);
                token.safeApproveWithRetry(to, amount);
            }
        }
    }

    function uniApproveMax(address token, address to, uint256 amount) internal {
        if (!isETH(token)) {
            uint256 allowance = ERC20(token).allowance(address(this), to);
            token.safeApproveWithRetry(to, type(uint256).max);
        }
    }

    function uniTransfer(address token, address payable to, uint256 amount) internal {
        if (amount > 0) {
            if (isETH(token)) {
                to.call{value: amount}("");
            } else {
                token.safeTransfer(to, amount);
            }
        }
    }

    function uniBalanceOf(address token, address account) internal view returns (uint256) {
        if (isETH(token)) {
            return account.balance;
        } else {
            return token.balanceOf(account);
        }
    }

    function isETH(address token) internal pure returns (bool) {
        return
            address(token) == address(ETH_ADDRESS) ||
            address(token) == address(MATIC_ADDRESS) ||
            address(token) == address(ZERO_ADDRESS);
    }
}
