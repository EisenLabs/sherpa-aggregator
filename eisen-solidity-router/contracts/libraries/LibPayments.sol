// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {GenericErrors} from "contracts/Errors/GenericErrors.sol";
import {SafeCast160} from "permit2/src/libraries/SafeCast160.sol";

import {SafeTransferLib} from "contracts/Libraries/SafeTransferLib.sol";
import {Constants} from "contracts/Libraries/Constants.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC1155} from "solmate/tokens/ERC1155.sol";
import {IWETH9} from "contracts/Interfaces/IWETH9.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";
import {UniERC20} from "contracts/Libraries/UniERC20.sol";

type Recipient is address;
type Payer is address;

/// @title Payments Library
/// @author Eisen (https://app.eisenfinance.com)
/// @notice Provides functionality for transferring assets
library LibPayments {
    using SafeTransferLib for address;
    using SafeCast160 for uint256;
    using UniERC20 for address;
    /// Types ///
    bytes32 internal constant NAMESPACE = bytes32(0x6a2b33915c87ebbd2e7a47520fe4aaa6f0e18ef6bdebd64915d7aeced08d447e);
    // bytes32(uint256(bytes32(keccak256("com.eisen.library.payments")))-1);

    uint256 internal constant FEE_BIPS_BASE = 10_000;

    /// Storage ///
    struct PaymentStorage {
        uint256 fee;
        address feeCollector;
        address WETH9;
        address PERMIT2;
        bool initialized;
    }

    /// Events ///
    event FeeChanged(uint256 feeOld, uint256 feeNew);
    event FeeCollectorChanged(address feeCollectorOld, address feeCollectorNew);
    event PaymentInitialized(address indexed weth9, address indexed permit2, address indexed feeCollector, uint256 fee);

    /// @dev Fetch local storage
    function paymentStorage() internal pure returns (PaymentStorage storage payStor) {
        bytes32 position = NAMESPACE;
        // solhint-disable-next-line no-inline-assembly
        assembly ("memory-safe") {
            payStor.slot := position
        }
    }

    /// @notice Set fee bips
    /// @param fee fee portion in bips
    function setFee(uint256 fee) internal {
        PaymentStorage storage payStor = paymentStorage();
        if (fee > FEE_BIPS_BASE / 10) {
            revert GenericErrors.GenericError(GenericErrors.INVALID_FEE_AMOUNT);
        }
        emit FeeChanged(payStor.fee, fee);
        payStor.fee = fee;
    }

    /// @notice Set fee collector
    /// @param feeCollector The address of feeCollector
    function changeFeeCollector(address feeCollector) internal {
        PaymentStorage storage payStor = paymentStorage();
        emit FeeCollectorChanged(payStor.feeCollector, feeCollector);
        payStor.feeCollector = feeCollector;
    }

    /// @notice Initializes parameters for transferring assets
    /// @param weth9 The address of wrapped native token
    /// @param permit2 The address of permit2 contract
    function initializePayment(address weth9, address permit2, address feeCollector, uint256 fee) internal {
        PaymentStorage storage payStor = paymentStorage();
        if (!payStor.initialized) {
            payStor.WETH9 = weth9;
            payStor.PERMIT2 = permit2;
            payStor.feeCollector = feeCollector;
            payStor.fee = fee;
            payStor.initialized = true;
        } else {
            revert GenericErrors.GenericError(GenericErrors.ALREADY_INITIALIZED);
        }
        emit PaymentInitialized(weth9, permit2, feeCollector, fee);
    }

    /// @notice Gets the address of wrapped native token
    /// @return The address of wrapped native token
    function WETH() internal view returns (address) {
        return paymentStorage().WETH9;
    }

    /// @notice Calculates the recipient address for a command
    /// @param recipient The recipient or recipient-flag for the command
    /// @return outRecipient The resultant recipient for the command
    function map(Recipient recipient) internal view returns (Recipient outRecipient) {
        if (Recipient.unwrap(recipient) == Constants.MSG_SENDER) {
            outRecipient = Recipient.wrap(msg.sender);
        } else if (Recipient.unwrap(recipient) == Constants.ADDRESS_THIS) {
            outRecipient = Recipient.wrap(address(this));
        } else if (UniERC20.isETH(Recipient.unwrap(recipient))) {
            // ETH is a special case, it is not a valid recipient(address(0))
            outRecipient = Recipient.wrap(msg.sender);
        } else {
            outRecipient = recipient;
        }
    }

    /// @notice Calculates the payer address for a command
    /// @param payer The payer-flag for the command
    /// @return outPayer The resultant payer for the command
    function payerMap(Payer payer) internal view returns (Payer outPayer) {
        if (Payer.unwrap(payer) == Constants.MSG_SENDER) {
            outPayer = Payer.wrap(msg.sender);
        } else if (Payer.unwrap(payer) == Constants.ADDRESS_THIS) {
            outPayer = Payer.wrap(address(this));
        } else {
            revert GenericErrors.GenericError(GenericErrors.INVALID_PARAMS);
        }
    }

    /// @notice Pays an amount of ETH or ERC20 to a recipient
    /// @param token The token to pay (can be ETH using Constants.ETH)
    /// @param recipient The Recipient that will receive the payment
    /// @param value The amount to pay
    function pay(address token, Recipient recipient, uint256 value) internal {
        if (Recipient.unwrap(recipient) == address(this)) return;
        if (token.isETH()) {
            Recipient.unwrap(recipient).safeTransferETH(value);
        } else {
            if (value == Constants.CONTRACT_BALANCE) {
                value = token.balanceOf(address(this));
            }

            token.safeTransfer(Recipient.unwrap(recipient), value);
        }
    }

    /// @notice Pays a proportion of the contract's ETH or ERC20 to a recipient
    /// @param token The token to pay (can be ETH using Constants.ETH)
    /// @param recipient The Recipient that will receive payment
    /// @param bips Portion in bips of whole balance of the contract
    function payPortion(address token, Recipient recipient, uint256 bips) internal {
        if (bips == 0 || bips > 10_000) revert GenericErrors.GenericError(GenericErrors.INVALID_BIPS);
        if (token.isETH()) {
            uint256 balance = address(this).balance;
            uint256 amount = (balance * bips) / FEE_BIPS_BASE;
            Recipient.unwrap(recipient).safeTransferETH(amount);
        } else {
            uint256 balance = ERC20(token).balanceOf(address(this));
            uint256 amount = (balance * bips) / FEE_BIPS_BASE;
            // pay with tokens already in the contract (for the exact input multihop case)
            token.safeTransfer(Recipient.unwrap(recipient), amount);
        }
    }

    /// @notice Sweeps all of the contract's ERC20 or ETH to an address
    /// @param token The token to sweep (can be ETH using Constants.ETH)
    /// @param recipient The address that will receive payment
    /// @param amountMinimum The minimum desired amount
    function sweep(address token, Recipient recipient, uint256 amountMinimum) internal {
        uint256 balance;
        if (token.isETH()) {
            balance = address(this).balance;
            if (balance < amountMinimum) revert GenericErrors.GenericError(GenericErrors.INSUFFICIENT_VALUE);
            if (balance > 0) Recipient.unwrap(recipient).safeTransferETH(balance);
        } else {
            balance = token.balanceOf(address(this));
            if (balance < amountMinimum) revert GenericErrors.GenericError(GenericErrors.INSUFFICIENT_TOKEN);
            if (balance > 0) token.safeTransfer(Recipient.unwrap(recipient), balance);
        }
    }

    /// @notice Sweeps an ERC721 to a recipient from the contract
    /// @param token The ERC721 token to sweep
    /// @param recipient The address that will receive payment
    /// @param id The ID of the ERC721 to sweep
    function sweepERC721(address token, Recipient recipient, uint256 id) internal {
        ERC721(token).safeTransferFrom(address(this), Recipient.unwrap(recipient), id);
    }

    /// @notice Sweeps all of the contract's ERC1155 to an address
    /// @param token The ERC1155 token to sweep
    /// @param recipient The address that will receive payment
    /// @param id The ID of the ERC1155 to sweep
    /// @param amountMinimum The minimum desired amount
    function sweepERC1155(address token, Recipient recipient, uint256 id, uint256 amountMinimum) internal {
        uint256 balance = ERC1155(token).balanceOf(address(this), id);
        if (balance < amountMinimum) revert GenericErrors.GenericError(GenericErrors.INSUFFICIENT_TOKEN);
        ERC1155(token).safeTransferFrom(address(this), Recipient.unwrap(recipient), id, balance, bytes(""));
    }

    /// @notice Wraps an amount of ETH into WETH
    /// @param recipient The recipient of the WETH
    /// @param amount The amount to wrap (can be CONTRACT_BALANCE)
    function wrapETH(Recipient recipient, uint256 amount) internal returns (uint256 amountOut) {
        if (amount == Constants.CONTRACT_BALANCE) {
            amount = address(this).balance;
        } else if (amount > address(this).balance) {
            revert GenericErrors.GenericError(GenericErrors.INSUFFICIENT_VALUE);
        }
        if (amount > 0) {
            PaymentStorage storage ps = paymentStorage();

            IWETH9(ps.WETH9).deposit{value: amount}();
            if (Recipient.unwrap(recipient) != address(this)) {
                IWETH9(ps.WETH9).transfer(Recipient.unwrap(recipient), amount);
            }
        }
        amountOut = amount;
    }

    /// @notice Unwraps the amount of the contract's WETH into ETH
    /// @param recipient The recipient of the ETH
    /// @param amount The minimum amount of ETH desired
    function unwrapWETH9(Recipient recipient, uint256 amount) internal returns (uint256 amountOut) {
        PaymentStorage storage ps = paymentStorage();

        if (IWETH9(ps.WETH9).balanceOf(address(this)) < amount) {
            revert GenericErrors.GenericError(GenericErrors.INSUFFICIENT_VALUE);
        }
        IWETH9(ps.WETH9).withdraw(amount);
        if (Recipient.unwrap(recipient) != address(this)) {
            Recipient.unwrap(recipient).safeTransferETH(amount);
        }
        amountOut = amount;
    }

    /// @notice Performs a approve function on Permit2
    /// @param token The token address
    /// @param spender The spender address
    function approveMax(address token, address spender, uint256 amount) internal {
        PaymentStorage storage ps = paymentStorage();
        (uint256 allowance, , ) = IAllowanceTransfer(ps.PERMIT2).allowance(address(this), token, spender);
        if (allowance < amount) {
            IAllowanceTransfer(ps.PERMIT2).approve(token, spender, type(uint160).max, type(uint48).max);
        }
    }

    /// @notice Performs a approve function on Permit2
    /// @param token The token address
    /// @param spender The spender address
    function approveWithOutExpiration(address token, address spender, uint256 amount) internal {
        PaymentStorage storage ps = paymentStorage();
        IAllowanceTransfer(ps.PERMIT2).approve(token, spender, amount.toUint160(), type(uint48).max);
    }

    /// @notice Performs a permit function on Permit2
    /// @param owner The token owner address
    /// @param permitSingle A single of permit description
    /// @param signature A single of permit data with signature
    function permit(
        address owner,
        IAllowanceTransfer.PermitSingle memory permitSingle,
        bytes memory signature
    ) internal {
        PaymentStorage storage ps = paymentStorage();

        IAllowanceTransfer(ps.PERMIT2).permit(owner, permitSingle, signature);
    }

    /// @notice Performs a batch permit function on Permit2
    /// @param owner The token owner address
    /// @param permitBatch A batch of permit descriptions
    /// @param signature A batch of permit data with signature
    function permit(address owner, IAllowanceTransfer.PermitBatch memory permitBatch, bytes memory signature) internal {
        PaymentStorage storage ps = paymentStorage();

        IAllowanceTransfer(ps.PERMIT2).permit(owner, permitBatch, signature);
    }

    /// @notice Performs a transferFrom on Permit2
    /// @param token The token to transfer
    /// @param from The address to transfer from
    /// @param to The recipient of the transfer
    /// @param amount The amount to transfer
    function permit2TransferFrom(address token, address from, address to, uint160 amount) internal {
        _permit2TransferFrom(token, from, to, amount);
    }

    /// @notice Performs a batch transferFrom on Permit2
    /// @param batchDetails An array detailing each of the transfers that should occur
    function permit2TransferFrom(IAllowanceTransfer.AllowanceTransferDetails[] memory batchDetails) internal {
        address owner = msg.sender;
        uint256 batchLength = batchDetails.length;
        PaymentStorage storage ps = paymentStorage();

        for (uint256 i = 0; i < batchLength; ++i) {
            if (batchDetails[i].from != owner) revert GenericErrors.GenericError(GenericErrors.FROM_ADDR_IS_NOT_OWNER);
        }
        for (uint256 i = 0; i < batchLength; ++i) {
            _permit2TransferFrom(
                batchDetails[i].token,
                batchDetails[i].from,
                batchDetails[i].to,
                batchDetails[i].amount
            );
        }
    }

    /// @notice Either performs a regular payment or transferFrom on Permit2, depending on the payer address
    /// @param token The token to transfer
    /// @param payer The address to pay for the transfer
    /// @param recipient The recipient of the transfer
    /// @param amount The amount to transfer
    function payOrPermit2Transfer(address token, Payer payer, Recipient recipient, uint256 amount) internal {
        if (Payer.unwrap(payer) == address(this)) pay(token, recipient, amount);
        else payFrom(token, payer, recipient, amount.toUint160());
    }

    /// @notice Performs a transferFrom on Permit2
    /// @param token The token to transfer
    /// @param payer The address to pay for the transfer
    /// @param recipient The recipient of the transfer
    /// @param amount The amount to transfer
    function payFrom(address token, Payer payer, Recipient recipient, uint256 amount) internal {
        if (Payer.unwrap(payer) == Recipient.unwrap(recipient)) return;
        if (!token.isETH()) {
            _permit2TransferFrom(token, Payer.unwrap(payer), Recipient.unwrap(recipient), amount.toUint160());
        }
    }

    /// @notice Performs a transferFrom on Permit2 internally
    /// @param token The token to transfer
    /// @param from The address to transfer from
    /// @param to The recipient of the transfer
    /// @param amount The amount to transfer
    function _permit2TransferFrom(address token, address from, address to, uint160 amount) internal {
        if (from == to) return;
        PaymentStorage storage ps = paymentStorage();
        IAllowanceTransfer(ps.PERMIT2).transferFrom(from, to, amount, token);
    }
}
