pub mod basic_math;
pub mod logmath;
pub mod ray_math;
pub mod uni2_math;
pub mod var;
pub use self::uni2_math::*;
use ethers::types::{U128, U256};
use std::collections::BTreeMap;

#[cfg(test)]
mod tests {
  use super::*;
  use ethers::types::U256;

  #[test]
  fn test_calc_amount_out() {
    // solidly example
    let x = U256::exp10(21);
    let y = U256::exp10(9);
    let x_decimals = *var::ONE18;
    let y_decimals = U256::exp10(6);
    // _x = 10**21
    // _y = 10**21

    // _x_y (_x^2+ _y^2) / (1e18)^3
    // 1e(21*4 - 18*3) (2)

    assert_eq!(
      todo!(), // calc_solidly_out(x, y, x_decimals, y_decimals),
      U256::exp10(30).checked_mul(U256::from(2))?
    );
  }
}
