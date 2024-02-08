use std::sync::Arc;

use async_trait::async_trait;
use ethers::{
  abi::Tokenize,
  contract::EthEvent,
  prelude::{Address, LogMeta, Middleware, U256, U64},
  types::{Bytes, Filter},
};
use futures::TryFutureExt;
use itertools::Itertools;

use bindings::i_uniswap_v2_pair;
use bindings::uni_v2_facet::{
  UniV2Facet, UniV2SwapExactInputCall, UniV2PoolParamsResponse, UniV2PoolStateResponse,
};
use domain::{
  dex_id::DexId,
  general_address::GeneralAddress,
  pool::{self, AmmLike, Pool},
};

pub struct UniV2<M> {
  pub dex_id: DexId,
  pub factory: Address,
  pub router: Option<Address>,
  pub facet: UniV2Facet<M>,
  pub multicall: ethers::contract::Multicall<M>,
  pub client: Arc<M>,
  pub addr_page_size: usize,
  pub param_page_size: usize,
  pub state_page_size: usize,
  pub block_page_size: usize,
}

#[async_trait]
impl<M: Middleware + 'static> super::Dex for UniV2<M> {
  fn get_dex_id(&self) -> DexId {
    self.dex_id
  }

  async fn fetch_pool_addresses(&self, block_number: U64) -> anyhow::Result<Vec<GeneralAddress>> {
    let pool_count = self
      .facet
      .uni_v2_pool_num(self.factory)
      .call()
      .await?
      .as_usize();

    let calls = (0..pool_count)
      .step_by(self.addr_page_size)
      .map(|offset| async move {
        self
          .facet
          .uni_v2_pools(
            self.factory,
            U256::from(offset),
            U256::from(pool_count.min(offset + self.addr_page_size)),
          )
          .block(block_number)
          .call()
          .await
      });

    let pool_addrs = futures::future::try_join_all(calls).await?.concat();
    let mut general_pool_addrs = Vec::new();

    for pool_addr in pool_addrs.iter() {
      general_pool_addrs.push(GeneralAddress::DefaultAddr(*pool_addr));
    }

    Ok(general_pool_addrs)
  }

  async fn fetch_pools(
    &self,
    block_number: U64,
    pool_addresses: &[GeneralAddress],
  ) -> anyhow::Result<Vec<Pool>> {
    let default_pool_addrs = pool_addresses
      .iter()
      .filter_map(|addr| match addr {
        GeneralAddress::DefaultAddr(t) => Some(*t),
        _ => None,
      })
      .collect_vec();

    let param_calls = default_pool_addrs
      .chunks(self.param_page_size)
      .map(|chunk| async move {
        let mut call = super::init_call(&self.multicall, Some(block_number));
        call.add_calls(
          false,
          chunk
            .iter()
            .map(|&pool_addr| self.facet.uni_v2_pool_params(pool_addr)),
        );
        call.call_array::<UniV2PoolParamsResponse>().await
      })
      .collect_vec();

    let params = futures::future::try_join_all(param_calls).await?.concat();

    let state_calls = default_pool_addrs
      .chunks(self.state_page_size)
      .map(|chunk| async move {
        let mut call = super::init_call(&self.multicall, Some(block_number));
        call.clear_calls();
        call.add_calls(
          false,
          chunk
            .iter()
            .map(|&pool_addr| self.facet.uni_v2_pool_state(pool_addr)),
        );
        call.call_array::<UniV2PoolStateResponse>().await
      })
      .collect_vec();

    let states = futures::future::try_join_all(state_calls).await?.concat();

    Ok(
      params
        .iter()
        .zip(states)
        .map(|(param, state)| pool::UniV2 {
          gasfee: 135000.0,
          dex_id: self.dex_id,
          address: GeneralAddress::from(param.pool),
          token_a: GeneralAddress::from(param.token_list[0]),
          token_b: GeneralAddress::from(param.token_list[1]),
          balance_a: state.balances[0],
          balance_b: state.balances[1],
          fee: (param.fees[0], param.fees[1]),
        })
        .map(Pool::from)
        .collect_vec(),
    )
  }

  async fn update_pools_mut(
    &self,
    prev_block_number: U64,
    current_block_number: U64,
    pools: &mut [Pool],
  ) -> anyhow::Result<()> {
    let pool_addresses = pools
      .iter()
      .map(|p| p.get_address().to_address())
      .collect_vec();

    let mut block_number = prev_block_number;

    while block_number < current_block_number {
      let to_block = (block_number + U64::from(self.block_page_size)).min(current_block_number);

      let events_query = pool_addresses
        .chunks(self.addr_page_size)
        .map(|chunk| async {
          let filter =
            i_uniswap_v2_pair::SyncFilter::new::<Arc<M>, M>(Filter::new(), self.client.clone())
              .from_block(block_number + U64::one())
              .to_block(to_block)
              .address(chunk.to_vec().into());

          let sync_events: Result<Vec<(i_uniswap_v2_pair::SyncFilter, LogMeta)>, _> =
            filter.query_with_meta().await;

          sync_events
        });

      let sync_events = futures::future::try_join_all(events_query).await?.concat();

      for (sync_event, log) in sync_events {
        let pool_address = log.address;
        let reserve_0 = U256::from(sync_event.reserve_0);
        let reserve_1 = U256::from(sync_event.reserve_1);
        for p in &mut *pools {
          if let Pool::UniV2(uni2) = p {
            if uni2.address.to_address() == pool_address {
              uni2.balance_a = reserve_0;
              uni2.balance_b = reserve_1;
            }
          }
        }
      }

      block_number = to_block;
    }

    Ok(())
  }
}
