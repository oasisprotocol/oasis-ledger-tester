# Functions for testing governance.

source common.sh

generate_upgrade_descriptor1() {
  local upgrade_desc=$1
  cat << EOF > $upgrade_desc
{
  "v": 1,
  "handler": "upgrade1",
  "target": {
    "runtime_host_protocol": {
      "major": 2
    },
    "runtime_committee_protocol": {
      "major": 3
    },
    "consensus_protocol": {
      "major": 4
    }
  },
  "epoch": 3828
}
EOF
}

generate_upgrade_descriptor2() {
  local upgrade_desc=$1
  cat << EOF > $upgrade_desc
{
  "v": 1,
  "handler": "upgrade2",
  "target": {
    "runtime_host_protocol": {
      "major": 2,
      "minor": 1
    },
    "runtime_committee_protocol": {
      "major": 43,
      "minor": 4,
      "patch": 109
    },
    "consensus_protocol": {
      "major": 3,
      "minor": 2,
      "patch": 1
    }
  },
  "epoch": 50843
}
EOF
}

test_governance() {
    PROPOSAL_ID=23
    TXN_FILE="$TXNS_DIR/tx_vote${PROPOSAL_ID}.json"
    $OASIS_NODE governance gen_cast_vote \
      "${TX_FLAGS[@]}" \
      --vote.proposal.id $PROPOSAL_ID \
      --vote yes \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 2000 \
      --transaction.fee.amount 300000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE

    PROPOSAL_ID=542
    TXN_FILE="$TXNS_DIR/tx_vote${PROPOSAL_ID}.json"
    $OASIS_NODE governance gen_cast_vote \
      "${TX_FLAGS[@]}" \
      --vote.proposal.id $PROPOSAL_ID \
      --vote abstain \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 2000 \
      --transaction.fee.amount 300000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE

    UPGRADE_DESC=$UPGRADES_DIR/upgrade1.json
    generate_upgrade_descriptor1 $UPGRADE_DESC
    TXN_FILE="$TXNS_DIR/tx_proposal1.json"
    $OASIS_NODE governance gen_submit_proposal \
      "${TX_FLAGS[@]}" \
      --proposal.upgrade.descriptor $UPGRADE_DESC \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 2000 \
      --transaction.fee.amount 30000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE

    UPGRADE_DESC=$UPGRADES_DIR/upgrade2.json
    generate_upgrade_descriptor2 $UPGRADE_DESC
    TXN_FILE="$TXNS_DIR/tx_proposal2.json"
    $OASIS_NODE governance gen_submit_proposal \
      "${TX_FLAGS[@]}" \
      --proposal.upgrade.descriptor $UPGRADE_DESC \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 2000 \
      --transaction.fee.amount 30000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
}
