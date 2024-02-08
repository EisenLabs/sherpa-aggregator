<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#chain-addition">Chain Addition</a></li>
        <li><a href="#dex-pool-addition">DEX Pool Addition</a></li>
        <li><a href="#pool-calculation-addition">Pool Calculation Addition</a></li>
        <li><a href="#protobuf-addition">Protobuf Addition</a></li>
      </ul>
    </li>
  </ol>
</details>

<!-- GETTING STARTED -->

## Getting Started

This section provides a comprehensive guide on how to get started with configuring and extending the functionality of our project. Follow the steps below to add new chains, DEX pools, pool calculations, and protobuf entities.

### Chain Addition

To add a new chain configuration, create a `.yaml` file based on the example of the [Base](../config/chain-config/base.yaml) network chain config. In your chain configuration, you can also specify the [Multicall3](https://www.multicall3.com/) address in the `multicall2` field for enhanced functionality.

### DEX Pool Addition

To add a new DEX pool, reference the [uni_v2.rs](./src/pool/uni_v2.rs) file. Create a new `dex_facet.rs` file by copying the structure from `uni_v3.rs`, replacing each field as necessary. Implement the `AmmLike` trait for your new DEX pool.

If your Solidity contract uses tick bitmap style data structure, convert these to a `BTreeMap` containing only valid tick values.

Once completed, implement the `from` function and the `AmmLike` trait for the Pool enum. To include your newly added DEX in the build, add its modules to the [mod.rs](./src/pool/mod.rs) file.

### Pool Calculation Addition

For adding pool calculations, create a `dex_math.rs` file within the [math](./src/pool/math/) directory by referencing `uni2_math.rs`. When implementing new math libraries, ensure to reference existing libraries in the folder to avoid redundant function definitions.

### Protobuf Addition

Extend the protobuf definitions by adding a message for each DEX based on the fields defined in your `dex_facet.rs` struct within the [entities.proto](./rpc/entities.proto) file.

Furthermore, implement `from/try-from` for each Pool enum and DEX struct within the [protobuf/conversion](./src/protobuf/conversion.rs) file to ensure seamless integration and conversion between your DEX structures and protobuf entities.

<p align="right">(<a href="#top">back to top</a>)</p>
