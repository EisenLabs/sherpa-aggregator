use ethers::providers::Middleware;

use super::TestEnv;

mod base_swap;

mod constants {
  use std::str::FromStr;

  use ethers::types::Address;
  use once_cell::sync::Lazy;

  pub static PUBLIC_ENDPOINT: &str = "https://base.llamarpc.com";
}
