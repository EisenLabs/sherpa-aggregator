use super::constants::*;
use crate::dex::TestEnv;
use bindings::uni_v2_facet::UniV2Facet;
use domain::dex_id::DexId;
use eisen_exchange::{Dex, UniV2};
use ethers::abi::Token;
use ethers::signers::Signer;
use ethers::types::Address;
use std::str::FromStr;

#[tokio::test(flavor = "multi_thread")]
async fn test_fetch_pools() -> anyhow::Result<()> {
  let test_env = TestEnv::live("base", PUBLIC_ENDPOINT).await?;
  let (signer, provider) = test_env.fork_utils.get_signer(0);

  let uni_v2_facet = UniV2Facet::deploy(test_env.client.clone(), ())?
    .from(signer.address())
    .send()
    .await?;

  let base_swap = UniV2 {
    dex_id: DexId::from("BaseSwap"),
    factory: Address::from_str("0xFDa619b6d20975be80A10332cD39b9a4b0FAa8BB")?,
    router: None,
    facet: uni_v2_facet,
    multicall: test_env.multicall,
    client: test_env.client,
    addr_page_size: 100,
    param_page_size: 100,
    state_page_size: 100,
    block_page_size: 100,
  };

  let addresses = base_swap
    .fetch_pool_addresses(test_env.block_number.into())
    .await?;

  base_swap
    .fetch_pools(test_env.block_number.into(), &addresses.as_slice()[0..5])
    .await?;

  Ok(())
}
