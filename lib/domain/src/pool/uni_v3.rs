use super::{math, PoolFinder};
use crate::dex_id::DexId;

use ethers::types::{Address, U256};
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, HashMap};

use crate::general_address::GeneralAddress;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UniV3 {
  pub gasfee: f64,
  pub dex_id: DexId,
  pub address: GeneralAddress,
  pub token_a: GeneralAddress, // token X
  pub token_b: GeneralAddress, // token Y

  pub fee: u32,
  pub tick2liquidity_net: BTreeMap<i64, i128>,
  pub min_tick: i64,
  pub max_tick: i64,

  pub tickspacing: i64,
  pub liquidity: U256,

  //Slot0
  pub slot0_sqrt_price_x96: U256,
  pub slot0_tick: i64,
}

impl super::AmmLike for UniV3 {
  fn print_info(&self) {
    println!("uni3");
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
    todo!();
  }

  fn calc_amount_out<PF: PoolFinder>(
    &self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    todo!();
  }

  fn swap<PF: PoolFinder>(
    &mut self,
    src_token: GeneralAddress,
    dst_token: GeneralAddress,
    amount: U256,
    pf: &PF,
  ) -> Option<U256> {
    todo!();
  }
}

#[cfg(test)]
mod tests {
  //tick//tickspacing
  use super::*;
  use crate::pool::math::var;
  use crate::pool::AmmLike;
  use ethers::types::U256;
  use std::str::FromStr;
  use std::time::Instant;

  struct EmptyPF {}

  impl PoolFinder for EmptyPF {
    fn get_pool(&self, addr: GeneralAddress) -> Option<&crate::pool::Pool> {
      todo!()
    }
  }

  #[test]
  fn test_calc_uni3_out() {
    let uni3 = UniV3 {
      gasfee: 1.0,
      dex_id: DexId::from("UniswapV3"),
      address: GeneralAddress::from_string("0x0000000000000000000000000000000000000000").unwrap(),
      token_a: GeneralAddress::from_string("0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270").unwrap(), //WETH
      token_b: GeneralAddress::from_string("0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619").unwrap(), //USDC
      fee: 3000,
      tick2liquidity_net: BTreeMap::from([
        (-70980, -1702366965429197666000),
        (-71040, -40994927592271966302626),
        (-71100, -9608440436255911467699),
        (-71160, -15132418164742649354988),
        (-71220, 27855721648124573985735),
        (-71280, 4768142461529150460927),
        (-71340, 19677517303143673629383),
        (-71400, -895430511677671765004),
        (-71460, 56876313361427921320118),
        (-71520, 37686440401109564602167),
        (-71580, 40570668654733298468632),
        (-71640, 23540984075726513607912),
        (-71700, 119134502793451017167858),
        (-71760, 18164165771138544265241),
        (-71820, 31378168963090082788410),
        (-71880, 3793015641078547275695),
        (-71940, 11524255593934044340754),
        (-72000, 2004851264632954356418),
        (-72060, 5175221576508300832302),
        (-72120, 1186355773057661737436),
        (-72180, -15782364925217716317511),
        (-72240, 8835271251509188039595),
        (-72300, 1424107998944066209879),
        (-72360, 15956899595295842157130),
        (-72420, 7393589440340399148624),
        (-72480, 3261490986887905667397),
        (-72540, 12723609558818691427487),
        (-72600, -8025482292130061258815),
      ]),
      tickspacing: 60,
      liquidity: U256::from_dec_str("860745611824702446532619").unwrap(),
      slot0_sqrt_price_x96: U256::from_dec_str("2221254246402465595639851560").unwrap(),
      slot0_tick: -71489,
      min_tick: *var::MIN_TICK,
      max_tick: *var::MAX_TICK,
    };
    assert_eq!(
      uni3
        .calc_amount_out(uni3.token_a, uni3.token_b, U256::exp10(18), &EmptyPF {})
        .unwrap(),
      U256::from_dec_str("783668731765458").unwrap(),
    );
    //807803371
  }

  #[test]
  fn test_btreemap() {
    let btree: BTreeMap<i64, i128> = BTreeMap::from([
      (-10, 25),
      (-20, 30),
      (-30, 21),
      (-40, 5),
      (-50, 7),
      (-60, 3),
    ]);
    let key = -25;
    let (a, b) = btree.range(..=key).next_back().unwrap();
    let (c, d) = btree.range((key + 1)..).next().unwrap();

    println!("{}, {}", a, b);
    println!("{}, {}", c, d);

    let key = -20;
    let (a, b) = btree.range(..=key).next_back().unwrap();
    let (c, d) = btree.range((key + 1)..).next().unwrap();

    println!("{}, {}", a, b);
    println!("{}, {}", c, d);
  }
}
