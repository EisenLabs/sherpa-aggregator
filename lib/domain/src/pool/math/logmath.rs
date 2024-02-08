use super::{basic_math, var};
use ethers::types::U256;

pub fn ln_36_lower_bound() -> U256 {
  *var::ONE18 - U256::exp10(17)
}

pub fn ln_36_upper_bound() -> U256 {
  *var::ONE18 + U256::exp10(17)
}

pub fn max_natural_exponent() -> U256 {
  U256::from(130) * U256::exp10(18)
}

pub fn min_natural_exponent() -> U256 {
  U256::from(41) * U256::exp10(18)
}

pub fn mild_exponent_bound() -> U256 {
  U256::from("0x4000000000000000000000000000000000000000000000000000000000000000") / *var::ONE20
}

pub fn x0() -> U256 {
  U256::from("0x6F05B59D3B2000000") // 2ˆ7
}

pub fn a0() -> U256 {
  U256::from("0x195E54C5DD42177F53A27172FA9EC630262827000000000") // eˆ(x0) (no decimals)
}

pub fn x1() -> U256 {
  U256::from("0x3782DACE9D9000000") // 2ˆ6
}
pub fn a1() -> U256 {
  U256::from("0x1425982CF597CD205CEF7380") // eˆ(x1) (no decimals)
}
pub fn x2() -> U256 {
  U256::from("0xAD78EBC5AC62000000") // 2ˆ5
}
pub fn a2() -> U256 {
  U256::from("0x1855144814A7FF805980FF0084000") // eˆ(x2)
}
pub fn x3() -> U256 {
  U256::from("0x56BC75E2D631000000") // 2^4
}
pub fn a3() -> U256 {
  U256::from("0x2DF0AB5A80A22C61AB5A700") // eˆ(x3)
}
pub fn x4() -> U256 {
  U256::from("0x2B5E3AF16B18800000") // 2ˆ3
}
pub fn a4() -> U256 {
  U256::from("0x3F1FCE3DA636EA5CF850") // eˆ(x4)
}
pub fn x5() -> U256 {
  U256::from("0x15AF1D78B58C400000") // 2ˆ2
}
pub fn a5() -> U256 {
  U256::from("0x127FA27722CC06CC5E2") // eˆ(x5)
}
pub fn x6() -> U256 {
  U256::from("0xAD78EBC5AC6200000") // 2ˆ1
}
pub fn a6() -> U256 {
  U256::from("0x280E60114EDB805D03") // eˆ(x6)
}
pub fn x7() -> U256 {
  U256::from("0x56BC75E2D63100000") // 2ˆ0
}
pub fn a7() -> U256 {
  U256::from("0xEBC5FB41746121110") // eˆ(x7)
}
pub fn x8() -> U256 {
  U256::from("0x2B5E3AF16B1880000") // 2ˆ-1
}
pub fn a8() -> U256 {
  U256::from("0x8F00F760A4B2DB55D") // eˆ(x8)
}
pub fn x9() -> U256 {
  U256::from("0x15AF1D78B58C40000") // 2ˆ-2
}
pub fn a9() -> U256 {
  U256::from("0x6F5F1775788937937") // eˆ(x9)
}
pub fn x10() -> U256 {
  U256::from("0xAD78EBC5AC620000") // 2ˆ-3
}
pub fn a10() -> U256 {
  U256::from("0x6248F33704B286603") // eˆ(x10)
}
pub fn x11() -> U256 {
  U256::from("0x56BC75E2D6310000") // 2ˆ-4
}
pub fn a11() -> U256 {
  U256::from("0x5C548670B9510E7AC") // eˆ(x11)
}

