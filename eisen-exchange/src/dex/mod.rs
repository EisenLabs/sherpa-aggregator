use std::{collections::HashMap, sync::Arc};

use anyhow::Result;
use async_trait::async_trait;
use domain::{
  contract::ContractInterface, dex_id::DexId, general_address::GeneralAddress, pool::Pool,
};
use ethers::{
  contract::Multicall,
  providers::Middleware,
  types::{Address, BlockNumber, U256, U64},
};
use itertools::Itertools;

mod integration;
pub use integration::*;

#[async_trait]
pub trait Dex: Sync + Send {
  fn get_dex_id(&self) -> DexId;

  async fn fetch_pool_addresses(&self, block_number: U64) -> Result<Vec<GeneralAddress>>;

  async fn fetch_pools(
    &self,
    block_number: U64,
    pool_addresses: &[GeneralAddress],
  ) -> Result<Vec<Pool>>;

  async fn update_pools_mut(
    &self,
    prev_block_number: U64,
    current_block_number: U64,
    pools: &mut [Pool],
  ) -> Result<()> {
    let pool_addresses = pools.iter().map(|p| p.address()).collect_vec();
    let updated_pools = self
      .fetch_pools(current_block_number, &pool_addresses)
      .await?;
    for (old, new) in pools.iter_mut().zip(updated_pools) {
      *old = new;
    }
    Ok(())
  }
}

#[derive(Clone)]
pub struct DexView {
  pub dex_map: HashMap<(DexId, ContractInterface), Arc<dyn Dex>>,
}
