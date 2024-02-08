pub mod contract;
pub mod dex_id;
pub mod general_address;
pub mod pool;
pub mod protobuf;
pub mod token;

pub mod serde_helpers {
  pub mod u256 {
    use ethers::types::U256;
    use serde::{self, Deserialize, Deserializer, Serializer};

    pub fn serialize<S>(value: &U256, serializer: S) -> Result<S::Ok, S::Error>
    where
      S: Serializer,
    {
      serializer.serialize_str(&value.to_string())
    }

    pub fn deserialize<'de, D>(deserializer: D) -> Result<U256, D::Error>
    where
      D: Deserializer<'de>,
    {
      let s = String::deserialize(deserializer)?;
      U256::from_dec_str(&s).map_err(serde::de::Error::custom)
    }
  }
}
