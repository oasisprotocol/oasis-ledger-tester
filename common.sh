# Common functions.

stake_account_info() {
  if [[ $SHOW_ACCOUNT_INFO = "yes" ]]; then
    $OASIS_NODE stake account info \
      -a $ADDR \
      --stake.account.address $ENTITY1_ADDRESS
  fi
}

show_tx() {
  local tx_file=$1
  if [[ $SHOW_TXNS = "yes" ]]; then
    $OASIS_NODE consensus show_tx \
      --genesis.file $GENESIS_FILE \
      --transaction.file $tx_file \
      --debug.dont_blame_oasis
  fi
}

submit_tx() {
  local tx_file=$1
  if [[ $SUBMIT_TXNS = "yes" ]]; then
    $OASIS_NODE consensus submit_tx \
      -a $ADDR \
      --transaction.file $tx_file
  else
    echo -e 2>&1 "Skipping submission of transaction $tx_file.\n"
  fi
}
