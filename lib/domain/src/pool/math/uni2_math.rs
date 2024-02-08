use super::{basic_math, var};
use ethers::types::U256;
use serde::{Deserialize, Serialize};

pub fn calc_uni2_out(
  input_balance: U256,
  output_balance: U256,
  input_amount: U256,
  fee: (U256, U256),
) -> Option<U256> {
  // (x + (1-f)dx)(y-dy) = xy
  // (1-f)dx*y - (1-f)dxdy -x dy = 0
  // dy = (1-f)dx * y / (x + (1-f)dx)
  // dy = (fee_d - fee_n)dx * y/ (x*fee_d + (fee_d - fee_n) dx))))
  if input_amount.is_zero() || input_balance.is_zero() || output_balance.is_zero() {
    return None;
  }

  let (fee_numerator, fee_denominator) = fee;
  let input_amount_without_fee =
    input_amount.checked_mul(fee_denominator.checked_sub(fee_numerator)?)?;

  let numerator = input_amount_without_fee.checked_mul(output_balance)?;

  let denominator = input_balance
    .checked_mul(fee_denominator)?
    .checked_add(input_amount_without_fee)?;

  numerator.checked_div(denominator)
}
