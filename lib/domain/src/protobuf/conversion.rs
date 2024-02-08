use std::str::FromStr;

use self::entities::*;
use ethers::types::U256;

use super::conversion_error::ConvError;
use crate::{
  dex_id,
  general_address::GeneralAddress,
  pool::{self},
  token,
};

pub mod entities {
  tonic::include_proto!("entities");
  tonic::include_proto!("entities.serde");
}

impl From<dex_id::DexId> for String {
  fn from(val: dex_id::DexId) -> Self {
    val.to_string()
  }
}

impl TryFrom<&str> for dex_id::DexId {
  type Error = ConvError;

  fn try_from(value: &str) -> Result<Self, Self::Error> {
    Ok(dex_id::DexId::from(value))
  }
}

impl TryFrom<&Token> for token::Token {
  type Error = ConvError;

  fn try_from(value: &Token) -> Result<Self, Self::Error> {
    Ok(token::Token {
      address: GeneralAddress::from_string(value.address.to_string().as_str())?,
      decimal: u16::try_from(value.decimal)?,
      symbol: value.symbol.clone(),
      name: value.name.clone(),
      bookmarked: value.bookmarked,
      icon: value.icon.clone(),
      paused: value.paused,
    })
  }
}

impl TryFrom<&UniV2> for pool::UniV2 {
  type Error = ConvError;

  fn try_from(value: &UniV2) -> Result<Self, Self::Error> {
    Ok(pool::UniV2 {
      gasfee: value.gasfee.parse()?,
      dex_id: dex_id::DexId::try_from(value.dex_id.as_str())?,
      address: GeneralAddress::from_string(value.address.to_string().as_str())?,
      token_a: GeneralAddress::from_string(value.token_a.to_string().as_str())?,
      token_b: GeneralAddress::from_string(value.token_b.to_string().as_str())?,
      balance_a: U256::from_dec_str(value.balance_a.as_str())?,
      balance_b: U256::from_dec_str(value.balance_b.as_str())?,
      fee: (
        U256::from_dec_str(value.fee_numerator.as_str())?,
        U256::from_dec_str(value.fee_denominator.as_str())?,
      ),
    })
  }
}

impl From<pool::UniV2> for UniV2 {
  fn from(val: pool::UniV2) -> Self {
    UniV2 {
      dex_id: val.dex_id.to_string(),
      address: format!("{:#x}", val.address),
      token_a: format!("{:#x}", val.token_a),
      token_b: format!("{:#x}", val.token_b),
      balance_a: val.balance_a.to_string(),
      balance_b: val.balance_b.to_string(),
      fee_numerator: val.fee.0.to_string(),
      fee_denominator: val.fee.1.to_string(),
      gasfee: val.gasfee.to_string(),
    }
  }
}

impl From<pool::UniV3> for UniV3 {
  fn from(value: pool::UniV3) -> Self {
    UniV3 {
      gasfee: value.gasfee.to_string(),
      dex_id: value.dex_id.to_string(),
      address: format!("{:#x}", value.address),
      token_a: format!("{:#x}", value.token_a),
      token_b: format!("{:#x}", value.token_b),
      fee: value.fee as i32,
      tick2liquidity_net: value
        .tick2liquidity_net
        .into_iter()
        .map(|(k, v)| (k, v.to_string()))
        .collect(),
      tickspacing: value.tickspacing,
      liquidity: value.liquidity.to_string(),
      slot0_sqrt_price_x96: value.slot0_sqrt_price_x96.to_string(),
      slot0_tick: value.slot0_tick,
      min_tick: value.min_tick,
      max_tick: value.max_tick,
    }
  }
}

impl TryFrom<&UniV3> for pool::UniV3 {
  type Error = ConvError;

  fn try_from(value: &UniV3) -> Result<Self, Self::Error> {
    Ok(pool::UniV3 {
      gasfee: value.gasfee.parse()?,
      dex_id: dex_id::DexId::try_from(value.dex_id.as_str())?,
      address: GeneralAddress::from_string(value.address.to_string().as_str())?,
      token_a: GeneralAddress::from_string(value.token_a.to_string().as_str())?,
      token_b: GeneralAddress::from_string(value.token_b.to_string().as_str())?,
      fee: value.fee as u32,
      tick2liquidity_net: value
        .tick2liquidity_net
        .iter()
        .map(|(k, v)| i128::from_str(v.as_str()).map(|v| (*k, v)))
        .collect::<Result<_, _>>()?,
      tickspacing: value.tickspacing,
      liquidity: U256::from_dec_str(value.liquidity.as_str())?,
      slot0_sqrt_price_x96: U256::from_dec_str(value.slot0_sqrt_price_x96.as_str())?,
      slot0_tick: value.slot0_tick,
      min_tick: value.min_tick,
      max_tick: value.max_tick,
    })
  }
}

impl From<pool::Pool> for Pool {
  fn from(value: pool::Pool) -> Self {
    match value {
      pool::Pool::UniV2(uni2) => Pool {
        value: Some(entities::pool::Value::UniV2(UniV2::from(uni2))),
      },
      pool::Pool::UniV3(uni3) => Pool {
        value: Some(entities::pool::Value::UniV3(UniV3::from(uni3))),
      },
    }
  }
}

impl TryFrom<&Pool> for pool::Pool {
  type Error = ConvError;

  fn try_from(value: &Pool) -> Result<Self, Self::Error> {
    match value.value {
      Some(entities::pool::Value::UniV2(ref uni2)) => {
        Ok(pool::Pool::UniV2(pool::UniV2::try_from(uni2)?))
      }
      Some(entities::pool::Value::UniV3(ref uni3)) => {
        Ok(pool::Pool::UniV3(pool::UniV3::try_from(uni3)?))
      }
      None => Err(ConvError::EmptyOneof),
    }
  }
}

impl From<token::Token> for Token {
  fn from(value: token::Token) -> Self {
    Token {
      address: format!("{:#x}", value.address),
      decimal: value.decimal as i32,
      symbol: value.symbol,
      name: value.name,
      paused: value.paused,
      bookmarked: value.bookmarked,
      icon: value.icon,
    }
  }
}
