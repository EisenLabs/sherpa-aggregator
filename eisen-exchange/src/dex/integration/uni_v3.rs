use async_trait::async_trait;
use bindings::{
  i_uniswap_v3_pool,
  uni_v3_facet::{
    Tick, UniV3Facet, UniV3PoolParamsResponse, UniV3PoolStateResponse, UniV3SwapExactInputCall,
  },
};
use domain::pool::AmmLike;
use domain::{
  dex_id::DexId,
  general_address::GeneralAddress,
  pool::{self, math, Pool},
};
use ethers::prelude::{Address, Middleware, U256, U64};
use ethers::types::Filter;
use graphql_client::{GraphQLQuery, Response};
use itertools::Itertools;
use std::collections::{BTreeMap, HashSet};

type Bytes = ethers::types::Bytes;
type BigDecimal = f64;
use super::BigInt;
use ethers::contract::EthEvent;
use std::{str::FromStr, sync::Arc};
#[derive(GraphQLQuery)]
#[graphql(
  schema_path = "subquery/uni_v3/schema.graphql",
  query_path = "subquery/uni_v3/query-pools.graphql",
  response_derives = "Debug,Clone"
)]
struct MyQuery;

#[derive(GraphQLQuery)]
#[graphql(
  schema_path = "subquery/uni_v3/schema.graphql",
  query_path = "subquery/uni_v3/query-pool-count.graphql",
  response_derives = "Debug,Clone"
)]
struct PoolCountQuery;

struct StateWithTicks {
  state: UniV3PoolStateResponse,
  ticks: Vec<Tick>,
}

pub struct UniV3<M> {
  pub dex_id: DexId,
  pub factory: Address,
  pub subgraph_url: Option<String>,
  pub pools: Vec<GeneralAddress>,
  pub facet: UniV3Facet<M>,
  pub client: Arc<M>,
  pub multicall: ethers::contract::Multicall<M>,
  pub addr_page_size: usize,
  pub param_page_size: usize,
  pub state_page_size: usize,
  pub tick_page_size: usize,
  pub block_page_size: usize,
}

fn get_tick2liquidity_net_from_ticks(ticks: Vec<Tick>) -> BTreeMap<i64, i128> {
  let tick2liquidity_net: BTreeMap<i64, i128> = ticks
    .into_iter()
    .map(|tick| (tick.tick as i64, tick.liquidity_net))
    .collect();
  tick2liquidity_net
}

