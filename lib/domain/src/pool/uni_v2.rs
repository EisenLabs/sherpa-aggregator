use ethers::types::{Address, U256};
use serde::{Deserialize, Serialize};

use crate::dex_id::DexId;

use super::{math, PoolFinder};

use crate::general_address::GeneralAddress;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UniV2 {
  pub gasfee: f64,
  pub dex_id: DexId,
  pub address: GeneralAddress,
  pub token_a: GeneralAddress,
  pub token_b: GeneralAddress,
  pub balance_a: U256,
  pub balance_b: U256,
  pub fee: (U256, U256), // (3, 1000) if fee is 0.3%
}

impl UniV2 {
  fn get_balance(&self, token: GeneralAddress) -> Option<U256> {
    if token == self.token_a {
      Some(self.balance_a)
    } else if token == self.token_b {
      Some(self.balance_b)
    } else {
      None
    }
  }

  fn get_balance_mut(&mut self, token: GeneralAddress) -> Option<&mut U256> {
    if token == self.token_a {
      Some(&mut self.balance_a)
    } else if token == self.token_b {
      Some(&mut self.balance_b)
    } else {
      None
    }
  }
}

impl super::AmmLike for UniV2 {
  fn print_info(&self) {
    println!(
      "uni2\n{} {}\n{} {}",
      self.token_a.to_string(),
      self.balance_a,
      self.token_b.to_string(),
      self.balance_b
    );
  }

  fn get_gasfee(&self) -> f64 {
    self.gasfee
  }
  fn get_dex_id(&self) -> DexId {
    self.dex_id
  }

  fn get_address(&self) -> GeneralAddress {
    self.address
  }

  fn get_tokens(&self) -> Vec<GeneralAddress> {
    vec![self.token_a, self.token_b]
  }

  fn calc_zero_fee_amount_out<PF: PoolFinder>(
    &self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    math::calc_uni2_out(
      self.get_balance(src_token)?,
      self.get_balance(dst_token)?,
      amount,
      (U256::zero(), U256::exp10(3)),
    )
  }

  fn calc_amount_out<PF: PoolFinder>(
    &self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    math::calc_uni2_out(
      self.get_balance(src_token)?,
      self.get_balance(dst_token)?,
      amount,
      self.fee,
    )
  }

  fn swap<PF: PoolFinder>(
    &mut self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    let amount_out = self.calc_amount_out(src_token, dst_token, amount, pf)?;

    if src_token == self.token_a {
      if self.balance_a + amount > U256::one() << U256::from(112) {
        return None;
      }
      self.balance_a = self.balance_a + amount;
      self.balance_b = self.balance_b - amount_out;
    } else {
      if self.balance_b + amount > U256::one() << U256::from(112) {
        return None;
      }
      self.balance_b = self.balance_b + amount;
      self.balance_a = self.balance_a - amount_out;
    }
    Some(amount_out)
  }
}

#[cfg(test)]
mod tests {
  use super::*;
  use ethers::types::{Address, U256};
  use std::str::FromStr;

  struct EmptyPF {}

  impl PoolFinder for EmptyPF {
    fn get_pool(&self, addr: GeneralAddress) -> Option<&crate::pool::Pool> {
      todo!()
    }
  }

  #[test]
  fn test_market_depth() {
    let price_amount = U256::from(10);
    let step_amount = U256::from(100);

    let pool = UniV2 {
      gasfee: 1.0,
      dex_id: DexId::from("Quickswap"),
      address: GeneralAddress::from_string("0x20C2E7a21322f1784597A23E977C9641b36E7AFb").unwrap(),
      token_a: GeneralAddress::from_string("0xa3Fa99A148fA48D14Ed51d610c367C61876997F1").unwrap(),
      token_b: GeneralAddress::from_string("0xB9638272aD6998708de56BBC0A290a1dE534a578").unwrap(),
      balance_a: U256::from("107"),
      balance_b: U256::from("9461"),
      fee: (U256::from(10), U256::from(100)),
    };
  }
}
