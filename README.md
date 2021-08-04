# Oasis Ledger Tester

This repo contains Bash scripts and auxiliary files for testing integration
between [Oasis Core], [Oasis Core Ledger Signer Plugin], [Oasis Metadata
Registry] and the [Oasis app for Ledger].

[Oasis Core]: https://github.com/oasisprotocol/oasis-core
[Oasis Metadata Registry]: https://github.com/oasisprotocol/metadata-registry
[Oasis Core Ledger Signer Plugin]:
  https://github.com/oasisprotocol/oasis-core-ledger
[Oasis app for Ledger]: https://github.com/Zondax/ledger-oasis

## Prerequisites

Make sure you have the following installed your system:

- [Oasis Node]
- [Ledger Signer Plugin for Oasis Core]
- [Oasis Metadata Registry CLI tool]
- [Oasis app for Ledger][oasis-app-install]

[Oasis Node]: https://docs.oasis.dev/general/run-a-node/prerequisites/oasis-node
[Ledger Signer Plugin for Oasis Core]:
  https://docs.oasis.dev/oasis-core-ledger/usage/setup
[Oasis Metadata Registry CLI tool]:
  https://github.com/oasisprotocol/metadata-registry-tools/#building
[oasis-app-install]:
  https://docs.oasis.dev/oasis-core-ledger/usage/setup#installing-oasis-app-on-your-ledger-wallet

## Running

Set variables in `test-ledger-signer.sh` to appropriate values for your system
and run:

```bash
./test-ledger-signer.sh
```