//(36 decimal places) natural logarithm (ln(x)) with signed 18 decimal fixed point argument,
pub fn _ln_36(x: U256) -> (U256, bool) {
  // We will use the following Taylor expansion, which converges very rapidly. Let z = (x - 1) / (x + 1).
  // ln(x) = 2 * (z + z^3 / 3 + z^5 / 5 + z^7 / 7 + ... + z^(2 * n + 1) / (2 * n + 1))
  let x18 = x * *var::ONE18;

  let diff = if x18 > *var::ONE36 {
    x18 - *var::ONE36
  } else {
    *var::ONE36 - x18
  };

  let sign = if x18 > *var::ONE36 { true } else { false };

  let z = (diff * *var::ONE36) / (x18 + *var::ONE36);
  let z_squared = (z * z) / *var::ONE36;

  // num is the numerator of the series: the z^(2 * n + 1) term
  let mut num = z;
  let mut series_sum = num;

  // In each step, the numerator is multiplied by z^2

  for i in 1..=7 {
    num = (num * z_squared) / *var::ONE36;
    series_sum = series_sum + num / (2 * i + 1);
  }

  let ln36 = series_sum * 2;

  (ln36, sign)
}

pub fn ln(a: U256) -> (U256, bool) {
  assert!(a > U256::zero(), "a should be larger than 0");
  if ln_36_lower_bound() < a && a < ln_36_upper_bound() {
    let (ln36, sign) = _ln_36(a);

    return (ln36 / *var::ONE18, sign);
  } else {
    return _ln(a);
  }
}

pub fn _ln(a: U256) -> (U256, bool) {
  let mut a_local = a;
  if a_local < *var::ONE18 {
    let (ln_v, ln_sign) = _ln((*var::ONE18 * *var::ONE18) / a_local);
    return (ln_v, !ln_sign);
  }

  let mut sum = U256::zero();
  if a_local >= a0() * *var::ONE18 {
    a_local /= a0(); // Integer, not fixed point division
    sum += x0();
  }

  if a_local >= a1() * *var::ONE18 {
    a_local /= a1(); // Integer, not fixed point division
    sum += x1();
  }

  sum *= 100;
  a_local *= 100;

  if a_local >= a2() {
    a_local = (a_local * *var::ONE20) / a2();
    sum += x2();
  }

  if a_local >= a3() {
    a_local = (a_local * *var::ONE20) / a3();
    sum += x3();
  }

  if a_local >= a4() {
    a_local = (a_local * *var::ONE20) / a4();
    sum += x4();
  }

  if a_local >= a5() {
    a_local = (a_local * *var::ONE20) / a5();
    sum += x5();
  }

  if a_local >= a6() {
    a_local = (a_local * *var::ONE20) / a6();
    sum += x6();
  }

  if a_local >= a7() {
    a_local = (a_local * *var::ONE20) / a7();
    sum += x7();
  }

  if a_local >= a8() {
    a_local = (a_local * *var::ONE20) / a8();
    sum += x8();
  }

  if a_local >= a9() {
    a_local = (a_local * *var::ONE20) / a9();
    sum += x9();
  }

  if a_local >= a10() {
    a_local = (a_local * *var::ONE20) / a10();
    sum += x10();
  }

  if a_local >= a11() {
    a_local = (a_local * *var::ONE20) / a11();
    sum += x11();
  }

  let diff = if a_local > *var::ONE20 {
    a_local - *var::ONE20
  } else {
    *var::ONE20 - a_local
  };

  let sign = if a_local > *var::ONE20 { true } else { false };

  let z = (diff * *var::ONE20) / (a_local + *var::ONE20);
  let z_squared = (z * z) / *var::ONE20;
  let mut num = z;
  let mut series_sum = num;

  // In each step, the numerator is multiplied by z^2
  //
  for i in 1..=5 {
    num = (num * z_squared) / *var::ONE20;
    series_sum += num / (2 * i + 1);
  }
  series_sum *= 2;
  let ln_v = (sum + series_sum) / 100;

  (ln_v, sign)
}

pub fn log_sub(val: U256) -> (U256, bool) {
  let (mut logval, logval_sign) = if ln_36_lower_bound() < val && val < ln_36_upper_bound() {
    _ln_36(val)
  } else {
    _ln(val)
  };

  if ln_36_lower_bound() < val && val < ln_36_upper_bound() {
  } else {
    logval = logval * *var::ONE18;
  }

  (logval, logval_sign)
}

