use super::var;
use ethers::types::{U128, U256, U512};
use std::ops::BitXor;

pub fn recip_Q64(x: U256) -> Option<U256> {
  let num = *var::Q128 / x;
  if num > *var::MAX_U128 {
    return None;
  }
  Some(num)
}

pub fn f64_to_u256(amount_f64: f64, decimal: usize) -> U256 {
  let value = amount_f64 * 10_f64.powi(decimal as i32);
  if value >= 1.0 {
    let bits = value.to_bits();
    let exponent = ((bits >> 52) & 0x7ff) - 1023;
    let mantissa = (bits & 0x0f_ffff_ffff_ffff) | 0x10_0000_0000_0000;
    if exponent <= 52 {
      U256::from(mantissa >> (52 - exponent))
    } else if exponent >= 256 {
      U256::MAX
    } else {
      U256::from(mantissa) << U256::from(exponent - 52)
    }
  } else {
    U256::zero()
  }
}

pub fn typecast_ether_u256(x: U256, nbit: usize) -> u128 {
  let bytes: [u8; 32] = x.into();
  let nblock = nbit / 8;

  let mut value: u128 = 0;

  // Extract the most significant bytes from bytes[16] to bytes[31]
  for i in 0..nblock {
    value = (value << 8) | (bytes[31 - i] as u128);
  }
  value
}

pub fn div_rem<T: std::ops::Div<Output = T> + std::ops::Rem<Output = T> + Copy>(
  x: T,
  y: T,
) -> (T, T) {
  let quot = x / y;
  let rem = x % y;
  (quot, rem)
}

pub fn add_delta(x: U256, y: i128) -> U256 {
  if y < 0 {
    return x - U256::from(-y);
  } else {
    return x + U256::from(y);
  }
}

pub fn unsafe_div_rounding_up(x: U256, y: U256) -> U256 {
  // x/y rounding up
  let (quot, rem) = div_rem(x, y);
  if rem > U256::zero() {
    return U256::one() + quot;
  } else {
    return quot;
  }
}

pub fn get_twos_and_twos_reverse(num: U256) -> (U256, U256) {
  //num = twos*odd
  // twos = 2^1
  let twos = (U256::max_value() - num + U256::from(1)) & num;
  // num                => 000000010100010000
  // max_value          => 111111111111111111
  // max_value - num +1 => 111111101011101111 + 1

  let (twos_reverse, _) = ((U256::max_value() - twos + 1) / twos).overflowing_add(U256::one());
  // 2^(256-a)
  // twos                            -     0000..000010000 = 2^a
  //                                       <-----256----->
  //(U256::max_value()-twos+1)       -     1111..111110000 = 2^256 - 2^a
  //                                       <--------><--->
  //                                          255-a   a+1
  //2^(256-a)
  (twos, twos_reverse)
}

pub fn convert_U256_to_U128_tuple(num: U256) -> (U128, U128) {
  // num = [d, c]
  let num_array: [u64; 4] = num.0;

  let c = U128::from(num_array[0]) + (U128::from(num_array[1]) << 64);
  let d = U128::from(num_array[2]) + (U128::from(num_array[3]) << 64);
  (d, c)
}

pub fn convert_U512_to_U256_tuple(num: U512) -> (U256, U256) {
  // num = [d, c]
  let num_array: [u64; 8] = num.0;

  let c = U256::from(num_array[0])
    + (U256::from(num_array[1]) << 64)
    + (U256::from(num_array[2]) << 128)
    + (U256::from(num_array[3]) << 192);
  let d = U256::from(num_array[4])
    + (U256::from(num_array[5]) << 64)
    + (U256::from(num_array[6]) << 128)
    + (U256::from(num_array[7]) << 192);

  (d, c)
}

pub fn mul_256(a: U256, b: U256) -> (U256, U256) {
  // a * b = prod1 * (2^256) + prod0

  let mm = a.full_mul(b); //U512

  let (prod1, prod0) = convert_U512_to_U256_tuple(mm);

  (prod1, prod0)
}

// odd*inv = 1 (mode 2^256)
pub fn get_inv_256(odd: U256) -> U256 {
  let mut inv = (U256::from(3) * odd).bitxor(U256::from(2));

  // odd = (2*x+1)^3
  for _ in 0..6 {
    let (mul, _) = odd.overflowing_mul(inv);
    (inv, _) = inv.overflowing_mul(U256::max_value() - mul + U256::from(3));
  }
  inv
}

