// Plan to move tointerface
use crate::protobuf::conversion_error::ConvError;
use ethers::types::{Address, H160, H256};
use serde::{Deserialize, Deserializer, Serialize};

use std::collections::HashMap;
use std::fmt;
use std::hash::{Hash, Hasher};

#[derive(Debug, Clone, Serialize, Eq, PartialEq, Copy, Hash)]
pub enum GeneralAddress {
  DefaultAddr(Address),
  BalancerAddr(H256),
}

impl GeneralAddress {
  pub fn to_address(&self) -> Address {
    match self {
      GeneralAddress::DefaultAddr(addr) => *addr,
      GeneralAddress::BalancerAddr(addr) => Address::from_slice(&addr.as_bytes()[12..]),
    }
  }

  pub fn to_bytes(&self) -> H256 {
    match self {
      GeneralAddress::DefaultAddr(addr) => todo!(),
      GeneralAddress::BalancerAddr(addr) => addr.clone(),
    }
  }

  pub fn from_string(t: &str) -> Result<GeneralAddress, ConvError> {
    let cleaned_hex = if t.starts_with("0x") { &t[2..] } else { t };

    let bytes = hex::decode(cleaned_hex).map_err(ConvError::InvalidH256Address)?;

    if bytes.len() == 20 {
      Ok(GeneralAddress::from(Address::from_slice(&bytes)))
    } else {
      Ok(GeneralAddress::from(H256::from_slice(&bytes)))
    }
  }
}

impl From<Address> for GeneralAddress {
  fn from(value: Address) -> Self {
    Self::DefaultAddr(value)
  }
}

impl From<H256> for GeneralAddress {
  fn from(value: H256) -> Self {
    Self::BalancerAddr(value)
  }
}

impl fmt::LowerHex for GeneralAddress {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    match *self {
      GeneralAddress::DefaultAddr(addr) => write!(f, "{:#x}", addr),
      GeneralAddress::BalancerAddr(addr) => write!(f, "{:#x}", addr),
    }
  }
}

impl fmt::Display for GeneralAddress {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    match self {
      GeneralAddress::DefaultAddr(addr) => write!(f, "{:#x}", addr),
      GeneralAddress::BalancerAddr(addr) => write!(f, "{:#x}", addr),
    }
  }
}

impl<'de> Deserialize<'de> for GeneralAddress {
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    let value = serde_json::Value::deserialize(deserializer)?;

    let address: GeneralAddress = match &value {
      serde_json::Value::String(s) => {
        if s.len() == 42 {
          GeneralAddress::DefaultAddr(s.parse().map_err(serde::de::Error::custom)?)
        } else if s.len() == 66 {
          GeneralAddress::BalancerAddr(s.parse().map_err(serde::de::Error::custom)?)
        } else {
          return Err(serde::de::Error::custom(
            "Invalid value type for pool address",
          ));
        }
      }

      _ => {
        return Err(serde::de::Error::custom(
          "Invalid value type for pool address",
        ))
      }
    };

    let name = value["name"].as_str().map(|s| s.to_string());

    Ok(address)
  }
}
