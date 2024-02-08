#!/usr/bin/env bash

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !
# ! Note:
# !
# ! THIS SCRIPT HAS BEEN AUTOMATICALLY GENERATED USING
# ! swagger-codegen (https://github.com/swagger-api/swagger-codegen)
# ! FROM SWAGGER SPECIFICATION IN JSON.
# !
# !
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#
# This is a Bash client for Gnosis Safe Transaction Service API.
#
# LICENSE:
# 
#
# CONTACT:
# safe@gnosis.io
#
# MORE INFORMATION:
# 
#

# For improved pattern matching in case statemets
shopt -s extglob

###############################################################################
#
# Make sure Bash is at least in version 4.3
#
###############################################################################
if ! ( (("${BASH_VERSION:0:1}" == "4")) && (("${BASH_VERSION:2:1}" >= "3")) ) \
  && ! (("${BASH_VERSION:0:1}" >= "5")); then
    echo ""
    echo "Sorry - your Bash version is ${BASH_VERSION}"
    echo ""
    echo "You need at least Bash 4.3 to run this script."
    echo ""
    exit 1
fi

###############################################################################
#
# Global variables
#
###############################################################################

##
# The filename of this script for help messages
script_name=$(basename "$0")

##
# Map for headers passed after operation as KEY:VALUE
declare -A header_arguments


##
# Map for operation parameters passed after operation as PARAMETER=VALUE
# These will be mapped to appropriate path or query parameters
# The values in operation_parameters are arrays, so that multiple values
# can be provided for the same parameter if allowed by API specification
declare -A operation_parameters