//  a * b =  prod1 * (2^256) + prod0 = denom * x + remain
//
//  if remain > prod 0:
//      (prod1-1)*(2^256) + 2^256 - remain +1 + prod0 - 1 = denom *x
//       <-prod1->          <------------ prod0 ------->
//  else:
//      (prod1)*(2^256) + prod0 - remain = denom *x
//                        <---prod0---->
//
//      (prod1)*(2^256) + prod0         = denom_odd * 2^a * x
//      (prod1)*(2^(256-a)) + prod0/2^a = denom_odd * x
//
//

pub fn muldiv(a: U256, b: U256, denom: U256) -> U256 {
  let mm = a.full_mul(b); //U512
  let (quot, _) = mm.div_mod(U512::from(denom));
  let (_, prod0) = convert_U512_to_U256_tuple(quot);
  prod0
}

pub fn muldiv_rounding_up(a: U256, b: U256, denom: U256) -> U256 {
  let mm = a.full_mul(b); //U512
  let (quot, rem) = mm.div_mod(U512::from(denom));
  let (_, mut rem_256) = convert_U512_to_U256_tuple(rem);
  let (_, mut quot_256) = convert_U512_to_U256_tuple(quot);

  if rem_256 > U256::zero() {
    quot_256 += U256::one();
  }
  quot_256
}

pub fn sqrt_int(x: U256) -> Option<U256> {
  // \sqrt{x 1e18}
  //
  if x == U256::from(0) {
    return Some(U256::from(0));
  }

  let mut z = x.checked_add(*var::ONE18)?.checked_div(U256::from(2))?;
  let mut y = x;

  for _ in 0..255 {
    if z == y {
      return Some(y);
    }
    y = z;
    z = x
      .checked_mul(*var::ONE18)?
      .checked_div(z)?
      .checked_add(z)?
      .checked_div(U256::from(2))?;
  }
  None
}

pub fn halfpow(power: U256, precision: U256) -> Option<U256> {
  // 1e18 * 0.5 ** (power/1e18)
  let intpow = power.checked_div(*var::ONE18)?;
  let otherpow = power.checked_sub(intpow.checked_mul(*var::ONE18)?)?;
  if intpow > U256::from(59) {
    return Some(U256::zero());
  }
  let result = (*var::ONE18).checked_div(U256::from(2).checked_pow(intpow)?)?;
  if otherpow == U256::from(0) {
    return Some(result);
  }
  let mut term = *var::ONE18;
  let x = U256::from(5) * U256::exp10(17);
  let mut s = *var::ONE18;
  let mut neg = false;

  for i in 1..256 {
    let k = U256::from(i).checked_mul(*var::ONE18)?;
    let mut c = k.checked_sub(*var::ONE18)?;

    if otherpow > c {
      c = otherpow.checked_sub(c)?;
      neg = !neg;
    } else {
      c = c.checked_sub(otherpow)?;
    }
    term = term
      .checked_mul(c.checked_mul(x)?.checked_div(*var::ONE18)?)?
      .checked_div(k)?;
    if neg {
      s = s.checked_sub(term)?;
    } else {
      s = s.checked_add(term)?;
    }
    if term < precision {
      return Some(result.checked_mul(s)?.checked_div(*var::ONE18)?);
    }
  }
  None
}

pub fn sort_array(array: &Vec<U256>) -> Vec<U256> {
  //bubble sort high to low
  let mut array_new = Vec::new();
  for &x in array.iter() {
    array_new.push(x);
  }

  for i in 1..array.len() {
    let x = array_new[i];
    let mut cur = i;
    for _ in 0..array_new.len() {
      let y = array_new[cur - 1];
      if y > x {
        break;
      }
      array_new[cur] = y;
      cur -= 1;
      if cur == 0 {
        break;
      }
    }
    array_new[cur] = x;
  }
  array_new
}

pub fn div_up(a: U256, b: U256) -> Option<U256> {
  // (a*10^18 - 1)/b + 1
  if b.is_zero() {
    return None;
  }

  if a.is_zero() {
    Some(a)
  } else {
    let a_inflated = a.checked_mul(*var::ONE18)?;

    (a_inflated - U256::one())
      .checked_div(b)?
      .checked_add(U256::one())
  }
}

