use std::collections::{HashMap, HashSet};

use domain::general_address::GeneralAddress;
use ethers::types::{Address, H256};
use once_cell::sync::Lazy;
use serde::{Deserialize, Deserializer, Serialize};

use domain::contract::ContractInterface;
use domain::dex_id::DexId;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ChainConfig {
  #[serde(rename = "chainMetadata")]
  pub metadata: ChainMetadata,
  pub tokens: TokensConfig,
  pub contracts: ContractsConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ContractsConfig {
  #[serde(rename = "multicall2")]
  pub multicall: Address,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ChainMetadata {
  pub id: String,
  pub chain_id: u32,
  pub nodes: Vec<ChainNodeConfig>,
  pub native_symbol: String,
  pub block_explorer: String,
  pub token_icon_uri: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ChainNodeConfig {
  pub endpoint: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct TokensConfig {
  pub native: TokenConfig,
  pub wrapped_natives: Vec<TokenConfig>,
  pub dollar_quote: TokenConfig,
  pub others: Vec<TokenConfig>,
}

impl TokensConfig {
  pub fn all(&self, include_native: bool) -> Vec<&TokenConfig> {
    let mut all_tokens: Vec<&TokenConfig> = Vec::new();
    if include_native {
      all_tokens.push(&self.native);
    }
    all_tokens.extend(&self.wrapped_natives);
    all_tokens.push(&self.dollar_quote);
    all_tokens.extend(&self.others);
    all_tokens
  }
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct TokenConfig {
  pub address: Address,
  pub name: Option<String>,
  pub symbol: Option<String>,
  pub bookmarked: bool,
  pub icon: Option<String>,
}

impl<'de> Deserialize<'de> for TokenConfig {
  fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
  where
    D: Deserializer<'de>,
  {
    let value = serde_json::Value::deserialize(deserializer)?;

    let address: Address = match &value {
      serde_json::Value::String(s) => s.parse().map_err(serde::de::Error::custom)?,
      serde_json::Value::Object(obj) => {
        let address_value = obj
          .get("address")
          .ok_or_else(|| serde::de::Error::missing_field("address"))?;
        serde_json::from_value(address_value.clone()).map_err(serde::de::Error::custom)?
      }
      _ => {
        return Err(serde::de::Error::custom(
          "Invalid value type for TokenConfig",
        ))
      }
    };

    let name = value["name"].as_str().map(|s| s.to_string());
    let symbol = value["symbol"].as_str().map(|s| s.to_string());
    let bookmarked = value["bookmarked"].as_bool().unwrap_or(false);
    let icon = value["icon"].as_str().map(|s| s.to_string());

    Ok(TokenConfig {
      address,
      name,
      symbol,
      bookmarked,
      icon,
    })
  }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Config {
  pub chain: ChainConfig,
}

impl Config {
  pub fn load(chain_env: &str) -> anyhow::Result<Self> {
    let project_root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    println!("project_root: {:?}", project_root);

    let chain_file_path = project_root.join(format!("chain-config/{chain_env}.yaml"));
    println!("chain_file_path: {:?}", chain_file_path);
    let chain_file = std::fs::File::open(chain_file_path)?;
    println!("chain_file: {:?}", chain_file);
    let chain_config: serde_yaml::Value = serde_yaml::from_reader(chain_file)?;
    let mut config: serde_yaml::Value = serde_yaml::Value::default();
    config["chain"] = chain_config;

    let conf: Config = serde_yaml::from_value(config)?;
    // let chain_config: ChainConfig = serde_yaml::from_reader(file)?;

    Ok(conf)
  }
}

pub static GLOBAL: Lazy<Config> = once_cell::sync::Lazy::new(|| {
  let chain_env = std::env::var("CHAIN_ENV").unwrap_or("chain".to_string());
  let config = Config::load(chain_env.as_str()).expect("Failed to load config");
  println!("{config:#?}");
  config
});
