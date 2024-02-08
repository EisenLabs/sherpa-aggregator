#[derive(thiserror::Error, Debug)]
pub enum ConvError {
  #[error("Hex to h256address error")]
  InvalidH256Address(#[from] hex::FromHexError),
  #[error("Hex to address error")]
  InvalidAddress(#[from] rustc_hex::FromHexError),
  #[error("Hex error")]
  InvalidU256(#[from] uint::FromDecStrErr),
  #[error("Int error")]
  InvalidInt(#[from] std::num::TryFromIntError),
  #[error("Parse int error")]
  ParseIntErr(#[from] std::num::ParseIntError),
  #[error("Parse int error")]
  ParseFloatErr(#[from] std::num::ParseFloatError),
  #[error("Unknown enum")]
  UnknownEnum,
  #[error("Empty oneof")]
  EmptyOneof,
  #[error("Empty option")]
  EmptyOption,
  #[error("Strum parse error")]
  StrumParse(#[from] strum::ParseError),
}

impl From<ConvError> for tonic::Status {
  fn from(e: ConvError) -> Self {
    tonic::Status::invalid_argument(e.to_string())
  }
}