pub fn div_down(a: U256, b: U256) -> Option<U256> {
  // (a*10^18)/b
  if b.is_zero() {
    return None;
  }

  if a.is_zero() {
    Some(a)
  } else {
    let a_inflated = a.checked_mul(*var::ONE18)?;
    a_inflated.checked_div(b)
  }
}

pub fn mul_down(a: U256, b: U256) -> Option<U256> {
  a.checked_mul(b)?.checked_div(*var::ONE18)
}
// ab/10^18

pub fn mul_up(a: U256, b: U256) -> Option<U256> {
  a.checked_mul(b)?
    .checked_sub(U256::one())?
    .checked_div(*var::ONE18)?
    .checked_add(U256::one())
}

pub fn as_f64(x: U256) -> f64 {
  let (int_part, mut dec_part) = x.div_mod(*var::ONE18);
  dec_part /= U256::exp10(12);

  (int_part.as_u64() as f64) + (dec_part.as_u64() as f64) / 1000000.0
}

pub fn complement(x: U256) -> U256 {
  if x < *var::ONE18 {
    *var::ONE18 - x
  } else {
    U256::zero()
  }
}

pub fn calc_geometric_mean(xp: &Vec<U256>, sort: bool) -> Option<U256> {
  let ncoin = U256::from(xp.len());

  let xp_sort = if sort { sort_array(xp) } else { xp.to_vec() };

  let mut gm = xp_sort[0];

  for _ in 0..255 {
    let gm_prev = gm;
    let mut tmp = *var::ONE18;

    for &x in xp_sort.iter() {
      tmp = tmp.checked_mul(x)?.checked_div(gm)?;
    }

    gm = gm
      .checked_mul(
        ncoin
          .checked_sub(U256::one())?
          .checked_mul(*var::ONE18)?
          .checked_add(tmp)?,
      )?
      .checked_div(ncoin.checked_mul(*var::ONE18)?)?;

    let diff = if gm > gm_prev {
      gm.checked_sub(gm_prev)?
    } else {
      gm_prev.checked_sub(gm)?
    };

    if diff <= U256::one() || diff * *var::ONE18 < gm {
      return Some(gm);
    }
  }
  None
}

pub fn get_diff<T: std::ops::Sub<Output = T> + std::cmp::Ord>(a: T, b: T) -> T {
  if a > b {
    return a - b;
  }
  b - a
}

#[cfg(test)]
mod tests {
  use super::*;
  use ethers::types::U256;
  #[test]

  fn test_typecast_ether_u256() {
    let x = U256::MAX;
    let mut y;
    y = typecast_ether_u256(x, 8);
    assert_eq!(y, 255);
    y = typecast_ether_u256(x, 88);
    assert_eq!(y, (1 << 88) - 1);
  }
  #[test]
  fn test_div_rem() {
    let mut tick = 500;
    let mut tickspacing = 21;
    let (mut quot, mut rem) = div_rem(tick, tickspacing);

    assert_eq!(quot, 23);
    assert_eq!(rem, 17);

    tick = -7;
    tickspacing = 3;
    (quot, rem) = div_rem(tick, tickspacing);

    assert_eq!(quot, -2);
    assert_eq!(rem, -1);
  }

  #[test]
  fn test_add_delta() {
    let x = U256::from(234);
    let y1: i128 = 100;
    let y2: i128 = -100;

    assert_eq!(add_delta(x, y1), U256::from(334));
    assert_eq!(add_delta(x, y2), U256::from(134));
  }

  #[test]
  fn test_unsafe_div_rounding_up() {
    let x = U256::from(100);
    let y = U256::from(30);

    assert_eq!(unsafe_div_rounding_up(x, y), U256::from(4));
    let x = U256::from(100);
    let y = U256::from(20);
    assert_eq!(unsafe_div_rounding_up(x, y), U256::from(5));
  }

  #[test]
  fn test_get_twos_and_twos_reverse() {
    let mut num = U256::from(48);
    let (mut twos, mut twos_reverse) = get_twos_and_twos_reverse(num);

    assert_eq!(twos, U256::from(16));
    assert_eq!(twos_reverse, U256::from(1) << 252);

    num = U256::from(5);
    (twos, twos_reverse) = get_twos_and_twos_reverse(num);

    assert_eq!(twos, U256::one());
    assert_eq!(twos_reverse, U256::zero());
  }