##
# Declare colors with autodection if output is terminal
if [ -t 1 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    MAGENTA="$(tput setaf 5)"
    CYAN="$(tput setaf 6)"
    WHITE="$(tput setaf 7)"
    BOLD="$(tput bold)"
    OFF="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGENTA=""
    CYAN=""
    WHITE=""
    BOLD=""
    OFF=""
fi

declare -a result_color_table=( "$WHITE" "$WHITE" "$GREEN" "$YELLOW" "$WHITE" "$MAGENTA" "$WHITE" )

##
# This array stores the minimum number of required occurrences for parameter
# 0 - optional
# 1 - required
declare -A operation_parameters_minimum_occurrences
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::safe"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::to"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::value__lt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::value__gt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::value__lte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::value__gte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::value"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::operation"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::failed"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__lt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__gt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__lte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__gte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__lt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__gt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__lte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__gte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__lt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__gt"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__lte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__gte"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_token"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::refund_receiver"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsByOriginList:::trusted"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsBySafeList:::master_copy"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsBySafeList:::limit"]=0
operation_parameters_minimum_occurrences["analyticsMultisigTransactionsBySafeList:::offset"]=0
operation_parameters_minimum_occurrences["contractsList:::ordering"]=0
operation_parameters_minimum_occurrences["contractsList:::limit"]=0
operation_parameters_minimum_occurrences["contractsList:::offset"]=0
operation_parameters_minimum_occurrences["contractsRead:::address"]=1
operation_parameters_minimum_occurrences["multisigTransactionsConfirmationsCreate:::safe_tx_hash"]=1
operation_parameters_minimum_occurrences["multisigTransactionsConfirmationsCreate:::data"]=1
operation_parameters_minimum_occurrences["multisigTransactionsConfirmationsList:::safe_tx_hash"]=1
operation_parameters_minimum_occurrences["multisigTransactionsConfirmationsList:::limit"]=0
operation_parameters_minimum_occurrences["multisigTransactionsConfirmationsList:::offset"]=0
operation_parameters_minimum_occurrences["multisigTransactionsRead:::safe_tx_hash"]=1
operation_parameters_minimum_occurrences["notificationsDevicesCreate:::data"]=1
operation_parameters_minimum_occurrences["notificationsDevicesDelete:::uuid"]=1
operation_parameters_minimum_occurrences["notificationsDevicesSafesDelete:::address"]=1
operation_parameters_minimum_occurrences["notificationsDevicesSafesDelete:::uuid"]=1
operation_parameters_minimum_occurrences["ownersRead:::address"]=1
operation_parameters_minimum_occurrences["safesAllTransactionsList:::address"]=1
operation_parameters_minimum_occurrences["safesAllTransactionsList:::ordering"]=0
operation_parameters_minimum_occurrences["safesAllTransactionsList:::limit"]=0
operation_parameters_minimum_occurrences["safesAllTransactionsList:::offset"]=0
operation_parameters_minimum_occurrences["safesAllTransactionsList:::queued"]=0
operation_parameters_minimum_occurrences["safesAllTransactionsList:::trusted"]=0
operation_parameters_minimum_occurrences["safesBalancesList:::address"]=1
operation_parameters_minimum_occurrences["safesBalancesList:::trusted"]=0
operation_parameters_minimum_occurrences["safesBalancesList:::exclude_spam"]=0
operation_parameters_minimum_occurrences["safesBalancesUsdList:::address"]=1
operation_parameters_minimum_occurrences["safesBalancesUsdList:::trusted"]=0
operation_parameters_minimum_occurrences["safesBalancesUsdList:::exclude_spam"]=0
operation_parameters_minimum_occurrences["safesCollectiblesList:::address"]=1
operation_parameters_minimum_occurrences["safesCollectiblesList:::trusted"]=0
operation_parameters_minimum_occurrences["safesCollectiblesList:::exclude_spam"]=0
operation_parameters_minimum_occurrences["safesCreationList:::address"]=1
operation_parameters_minimum_occurrences["safesDelegatesCreate:::address"]=1
operation_parameters_minimum_occurrences["safesDelegatesCreate:::data"]=1
operation_parameters_minimum_occurrences["safesDelegatesDelete:::address"]=1
operation_parameters_minimum_occurrences["safesDelegatesDelete:::delegate_address"]=1
operation_parameters_minimum_occurrences["safesDelegatesList:::address"]=1
operation_parameters_minimum_occurrences["safesDelegatesList:::limit"]=0
operation_parameters_minimum_occurrences["safesDelegatesList:::offset"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::address"]=1
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::_from"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::block_number"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::block_number__gt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::block_number__lt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::execution_date__gte"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::execution_date__lte"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::execution_date__gt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::execution_date__lt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::to"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::token_address"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::transaction_hash"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::value"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::value__gt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::value__lt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::limit"]=0
operation_parameters_minimum_occurrences["safesIncomingTransactionsList:::offset"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::address"]=1
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::_from"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::block_number"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::block_number__gt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::block_number__lt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::execution_date__gte"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::execution_date__lte"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::execution_date__gt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::execution_date__lt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::to"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::token_address"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::transaction_hash"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::value"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::value__gt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::value__lt"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::limit"]=0
operation_parameters_minimum_occurrences["safesIncomingTransfersList:::offset"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::address"]=1
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::safe"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::module"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::to"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::operation"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::failed"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::block_number"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::block_number__gt"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::block_number__lt"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::transaction_hash"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::ordering"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::limit"]=0
operation_parameters_minimum_occurrences["safesModuleTransactionsList:::offset"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsCreate:::address"]=1
operation_parameters_minimum_occurrences["safesMultisigTransactionsCreate:::data"]=1
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::address"]=1
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::failed"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::modified__lt"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::modified__gt"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::modified__lte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::modified__gte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::nonce__lt"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::nonce__gt"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::nonce__lte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::nonce__gte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::nonce"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::safe_tx_hash"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::to"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::value__lt"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::value__gt"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::value"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::executed"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::has_confirmations"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::trusted"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::execution_date__gte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::execution_date__lte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::submission_date__gte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::submission_date__lte"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::transaction_hash"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::ordering"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::limit"]=0
operation_parameters_minimum_occurrences["safesMultisigTransactionsList:::offset"]=0
operation_parameters_minimum_occurrences["safesRead:::address"]=1
operation_parameters_minimum_occurrences["safesTransactionsCreate:::address"]=1
operation_parameters_minimum_occurrences["safesTransactionsCreate:::data"]=1
operation_parameters_minimum_occurrences["safesTransactionsList:::address"]=1
operation_parameters_minimum_occurrences["safesTransactionsList:::failed"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::modified__lt"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::modified__gt"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::modified__lte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::modified__gte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::nonce__lt"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::nonce__gt"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::nonce__lte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::nonce__gte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::nonce"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::safe_tx_hash"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::to"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::value__lt"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::value__gt"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::value"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::executed"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::has_confirmations"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::trusted"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::execution_date__gte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::execution_date__lte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::submission_date__gte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::submission_date__lte"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::transaction_hash"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::ordering"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::limit"]=0
operation_parameters_minimum_occurrences["safesTransactionsList:::offset"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::address"]=1
operation_parameters_minimum_occurrences["safesTransfersList:::_from"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::block_number"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::block_number__gt"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::block_number__lt"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::execution_date__gte"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::execution_date__lte"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::execution_date__gt"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::execution_date__lt"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::to"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::token_address"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::transaction_hash"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::value"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::value__gt"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::value__lt"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::limit"]=0
operation_parameters_minimum_occurrences["safesTransfersList:::offset"]=0
operation_parameters_minimum_occurrences["tokensList:::name"]=0
operation_parameters_minimum_occurrences["tokensList:::address"]=0
operation_parameters_minimum_occurrences["tokensList:::symbol"]=0
operation_parameters_minimum_occurrences["tokensList:::decimals__lt"]=0
operation_parameters_minimum_occurrences["tokensList:::decimals__gt"]=0
operation_parameters_minimum_occurrences["tokensList:::decimals"]=0
operation_parameters_minimum_occurrences["tokensList:::search"]=0
operation_parameters_minimum_occurrences["tokensList:::ordering"]=0
operation_parameters_minimum_occurrences["tokensList:::limit"]=0
operation_parameters_minimum_occurrences["tokensList:::offset"]=0
operation_parameters_minimum_occurrences["tokensRead:::address"]=1
operation_parameters_minimum_occurrences["transactionsRead:::safe_tx_hash"]=1

##
# This array stores the maximum number of allowed occurrences for parameter
# 1 - single value
# 2 - 2 values
# N - N values
# 0 - unlimited
declare -A operation_parameters_maximum_occurrences
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::safe"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::to"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::value__lt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::value__gt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::value__lte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::value__gte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::value"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::operation"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::failed"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__lt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__gt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__lte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__gte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::safe_tx_gas"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__lt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__gt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__lte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas__gte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::base_gas"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__lt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__gt"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__lte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price__gte"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_price"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::gas_token"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::refund_receiver"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsByOriginList:::trusted"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsBySafeList:::master_copy"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsBySafeList:::limit"]=0
operation_parameters_maximum_occurrences["analyticsMultisigTransactionsBySafeList:::offset"]=0
operation_parameters_maximum_occurrences["contractsList:::ordering"]=0
operation_parameters_maximum_occurrences["contractsList:::limit"]=0
operation_parameters_maximum_occurrences["contractsList:::offset"]=0
operation_parameters_maximum_occurrences["contractsRead:::address"]=0
operation_parameters_maximum_occurrences["multisigTransactionsConfirmationsCreate:::safe_tx_hash"]=0
operation_parameters_maximum_occurrences["multisigTransactionsConfirmationsCreate:::data"]=0
operation_parameters_maximum_occurrences["multisigTransactionsConfirmationsList:::safe_tx_hash"]=0
operation_parameters_maximum_occurrences["multisigTransactionsConfirmationsList:::limit"]=0
operation_parameters_maximum_occurrences["multisigTransactionsConfirmationsList:::offset"]=0
operation_parameters_maximum_occurrences["multisigTransactionsRead:::safe_tx_hash"]=0
operation_parameters_maximum_occurrences["notificationsDevicesCreate:::data"]=0
operation_parameters_maximum_occurrences["notificationsDevicesDelete:::uuid"]=0
operation_parameters_maximum_occurrences["notificationsDevicesSafesDelete:::address"]=0
operation_parameters_maximum_occurrences["notificationsDevicesSafesDelete:::uuid"]=0
operation_parameters_maximum_occurrences["ownersRead:::address"]=0
operation_parameters_maximum_occurrences["safesAllTransactionsList:::address"]=0
operation_parameters_maximum_occurrences["safesAllTransactionsList:::ordering"]=0
operation_parameters_maximum_occurrences["safesAllTransactionsList:::limit"]=0
operation_parameters_maximum_occurrences["safesAllTransactionsList:::offset"]=0
operation_parameters_maximum_occurrences["safesAllTransactionsList:::queued"]=0
operation_parameters_maximum_occurrences["safesAllTransactionsList:::trusted"]=0
operation_parameters_maximum_occurrences["safesBalancesList:::address"]=0
operation_parameters_maximum_occurrences["safesBalancesList:::trusted"]=0
operation_parameters_maximum_occurrences["safesBalancesList:::exclude_spam"]=0
operation_parameters_maximum_occurrences["safesBalancesUsdList:::address"]=0
operation_parameters_maximum_occurrences["safesBalancesUsdList:::trusted"]=0
operation_parameters_maximum_occurrences["safesBalancesUsdList:::exclude_spam"]=0
operation_parameters_maximum_occurrences["safesCollectiblesList:::address"]=0
operation_parameters_maximum_occurrences["safesCollectiblesList:::trusted"]=0
operation_parameters_maximum_occurrences["safesCollectiblesList:::exclude_spam"]=0
operation_parameters_maximum_occurrences["safesCreationList:::address"]=0
operation_parameters_maximum_occurrences["safesDelegatesCreate:::address"]=0
operation_parameters_maximum_occurrences["safesDelegatesCreate:::data"]=0
operation_parameters_maximum_occurrences["safesDelegatesDelete:::address"]=0
operation_parameters_maximum_occurrences["safesDelegatesDelete:::delegate_address"]=0
operation_parameters_maximum_occurrences["safesDelegatesList:::address"]=0
operation_parameters_maximum_occurrences["safesDelegatesList:::limit"]=0
operation_parameters_maximum_occurrences["safesDelegatesList:::offset"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::address"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::_from"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::block_number"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::block_number__gt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::block_number__lt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::execution_date__gte"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::execution_date__lte"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::execution_date__gt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::execution_date__lt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::to"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::token_address"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::transaction_hash"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::value"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::value__gt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::value__lt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::limit"]=0
operation_parameters_maximum_occurrences["safesIncomingTransactionsList:::offset"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::address"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::_from"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::block_number"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::block_number__gt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::block_number__lt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::execution_date__gte"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::execution_date__lte"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::execution_date__gt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::execution_date__lt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::to"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::token_address"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::transaction_hash"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::value"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::value__gt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::value__lt"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::limit"]=0
operation_parameters_maximum_occurrences["safesIncomingTransfersList:::offset"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::address"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::safe"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::module"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::to"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::operation"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::failed"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::block_number"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::block_number__gt"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::block_number__lt"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::transaction_hash"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::ordering"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::limit"]=0
operation_parameters_maximum_occurrences["safesModuleTransactionsList:::offset"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsCreate:::address"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsCreate:::data"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::address"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::failed"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::modified__lt"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::modified__gt"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::modified__lte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::modified__gte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::nonce__lt"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::nonce__gt"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::nonce__lte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::nonce__gte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::nonce"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::safe_tx_hash"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::to"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::value__lt"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::value__gt"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::value"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::executed"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::has_confirmations"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::trusted"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::execution_date__gte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::execution_date__lte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::submission_date__gte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::submission_date__lte"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::transaction_hash"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::ordering"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::limit"]=0
operation_parameters_maximum_occurrences["safesMultisigTransactionsList:::offset"]=0
operation_parameters_maximum_occurrences["safesRead:::address"]=0
operation_parameters_maximum_occurrences["safesTransactionsCreate:::address"]=0
operation_parameters_maximum_occurrences["safesTransactionsCreate:::data"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::address"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::failed"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::modified__lt"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::modified__gt"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::modified__lte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::modified__gte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::nonce__lt"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::nonce__gt"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::nonce__lte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::nonce__gte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::nonce"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::safe_tx_hash"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::to"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::value__lt"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::value__gt"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::value"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::executed"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::has_confirmations"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::trusted"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::execution_date__gte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::execution_date__lte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::submission_date__gte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::submission_date__lte"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::transaction_hash"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::ordering"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::limit"]=0
operation_parameters_maximum_occurrences["safesTransactionsList:::offset"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::address"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::_from"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::block_number"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::block_number__gt"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::block_number__lt"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::execution_date__gte"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::execution_date__lte"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::execution_date__gt"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::execution_date__lt"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::to"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::token_address"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::transaction_hash"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::value"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::value__gt"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::value__lt"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::limit"]=0
operation_parameters_maximum_occurrences["safesTransfersList:::offset"]=0
operation_parameters_maximum_occurrences["tokensList:::name"]=0
operation_parameters_maximum_occurrences["tokensList:::address"]=0
operation_parameters_maximum_occurrences["tokensList:::symbol"]=0
operation_parameters_maximum_occurrences["tokensList:::decimals__lt"]=0
operation_parameters_maximum_occurrences["tokensList:::decimals__gt"]=0
operation_parameters_maximum_occurrences["tokensList:::decimals"]=0
operation_parameters_maximum_occurrences["tokensList:::search"]=0
operation_parameters_maximum_occurrences["tokensList:::ordering"]=0
operation_parameters_maximum_occurrences["tokensList:::limit"]=0
operation_parameters_maximum_occurrences["tokensList:::offset"]=0
operation_parameters_maximum_occurrences["tokensRead:::address"]=0
operation_parameters_maximum_occurrences["transactionsRead:::safe_tx_hash"]=0

##
# The type of collection for specifying multiple values for parameter:
# - multi, csv, ssv, tsv
declare -A operation_parameters_collection_type
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::safe"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::to"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::value__lt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::value__gt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::value__lte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::value__gte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::value"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::operation"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::failed"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__lt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__gt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__lte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::safe_tx_gas__gte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::safe_tx_gas"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::base_gas__lt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::base_gas__gt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::base_gas__lte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::base_gas__gte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::base_gas"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::gas_price__lt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::gas_price__gt"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::gas_price__lte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::gas_price__gte"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::gas_price"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::gas_token"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::refund_receiver"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsByOriginList:::trusted"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsBySafeList:::master_copy"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsBySafeList:::limit"]=""
operation_parameters_collection_type["analyticsMultisigTransactionsBySafeList:::offset"]=""
operation_parameters_collection_type["contractsList:::ordering"]=""
operation_parameters_collection_type["contractsList:::limit"]=""
operation_parameters_collection_type["contractsList:::offset"]=""
operation_parameters_collection_type["contractsRead:::address"]=""
operation_parameters_collection_type["multisigTransactionsConfirmationsCreate:::safe_tx_hash"]=""
operation_parameters_collection_type["multisigTransactionsConfirmationsCreate:::data"]=""
operation_parameters_collection_type["multisigTransactionsConfirmationsList:::safe_tx_hash"]=""
operation_parameters_collection_type["multisigTransactionsConfirmationsList:::limit"]=""
operation_parameters_collection_type["multisigTransactionsConfirmationsList:::offset"]=""
operation_parameters_collection_type["multisigTransactionsRead:::safe_tx_hash"]=""
operation_parameters_collection_type["notificationsDevicesCreate:::data"]=""
operation_parameters_collection_type["notificationsDevicesDelete:::uuid"]=""
operation_parameters_collection_type["notificationsDevicesSafesDelete:::address"]=""
operation_parameters_collection_type["notificationsDevicesSafesDelete:::uuid"]=""
operation_parameters_collection_type["ownersRead:::address"]=""
operation_parameters_collection_type["safesAllTransactionsList:::address"]=""
operation_parameters_collection_type["safesAllTransactionsList:::ordering"]=""
operation_parameters_collection_type["safesAllTransactionsList:::limit"]=""
operation_parameters_collection_type["safesAllTransactionsList:::offset"]=""
operation_parameters_collection_type["safesAllTransactionsList:::queued"]=""
operation_parameters_collection_type["safesAllTransactionsList:::trusted"]=""
operation_parameters_collection_type["safesBalancesList:::address"]=""
operation_parameters_collection_type["safesBalancesList:::trusted"]=""
operation_parameters_collection_type["safesBalancesList:::exclude_spam"]=""
operation_parameters_collection_type["safesBalancesUsdList:::address"]=""
operation_parameters_collection_type["safesBalancesUsdList:::trusted"]=""
operation_parameters_collection_type["safesBalancesUsdList:::exclude_spam"]=""
operation_parameters_collection_type["safesCollectiblesList:::address"]=""
operation_parameters_collection_type["safesCollectiblesList:::trusted"]=""
operation_parameters_collection_type["safesCollectiblesList:::exclude_spam"]=""
operation_parameters_collection_type["safesCreationList:::address"]=""
operation_parameters_collection_type["safesDelegatesCreate:::address"]=""
operation_parameters_collection_type["safesDelegatesCreate:::data"]=""
operation_parameters_collection_type["safesDelegatesDelete:::address"]=""
operation_parameters_collection_type["safesDelegatesDelete:::delegate_address"]=""
operation_parameters_collection_type["safesDelegatesList:::address"]=""
operation_parameters_collection_type["safesDelegatesList:::limit"]=""
operation_parameters_collection_type["safesDelegatesList:::offset"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::address"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::_from"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::block_number"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::block_number__gt"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::block_number__lt"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::execution_date__gte"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::execution_date__lte"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::execution_date__gt"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::execution_date__lt"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::to"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::token_address"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::transaction_hash"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::value"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::value__gt"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::value__lt"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::limit"]=""
operation_parameters_collection_type["safesIncomingTransactionsList:::offset"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::address"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::_from"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::block_number"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::block_number__gt"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::block_number__lt"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::execution_date__gte"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::execution_date__lte"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::execution_date__gt"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::execution_date__lt"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::to"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::token_address"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::transaction_hash"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::value"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::value__gt"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::value__lt"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::limit"]=""
operation_parameters_collection_type["safesIncomingTransfersList:::offset"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::address"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::safe"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::module"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::to"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::operation"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::failed"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::block_number"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::block_number__gt"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::block_number__lt"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::transaction_hash"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::ordering"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::limit"]=""
operation_parameters_collection_type["safesModuleTransactionsList:::offset"]=""
operation_parameters_collection_type["safesMultisigTransactionsCreate:::address"]=""
operation_parameters_collection_type["safesMultisigTransactionsCreate:::data"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::address"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::failed"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::modified__lt"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::modified__gt"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::modified__lte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::modified__gte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::nonce__lt"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::nonce__gt"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::nonce__lte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::nonce__gte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::nonce"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::safe_tx_hash"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::to"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::value__lt"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::value__gt"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::value"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::executed"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::has_confirmations"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::trusted"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::execution_date__gte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::execution_date__lte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::submission_date__gte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::submission_date__lte"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::transaction_hash"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::ordering"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::limit"]=""
operation_parameters_collection_type["safesMultisigTransactionsList:::offset"]=""
operation_parameters_collection_type["safesRead:::address"]=""
operation_parameters_collection_type["safesTransactionsCreate:::address"]=""
operation_parameters_collection_type["safesTransactionsCreate:::data"]=""
operation_parameters_collection_type["safesTransactionsList:::address"]=""
operation_parameters_collection_type["safesTransactionsList:::failed"]=""
operation_parameters_collection_type["safesTransactionsList:::modified__lt"]=""
operation_parameters_collection_type["safesTransactionsList:::modified__gt"]=""
operation_parameters_collection_type["safesTransactionsList:::modified__lte"]=""
operation_parameters_collection_type["safesTransactionsList:::modified__gte"]=""
operation_parameters_collection_type["safesTransactionsList:::nonce__lt"]=""
operation_parameters_collection_type["safesTransactionsList:::nonce__gt"]=""
operation_parameters_collection_type["safesTransactionsList:::nonce__lte"]=""
operation_parameters_collection_type["safesTransactionsList:::nonce__gte"]=""
operation_parameters_collection_type["safesTransactionsList:::nonce"]=""
operation_parameters_collection_type["safesTransactionsList:::safe_tx_hash"]=""
operation_parameters_collection_type["safesTransactionsList:::to"]=""
operation_parameters_collection_type["safesTransactionsList:::value__lt"]=""
operation_parameters_collection_type["safesTransactionsList:::value__gt"]=""
operation_parameters_collection_type["safesTransactionsList:::value"]=""
operation_parameters_collection_type["safesTransactionsList:::executed"]=""
operation_parameters_collection_type["safesTransactionsList:::has_confirmations"]=""
operation_parameters_collection_type["safesTransactionsList:::trusted"]=""
operation_parameters_collection_type["safesTransactionsList:::execution_date__gte"]=""
operation_parameters_collection_type["safesTransactionsList:::execution_date__lte"]=""
operation_parameters_collection_type["safesTransactionsList:::submission_date__gte"]=""
operation_parameters_collection_type["safesTransactionsList:::submission_date__lte"]=""
operation_parameters_collection_type["safesTransactionsList:::transaction_hash"]=""
operation_parameters_collection_type["safesTransactionsList:::ordering"]=""
operation_parameters_collection_type["safesTransactionsList:::limit"]=""
operation_parameters_collection_type["safesTransactionsList:::offset"]=""
operation_parameters_collection_type["safesTransfersList:::address"]=""
operation_parameters_collection_type["safesTransfersList:::_from"]=""
operation_parameters_collection_type["safesTransfersList:::block_number"]=""
operation_parameters_collection_type["safesTransfersList:::block_number__gt"]=""
operation_parameters_collection_type["safesTransfersList:::block_number__lt"]=""
operation_parameters_collection_type["safesTransfersList:::execution_date__gte"]=""
operation_parameters_collection_type["safesTransfersList:::execution_date__lte"]=""
operation_parameters_collection_type["safesTransfersList:::execution_date__gt"]=""
operation_parameters_collection_type["safesTransfersList:::execution_date__lt"]=""
operation_parameters_collection_type["safesTransfersList:::to"]=""
operation_parameters_collection_type["safesTransfersList:::token_address"]=""
operation_parameters_collection_type["safesTransfersList:::transaction_hash"]=""
operation_parameters_collection_type["safesTransfersList:::value"]=""
operation_parameters_collection_type["safesTransfersList:::value__gt"]=""
operation_parameters_collection_type["safesTransfersList:::value__lt"]=""
operation_parameters_collection_type["safesTransfersList:::limit"]=""
operation_parameters_collection_type["safesTransfersList:::offset"]=""
operation_parameters_collection_type["tokensList:::name"]=""
operation_parameters_collection_type["tokensList:::address"]=""
operation_parameters_collection_type["tokensList:::symbol"]=""
operation_parameters_collection_type["tokensList:::decimals__lt"]=""
operation_parameters_collection_type["tokensList:::decimals__gt"]=""
operation_parameters_collection_type["tokensList:::decimals"]=""
operation_parameters_collection_type["tokensList:::search"]=""
operation_parameters_collection_type["tokensList:::ordering"]=""
operation_parameters_collection_type["tokensList:::limit"]=""
operation_parameters_collection_type["tokensList:::offset"]=""
operation_parameters_collection_type["tokensRead:::address"]=""
operation_parameters_collection_type["transactionsRead:::safe_tx_hash"]=""


##
# Map for body parameters passed after operation as
# PARAMETER==STRING_VALUE or PARAMETER:=NUMERIC_VALUE
# These will be mapped to top level json keys ( { "PARAMETER": "VALUE" })
declare -A body_parameters

##
# These arguments will be directly passed to cURL
curl_arguments=""

##
# The host for making the request
host=""

##
# The user credentials for basic authentication
basic_auth_credential=""


##
# If true, the script will only output the actual cURL command that would be
# used
print_curl=false

##
# The operation ID passed on the command line
operation=""

##
# The provided Accept header value
header_accept=""

##
# The provided Content-type header value
header_content_type=""

##
# If there is any body content on the stdin pass it to the body of the request
body_content_temp_file=""

##
# If this variable is set to true, the request will be performed even
# if parameters for required query, header or body values are not provided
# (path parameters are still required).
force=false

##
# Declare some mime types abbreviations for easier content-type and accepts
# headers specification
declare -A mime_type_abbreviations
# text/*
mime_type_abbreviations["text"]="text/plain"
mime_type_abbreviations["html"]="text/html"
mime_type_abbreviations["md"]="text/x-markdown"
mime_type_abbreviations["csv"]="text/csv"
mime_type_abbreviations["css"]="text/css"
mime_type_abbreviations["rtf"]="text/rtf"
# application/*
mime_type_abbreviations["json"]="application/json"
mime_type_abbreviations["xml"]="application/xml"
mime_type_abbreviations["yaml"]="application/yaml"
mime_type_abbreviations["js"]="application/javascript"
mime_type_abbreviations["bin"]="application/octet-stream"
mime_type_abbreviations["rdf"]="application/rdf+xml"
# image/*
mime_type_abbreviations["jpg"]="image/jpeg"
mime_type_abbreviations["png"]="image/png"
mime_type_abbreviations["gif"]="image/gif"
mime_type_abbreviations["bmp"]="image/bmp"
mime_type_abbreviations["tiff"]="image/tiff"


##############################################################################
#
# Escape special URL characters
# Based on table at http://www.w3schools.com/tags/ref_urlencode.asp
#
##############################################################################
url_escape() {
    local raw_url="$1"

    value=$(sed -e 's/ /%20/g' \
       -e 's/!/%21/g' \
       -e 's/"/%22/g' \
       -e 's/#/%23/g' \
       -e 's/\&/%26/g' \
       -e 's/'\''/%28/g' \
       -e 's/(/%28/g' \
       -e 's/)/%29/g' \
       -e 's/:/%3A/g' \
       -e 's/\t/%09/g' \
       -e 's/?/%3F/g' <<<"$raw_url");

    echo "$value"
}

##############################################################################
#
# Lookup the mime type abbreviation in the mime_type_abbreviations array.
# If not present assume the user provided a valid mime type
#
##############################################################################
lookup_mime_type() {
    local mime_type="$1"

    if [[ ${mime_type_abbreviations[$mime_type]} ]]; then
        echo "${mime_type_abbreviations[$mime_type]}"
    else
        echo "$mime_type"
    fi
}

##############################################################################
#
# Converts an associative array into a list of cURL header
# arguments (-H "KEY: VALUE")
#
##############################################################################
header_arguments_to_curl() {
    local headers_curl=""

    for key in "${!header_arguments[@]}"; do
        headers_curl+="-H \"${key}: ${header_arguments[${key}]}\" "
    done
    headers_curl+=" "

    echo "${headers_curl}"
}

##############################################################################
#
# Converts an associative array into a simple JSON with keys as top
# level object attributes
#
# \todo Add conversion of more complex attributes using paths
#
##############################################################################
body_parameters_to_json() {
    local body_json="-d '{"
    local count=0
    for key in "${!body_parameters[@]}"; do
        if [[ $((count++)) -gt 0 ]]; then
            body_json+=", "
        fi
        body_json+="\"${key}\": ${body_parameters[${key}]}"
    done
    body_json+="}'"

    if [[ "${#body_parameters[@]}" -eq 0 ]]; then
        echo ""
    else
        echo "${body_json}"
    fi
}

##############################################################################
#
# Helper method for showing error because for example echo in
# build_request_path() is evaluated as part of command line not printed on
# output. Anyway better idea for resource clean up ;-).
#
##############################################################################
ERROR_MSG=""
function finish {
    if [[ -n "$ERROR_MSG" ]]; then
        echo >&2 "${OFF}${RED}$ERROR_MSG"
        echo >&2 "${OFF}Check usage: '${script_name} --help'"
    fi
}
trap finish EXIT


##############################################################################
#
# Validate and build request path including query parameters
#
##############################################################################
build_request_path() {
    local path_template=$1
    local -n path_params=$2
    local -n query_params=$3


    #
    # Check input parameters count against minimum and maximum required
    #
    if [[ "$force" = false ]]; then
        local was_error=""
        for qparam in "${query_params[@]}" "${path_params[@]}"; do
            local parameter_values
            mapfile -t parameter_values < <(sed -e 's/'":::"'/\n/g' <<<"${operation_parameters[$qparam]}")

            #
            # Check if the number of provided values is not less than minimum required
            #
            if [[ ${#parameter_values[@]} -lt ${operation_parameters_minimum_occurrences["${operation}:::${qparam}"]} ]]; then
                echo "ERROR: Too few values provided for '${qparam}' parameter."
                was_error=true
            fi

            #
            # Check if the number of provided values is not more than maximum
            #
            if [[ ${operation_parameters_maximum_occurrences["${operation}:::${qparam}"]} -gt 0 \
                  && ${#parameter_values[@]} -gt ${operation_parameters_maximum_occurrences["${operation}:::${qparam}"]} ]]; then
                echo "ERROR: Too many values provided for '${qparam}' parameter"
                was_error=true
            fi
        done
        if [[ -n "$was_error" ]]; then
            exit 1
        fi
    fi

    # First replace all path parameters in the path
    for pparam in "${path_params[@]}"; do
        local path_regex="(.*)(\\{$pparam\\})(.*)"
        if [[ $path_template =~ $path_regex ]]; then
            path_template=${BASH_REMATCH[1]}${operation_parameters[$pparam]}${BASH_REMATCH[3]}
        fi
    done

    local query_request_part=""

    local count=0
    for qparam in "${query_params[@]}"; do
        # Get the array of parameter values
        local parameter_value=""
        local parameter_values
        mapfile -t parameter_values < <(sed -e 's/'":::"'/\n/g' <<<"${operation_parameters[$qparam]}")

        if [[ -n "${parameter_values[*]}" ]]; then
            if [[ $((count++)) -gt 0 ]]; then
                query_request_part+="&"
            fi
        fi


        #
        # Append parameters without specific cardinality
        #
        local collection_type="${operation_parameters_collection_type["${operation}:::${qparam}"]}"
        if [[ "${collection_type}" == "" ]]; then
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                if [[ $((vcount++)) -gt 0 ]]; then
                    parameter_value+="&"
                fi
                parameter_value+="${qparam}=${qvalue}"
            done
        #
        # Append parameters specified as 'mutli' collections i.e. param=value1&param=value2&...
        #
        elif [[ "${collection_type}" == "multi" ]]; then
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                if [[ $((vcount++)) -gt 0 ]]; then
                    parameter_value+="&"
                fi
                parameter_value+="${qparam}=${qvalue}"
            done
        #
        # Append parameters specified as 'csv' collections i.e. param=value1,value2,...
        #
        elif [[ "${collection_type}" == "csv" ]]; then
            parameter_value+="${qparam}="
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                if [[ $((vcount++)) -gt 0 ]]; then
                    parameter_value+=","
                fi
                parameter_value+="${qvalue}"
            done
        #
        # Append parameters specified as 'ssv' collections i.e. param="value1 value2 ..."
        #
        elif [[ "${collection_type}" == "ssv" ]]; then
            parameter_value+="${qparam}="
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                if [[ $((vcount++)) -gt 0 ]]; then
                    parameter_value+=" "
                fi
                parameter_value+="${qvalue}"
            done
        #
        # Append parameters specified as 'tsv' collections i.e. param="value1\tvalue2\t..."
        #
        elif [[ "${collection_type}" == "tsv" ]]; then
            parameter_value+="${qparam}="
            local vcount=0
            for qvalue in "${parameter_values[@]}"; do
                if [[ $((vcount++)) -gt 0 ]]; then
                    parameter_value+="\\t"
                fi
                parameter_value+="${qvalue}"
            done
        else
            echo "Unsupported collection format \"${collection_type}\""
            exit 1
        fi

        if [[ -n "${parameter_value}" ]]; then
            query_request_part+="${parameter_value}"
        fi

    done


    # Now append query parameters - if any
    if [[ -n "${query_request_part}" ]]; then
        path_template+="?${query_request_part}"
    fi

    echo "$path_template"
}



###############################################################################
#
# Print main help message
#
###############################################################################
print_help() {
cat <<EOF

${BOLD}${WHITE}Gnosis Safe Transaction Service API command line client (API version v1)${OFF}

${BOLD}${WHITE}Usage${OFF}

  ${GREEN}${script_name}${OFF} [-h|--help] [-V|--version] [--about] [${RED}<curl-options>${OFF}]
           [-ac|--accept ${GREEN}<mime-type>${OFF}] [-ct,--content-type ${GREEN}<mime-type>${OFF}]
           [--host ${CYAN}<url>${OFF}] [--dry-run] [-nc|--no-colors] ${YELLOW}<operation>${OFF} [-h|--help]
           [${BLUE}<headers>${OFF}] [${MAGENTA}<parameters>${OFF}] [${MAGENTA}<body-parameters>${OFF}]

  - ${CYAN}<url>${OFF} - endpoint of the REST service without basepath

  - ${RED}<curl-options>${OFF} - any valid cURL options can be passed before ${YELLOW}<operation>${OFF}
  - ${GREEN}<mime-type>${OFF} - either full mime-type or one of supported abbreviations:
                   (text, html, md, csv, css, rtf, json, xml, yaml, js, bin,
                    rdf, jpg, png, gif, bmp, tiff)
  - ${BLUE}<headers>${OFF} - HTTP headers can be passed in the form ${YELLOW}HEADER${OFF}:${BLUE}VALUE${OFF}
  - ${MAGENTA}<parameters>${OFF} - REST operation parameters can be passed in the following
                   forms:
                   * ${YELLOW}KEY${OFF}=${BLUE}VALUE${OFF} - path or query parameters
  - ${MAGENTA}<body-parameters>${OFF} - simple JSON body content (first level only) can be build
                        using the following arguments:
                        * ${YELLOW}KEY${OFF}==${BLUE}VALUE${OFF} - body parameters which will be added to body
                                      JSON as '{ ..., "${YELLOW}KEY${OFF}": "${BLUE}VALUE${OFF}", ... }'
                        * ${YELLOW}KEY${OFF}:=${BLUE}VALUE${OFF} - body parameters which will be added to body
                                      JSON as '{ ..., "${YELLOW}KEY${OFF}": ${BLUE}VALUE${OFF}, ... }'

EOF
    echo -e "${BOLD}${WHITE}Authentication methods${OFF}"
    echo -e ""
    echo -e "  - ${BLUE}Basic AUTH${OFF} - add '-u <username>:<password>' before ${YELLOW}<operation>${OFF}"
    
    echo ""
    echo -e "${BOLD}${WHITE}Operations (grouped by tags)${OFF}"
    echo ""
    echo -e "${BOLD}${WHITE}[about]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}aboutList${OFF}; (AUTH)
  ${CYAN}aboutMasterCopiesList${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[analytics]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}analyticsMultisigTransactionsByOriginList${OFF}; (AUTH)
  ${CYAN}analyticsMultisigTransactionsBySafeList${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[contracts]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}contractsList${OFF}; (AUTH)
  ${CYAN}contractsRead${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[multisigTransactions]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}multisigTransactionsConfirmationsCreate${OFF}; (AUTH)
  ${CYAN}multisigTransactionsConfirmationsList${OFF}; (AUTH)
  ${CYAN}multisigTransactionsRead${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[notifications]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}notificationsDevicesCreate${OFF}; (AUTH)
  ${CYAN}notificationsDevicesDelete${OFF}; (AUTH)
  ${CYAN}notificationsDevicesSafesDelete${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[owners]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}ownersRead${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[safes]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}safesAllTransactionsList${OFF}; (AUTH)
  ${CYAN}safesBalancesList${OFF}; (AUTH)
  ${CYAN}safesBalancesUsdList${OFF}; (AUTH)
  ${CYAN}safesCollectiblesList${OFF}; (AUTH)
  ${CYAN}safesCreationList${OFF}; (AUTH)
  ${CYAN}safesDelegatesCreate${OFF}; (AUTH)
  ${CYAN}safesDelegatesDelete${OFF}; (AUTH)
  ${CYAN}safesDelegatesList${OFF}; (AUTH)
  ${CYAN}safesIncomingTransactionsList${OFF}; (AUTH)
  ${CYAN}safesIncomingTransfersList${OFF}; (AUTH)
  ${CYAN}safesModuleTransactionsList${OFF}; (AUTH)
  ${CYAN}safesMultisigTransactionsCreate${OFF}; (AUTH)
  ${CYAN}safesMultisigTransactionsList${OFF}; (AUTH)
  ${CYAN}safesRead${OFF}; (AUTH)
  ${CYAN}safesTransactionsCreate${OFF}; (AUTH)
  ${CYAN}safesTransactionsList${OFF}; (AUTH)
  ${CYAN}safesTransfersList${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[tokens]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}tokensList${OFF}; (AUTH)
  ${CYAN}tokensRead${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}[transactions]${OFF}"
read -r -d '' ops <<EOF
  ${CYAN}transactionsRead${OFF}; (AUTH)
EOF
echo "  $ops" | column -t -s ';'
    echo ""
    echo -e "${BOLD}${WHITE}Options${OFF}"
    echo -e "  -h,--help\\t\\t\\t\\tPrint this help"
    echo -e "  -V,--version\\t\\t\\t\\tPrint API version"
    echo -e "  --about\\t\\t\\t\\tPrint the information about service"
    echo -e "  --host ${CYAN}<url>${OFF}\\t\\t\\t\\tSpecify the host URL "
echo -e "              \\t\\t\\t\\t(e.g. 'https://safe-transaction.mainnet.gnosis.io')"

    echo -e "  --force\\t\\t\\t\\tForce command invocation in spite of missing"
    echo -e "         \\t\\t\\t\\trequired parameters or wrong content type"
    echo -e "  --dry-run\\t\\t\\t\\tPrint out the cURL command without"
    echo -e "           \\t\\t\\t\\texecuting it"
    echo -e "  -nc,--no-colors\\t\\t\\tEnforce print without colors, otherwise autodected"
    echo -e "  -ac,--accept ${YELLOW}<mime-type>${OFF}\\t\\tSet the 'Accept' header in the request"
    echo -e "  -ct,--content-type ${YELLOW}<mime-type>${OFF}\\tSet the 'Content-type' header in "
    echo -e "                                \\tthe request"
    echo ""
}


##############################################################################
#
# Print REST service description
#
##############################################################################
print_about() {
    echo ""
    echo -e "${BOLD}${WHITE}Gnosis Safe Transaction Service API command line client (API version v1)${OFF}"
    echo ""
    echo -e "License: MIT License"
    echo -e "Contact: safe@gnosis.io"
    echo ""
read -r -d '' appdescription <<EOF

API to store safe multisig transactions
EOF
echo "$appdescription" | paste -sd' ' | fold -sw 80
}


##############################################################################
#
# Print REST api version
#
##############################################################################
print_version() {
    echo ""
    echo -e "${BOLD}Gnosis Safe Transaction Service API command line client (API version v1)${OFF}"
    echo ""
}

##############################################################################
#
# Print help for aboutList operation
#
##############################################################################
print_aboutList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}aboutList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns information and configuration of the service" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for aboutMasterCopiesList operation
#
##############################################################################
print_aboutMasterCopiesList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}aboutMasterCopiesList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for analyticsMultisigTransactionsByOriginList operation
#
##############################################################################
print_analyticsMultisigTransactionsByOriginList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}analyticsMultisigTransactionsByOriginList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}safe${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: safe=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}to${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: to=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__lte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__gte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}operation${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: operation=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}failed${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: failed=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe_tx_gas__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: safe_tx_gas__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe_tx_gas__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: safe_tx_gas__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe_tx_gas__lte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: safe_tx_gas__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe_tx_gas__gte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: safe_tx_gas__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe_tx_gas${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: safe_tx_gas=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}base_gas__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: base_gas__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}base_gas__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: base_gas__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}base_gas__lte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: base_gas__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}base_gas__gte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: base_gas__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}base_gas${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: base_gas=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}gas_price__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: gas_price__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}gas_price__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: gas_price__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}gas_price__lte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: gas_price__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}gas_price__gte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: gas_price__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}gas_price${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: gas_price=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}gas_token${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: gas_token=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}refund_receiver${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: refund_receiver=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}trusted${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: trusted=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for analyticsMultisigTransactionsBySafeList operation
#
##############################################################################
print_analyticsMultisigTransactionsBySafeList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}analyticsMultisigTransactionsBySafeList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}master_copy${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: master_copy=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for contractsList operation
#
##############################################################################
print_contractsList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}contractsList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}ordering${OFF} ${BLUE}[string]${OFF}${OFF} - Which field to use when ordering the results.${YELLOW} Specify as: ordering=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for contractsRead operation
#
##############################################################################
print_contractsRead_help() {
    echo ""
    echo -e "${BOLD}${WHITE}contractsRead - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} - A unique value identifying this contract. ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for multisigTransactionsConfirmationsCreate operation
#
##############################################################################
print_multisigTransactionsConfirmationsCreate_help() {
    echo ""
    echo -e "${BOLD}${WHITE}multisigTransactionsConfirmationsCreate - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Add a confirmation for a transaction. More than one signature can be used. This endpoint does not support
the use of delegates to make a transaction trusted." | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}safe_tx_hash${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: safe_tx_hash=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}body${OFF} ${BLUE}[application/json]${OFF} ${RED}(required)${OFF}${OFF} - " | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=201
    echo -e "${result_color_table[${code:0:1}]}  201;Created${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Malformed data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Error processing data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for multisigTransactionsConfirmationsList operation
#
##############################################################################
print_multisigTransactionsConfirmationsList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}multisigTransactionsConfirmationsList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Get the list of confirmations for a multisig transaction" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}safe_tx_hash${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: safe_tx_hash=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Invalid data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for multisigTransactionsRead operation
#
##############################################################################
print_multisigTransactionsRead_help() {
    echo ""
    echo -e "${BOLD}${WHITE}multisigTransactionsRead - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}safe_tx_hash${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: safe_tx_hash=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for notificationsDevicesCreate operation
#
##############################################################################
print_notificationsDevicesCreate_help() {
    echo ""
    echo -e "${BOLD}${WHITE}notificationsDevicesCreate - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Creates a new FirebaseDevice. If uuid is not provided a new device will be created.
If a uuid for an existing Safe is provided the FirebaseDevice will be updated with all the new data provided.
Safes provided on the request are always added and never removed/replaced" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}body${OFF} ${BLUE}[application/json]${OFF} ${RED}(required)${OFF}${OFF} - " | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=201
    echo -e "${result_color_table[${code:0:1}]}  201;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for notificationsDevicesDelete operation
#
##############################################################################
print_notificationsDevicesDelete_help() {
    echo ""
    echo -e "${BOLD}${WHITE}notificationsDevicesDelete - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Remove a FirebaseDevice" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}uuid${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} - A UUID string identifying this Firebase Device. ${YELLOW}Specify as: uuid=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=204
    echo -e "${result_color_table[${code:0:1}]}  204;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for notificationsDevicesSafesDelete operation
#
##############################################################################
print_notificationsDevicesSafesDelete_help() {
    echo ""
    echo -e "${BOLD}${WHITE}notificationsDevicesSafesDelete - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Remove a Safe for a FirebaseDevice" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}uuid${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} - A UUID string identifying this Firebase Device. ${YELLOW}Specify as: uuid=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=204
    echo -e "${result_color_table[${code:0:1}]}  204;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for ownersRead operation
#
##############################################################################
print_ownersRead_help() {
    echo ""
    echo -e "${BOLD}${WHITE}ownersRead - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Return Safes where the address provided is an owner" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Owner address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesAllTransactionsList operation
#
##############################################################################
print_safesAllTransactionsList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesAllTransactionsList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns a paginated list of transactions for a Safe. The list has different structures depending on the
transaction type:
- Multisig Transactions for a Safe. 'tx_type=MULTISIG_TRANSACTION'. If the query parameter 'queued=False' is
set only the transactions with 'safe nonce < current Safe nonce' will be displayed. By default, only the
'trusted' transactions will be displayed (transactions indexed, with at least one confirmation or proposed
by a delegate). If you need that behaviour to be disabled set the query parameter 'trusted=False'
- Module Transactions for a Safe. 'tx_type=MODULE_TRANSACTION'
- Incoming Transfers of Ether/ERC20 Tokens/ERC721 Tokens. 'tx_type=ETHEREUM_TRANSACTION'" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}ordering${OFF} ${BLUE}[string]${OFF}${OFF} - Which field to use when ordering the results.${YELLOW} Specify as: ordering=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}queued${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: true)${OFF} - If 'True' transactions with 'nonce >= Safe current nonce' are also returned${YELLOW} Specify as: queued=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}trusted${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: true)${OFF} - If 'True' just trusted transactions are shown (indexed, added by a delegate or with at least one confirmation)${YELLOW} Specify as: trusted=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;A list with every element with the structure of one of these transactiontypes${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;code = 1: Checksum address validation failed${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesBalancesList operation
#
##############################################################################
print_safesBalancesList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesBalancesList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Get balance for Ether and ERC20 tokens" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}trusted${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: false)${OFF} - If 'True' just trusted tokens will be returned${YELLOW} Specify as: trusted=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}exclude_spam${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: false)${OFF} - If 'True' spam tokens will not be returned${YELLOW} Specify as: exclude_spam=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=404
    echo -e "${result_color_table[${code:0:1}]}  404;Safe not found${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Safe address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesBalancesUsdList operation
#
##############################################################################
print_safesBalancesUsdList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesBalancesUsdList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Get balance for Ether and ERC20 tokens with USD fiat conversion" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}trusted${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: false)${OFF} - If 'True' just trusted tokens will be returned${YELLOW} Specify as: trusted=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}exclude_spam${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: false)${OFF} - If 'True' spam tokens will not be returned${YELLOW} Specify as: exclude_spam=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=404
    echo -e "${result_color_table[${code:0:1}]}  404;Safe not found${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Safe address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesCollectiblesList operation
#
##############################################################################
print_safesCollectiblesList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesCollectiblesList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Get collectibles (ERC721 tokens) and information about them" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}trusted${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: false)${OFF} - If 'True' just trusted tokens will be returned${YELLOW} Specify as: trusted=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}exclude_spam${OFF} ${BLUE}[boolean]${OFF} ${CYAN}(default: false)${OFF} - If 'True' spam tokens will not be returned${YELLOW} Specify as: exclude_spam=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=404
    echo -e "${result_color_table[${code:0:1}]}  404;Safe not found${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Safe address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesCreationList operation
#
##############################################################################
print_safesCreationList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesCreationList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Get status of the safe" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=404
    echo -e "${result_color_table[${code:0:1}]}  404;Safe creation not found${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Owner address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=503
    echo -e "${result_color_table[${code:0:1}]}  503;Problem connecting to Ethereum network${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesDelegatesCreate operation
#
##############################################################################
print_safesDelegatesCreate_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesDelegatesCreate - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Create a delegate for a Safe address with a custom label. Calls with same delegate but different label or
signer will update the label or delegator if different.
For the signature we are using TOTP with 'T0=0' and 'Tx=3600'. TOTP is calculated by taking the
Unix UTC epoch time (no milliseconds) and dividing by 3600 (natural division, no decimals)
For signature this hash need to be signed: keccak(address + str(int(current_epoch // 3600)))
For example:
     - we want to add the owner '0x132512f995866CcE1b0092384A6118EDaF4508Ff' and 'epoch=1586779140'.
     - TOTP = epoch // 3600 = 1586779140 // 3600 = 440771
     - The hash to sign by a Safe owner would be 'keccak(\"0x132512f995866CcE1b0092384A6118EDaF4508Ff440771\")'" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}body${OFF} ${BLUE}[application/json]${OFF} ${RED}(required)${OFF}${OFF} - " | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=202
    echo -e "${result_color_table[${code:0:1}]}  202;Accepted${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Malformed data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid Ethereum address/Error processing data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesDelegatesDelete operation
#
##############################################################################
print_safesDelegatesDelete_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesDelegatesDelete - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Delete a delegate for a Safe. Signature is built the same way that for adding a delegate.
Check 'POST /delegates/'" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}delegate_address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: delegate_address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=204
    echo -e "${result_color_table[${code:0:1}]}  204;Deleted${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Malformed data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=404
    echo -e "${result_color_table[${code:0:1}]}  404;Delegate not found${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid Ethereum address/Error processing data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesDelegatesList operation
#
##############################################################################
print_safesDelegatesList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesDelegatesList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Get the list of delegates for a Safe address" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Invalid data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid Ethereum address${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesIncomingTransactionsList operation
#
##############################################################################
print_safesIncomingTransactionsList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesIncomingTransactionsList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns the history of a multisig tx (safe)" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}_from${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: _from=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}to${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: to=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}token_address${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: token_address=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}transaction_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: transaction_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Safe address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesIncomingTransfersList operation
#
##############################################################################
print_safesIncomingTransfersList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesIncomingTransfersList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns the history of a multisig tx (safe)" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}_from${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: _from=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}to${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: to=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}token_address${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: token_address=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}transaction_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: transaction_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Safe address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesModuleTransactionsList operation
#
##############################################################################
print_safesModuleTransactionsList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesModuleTransactionsList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns the module transaction of a Safe" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: safe=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}module${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: module=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}to${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: to=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}operation${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: operation=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}failed${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: failed=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}transaction_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: transaction_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}ordering${OFF} ${BLUE}[string]${OFF}${OFF} - Which field to use when ordering the results.${YELLOW} Specify as: ordering=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Invalid data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid ethereum address${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesMultisigTransactionsCreate operation
#
##############################################################################
print_safesMultisigTransactionsCreate_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesMultisigTransactionsCreate - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Creates a Multisig Transaction with its confirmations and retrieves all the information related." | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}body${OFF} ${BLUE}[application/json]${OFF} ${RED}(required)${OFF}${OFF} - " | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=201
    echo -e "${result_color_table[${code:0:1}]}  201;Created or signature updated${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Invalid data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid ethereum address/User is not an owner/Invalid safeTxHash/Invalid signature/Nonce already executed/Sender is not an owner${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesMultisigTransactionsList operation
#
##############################################################################
print_safesMultisigTransactionsList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesMultisigTransactionsList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns the history of a multisig tx (safe)" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}failed${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: failed=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__lt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__gt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__lte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__gte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe_tx_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: safe_tx_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}to${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: to=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}executed${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: executed=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}has_confirmations${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: has_confirmations=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}trusted${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: trusted=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}submission_date__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: submission_date__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}submission_date__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: submission_date__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}transaction_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: transaction_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}ordering${OFF} ${BLUE}[string]${OFF}${OFF} - Which field to use when ordering the results.${YELLOW} Specify as: ordering=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Invalid data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid ethereum address${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesRead operation
#
##############################################################################
print_safesRead_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesRead - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Get status of the safe" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=404
    echo -e "${result_color_table[${code:0:1}]}  404;Safe not found${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;code = 1: Checksum address validation failed
code = 50: Cannot get Safe info${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesTransactionsCreate operation
#
##############################################################################
print_safesTransactionsCreate_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesTransactionsCreate - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Creates a Multisig Transaction with its confirmations and retrieves all the information related." | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}body${OFF} ${BLUE}[application/json]${OFF} ${RED}(required)${OFF}${OFF} - " | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=201
    echo -e "${result_color_table[${code:0:1}]}  201;Created or signature updated${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Invalid data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid ethereum address/User is not an owner/Invalid safeTxHash/Invalid signature/Nonce already executed/Sender is not an owner${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesTransactionsList operation
#
##############################################################################
print_safesTransactionsList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesTransactionsList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns the history of a multisig tx (safe)" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}failed${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: failed=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__lt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__gt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}modified__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: modified__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__lte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce__gte${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}nonce${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: nonce=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}safe_tx_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: safe_tx_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}to${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: to=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}executed${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: executed=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}has_confirmations${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: has_confirmations=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}trusted${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: trusted=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}submission_date__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: submission_date__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}submission_date__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: submission_date__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}transaction_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: transaction_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}ordering${OFF} ${BLUE}[string]${OFF}${OFF} - Which field to use when ordering the results.${YELLOW} Specify as: ordering=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=400
    echo -e "${result_color_table[${code:0:1}]}  400;Invalid data${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Invalid ethereum address${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for safesTransfersList operation
#
##############################################################################
print_safesTransfersList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}safesTransfersList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "Returns the history of a multisig tx (safe)" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}_from${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: _from=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}block_number__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: block_number__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lte${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lte=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__gt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}execution_date__lt${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: execution_date__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}to${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: to=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}token_address${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: token_address=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}transaction_hash${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: transaction_hash=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}value__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: value__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
    code=422
    echo -e "${result_color_table[${code:0:1}]}  422;Safe address checksum not valid${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for tokensList operation
#
##############################################################################
print_tokensList_help() {
    echo ""
    echo -e "${BOLD}${WHITE}tokensList - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}name${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: name=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: address=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}symbol${OFF} ${BLUE}[string]${OFF}${OFF} - ${YELLOW} Specify as: symbol=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}decimals__lt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: decimals__lt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}decimals__gt${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: decimals__gt=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}decimals${OFF} ${BLUE}[integer]${OFF}${OFF} - ${YELLOW} Specify as: decimals=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}search${OFF} ${BLUE}[string]${OFF}${OFF} - A search term.${YELLOW} Specify as: search=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}ordering${OFF} ${BLUE}[string]${OFF}${OFF} - Which field to use when ordering the results.${YELLOW} Specify as: ordering=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}limit${OFF} ${BLUE}[integer]${OFF}${OFF} - Number of results to return per page.${YELLOW} Specify as: limit=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e "  * ${GREEN}offset${OFF} ${BLUE}[integer]${OFF}${OFF} - The initial index from which to return the results.${YELLOW} Specify as: offset=value${OFF}" \
        | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for tokensRead operation
#
##############################################################################
print_tokensRead_help() {
    echo ""
    echo -e "${BOLD}${WHITE}tokensRead - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}address${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} - A unique value identifying this token. ${YELLOW}Specify as: address=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}
##############################################################################
#
# Print help for transactionsRead operation
#
##############################################################################
print_transactionsRead_help() {
    echo ""
    echo -e "${BOLD}${WHITE}transactionsRead - ${OFF}${BLUE}(AUTH - BASIC)${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo -e ""
    echo -e "" | paste -sd' ' | fold -sw 80
    echo -e ""
    echo -e "${BOLD}${WHITE}Parameters${OFF}"
    echo -e "  * ${GREEN}safe_tx_hash${OFF} ${BLUE}[string]${OFF} ${RED}(required)${OFF}${OFF} -  ${YELLOW}Specify as: safe_tx_hash=value${OFF}" | paste -sd' ' | fold -sw 80 | sed '2,$s/^/    /'
    echo ""
    echo -e "${BOLD}${WHITE}Responses${OFF}"
    code=200
    echo -e "${result_color_table[${code:0:1}]}  200;${OFF}" | paste -sd' ' | column -t -s ';' | fold -sw 80 | sed '2,$s/^/       /'
}


##############################################################################
#
# Call aboutList operation
#
##############################################################################
call_aboutList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=()
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/about/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call aboutMasterCopiesList operation
#
##############################################################################
call_aboutMasterCopiesList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=()
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/about/master-copies/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call analyticsMultisigTransactionsByOriginList operation
#
##############################################################################
call_analyticsMultisigTransactionsByOriginList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=()
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(safe to value__lt value__gt value__lte value__gte value operation failed safe_tx_gas__lt safe_tx_gas__gt safe_tx_gas__lte safe_tx_gas__gte safe_tx_gas base_gas__lt base_gas__gt base_gas__lte base_gas__gte base_gas gas_price__lt gas_price__gt gas_price__lte gas_price__gte gas_price gas_token refund_receiver trusted  )
    local path

    if ! path=$(build_request_path "/api/v1/analytics/multisig-transactions/by-origin/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call analyticsMultisigTransactionsBySafeList operation
#
##############################################################################
call_analyticsMultisigTransactionsBySafeList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=()
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(master_copy limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/analytics/multisig-transactions/by-safe/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call contractsList operation
#
##############################################################################
call_contractsList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=()
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(ordering limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/contracts/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call contractsRead operation
#
##############################################################################
call_contractsRead() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/contracts/{address}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call multisigTransactionsConfirmationsCreate operation
#
##############################################################################
call_multisigTransactionsConfirmationsCreate() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(safe_tx_hash)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/multisig-transactions/{safe_tx_hash}/confirmations/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="POST"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    local body_json_curl=""

    #
    # Check if the user provided 'Content-type' headers in the
    # command line. If not try to set them based on the Swagger specification
    # if values produces and consumes are defined unambigously
    #
    if [[ -z $header_content_type ]]; then
        header_content_type="application/json"
    fi


    if [[ -z $header_content_type && "$force" = false ]]; then
        :
        echo "ERROR: Request's content-type not specified!!!"
        echo "This operation expects content-type in one of the following formats:"
        echo -e "\\t- application/json"
        echo ""
        echo "Use '--content-type' to set proper content type"
        exit 1
    else
        headers_curl="${headers_curl} -H 'Content-type: ${header_content_type}'"
    fi


    #
    # If we have received some body content over pipe, pass it from the
    # temporary file to cURL
    #
    if [[ -n $body_content_temp_file ]]; then
        if [[ "$print_curl" = true ]]; then
            echo "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        else
            eval "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        fi
        rm "${body_content_temp_file}"
    #
    # If not, try to build the content body from arguments KEY==VALUE and KEY:=VALUE
    #
    else
        body_json_curl=$(body_parameters_to_json)
        if [[ "$print_curl" = true ]]; then
            echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        else
            eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        fi
    fi
}

##############################################################################
#
# Call multisigTransactionsConfirmationsList operation
#
##############################################################################
call_multisigTransactionsConfirmationsList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(safe_tx_hash)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/multisig-transactions/{safe_tx_hash}/confirmations/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call multisigTransactionsRead operation
#
##############################################################################
call_multisigTransactionsRead() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(safe_tx_hash)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/multisig-transactions/{safe_tx_hash}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call notificationsDevicesCreate operation
#
##############################################################################
call_notificationsDevicesCreate() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=()
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/notifications/devices/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="POST"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    local body_json_curl=""

    #
    # Check if the user provided 'Content-type' headers in the
    # command line. If not try to set them based on the Swagger specification
    # if values produces and consumes are defined unambigously
    #
    if [[ -z $header_content_type ]]; then
        header_content_type="application/json"
    fi


    if [[ -z $header_content_type && "$force" = false ]]; then
        :
        echo "ERROR: Request's content-type not specified!!!"
        echo "This operation expects content-type in one of the following formats:"
        echo -e "\\t- application/json"
        echo ""
        echo "Use '--content-type' to set proper content type"
        exit 1
    else
        headers_curl="${headers_curl} -H 'Content-type: ${header_content_type}'"
    fi


    #
    # If we have received some body content over pipe, pass it from the
    # temporary file to cURL
    #
    if [[ -n $body_content_temp_file ]]; then
        if [[ "$print_curl" = true ]]; then
            echo "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        else
            eval "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        fi
        rm "${body_content_temp_file}"
    #
    # If not, try to build the content body from arguments KEY==VALUE and KEY:=VALUE
    #
    else
        body_json_curl=$(body_parameters_to_json)
        if [[ "$print_curl" = true ]]; then
            echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        else
            eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        fi
    fi
}

##############################################################################
#
# Call notificationsDevicesDelete operation
#
##############################################################################
call_notificationsDevicesDelete() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(uuid)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/notifications/devices/{uuid}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="DELETE"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call notificationsDevicesSafesDelete operation
#
##############################################################################
call_notificationsDevicesSafesDelete() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address uuid)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/notifications/devices/{uuid}/safes/{address}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="DELETE"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call ownersRead operation
#
##############################################################################
call_ownersRead() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/owners/{address}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesAllTransactionsList operation
#
##############################################################################
call_safesAllTransactionsList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(ordering limit offset queued trusted  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/all-transactions/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesBalancesList operation
#
##############################################################################
call_safesBalancesList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(trusted exclude_spam  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/balances/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesBalancesUsdList operation
#
##############################################################################
call_safesBalancesUsdList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(trusted exclude_spam  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/balances/usd/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesCollectiblesList operation
#
##############################################################################
call_safesCollectiblesList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(trusted exclude_spam  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/collectibles/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesCreationList operation
#
##############################################################################
call_safesCreationList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/creation/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesDelegatesCreate operation
#
##############################################################################
call_safesDelegatesCreate() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/delegates/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="POST"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    local body_json_curl=""

    #
    # Check if the user provided 'Content-type' headers in the
    # command line. If not try to set them based on the Swagger specification
    # if values produces and consumes are defined unambigously
    #
    if [[ -z $header_content_type ]]; then
        header_content_type="application/json"
    fi


    if [[ -z $header_content_type && "$force" = false ]]; then
        :
        echo "ERROR: Request's content-type not specified!!!"
        echo "This operation expects content-type in one of the following formats:"
        echo -e "\\t- application/json"
        echo ""
        echo "Use '--content-type' to set proper content type"
        exit 1
    else
        headers_curl="${headers_curl} -H 'Content-type: ${header_content_type}'"
    fi


    #
    # If we have received some body content over pipe, pass it from the
    # temporary file to cURL
    #
    if [[ -n $body_content_temp_file ]]; then
        if [[ "$print_curl" = true ]]; then
            echo "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        else
            eval "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        fi
        rm "${body_content_temp_file}"
    #
    # If not, try to build the content body from arguments KEY==VALUE and KEY:=VALUE
    #
    else
        body_json_curl=$(body_parameters_to_json)
        if [[ "$print_curl" = true ]]; then
            echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        else
            eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        fi
    fi
}

##############################################################################
#
# Call safesDelegatesDelete operation
#
##############################################################################
call_safesDelegatesDelete() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address delegate_address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/delegates/{delegate_address}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="DELETE"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesDelegatesList operation
#
##############################################################################
call_safesDelegatesList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/delegates/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesIncomingTransactionsList operation
#
##############################################################################
call_safesIncomingTransactionsList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(_from block_number block_number__gt block_number__lt execution_date__gte execution_date__lte execution_date__gt execution_date__lt to token_address transaction_hash value value__gt value__lt limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/incoming-transactions/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesIncomingTransfersList operation
#
##############################################################################
call_safesIncomingTransfersList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(_from block_number block_number__gt block_number__lt execution_date__gte execution_date__lte execution_date__gt execution_date__lt to token_address transaction_hash value value__gt value__lt limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/incoming-transfers/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesModuleTransactionsList operation
#
##############################################################################
call_safesModuleTransactionsList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(safe module to operation failed block_number block_number__gt block_number__lt transaction_hash ordering limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/module-transactions/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesMultisigTransactionsCreate operation
#
##############################################################################
call_safesMultisigTransactionsCreate() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/multisig-transactions/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="POST"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    local body_json_curl=""

    #
    # Check if the user provided 'Content-type' headers in the
    # command line. If not try to set them based on the Swagger specification
    # if values produces and consumes are defined unambigously
    #
    if [[ -z $header_content_type ]]; then
        header_content_type="application/json"
    fi


    if [[ -z $header_content_type && "$force" = false ]]; then
        :
        echo "ERROR: Request's content-type not specified!!!"
        echo "This operation expects content-type in one of the following formats:"
        echo -e "\\t- application/json"
        echo ""
        echo "Use '--content-type' to set proper content type"
        exit 1
    else
        headers_curl="${headers_curl} -H 'Content-type: ${header_content_type}'"
    fi


    #
    # If we have received some body content over pipe, pass it from the
    # temporary file to cURL
    #
    if [[ -n $body_content_temp_file ]]; then
        if [[ "$print_curl" = true ]]; then
            echo "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        else
            eval "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        fi
        rm "${body_content_temp_file}"
    #
    # If not, try to build the content body from arguments KEY==VALUE and KEY:=VALUE
    #
    else
        body_json_curl=$(body_parameters_to_json)
        if [[ "$print_curl" = true ]]; then
            echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        else
            eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        fi
    fi
}

##############################################################################
#
# Call safesMultisigTransactionsList operation
#
##############################################################################
call_safesMultisigTransactionsList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(failed modified__lt modified__gt modified__lte modified__gte nonce__lt nonce__gt nonce__lte nonce__gte nonce safe_tx_hash to value__lt value__gt value executed has_confirmations trusted execution_date__gte execution_date__lte submission_date__gte submission_date__lte transaction_hash ordering limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/multisig-transactions/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesRead operation
#
##############################################################################
call_safesRead() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesTransactionsCreate operation
#
##############################################################################
call_safesTransactionsCreate() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/transactions/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="POST"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    local body_json_curl=""

    #
    # Check if the user provided 'Content-type' headers in the
    # command line. If not try to set them based on the Swagger specification
    # if values produces and consumes are defined unambigously
    #
    if [[ -z $header_content_type ]]; then
        header_content_type="application/json"
    fi


    if [[ -z $header_content_type && "$force" = false ]]; then
        :
        echo "ERROR: Request's content-type not specified!!!"
        echo "This operation expects content-type in one of the following formats:"
        echo -e "\\t- application/json"
        echo ""
        echo "Use '--content-type' to set proper content type"
        exit 1
    else
        headers_curl="${headers_curl} -H 'Content-type: ${header_content_type}'"
    fi


    #
    # If we have received some body content over pipe, pass it from the
    # temporary file to cURL
    #
    if [[ -n $body_content_temp_file ]]; then
        if [[ "$print_curl" = true ]]; then
            echo "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        else
            eval "cat ${body_content_temp_file} | curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\" -d @-"
        fi
        rm "${body_content_temp_file}"
    #
    # If not, try to build the content body from arguments KEY==VALUE and KEY:=VALUE
    #
    else
        body_json_curl=$(body_parameters_to_json)
        if [[ "$print_curl" = true ]]; then
            echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        else
            eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} ${body_json_curl} \"${host}${path}\""
        fi
    fi
}

##############################################################################
#
# Call safesTransactionsList operation
#
##############################################################################
call_safesTransactionsList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(failed modified__lt modified__gt modified__lte modified__gte nonce__lt nonce__gt nonce__lte nonce__gte nonce safe_tx_hash to value__lt value__gt value executed has_confirmations trusted execution_date__gte execution_date__lte submission_date__gte submission_date__lte transaction_hash ordering limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/transactions/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call safesTransfersList operation
#
##############################################################################
call_safesTransfersList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(_from block_number block_number__gt block_number__lt execution_date__gte execution_date__lte execution_date__gt execution_date__lt to token_address transaction_hash value value__gt value__lt limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/safes/{address}/transfers/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call tokensList operation
#
##############################################################################
call_tokensList() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=()
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(name address symbol decimals__lt decimals__gt decimals search ordering limit offset  )
    local path

    if ! path=$(build_request_path "/api/v1/tokens/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call tokensRead operation
#
##############################################################################
call_tokensRead() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(address)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/tokens/{address}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}

##############################################################################
#
# Call transactionsRead operation
#
##############################################################################
call_transactionsRead() {
    # ignore error about 'path_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local path_parameter_names=(safe_tx_hash)
    # ignore error about 'query_parameter_names' being unused; passed by reference
    # shellcheck disable=SC2034
    local query_parameter_names=(  )
    local path

    if ! path=$(build_request_path "/api/v1/transactions/{safe_tx_hash}/" path_parameter_names query_parameter_names); then
        ERROR_MSG=$path
        exit 1
    fi
    local method="GET"
    local headers_curl
    headers_curl=$(header_arguments_to_curl)
    if [[ -n $header_accept ]]; then
        headers_curl="${headers_curl} -H 'Accept: ${header_accept}'"
    fi

    local basic_auth_option=""
    if [[ -n $basic_auth_credential ]]; then
        basic_auth_option="-u ${basic_auth_credential}"
    fi
    if [[ "$print_curl" = true ]]; then
        echo "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    else
        eval "curl ${basic_auth_option} ${curl_arguments} ${headers_curl} -X ${method} \"${host}${path}\""
    fi
}



##############################################################################
#
# Main
#
##############################################################################


# Check dependencies
type curl >/dev/null 2>&1 || { echo >&2 "ERROR: You do not have 'cURL' installed."; exit 1; }
type sed >/dev/null 2>&1 || { echo >&2 "ERROR: You do not have 'sed' installed."; exit 1; }
type column >/dev/null 2>&1 || { echo >&2 "ERROR: You do not have 'bsdmainutils' installed."; exit 1; }

#
# Process command line
#
# Pass all arguments before 'operation' to cURL except the ones we override
#
take_user=false
take_host=false
take_accept_header=false
take_contenttype_header=false

for key in "$@"; do
# Take the value of -u|--user argument
if [[ "$take_user" = true ]]; then
    basic_auth_credential="$key"
    take_user=false
    continue
fi
# Take the value of --host argument
if [[ "$take_host" = true ]]; then
    host="$key"
    take_host=false
    continue
fi
# Take the value of --accept argument
if [[ "$take_accept_header" = true ]]; then
    header_accept=$(lookup_mime_type "$key")
    take_accept_header=false
    continue
fi
# Take the value of --content-type argument
if [[ "$take_contenttype_header" = true ]]; then
    header_content_type=$(lookup_mime_type "$key")
    take_contenttype_header=false
    continue
fi
case $key in
    -h|--help)
    if [[ "x$operation" == "x" ]]; then
        print_help
        exit 0
    else
        eval "print_${operation}_help"
        exit 0
    fi
    ;;
    -V|--version)
    print_version
    exit 0
    ;;
    --about)
    print_about
    exit 0
    ;;
    -u|--user)
    take_user=true
    ;;
    --host)
    take_host=true
    ;;
    --force)
    force=true
    ;;
    -ac|--accept)
    take_accept_header=true
    ;;
    -ct|--content-type)
    take_contenttype_header=true
    ;;
    --dry-run)
    print_curl=true
    ;;
    -nc|--no-colors)
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        MAGENTA=""
        CYAN=""
        WHITE=""
        BOLD=""
        OFF=""
        result_color_table=( "" "" "" "" "" "" "" )
    ;;
    aboutList)
    operation="aboutList"
    ;;
    aboutMasterCopiesList)
    operation="aboutMasterCopiesList"
    ;;
    analyticsMultisigTransactionsByOriginList)
    operation="analyticsMultisigTransactionsByOriginList"
    ;;
    analyticsMultisigTransactionsBySafeList)
    operation="analyticsMultisigTransactionsBySafeList"
    ;;
    contractsList)
    operation="contractsList"
    ;;
    contractsRead)
    operation="contractsRead"
    ;;
    multisigTransactionsConfirmationsCreate)
    operation="multisigTransactionsConfirmationsCreate"
    ;;
    multisigTransactionsConfirmationsList)
    operation="multisigTransactionsConfirmationsList"
    ;;
    multisigTransactionsRead)
    operation="multisigTransactionsRead"
    ;;
    notificationsDevicesCreate)
    operation="notificationsDevicesCreate"
    ;;
    notificationsDevicesDelete)
    operation="notificationsDevicesDelete"
    ;;
    notificationsDevicesSafesDelete)
    operation="notificationsDevicesSafesDelete"
    ;;
    ownersRead)
    operation="ownersRead"
    ;;
    safesAllTransactionsList)
    operation="safesAllTransactionsList"
    ;;
    safesBalancesList)
    operation="safesBalancesList"
    ;;
    safesBalancesUsdList)
    operation="safesBalancesUsdList"
    ;;
    safesCollectiblesList)
    operation="safesCollectiblesList"
    ;;
    safesCreationList)
    operation="safesCreationList"
    ;;
    safesDelegatesCreate)
    operation="safesDelegatesCreate"
    ;;
    safesDelegatesDelete)
    operation="safesDelegatesDelete"
    ;;
    safesDelegatesList)
    operation="safesDelegatesList"
    ;;
    safesIncomingTransactionsList)
    operation="safesIncomingTransactionsList"
    ;;
    safesIncomingTransfersList)
    operation="safesIncomingTransfersList"
    ;;
    safesModuleTransactionsList)
    operation="safesModuleTransactionsList"
    ;;
    safesMultisigTransactionsCreate)
    operation="safesMultisigTransactionsCreate"
    ;;
    safesMultisigTransactionsList)
    operation="safesMultisigTransactionsList"
    ;;
    safesRead)
    operation="safesRead"
    ;;
    safesTransactionsCreate)
    operation="safesTransactionsCreate"
    ;;
    safesTransactionsList)
    operation="safesTransactionsList"
    ;;
    safesTransfersList)
    operation="safesTransfersList"
    ;;
    tokensList)
    operation="tokensList"
    ;;
    tokensRead)
    operation="tokensRead"
    ;;
    transactionsRead)
    operation="transactionsRead"
    ;;
    *==*)
    # Parse body arguments and convert them into top level
    # JSON properties passed in the body content as strings
    if [[ "$operation" ]]; then
        IFS='==' read -r body_key sep body_value <<< "$key"
        body_parameters[${body_key}]="\"${body_value}\""
    fi
    ;;
    *:=*)
    # Parse body arguments and convert them into top level
    # JSON properties passed in the body content without qoutes
    if [[ "$operation" ]]; then
        # ignore error about 'sep' being unused
        # shellcheck disable=SC2034
        IFS=':=' read -r body_key sep body_value <<< "$key"
        body_parameters[${body_key}]=${body_value}
    fi
    ;;
    +\([^=]\):*)
    # Parse header arguments and convert them into curl
    # only after the operation argument
    if [[ "$operation" ]]; then
        IFS=':' read -r header_name header_value <<< "$key"
        header_arguments[$header_name]=$header_value
    else
        curl_arguments+=" $key"
    fi
    ;;
    -)
    body_content_temp_file=$(mktemp)
    cat - > "$body_content_temp_file"
    ;;
    *=*)
    # Parse operation arguments and convert them into curl
    # only after the operation argument
    if [[ "$operation" ]]; then
        IFS='=' read -r parameter_name parameter_value <<< "$key"
        if [[ -z "${operation_parameters[$parameter_name]+foo}" ]]; then
            operation_parameters[$parameter_name]=$(url_escape "${parameter_value}")
        else
            operation_parameters[$parameter_name]+=":::"$(url_escape "${parameter_value}")
        fi
    else
        curl_arguments+=" $key"
    fi
    ;;
    *)
    # If we are before the operation, treat the arguments as cURL arguments
    if [[ "x$operation" == "x" ]]; then
        # Maintain quotes around cURL arguments if necessary
        space_regexp="[[:space:]]"
        if [[ $key =~ $space_regexp ]]; then
            curl_arguments+=" \"$key\""
        else
            curl_arguments+=" $key"
        fi
    fi
    ;;
