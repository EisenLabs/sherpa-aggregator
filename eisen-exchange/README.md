<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#dex-pool-addition">DEX Pool Addition</a></li>
        <li><a href="#subquery-addition">Subquery Addition</a></li>
        <li>
          <a href="#test-addition">Test Addition</a>
          <ul>
            <li><a href="#chain-addition">Chain Addition</a></li>
            <li><a href="#dex-addition">DEX Addition</a></li>
          </ul>
        </li>
      </ul>
    </li>
  </ol>
</details>

<!-- GETTING STARTED -->

## Getting Started

### DEX Pool Addition

To integrate a new DEX pool, start by examining the [uni_v2.rs](./src/dex/integration/uni_v2.rs) file for guidance. Craft a `dex_facet.rs` by emulating the structure found in `uni_v3.rs`, adjusting each field to suit your requirements. Implement the `<M: Middleware + 'static> eisen_exchange::dex::Dex` trait for your DEX pool.

For Solidity contracts that utilize a tick bitmap data structure, incorporate a `page_size` attribute for the DEX struct. This facilitates querying ticks or parameters via the multicall contract, accompanied by explanatory comments.

Ensure that all events altering pool contract states are included within the `update_pools_mut` function's events.

Incorporate your additions into the integration [mod.rs](src/dex/integration/mod.rs) file.

<p align="right">(<a href="#top">back to top</a>)</p>

### Subquery Addition

To facilitate new pool additions via events or an indexer for retrieving valid pools, add the subquery schema and GraphQL queries to the [subquery](subquery/) directory.

Implement the `fetch_pool_addresses` function to exclusively retrieve parameters and states through the viewer smart contract.

<p align="right">(<a href="#top">back to top</a>)</p>

### Test Addition

Ensure the dex module functions correctly within a specific chain environment.

#### Chain Addition

Create a chain-specific folder within [test/dex](./tests/dex/) and update [mod.rs](./tests/dex/mod.rs) accordingly. You must also configure a [chain-config](../lib/config/chain-config/) for the new chain.

#### DEX Addition

For each chain folder, add new fetch pool test files utilizing the `tokio::test` macro for comprehensive testing.

<p align="right">(<a href="#top">back to top</a>)</p>
