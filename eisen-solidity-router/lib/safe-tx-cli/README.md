# Gnosis Safe Transaction Service API Bash client

## Overview
This is a Bash client script for accessing Gnosis Safe Transaction Service API service.

The script uses cURL underneath for making all REST calls.

## Usage

```shell
# Make sure the script has executable rights
$ chmod u+x 

# Print the list of operations available on the service
$ ./ -h

# Print the service description
$ ./ --about

# Print detailed information about specific operation
$ ./ <operationId> -h

# Make GET request
./ --host http://<hostname>:<port> --accept xml <operationId> <queryParam1>=<value1> <header_key1>:<header_value2>

# Make GET request using arbitrary curl options (must be passed before <operationId>) to an SSL service using username:password
 -k -sS --tlsv1.2 --host https://<hostname> -u <user>:<password> --accept xml <operationId> <queryParam1>=<value1> <header_key1>:<header_value2>

# Make POST request
$ echo '<body_content>' |  --host <hostname> --content-type json <operationId> -

# Make POST request with simple JSON content, e.g.:
# {
#   "key1": "value1",
#   "key2": "value2",
#   "key3": 23
# }
$ echo '<body_content>' |  --host <hostname> --content-type json <operationId> key1==value1 key2=value2 key3:=23 -

# Preview the cURL command without actually executing it
$  --host http://<hostname>:<port> --dry-run <operationid>

```

## Docker image
You can easily create a Docker image containing a preconfigured environment
for using the REST Bash client including working autocompletion and short
welcome message with basic instructions, using the generated Dockerfile:

```shell
docker build -t my-rest-client .
docker run -it my-rest-client
```

By default you will be logged into a Zsh environment which has much more
advanced auto completion, but you can switch to Bash, where basic autocompletion
is also available.

## Shell completion

### Bash
The generated bash-completion script can be either directly loaded to the current Bash session using:

```shell
source .bash-completion
```

Alternatively, the script can be copied to the `/etc/bash-completion.d` (or on OSX with Homebrew to `/usr/local/etc/bash-completion.d`):

```shell
sudo cp .bash-completion /etc/bash-completion.d/
```

#### OS X
On OSX you might need to install bash-completion using Homebrew:
```shell
brew install bash-completion
```
and add the following to the `~/.bashrc`:

```shell
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
```

### Zsh
In Zsh, the generated `_` Zsh completion file must be copied to one of the folders under `$FPATH` variable.


## Documentation for API Endpoints

