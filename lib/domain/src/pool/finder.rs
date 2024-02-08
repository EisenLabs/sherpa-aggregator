use crate::general_address::GeneralAddress;

use super::Pool;

pub trait PoolFinder {
  fn get_pool(&self, addr: GeneralAddress) -> Option<&Pool>;
}
