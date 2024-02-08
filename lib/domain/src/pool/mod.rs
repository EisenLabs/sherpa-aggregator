mod finder;
pub mod math;
mod uni_v2;
mod uni_v3;

use ethers::types::U256;
pub use finder::*;
use serde::{Deserialize, Serialize};
pub use uni_v2::*;
pub use uni_v3::*;

use crate::dex_id::DexId;
use crate::general_address::GeneralAddress;

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(tag = "type")]
pub enum Pool {
  UniV2(UniV2),
  UniV3(UniV3),
}

impl Pool {
  pub fn address(&self) -> GeneralAddress {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.address.into(),
      Pool::UniV3(uni_v3) => uni_v3.address.into(),
    }
  }
}

impl From<UniV2> for Pool {
  fn from(value: UniV2) -> Self {
    Pool::UniV2(value)
  }
}
impl From<UniV3> for Pool {
  fn from(value: UniV3) -> Self {
    Pool::UniV3(value)
  }
}

impl AmmLike for Pool {
  fn print_info(&self) {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.print_info(),
      Pool::UniV3(uni_v3) => uni_v3.print_info(),
    }
  }

  fn get_gasfee(&self) -> f64 {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.get_gasfee(),
      Pool::UniV3(uni_v3) => uni_v3.get_gasfee(),
    }
  }

  fn get_dex_id(&self) -> DexId {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.get_dex_id(),
      Pool::UniV3(uni_v3) => uni_v3.get_dex_id(),
    }
  }
  fn get_address(&self) -> GeneralAddress {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.get_address(),
      Pool::UniV3(uni_v3) => uni_v3.get_address(),
    }
  }
  fn get_tokens(&self) -> Vec<GeneralAddress> {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.get_tokens(),
      Pool::UniV3(uni_v3) => uni_v3.get_tokens(),
    }
  }

  fn calc_amount_out<PF: PoolFinder>(
    &self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.calc_amount_out(src_token, dst_token, amount, pf),
      Pool::UniV3(uni_v3) => None,
    }
  }

  fn calc_zero_fee_amount_out<PF: PoolFinder>(
    &self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.calc_zero_fee_amount_out(src_token, dst_token, amount, pf),
      Pool::UniV3(uni_v3) => None,
    }
  }

  fn swap<PF: PoolFinder>(
    &mut self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    match self {
      Pool::UniV2(uni_v2) => uni_v2.swap(src_token, dst_token, amount, pf),
      Pool::UniV3(uni_v3) => None,
    }
  }
}

pub trait AmmLike {
  fn print_info(&self);

  fn get_gasfee(&self) -> f64;

  fn get_dex_id(&self) -> DexId;

  fn get_address(&self) -> GeneralAddress;

  fn get_tokens(&self) -> Vec<GeneralAddress>;

  fn calc_amount_out<PF: PoolFinder>(
    &self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256>;

  fn calc_zero_fee_amount_out<PF: PoolFinder>(
    &self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256>;

  fn swap<PF: PoolFinder>(
    &mut self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256>;
}
