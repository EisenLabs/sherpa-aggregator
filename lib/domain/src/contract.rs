use serde::{Deserialize, Serialize};
use strum_macros::{Display, EnumString};

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq, Display, Hash, EnumString)]
pub enum ContractInterface {
  Uni2Viewer,
  Uni3Viewer,
}