pub fn log(arg: U256, base: U256) -> (U256, bool) {
  let (logbase, logbase_sign) = log_sub(base);
  let (logarg, logarg_sign) = log_sub(arg);

  let log_sign = !(logbase_sign ^ logarg_sign);
  let log_val = (logarg * *var::ONE18) / logbase;

  return (log_val, log_sign); // When dividing, we multiply by *var::ONE18 to arrive at a result with 18 decimal places
}

pub fn exp(x: U256, sign: bool) -> U256 {
  if x == U256::zero() {
    return *var::ONE18;
  }

  if !sign {
    assert!(x <= min_natural_exponent(), "invalid exponent");
    return *var::ONE18 * *var::ONE18 / exp(x, !sign);
  }

  assert!(x <= max_natural_exponent(), "invalid exponent");

  let mut x_local = x;

  let first_an = if x_local >= x0() {
    a0()
  } else if x_local >= x1() {
    a1()
  } else {
    U256::one()
  };

  if x_local >= x0() {
    x_local = x_local - x0();
  } else if x_local >= x1() {
    x_local = x_local - x1();
  }

  x_local = x_local * 100;

  let mut product = *var::ONE20;
  if x_local >= x2() {
    x_local = x_local - x2();
    product = (product * a2()) / *var::ONE20;
  }
  if x_local >= x3() {
    x_local = x_local - x3();
    product = (product * a3()) / *var::ONE20;
  }
  if x_local >= x4() {
    x_local = x_local - x4();
    product = (product * a4()) / *var::ONE20;
  }
  if x_local >= x5() {
    x_local = x_local - x5();
    product = (product * a5()) / *var::ONE20;
  }
  if x_local >= x6() {
    x_local = x_local - x6();
    product = (product * a6()) / *var::ONE20;
  }
  if x_local >= x7() {
    x_local = x_local - x7();
    product = (product * a7()) / *var::ONE20;
  }
  if x_local >= x8() {
    x_local = x_local - x8();
    product = (product * a8()) / *var::ONE20;
  }
  if x_local >= x9() {
    x_local = x_local - x9();
    product = (product * a9()) / *var::ONE20;
  }

  let mut series_sum = *var::ONE20; // The initial one in the sum, with 20 decimal places.
  let mut term = x_local; // Each term in the sum, where the nth term is (x^n / n!).

  series_sum = series_sum + term;

  for i in 2..=12 {
    term = term * x_local / *var::ONE20 / i;
    series_sum = series_sum + term;
  }

  return (((product * series_sum) / *var::ONE20) * first_an) / 100;
}

pub fn pow(x: U256, y: U256, y_sign: bool) -> U256 {
  if y == U256::zero() {
    // We solve the 0^0 indetermination by making it equal one.
    return *var::ONE18;
  }

  if x == U256::zero() {
    return U256::zero();
  }

  assert!(x >> 255 == U256::zero(), "out of bounds");
  assert!(y < mild_exponent_bound(), "out of bounds");

  let (mut logx_times_y, sign);

  if ln_36_lower_bound() < x && x < ln_36_upper_bound() {
    let (ln_36_x, ln_36_x_sign) = _ln_36(x);

    let (quot, rem) = basic_math::div_rem(ln_36_x, *var::ONE18);
    logx_times_y = quot * y + (rem * y) / *var::ONE18;
    sign = !(ln_36_x_sign ^ y_sign);
  } else {
    let (ln_x, ln_x_sign) = _ln(x);
    logx_times_y = ln_x * y;
    sign = !(ln_x_sign ^ y_sign);
  }
  logx_times_y /= *var::ONE18;

  if sign {
    assert!(x <= max_natural_exponent(), "out of boundary");
  } else {
    assert!(x <= min_natural_exponent(), "out of boundary");
  }

  return exp(logx_times_y, sign);
}

// (ab-1)/10^18 + 1
pub fn pow_up(x: U256, y: U256) -> Option<U256> {
  if y == *var::ONE18 {
    Some(x)
  } else if y == U256::from(2_i64) * *var::ONE18 {
    basic_math::mul_up(x, x)
  } else if y == U256::from(4_i64) * *var::ONE18 {
    let square = basic_math::mul_up(x, x)?;
    basic_math::mul_up(square, square)
  } else {
    // TODO: more nice way
    let pow_f = basic_math::as_f64(x).powf(basic_math::as_f64(y));
    let pow_i = (pow_f * 1000000.0) as u128;
    U256::from(pow_i).checked_mul(U256::exp10(12))
  }
}