esac
done


# Check if user provided host name
if [[ -z "$host" ]]; then
    ERROR_MSG="ERROR: No hostname provided!!! You have to  provide on command line option '--host ...'"
    exit 1
fi

# Check if user specified operation ID
if [[ -z "$operation" ]]; then
    ERROR_MSG="ERROR: No operation specified!!!"
    exit 1
fi


# Run cURL command based on the operation ID
case $operation in
    aboutList)
    call_aboutList
    ;;
    aboutMasterCopiesList)
    call_aboutMasterCopiesList
    ;;
    analyticsMultisigTransactionsByOriginList)
    call_analyticsMultisigTransactionsByOriginList
    ;;
    analyticsMultisigTransactionsBySafeList)
    call_analyticsMultisigTransactionsBySafeList
    ;;
    contractsList)
    call_contractsList
    ;;
    contractsRead)
    call_contractsRead
    ;;
    multisigTransactionsConfirmationsCreate)
    call_multisigTransactionsConfirmationsCreate
    ;;
    multisigTransactionsConfirmationsList)
    call_multisigTransactionsConfirmationsList
    ;;
    multisigTransactionsRead)
    call_multisigTransactionsRead
    ;;
    notificationsDevicesCreate)
    call_notificationsDevicesCreate
    ;;
    notificationsDevicesDelete)
    call_notificationsDevicesDelete
    ;;
    notificationsDevicesSafesDelete)
    call_notificationsDevicesSafesDelete
    ;;
    ownersRead)
    call_ownersRead
    ;;
    safesAllTransactionsList)
    call_safesAllTransactionsList
    ;;
    safesBalancesList)
    call_safesBalancesList
    ;;
    safesBalancesUsdList)
    call_safesBalancesUsdList
    ;;
    safesCollectiblesList)
    call_safesCollectiblesList
    ;;
    safesCreationList)
    call_safesCreationList
    ;;
    safesDelegatesCreate)
    call_safesDelegatesCreate
    ;;
    safesDelegatesDelete)
    call_safesDelegatesDelete
    ;;
    safesDelegatesList)
    call_safesDelegatesList
    ;;
    safesIncomingTransactionsList)
    call_safesIncomingTransactionsList
    ;;
    safesIncomingTransfersList)
    call_safesIncomingTransfersList
    ;;
    safesModuleTransactionsList)
    call_safesModuleTransactionsList
    ;;
    safesMultisigTransactionsCreate)
    call_safesMultisigTransactionsCreate
    ;;
    safesMultisigTransactionsList)
    call_safesMultisigTransactionsList
    ;;
    safesRead)
    call_safesRead
    ;;
    safesTransactionsCreate)
    call_safesTransactionsCreate
    ;;
    safesTransactionsList)
    call_safesTransactionsList
    ;;
    safesTransfersList)
    call_safesTransfersList
    ;;
    tokensList)
    call_tokensList
    ;;
    tokensRead)
    call_tokensRead
    ;;
    transactionsRead)
    call_transactionsRead
    ;;
    *)
    ERROR_MSG="ERROR: Unknown operation: $operation"
    exit 1
esac
