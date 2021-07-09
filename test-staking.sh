# Functions for testing staking.

source common.sh

test_staking() {
    stake_account_info

    TXN_FILE="$TXNS_DIR/tx_transfer.json"
    $OASIS_NODE stake account gen_transfer \
      "${TX_FLAGS[@]}" \
      --stake.amount 170000000000 \
      --stake.transfer.destination $DST_ADDRESS \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
    stake_account_info

    TXN_FILE="$TXNS_DIR/tx_allow.json"
    $OASIS_NODE stake account gen_allow \
      "${TX_FLAGS[@]}" \
      --stake.allow.amount_change -15135000000000 \
      --stake.allow.beneficiary $DST_ADDRESS \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
    stake_account_info

    TXN_FILE="$TXNS_DIR/tx_withdraw.json"
    $OASIS_NODE stake account gen_withdraw \
      "${TX_FLAGS[@]}" \
      --stake.amount 84038000000000 \
      --stake.withdraw.source $DST_ADDRESS \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
    stake_account_info

    TXN_FILE="$TXNS_DIR/tx_escrow.json"
    $OASIS_NODE stake account gen_escrow \
      "${TX_FLAGS[@]}" \
      --stake.amount 208000000000 \
      --stake.escrow.account $ENTITY1_ADDRESS \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
    stake_account_info

    TXN_FILE="$TXNS_DIR/tx_reclaim.json"
    $OASIS_NODE stake account gen_reclaim_escrow \
      "${TX_FLAGS[@]}" \
      --stake.shares 357000000000 \
      --stake.escrow.account $ENTITY1_ADDRESS \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
    stake_account_info

    TXN_FILE="$TXNS_DIR/tx_amend_commission_schedule.json"
    $OASIS_NODE stake account gen_amend_commission_schedule \
      "${TX_FLAGS[@]}" \
      --stake.commission_schedule.bounds 32/10000/50000 \
      --stake.commission_schedule.bounds 64/10000/30000 \
      --stake.commission_schedule.rates 32/50000 \
      --stake.commission_schedule.rates 40/40000 \
      --stake.commission_schedule.rates 48/30000 \
      --stake.commission_schedule.rates 56/25000 \
      --stake.commission_schedule.rates 64/20000 \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
    stake_account_info

    TXN_FILE="$TXNS_DIR/tx_burn.json"
    $OASIS_NODE stake account gen_burn \
      "${TX_FLAGS[@]}" \
      --stake.amount 75849000000000 \
      --transaction.file $TXN_FILE \
      --transaction.nonce $ENTITY1_NONCE \
      --transaction.fee.gas 1000 \
      --transaction.fee.amount 2000

    ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    show_tx $TXN_FILE
    submit_tx $TXN_FILE
    stake_account_info
}
