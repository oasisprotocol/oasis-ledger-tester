#!/bin/bash

# A script that can be used for an End-to-End test of using the Oasis Node CLI
# with the Ledger signer to generate and sign all different transaction types.

set -eux


source test-staking.sh
source test-governance.sh
source test-registry.sh
source test-metadata-registry.sh

# Oasis Node binary.
# Current development build of Oasis Core oasis-node binary.
#OASIS_NODE=oasis-node-dev
# Official build of Oasis Core oasis-node binary.
OASIS_NODE=oasis-node-21.2.7

# Ledger Signer binary.
# Current development build of Oasis Core Ledger ledger-signer binary.
#LEDGER_SIGNER_PATH=/home/tadej/Oasis/oasis-core-ledger/ledger-signer/ledger-signer
# Official build of Oasis Core Ledger ledger-signer binary.
LEDGER_SIGNER_PATH="/home/tadej/Apps/Oasis Core Ledger/oasis_core_ledger_1.2.0_linux_amd64/ledger-signer"

# Oasis Metadata Registry binary.
# Current development build of oasis-registry binary.
OASIS_REGISTRY=oasis-registry-dev

GENESIS_FILE=testnet/genesis.json

TXNS_DIR=testnet/transactions
UPGRADES_DIR=testnet/upgrades
ENTITY_META_DIR=metadata-registry/entities-meta

SSH_NODE_SOCKET_TUNNEL="ssh -L ./internal.sock:/srv/oasis/node/internal.sock oasis@vikunja.ja.nez.si -N"
NODE_SOCKET=internal.sock
ADDR=unix:$PWD/$NODE_SOCKET

# Variable indicating whether to show stake account info before each test or not.
SHOW_ACCOUNT_INFO=no
# Variable indicating whether to show the generated transactions or not.
SHOW_TXNS=no
# Variable indicating whether to submit the generated transactions or not.
SUBMIT_TXNS=no
# Variable indicating whether to use the file signer instead of Ledger-based
# signer or not.
USE_FILE_SIGNER=no

if [[ ${USE_FILE_SIGNER:-no} = "no" ]]; then
  # Wallet ID for Nano S initialized with the Zondax's testing mnemonic.
  LEDGER_WALLET_ID=dba676
  # Wallet ID for Nano S initialized with the Zondax's second testing mnemonic.
  #LEDGER_WALLET_ID=431fc6
  # Wallet ID for Nano S initialized with Tadej's mnemonic.
  #LEDGER_WALLET_ID=70e0b3
  LEDGER_INDEX=0
  LEDGER_SIGNER_CONF="wallet_id:$LEDGER_WALLET_ID,index:$LEDGER_INDEX"

  ENTITY1_DIR=entity-${LEDGER_INDEX}/

  SIGNER_FLAGS=(--signer.dir $ENTITY1_DIR
    --signer.backend plugin
    --signer.plugin.name ledger
    --signer.plugin.path "$LEDGER_SIGNER_PATH"
    --signer.plugin.config $LEDGER_SIGNER_CONF
  )
else
  ENTITY1_DIR=entity-file-signer/

  SIGNER_FLAGS=(--signer.dir $ENTITY1_DIR
  )
fi

TX_FLAGS=(--genesis.file $GENESIS_FILE
  "${SIGNER_FLAGS[@]}"
)

NODE1_DIR=node-1/
NODE2_DIR=node-2/

# Check if required commands are present.
COMMANDS=(
  inotifywait
  $OASIS_NODE
)
for cmd in "${COMMANDS[@]}"; do
  echo $cmd
  if ! command -v $cmd &> /dev/null
  then
      echo "$cmd command could not be found"
      exit
  fi
done

echo 1>&2 "Cleaning up from previous runs..."
rm -rf $ENTITY1_DIR
rm -rf $NODE1_DIR
rm -rf $NODE2_DIR
rm -rf $ENTITY_META_DIR
rm -rf registry/
rm -f $NODE_SOCKET

mkdir -p $ENTITY_META_DIR

# Tunnel Oasis Node's socket via SSH.
$SSH_NODE_SOCKET_TUNNEL &
# Wait for Oasis Node's socket to appear.
while read i; do if [ "$i" = $NODE_SOCKET ]; then break; fi; done \
   < <(inotifywait  -e create,open --format '%f' --quiet "$PWD" --monitor)

mkdir $ENTITY1_DIR
if [[ ${USE_FILE_SIGNER:-no} = "no" ]]; then
  # Export Ledger signer's entity.
  $OASIS_NODE signer export "${SIGNER_FLAGS[@]}"
else
  # Create a new file-signer based entity.
  $OASIS_NODE registry entity init "${SIGNER_FLAGS[@]}"
fi
# Get entity account's address.
ENTITY1_ADDRESS=$($OASIS_NODE stake pubkey2address --public_key $(cat $ENTITY1_DIR/entity.json | jq .id -r))

DST_ADDRESS=oasis1qr6swa6gsp2ukfjcdmka8wrkrwz294t7ev39nrw6

$OASIS_NODE --version
if [[ ${USE_FILE_SIGNER:-no} = "no" ]]; then
  "$LEDGER_SIGNER_PATH" --version
fi

# Get entity account's nonce.
ENTITY1_NONCE=$($OASIS_NODE stake account nonce --stake.account.address $ENTITY1_ADDRESS)
test_staking

# Get entity account's nonce.
ENTITY1_NONCE=$($OASIS_NODE stake account nonce --stake.account.address $ENTITY1_ADDRESS)
test_governance

# Get entity account's nonce.
ENTITY1_NONCE=$($OASIS_NODE stake account nonce --stake.account.address $ENTITY1_ADDRESS)
test_registry

test_metadata_registry