All URIs are relative to */api/v1*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*AboutApi* | [**aboutList**](docs/AboutApi.md#aboutlist) | **GET** /about/ | 
*AboutApi* | [**aboutMasterCopiesList**](docs/AboutApi.md#aboutmastercopieslist) | **GET** /about/master-copies/ | 
*AnalyticsApi* | [**analyticsMultisigTransactionsByOriginList**](docs/AnalyticsApi.md#analyticsmultisigtransactionsbyoriginlist) | **GET** /analytics/multisig-transactions/by-origin/ | 
*AnalyticsApi* | [**analyticsMultisigTransactionsBySafeList**](docs/AnalyticsApi.md#analyticsmultisigtransactionsbysafelist) | **GET** /analytics/multisig-transactions/by-safe/ | 
*ContractsApi* | [**contractsList**](docs/ContractsApi.md#contractslist) | **GET** /contracts/ | 
*ContractsApi* | [**contractsRead**](docs/ContractsApi.md#contractsread) | **GET** /contracts/{address}/ | 
*MultisigTransactionsApi* | [**multisigTransactionsConfirmationsCreate**](docs/MultisigTransactionsApi.md#multisigtransactionsconfirmationscreate) | **POST** /multisig-transactions/{safe_tx_hash}/confirmations/ | 
*MultisigTransactionsApi* | [**multisigTransactionsConfirmationsList**](docs/MultisigTransactionsApi.md#multisigtransactionsconfirmationslist) | **GET** /multisig-transactions/{safe_tx_hash}/confirmations/ | 
*MultisigTransactionsApi* | [**multisigTransactionsRead**](docs/MultisigTransactionsApi.md#multisigtransactionsread) | **GET** /multisig-transactions/{safe_tx_hash}/ | 
*NotificationsApi* | [**notificationsDevicesCreate**](docs/NotificationsApi.md#notificationsdevicescreate) | **POST** /notifications/devices/ | 
*NotificationsApi* | [**notificationsDevicesDelete**](docs/NotificationsApi.md#notificationsdevicesdelete) | **DELETE** /notifications/devices/{uuid}/ | 
*NotificationsApi* | [**notificationsDevicesSafesDelete**](docs/NotificationsApi.md#notificationsdevicessafesdelete) | **DELETE** /notifications/devices/{uuid}/safes/{address}/ | 
*OwnersApi* | [**ownersRead**](docs/OwnersApi.md#ownersread) | **GET** /owners/{address}/ | 
*SafesApi* | [**safesAllTransactionsList**](docs/SafesApi.md#safesalltransactionslist) | **GET** /safes/{address}/all-transactions/ | 
*SafesApi* | [**safesBalancesList**](docs/SafesApi.md#safesbalanceslist) | **GET** /safes/{address}/balances/ | 
*SafesApi* | [**safesBalancesUsdList**](docs/SafesApi.md#safesbalancesusdlist) | **GET** /safes/{address}/balances/usd/ | 
*SafesApi* | [**safesCollectiblesList**](docs/SafesApi.md#safescollectibleslist) | **GET** /safes/{address}/collectibles/ | 
*SafesApi* | [**safesCreationList**](docs/SafesApi.md#safescreationlist) | **GET** /safes/{address}/creation/ | 
*SafesApi* | [**safesDelegatesCreate**](docs/SafesApi.md#safesdelegatescreate) | **POST** /safes/{address}/delegates/ | 
*SafesApi* | [**safesDelegatesDelete**](docs/SafesApi.md#safesdelegatesdelete) | **DELETE** /safes/{address}/delegates/{delegate_address}/ | 
*SafesApi* | [**safesDelegatesList**](docs/SafesApi.md#safesdelegateslist) | **GET** /safes/{address}/delegates/ | 
*SafesApi* | [**safesIncomingTransactionsList**](docs/SafesApi.md#safesincomingtransactionslist) | **GET** /safes/{address}/incoming-transactions/ | 
*SafesApi* | [**safesIncomingTransfersList**](docs/SafesApi.md#safesincomingtransferslist) | **GET** /safes/{address}/incoming-transfers/ | 
*SafesApi* | [**safesModuleTransactionsList**](docs/SafesApi.md#safesmoduletransactionslist) | **GET** /safes/{address}/module-transactions/ | 
*SafesApi* | [**safesMultisigTransactionsCreate**](docs/SafesApi.md#safesmultisigtransactionscreate) | **POST** /safes/{address}/multisig-transactions/ | 
*SafesApi* | [**safesMultisigTransactionsList**](docs/SafesApi.md#safesmultisigtransactionslist) | **GET** /safes/{address}/multisig-transactions/ | 
*SafesApi* | [**safesRead**](docs/SafesApi.md#safesread) | **GET** /safes/{address}/ | 
*SafesApi* | [**safesTransactionsCreate**](docs/SafesApi.md#safestransactionscreate) | **POST** /safes/{address}/transactions/ | 
*SafesApi* | [**safesTransactionsList**](docs/SafesApi.md#safestransactionslist) | **GET** /safes/{address}/transactions/ | 
*SafesApi* | [**safesTransfersList**](docs/SafesApi.md#safestransferslist) | **GET** /safes/{address}/transfers/ | 
*TokensApi* | [**tokensList**](docs/TokensApi.md#tokenslist) | **GET** /tokens/ | 
*TokensApi* | [**tokensRead**](docs/TokensApi.md#tokensread) | **GET** /tokens/{address}/ | 
*TransactionsApi* | [**transactionsRead**](docs/TransactionsApi.md#transactionsread) | **GET** /transactions/{safe_tx_hash}/ | 


## Documentation For Models

 - [AnalyticsMultisigTxsByOriginResponse](docs/AnalyticsMultisigTxsByOriginResponse.md)
 - [AnalyticsMultisigTxsBySafeResponse](docs/AnalyticsMultisigTxsBySafeResponse.md)
 - [Contract](docs/Contract.md)
 - [ContractAbi](docs/ContractAbi.md)
 - [Erc20Info](docs/Erc20Info.md)
 - [EthereumTxWithTransfersResponse](docs/EthereumTxWithTransfersResponse.md)
 - [FirebaseDevice](docs/FirebaseDevice.md)
 - [MasterCopyResponse](docs/MasterCopyResponse.md)
 - [OwnerResponse](docs/OwnerResponse.md)
 - [SafeBalanceResponse](docs/SafeBalanceResponse.md)
 - [SafeBalanceUsdResponse](docs/SafeBalanceUsdResponse.md)
 - [SafeCollectibleResponse](docs/SafeCollectibleResponse.md)
 - [SafeCreationInfoResponse](docs/SafeCreationInfoResponse.md)
 - [SafeDelegate](docs/SafeDelegate.md)
 - [SafeDelegateResponse](docs/SafeDelegateResponse.md)
 - [SafeInfoResponse](docs/SafeInfoResponse.md)
 - [SafeModuleTransactionResponse](docs/SafeModuleTransactionResponse.md)
 - [SafeModuleTransactionWithTransfersResponse](docs/SafeModuleTransactionWithTransfersResponse.md)
 - [SafeMultisigConfirmation](docs/SafeMultisigConfirmation.md)
 - [SafeMultisigConfirmationResponse](docs/SafeMultisigConfirmationResponse.md)
 - [SafeMultisigTransaction](docs/SafeMultisigTransaction.md)
 - [SafeMultisigTransactionResponse](docs/SafeMultisigTransactionResponse.md)
 - [SafeMultisigTransactionWithTransfersResponse](docs/SafeMultisigTransactionWithTransfersResponse.md)
 - [TokenInfoResponse](docs/TokenInfoResponse.md)
 - [TransferResponse](docs/TransferResponse.md)
 - [TransferWithTokenInfoResponse](docs/TransferWithTokenInfoResponse.md)
 - [_AllTransactionsSchema](docs/_AllTransactionsSchema.md)


## Documentation For Authorization


## Basic

- **Type**: HTTP basic authentication

