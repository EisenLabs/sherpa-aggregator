use std::{env, io::Result, path::PathBuf};

fn main() -> Result<()> {
  println!("cargo:rerun-if-changed=rpc");

  let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
  let descriptor_path = PathBuf::from(env::var("OUT_DIR").unwrap()).join("descriptor.bin");

  tonic_build::configure()
    .file_descriptor_set_path(out_dir.join("descriptor.bin"))
    .compile(&["./rpc/entities.proto"], &["rpc/"])?;

  let descriptor_set = std::fs::read(descriptor_path)?;
  pbjson_build::Builder::new()
    .register_descriptors(&descriptor_set)?
    .build(&[".entities"])?;

  Ok(())
}
