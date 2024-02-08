use ethers::types::U256;

use super::var;
pub fn raymul(a: U256, b: U256) -> Option<U256> {
  a.checked_mul(b)?
    .checked_add(*var::HALFRAY)?
    .checked_div(*var::RAY)
}

pub fn raydiv(a: U256, b: U256) -> Option<U256> {
  a.checked_mul(*var::RAY)?
    .checked_add(b.checked_div(U256::from(2))?)?
    .checked_div(b)
}
