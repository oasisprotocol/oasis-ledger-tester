# Functions for testing registry.

source common.sh

test_registry() {
    # Create 2 Nodes for Entity 1.
    $OASIS_NODE registry node init --datadir $NODE1_DIR --node.entity_id $(cat $ENTITY1_DIR/entity.json | jq .id -r)
    $OASIS_NODE registry node init --datadir $NODE2_DIR --node.entity_id $(cat $ENTITY1_DIR/entity.json | jq .id -r)
    # Update Entity 1 with these 2 Nodes.
    $OASIS_NODE registry entity update \
    "${SIGNER_FLAGS[@]}" \
    --entity.node.descriptor $NODE1_DIR/node_genesis.json \
    --entity.node.descriptor $NODE2_DIR/node_genesis.json

    TXN_FILE="$TXNS_DIR/tx_entity_register.json"
    $OASIS_NODE registry entity gen_register \
      "${TX_FLAGS[@]}" \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE

    TXN_FILE="$TXNS_DIR/tx_entity_deregister.json"
    $OASIS_NODE registry entity gen_deregister \
      "${TX_FLAGS[@]}" \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE

    # TODO: Add oasis-node registy node gen_unfreeze CLI command.
    # TXN_FILE="$TXNS_DIR/tx_unfreeze_node.json"
    # $OASIS_NODE registry node gen_unfreeze \
    #   "${TX_FLAGS[@]}" \
    #   --transaction.file $TXN_FILE \
    #   --transaction.nonce $ENTITY1_NONCE \
    #   --transaction.fee.gas 1000 \
    #   --transaction.fee.amount 2000

    # ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    # show_tx $TXN_FILE
    # submit_tx $TXN_FILE
}
