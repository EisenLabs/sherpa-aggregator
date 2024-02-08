use bindings::erc20::erc20::ERC20;
use std::sync::Arc;

use anvil::{eth::EthApi, spawn, NodeConfig, NodeHandle};
use ethers::{
  abi::Address,
  prelude::{rand, LocalWallet, SignerMiddleware},
  providers::{Http, Middleware, Provider},
  signers::Signer,
  types::{transaction::eip2718::TypedTransaction, U256},
};
use foundry_utils::rpc;

pub struct ForkUtils {
  api: EthApi,
  handle: NodeHandle,
  accounts: Vec<LocalWallet>,
  pub provider: Arc<Provider<Http>>,
}

impl ForkUtils {
  pub async fn new(
    chain_id: impl Into<u64>,
    block_number: Option<impl Into<u64>>,
    rpc_url: impl Into<String>,
  ) -> anyhow::Result<ForkUtils> {
    let (api, handle) = spawn(
      NodeConfig::test()
        .with_eth_rpc_url(Some(rpc_url))
        .with_fork_block_number(block_number)
        .with_chain_id(Some(chain_id))
        .silent(),
    )
    .await;

    if !api.is_fork() {
      return Err(anyhow::anyhow!("fork failed!"));
    }

    let accounts: Vec<_> = handle.dev_wallets().collect();
    for account in handle.dev_accounts() {
      api
        .anvil_set_balance(account, U256::from(10000000e18 as u64))
        .await?;
    }

    let wallet = LocalWallet::new(&mut rand::thread_rng());
    api
      .anvil_set_balance(wallet.address(), U256::from(10000000e18 as u64))
      .await?;

    
    let provider: Arc<Provider<Http>> = Arc::new(handle.http_provider());

    Ok(ForkUtils {
      api,
      handle,
      provider,
      accounts,
    })
  }
  pub async fn mainnet(block_number: Option<impl Into<u64>>) -> anyhow::Result<ForkUtils> {
    Self::new(1_u64, block_number, rpc::next_http_archive_rpc_endpoint()).await
  }

  pub fn get_signer(&self, idx: usize) -> (&LocalWallet, Arc<impl Middleware>) {
    let http_provider: Provider<Http> = self.handle.http_provider();

    let provider = SignerMiddleware::new(http_provider, self.accounts[idx].clone());

    (&self.accounts[idx], Arc::new(provider))
  }

  pub async fn impersonate_tx(
    &self,
    account: Address,
    mut tx: TypedTransaction,
  ) -> anyhow::Result<ethers::types::TransactionReceipt> {
    self.api.anvil_impersonate_account(account).await?;
    self
      .api
      .anvil_set_balance(account, U256::from(1e18 as u64))
      .await?;
    tx.set_from(account);

    self.provider.fill_transaction(&mut tx, None).await?;

    let receipt = self.provider.send_transaction(tx, None).await?.await?;

    match receipt {
      Some(receipt) => {
        if receipt.status == Some(1u64.into()) {
          Ok(receipt)
        } else {
          Err(anyhow::anyhow!("transaction failed"))
        }
      }
      None => Err(anyhow::anyhow!("no receipt")),
    }
  }

  pub async fn deal(
    &self,
    token: Address,
    from: Address,
    to: Address,
    amount: U256,
  ) -> anyhow::Result<()> {
    let token = ERC20::new(token, self.provider.clone());
    let call = token.transfer(to, amount).legacy();
    self.impersonate_tx(from, call.tx).await?;
    Ok(())
  }

  pub async fn deal_eth(&self, to: Address, amount: U256) -> anyhow::Result<()> {
    self.api.anvil_set_balance(to, amount).await?;

    Ok(())
  }
}
