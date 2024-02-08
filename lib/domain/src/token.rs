use crate::general_address::GeneralAddress;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone)]
pub struct Token {
  pub address: GeneralAddress,
  pub decimal: u16,
  pub symbol: String,
  pub name: String,
  pub icon: String,
  pub bookmarked: bool,
  pub paused: bool,
}