  #[test]
  fn test_mul_256() {
    let mut a = (U256::one() << 4) - U256::one(); //2^255 - 1
    let mut b = (U256::one() << 4) - U256::one(); //2^255 - 1

    let (mut prod1, mut prod0) = mul_256(a, b); // 2^(255*2) - 2^256 + 1

    assert_eq!(prod0, U256::from(225));
    assert_eq!(prod1, U256::zero());

    a = (U256::one() << 255) - U256::one(); //2^255 - 1
    b = (U256::one() << 255) - U256::one(); //2^255 - 1

    println!("{}, {}", a, b);

    (prod1, prod0) = mul_256(a, b); // 2^(255*2) - 2^256 + 1
                                    // prod1 2^(254) - 1
                                    // prod0 1
    assert_eq!(prod0, U256::one());
    assert_eq!(prod1, (U256::one() << 254) - U256::one());
  }

  #[test]
  fn test_get_inv_256() {
    let mut odd = U256::from(11);
    let mut inv = get_inv_256(odd);

    let (_, mut prod0) = mul_256(odd, inv);

    odd = U256::from(131);
    inv = get_inv_256(odd);

    (_, prod0) = mul_256(odd, inv);

    assert_eq!(prod0, U256::one());
  }

  #[test]
  fn test_muldiv() {
    let a = (U256::one() << 255) - U256::one(); //2^255 - 1
    let b = (U256::one() << 255) - U256::one(); //2^255 - 1
    let denom = ((U256::one() << 250) - U256::one()) * U256::from(4); //(2^250 - 1)*4

    let div = muldiv(a, b, denom);
    // 2^(255*2) - 2^256 +1
    // (2^252-4)*(2^258) + 2^260 - 2^256 + 1
    // (2^252-4)*(2^258) + (2^252-4)*2^8 + 2^10 - (2^252-4)(2^4) + 64 + 1
    // (2^252-4)*(2^258 + 2^8 -2^4) + 2^10 + 64 + 1

    assert_eq!(div, U256::from(240));
  }

  #[test]
  fn test_muldiv_rounding_up() {
    let a = (U256::one() << 255) - U256::one(); //2^255 - 1
    let b = (U256::one() << 255) - U256::one(); //2^255 - 1
    let denom = ((U256::one() << 250) - U256::one()) * U256::from(4); //(2^250 - 1)*4
    let div = muldiv_rounding_up(a, b, denom);

    assert_eq!(div, U256::from(241));
  }

  #[test]
  fn test_div_up_down() {
    let mut a = U256::from(36);
    let mut b = U256::from(9);
    let mut c = div_up(a, b).unwrap();
    let mut d = div_down(a, b).unwrap();

    assert_eq!(c, U256::from(4) * *var::ONE18);
    assert_eq!(d, U256::from(4) * *var::ONE18);

    a = U256::from(37);
    b = U256::from(9);
    c = div_up(a, b).unwrap();
    d = div_down(a, b).unwrap();

    assert_eq!(c, U256::from("0x390D99C621F071C8")); //4111111111111111112
    assert_eq!(d, U256::from("0x390D99C621F071C7")); //4111111111111111111

    a = U256::from(35);
    b = U256::from(9);
    c = div_up(a, b).unwrap();
    d = div_down(a, b).unwrap();

    assert_eq!(c, U256::from("0x35F81BD7192F8E39")); //3888888888888888889
    assert_eq!(d, U256::from("0x35F81BD7192F8E38")); //3888888888888888888
  }

  #[test]
  fn test_mul_up_down() {
    let mut a = U256::from(3) * *var::ONE18;
    let mut b = U256::from(2) * *var::ONE18;
    let mut c = mul_up(a, b).unwrap();
    let mut d = mul_down(a, b).unwrap();

    assert_eq!(c, U256::from(6) * *var::ONE18);
    assert_eq!(d, U256::from(6) * *var::ONE18);

    a = U256::from(3) * *var::ONE18 + U256::one();
    b = U256::from(2) * *var::ONE18;
    c = mul_up(a, b).unwrap();
    d = mul_down(a, b).unwrap();

    assert_eq!(c, U256::from("0x53444835EC580002")); //6000000000000000002
    assert_eq!(d, U256::from("0x53444835EC580002")); //6000000000000000002
  }

  #[test]
  fn test_complement() {
    let mut x = U256::from(53) * U256::exp10(16);
    let mut y = complement(x);

    assert_eq!(y, U256::from(47) * U256::exp10(16));
    x = U256::exp10(19);
    y = complement(x);
    assert_eq!(y, U256::zero());
  }
}
