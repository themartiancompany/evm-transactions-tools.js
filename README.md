[comment]: <> (SPDX-License-Identifier: AGPL-3.0)

[comment]: <> (------------------------------------------------------)
[comment]: <> (Copyright © 2024, 2025, 2026  Pellegrino Prevete)
[comment]: <> (All rights reserved)
[comment]: <> (------------------------------------------------------)

[comment]: <> (This program is free software: you can redistribute)
[comment]: <> (it and/or modify it under the terms of the GNU Affero)
[comment]: <> (General Public License as published by the Free)
[comment]: <> (Software Foundation, either version 3 of the License.)

[comment]: <> (This program is distributed in the hope that it will be)
[comment]: <> (useful, but WITHOUT ANY WARRANTY; without even the)
[comment]: <> (implied warranty of MERCHANTABILITY or FITNESS FOR)
[comment]: <> (A PARTICULAR PURPOSE. See the)
[comment]: <> (See the GNU Affero General Public License for)
[comment]: <> (more details.)

[comment]: <> (You should have received a copy of the GNU Affero)
[comment]: <> (General Public License along with this program.)
[comment]: <> (If not, see <https://www.gnu.org/licenses/>.)

# EVM Transactions Tools

A collection of useful Bash and JavaScript
programs and libraries to interact with
Ethereum Virtual Machine (EVM) networks transactions
in native computer applications, in particular those
written using the
[LibEVM](
  https://github.com/themartiancompany/libevm)
and using the
[EVM Contracts Tools](
  https://github.com).

Same as those, the tools obtains networks'
informations from the
[EVM Chains Info](
  https://github.com/themartiancompany/evm-chains-info)
and 
[EVM Chains Explorers](
  https://github.com/themartiancompany/evm-chains-explorers)
programs.

The `evm-transaction-get` program uses the 
[Ethers](
  https://github.com/ethers-io/ethers.js)
JavaScript library to
interact with Ethereum Virtual Machine-compatible
blockchain networks and integrates natively with
and depends on the
[EVM Wallet](
  https://github.com/themartiancompany/evm-wallet),
but it's also possible to directly provide seeds files.

The tools are a required software dependency for the
[EVM Contracts Source Index](
  https://github.com/themartiancompany/evm-contracts-source-index).

## Installation

The tools in this source repo
can be installed from source using GNU Make.

```bash
make \
  install
```

The collection has been officially published
on the the uncensorable
[Ur](
  https://github.com/themartiancompany/ur)
user repository and application store as
`evm-transactions-tools`.
The source code is published on the
[Ethereum Virtual Machine File System](
  https://github.com/themartiancompany/evmfs)
so it can't possibly be taken down.

To install it from there just type

```bash
ur \
  evm-transactions-tools
```

A censorable HTTP Github mirror of the recipe published there,
containing a full list of the software dependencies needed to run the
tools is hosted on
[evm-transactions-tools-ur](
  https://github.com/themartiancompany/evm-contracts-tools-ur).

Be aware the mirror could go offline any time as Github and more
in general all HTTP resources are inherently unstable and censorable.

## License

This program is released by Pellegrino Prevete under the terms
of the GNU Affero General Public License version 3.
