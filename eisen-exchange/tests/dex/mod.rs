use std::sync::Arc;

use config::Config;
use domain::general_address::GeneralAddress;
use domain::pool::{AmmLike, PoolFinder};
use eisen_ethers::ForkUtils;
use eisen_exchange::Dex;
use ethers::contract::{EthEvent, Multicall, MulticallVersion};
use ethers::providers::{Http, Middleware, Provider};
use ethers::signers::Signer;
use ethers::types::{Address, Bytes, U256, U64};
use itertools::Itertools;
use reqwest::Url;
use tokio::time::Instant;

mod base;
mod bera_test;

pub struct TestEnv<M: Middleware + 'static> {
  config: Config,
  client: Arc<M>,
  multicall: Multicall<M>,
  block_number: u64,
  fork_utils: ForkUtils,
}

impl<M: Middleware + 'static> TestEnv<M> {
  fn new(
    config: Config,
    client: Arc<M>,
    multicall: Multicall<M>,
    block_number: u64,
    fork_utils: ForkUtils,
  ) -> Self {
    Self {
      config,
      client,
      multicall,
      block_number,
      fork_utils,
    }
  }
}

impl TestEnv<Provider<Http>> {
  async fn live(chain: &str, public_endpoint: &str) -> anyhow::Result<Self> {
    let config = config::Config::load(chain)?;

    let fork_utils = ForkUtils::new(
      config.chain.metadata.chain_id as u64,
      None::<u64>,
      public_endpoint,
    )
    .await?;

    let multicall = ethers::contract::Multicall::<Provider<_>>::new_with_chain_id(
      fork_utils.provider.clone(),
      Some(config.chain.contracts.multicall),
      None::<u64>,
    )?
    .version(MulticallVersion::Multicall2)
    .legacy();

    let block_number = fork_utils.provider.get_block_number().await?;
    let chain_id = config.chain.metadata.chain_id as u64;

    let client = fork_utils.provider.clone();

    Ok(Self::new(
      config,
      client,
      multicall,
      block_number.as_u64(),
      fork_utils,
    ))
  }

  async fn fork(
    chain: &str,
    archive_endpoint: &str,
    block_number: Option<u64>,
  ) -> anyhow::Result<Self> {
    let config = config::Config::load(chain)?;

    let fork_utils = ForkUtils::new(
      config.chain.metadata.chain_id,
      block_number,
      archive_endpoint,
    )
    .await?;

    let multicall = ethers::contract::Multicall::<_>::new_with_chain_id(
      fork_utils.provider.clone(),
      Some(config.chain.contracts.multicall),
      None::<u64>,
    )?
    .version(MulticallVersion::Multicall2)
    .legacy();

    let block_number = fork_utils.provider.get_block_number().await?;

    Ok(Self::new(
      config,
      fork_utils.provider.clone(),
      multicall,
      block_number.as_u64(),
      fork_utils,
    ))
  }
}

pub struct DummyPF;

impl PoolFinder for DummyPF {
  fn get_pool(&self, addr: GeneralAddress) -> Option<&domain::pool::Pool> {
    None
  }
}
