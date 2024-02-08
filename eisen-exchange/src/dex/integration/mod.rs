pub use super::Dex;
pub use uni_v2::*;
pub use uni_v3::*;
mod uni_v2;
mod uni_v3;
use bindings;
use ethers::providers::Middleware;
use ethers::types::BlockNumber;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct BigInt(#[serde(with = "domain::serde_helpers::u256")] ethers::types::U256);

impl From<BigInt> for ethers::types::U256 {
  fn from(value: BigInt) -> Self {
    value.0
  }
}

fn init_call<M: Middleware + 'static>(
  multicall: &ethers::contract::Multicall<M>,
  block_number: Option<impl Into<BlockNumber>>,
) -> ethers::contract::Multicall<M> {
  let mut cloned = multicall.clone();
  cloned.clear_calls();
  if let Some(bn) = block_number {
    cloned.block(bn)
  } else {
    cloned
  }
}
