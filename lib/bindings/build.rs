use ethers::contract::Abigen;
use glob::glob;
use heck::ToSnakeCase;
use std::{io::Result, path::PathBuf};

fn main() -> Result<()> {
  println!("cargo:rerun-if-changed=contract-abi");

  let abi_dir = PathBuf::from("./contract-abi");
  // Generate bindgen calls for each JSON file in the ABI directory
  for path in glob(&abi_dir.join("*.json").to_string_lossy())
    .unwrap()
    .flatten()
  {
    if let Some(contract_name) = path.file_stem().and_then(|f| f.to_str()) {
      bindgen(contract_name);
    }
  }

  Ok(())
}

#[allow(dead_code)]
fn bindgen(fname: &str) {
  let bindings = Abigen::new(fname, format!("./contract-abi/{}.json", fname))
    .expect("could not instantiate Abigen")
    .generate()
    .expect("could not generate bindings");

  bindings
    .write_to_file(format!("./src/{}.rs", fname.to_snake_case()))
    .expect("could not write bindings to file");
}
