# Eisen DEX Aggregator

[![Website](https://img.shields.io/website?url=https://app.eisenfinance.com/)](https://app.eisenfinance.com/)
[![Docs](https://img.shields.io/badge/docs-%F0%9F%93%84-blue)](https://books.eisenfinance.com/eisen-finance/)
[![Github](https://img.shields.io/static/v1?logo=github&label=github&message=repo&color=blue)](https://github.com/orgs/EisenLabs/repositories)
[![Discord](https://img.shields.io/static/v1?logo=discord&label=discord&message=Join&color=blue)](https://discord.com/invite/aKeX36N5pk)
[![Twitter](https://img.shields.io/static/v1?logo=twitter&label=twitter&message=Follow&color=blue)](https://twitter.com/EisenLabs)

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#introduction">Introduction</a></li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        </ul>
        </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#workspace">Workspace</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#more-information">More Information</a></li>

  </ol>
</details>

## Introduction

The Eisen Finance provides CEX & DEX hybrid trade solution that allows users to trade assets across multi-chain and protocols. This README provides instructions on how to add a new DEX protocol to the aggregator.

<!-- GETTING STARTED -->

## Getting Started

### Prerequisites

- Clone submodule
  ```sh
  git submodule update --init --recursive
  ```
- Install [rust](https://www.rust-lang.org/tools/install)
  ```sh
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

### Installation

```sh
cargo build
```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## Usage

1. Go to [eisen-solidity-router](eisen-solidity-router) and follow the steps in [README.md](eisen-solidity-router/README.md).

2. In [lib](lib/bindings/src/lib.rs), pub mod all bindings to lib.rs

3. Go to [domain](lib/domain) and follow the steps in [README.md](lib/domain/README.md)

4. Go to [eisen-exchange](eisen-exchange) and follow the steps in [README.md](eisen-exchange/README.md)

5. Pull request with core smart contract github and verified contract addresses.

<p align="right">(<a href="#top">back to top</a>)</p>

## Workspace

| name           | type of crate | description                                          |
| -------------- | ------------- | ---------------------------------------------------- |
| eisen-ethers   | lib           | fork and simulate the codes through anvil            |
| eisen-exchange | lib           | interact with smart contracts to sync data           |
| bindings       | lib           | convert abi json to rust code                        |
| config         | lib           | read yaml and provide config                         |
| domain         | lib           | domain includes token, pool, block, contract and dex |

<p align="right">(<a href="#top">back to top</a>)</p>

## License

The Eisen Finance DEX Aggregator is licensed under the MIT License

<p align="right">(<a href="#top">back to top</a>)</p>

## More Information

If you have any questions or need further assistance, please contact our support team at information@eisenfinance.com / conner@eisenfinance.com

<p align="right">(<a href="#top">back to top</a>)</p>