pub fn pow_down(x: U256, y: U256) -> U256 {
  if y == *var::ONE18 {
    return x;
  } else if y == U256::from(2) * *var::ONE18 {
    return basic_math::mul_down(x, x).unwrap();
  } else if y == U256::from(4) * *var::ONE18 {
    let square = basic_math::mul_down(x, x).unwrap();
    return basic_math::mul_down(square, square).unwrap();
  } else {
    let raw = pow(x, y, true);
    let max_error = basic_math::mul_up(raw, U256::exp10(4)).unwrap() + U256::one();

    if raw < max_error {
      return U256::zero();
    } else {
      return raw - max_error;
    }
  }
}

pub fn pow_up_v2(x: U256, y: U256) -> U256 {
  if y == *var::ONE18 {
    return x;
  } else if y == U256::from(2) * *var::ONE18 {
    return basic_math::mul_up(x, x).unwrap();
  } else if y == U256::from(4) * *var::ONE18 {
    let square = basic_math::mul_up(x, x).unwrap();
    return basic_math::mul_up(square, square).unwrap();
  } else {
    let raw = pow(x, y, true);
    let max_error = basic_math::mul_up(raw, U256::exp10(4)).unwrap() + U256::one();
    return raw + max_error;
  }
}

#[cfg(test)]
mod tests {
  use super::*;
  use ethers::types::U256;

  #[test]
  fn test_ln_exp() {
    let x = U256::from(2) * *var::ONE18;
    let (y, y_sign) = _ln(x);
    let z1 = exp(*var::ONE18, y_sign);
    let z2 = exp(y, y_sign);
    assert_eq!(y, U256::from("0x99E8DB03256CE5D")); // ln2 *10**18
    assert_eq!(y_sign, true);
    assert_eq!(z1, U256::from("0x25B946EBC0B36173")); // 2718281828459045235 = e * 10^18;
    if z2 > x {
      assert!(z2 - x < U256::from(100));
    } else {
      assert!(x - z2 < U256::from(100));
    }
  }

  #[test]
  fn test_log_pow() {
    let mut arg = U256::from(2) * *var::ONE18;
    let mut base = U256::from(10) * *var::ONE18;
    let (mut z, mut z_sign) = log(arg, base);
    let mut w = pow(base, z, z_sign);
    assert_eq!(z, U256::from("0x42D792FA649FA8B")); //  301029995663981195 = log 2 * 10**18
    assert_eq!(z_sign, true);
    if arg > w {
      assert!(arg - w < U256::from(10));
    } else {
      assert!(w - arg < U256::from(10));
    }
    arg = U256::from(2) * U256::exp10(17);
    base = U256::from(10) * *var::ONE18;
    (z, z_sign) = log(arg, base);
    w = pow(base, z, z_sign);
    assert_eq!(z, U256::from("0x9B33D84011A0574")); //  698970004336018804 = 10**18 - log 2 * 10**18
    assert_eq!(z_sign, false);
    assert_eq!(w, arg);
    if arg > w {
      assert!(arg - w < U256::from(10));
    } else {
      assert!(w - arg < U256::from(10));
    }
  }
  #[test]
  fn test_pow_up_down() {
    let mut x = U256::from(2) * *var::ONE18;
    let mut y = U256::from(10) * *var::ONE18;
    let mut a1 = pow_up(x, y).unwrap();
    let mut a2 = pow_up_v2(x, y);
    let mut a3 = pow_down(x, y);
    let mut aexp = U256::from(1024) * *var::ONE18;

    assert!(basic_math::get_diff(a1, aexp) < U256::exp10(4));
    assert!(basic_math::get_diff(a2, aexp) < U256::exp10(8));
    assert!(basic_math::get_diff(a3, aexp) < U256::exp10(8));
  }
}