#[async_trait]
impl<M: Middleware + 'static> super::Dex for UniV3<M> {
  fn get_dex_id(&self) -> DexId {
    self.dex_id
  }

  async fn fetch_pool_addresses(&self, block_number: U64) -> anyhow::Result<Vec<GeneralAddress>> {
    //Get chainId for passing params
    //Use subGraph to fetch pool addresses
    // https://github.com/messari/subgraphs/tree/master/subgraphs/uniswap-v3/protocols/uniswap-v3/config/deployments

    let subgraph_url: &str = if let Some(subgraph_url) = &self.subgraph_url {
      subgraph_url
    } else {
      return Ok(self.pools.clone());
    };

    let pool_count_query = PoolCountQuery::build_query(pool_count_query::Variables {});
    let client = Arc::new(reqwest::Client::new());
    let response: Response<pool_count_query::ResponseData> = client
      .post(subgraph_url)
      .json(&pool_count_query)
      .send()
      .await?
      .json()
      .await?;

    let pool_count = response.data.unwrap().dex_amm_protocols.unwrap()[0]
      .clone()
      .unwrap()
      .total_pool_count
      .min(5000); // TODO: thegraph issue

    let calls = (0..pool_count)
      .step_by(self.addr_page_size)
      .map(|skip| {
        let c = client.clone();
        async move {
          let x = c
            .post(subgraph_url)
            .json(&MyQuery::build_query(my_query::Variables {
              first: Some(self.addr_page_size as i64),
              skip: Some(skip as i64),
            }))
            .send()
            .await?
            .json()
            .await?;

          Ok::<_, reqwest::Error>(x)
        }
      })
      .collect_vec();

    //TODO
    //Total pool count -> sequential query to get all pool addresses
    let responses: Vec<Response<my_query::ResponseData>> =
      futures::future::try_join_all(calls).await?;

    let mut general_pool_addrs = Vec::new();

    for response in responses {
      let pools = response.data.unwrap().dex_amm_protocols.unwrap()[0]
        .clone()
        .unwrap()
        .pools;

      for pool in pools.into_iter() {
        general_pool_addrs.push(GeneralAddress::DefaultAddr(Address::from_slice(&pool.id)));
      }
    }

    Ok(general_pool_addrs)
  }

  async fn fetch_pools(
    &self,
    block_number: U64,
    pool_addresses: &[GeneralAddress],
  ) -> anyhow::Result<Vec<Pool>> {
    let mut new_pool_addresses = Vec::new();
    for pool_addr in pool_addresses.iter() {
      if let GeneralAddress::DefaultAddr(v) = pool_addr {
        new_pool_addresses.push(v);
      }
    }

    let param_calls = new_pool_addresses
      .chunks(self.param_page_size)
      .map(|chunk| async move {
        let mut call = super::init_call(&self.multicall, Some(block_number));
        call.add_calls(
          false,
          chunk
            .iter()
            .map(|&pool_addr| self.facet.uni_v3_pool_params(*pool_addr)),
        );
        call.call_array::<UniV3PoolParamsResponse>().await
      })
      .collect_vec();

    let params = futures::future::try_join_all(param_calls).await?.concat();

    let state_calls = pool_addresses
      .chunks(self.state_page_size)
      .map(|chunk| async move {
        let mut call = super::init_call(&self.multicall, Some(block_number));
        call.clear_calls();
        call.add_calls(
          false,
          chunk
            .iter()
            .map(|pool_addr| self.facet.uni_v3_pool_state(pool_addr.to_address())),
        );
        call.call_array::<UniV3PoolStateResponse>().await
      })
      .collect_vec();

    let states = futures::future::try_join_all(state_calls).await?.concat();

    let tick_calls = pool_addresses
      .chunks(self.tick_page_size)
      .map(|chunk| async move {
        let mut call = super::init_call(&self.multicall, Some(block_number));
        call.clear_calls();
        call.add_calls(
          false,
          chunk
            .iter()
            .map(|pool_addr| self.facet.uni_v3_get_ticks(pool_addr.to_address(), 5)),
        );
        call.call_array::<Vec<Tick>>().await
      })
      .collect_vec();

    let ticks = futures::future::try_join_all(tick_calls).await?.concat();
    let states_with_ticks: Vec<StateWithTicks> = ticks
      .iter()
      .zip(&states)
      .zip(&params)
      .map(|((tick, state), param)| {
        let mut state_with_ticks: StateWithTicks = StateWithTicks {
          state: state.clone(),
          ticks: tick.clone(),
        };

        state_with_ticks
      })
      .collect_vec();

    Ok(
      params
        .iter()
        .zip(states_with_ticks)
        .map(|(param, state_with_ticks)| pool::UniV3 {
          dex_id: self.dex_id,
          address: GeneralAddress::from(param.pool),
          token_a: GeneralAddress::from(param.token_list[0]),
          token_b: GeneralAddress::from(param.token_list[1]),
          gasfee: 250000.0,
          fee: param.fee,
          tick2liquidity_net: get_tick2liquidity_net_from_ticks(state_with_ticks.ticks),
          min_tick: *math::var::MIN_TICK,
          max_tick: *math::var::MAX_TICK,
          tickspacing: param.tick_spacing.into(),
          liquidity: state_with_ticks.state.liquidity.into(),
          slot0_sqrt_price_x96: state_with_ticks.state.sqrt_price_x96,
          slot0_tick: state_with_ticks.state.tick.into(),
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
    let pool_addresses: Vec<Address> = pools
      .iter()
      .map(|p| p.get_address().to_address())
      .collect_vec();
    let pool_addresses_set: HashSet<Address> = HashSet::from_iter(pool_addresses.clone());

    let events: Vec<Vec<u8>> = vec![
      i_uniswap_v3_pool::SwapFilter::abi_signature().to_string(),
      i_uniswap_v3_pool::BurnFilter::abi_signature().to_string(),
      i_uniswap_v3_pool::MintFilter::abi_signature().to_string(),
      i_uniswap_v3_pool::FlashFilter::abi_signature().to_string(),
    ]
    .into_iter()
    .map(|e| e.into_bytes())
    .collect_vec();

    let mut block_number = prev_block_number;

    while block_number < current_block_number {
      let to_block = (block_number + U64::from(self.block_page_size)).min(current_block_number);

      let filter = Filter::new()
        .address::<Vec<Address>>(pool_addresses.clone())
        .from_block(block_number + U64::one())
        .to_block(to_block)
        .events(events.clone());

      let logs = self.client.get_logs(&filter).await?;

      let updated_pools = logs
        .iter()
        .map(|log| log.address)
        .unique()
        .filter(|addr| pool_addresses_set.contains(addr)) // note: address filter seems not work in base chain
        .map(GeneralAddress::from)
        .collect_vec();

      let fetched_pools = self
        .fetch_pools(current_block_number, &updated_pools)
        .await?;

      for new_pool in fetched_pools {
        for old_pool in &mut *pools {
          if old_pool.get_address() == new_pool.get_address() {
            *old_pool = new_pool;
            break;
          }
        }
      }

      block_number = to_block;
    }

    Ok(())
  }
}
