# Functions for testing registry.

source common.sh

test_registry() {

    # NOTE: This appears to be broken in the newest version of the Oasis App: 2.1.0:
    # + oasis-node-21.2.7 registry entity gen_register --genesis.file testnet/genesis.json --signer.dir entity-0/ --signer.backend plugin --signer.plugin.name ledger --signer.plugin.path '/home/tadej/Apps/Oasis Core Ledger/oasis_core_ledger_1.2.0_linux_amd64/ledger-signer' --signer.plugin.config wallet_id:dba676,index:0 --transaction.file testnet/transactions/tx_entity_register.json --transaction.nonce 25 --transaction.fee.gas 1000 --transaction.fee.amount 2000
    # ts=2021-07-09T16:19:55.607272785Z level=error module=cmd/registry/entity caller=entity.go:297 msg="failed to sign entity descriptor" err="signature/signer/plugin: failed to sign: ledger: failed to sign message: ledger/oasis: failed to sign: Unrecognized error code"
    #
    # TXN_FILE="$TXNS_DIR/tx_entity_register.json"
    # $OASIS_NODE registry entity gen_register \
    #   "${TX_FLAGS[@]}" \
    #   --transaction.file $TXN_FILE \
    #   --transaction.nonce $ENTITY1_NONCE \
    #   --transaction.fee.gas 1000 \
    #   --transaction.fee.amount 2000

    # ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    # show_tx $TXN_FILE
    # submit_tx $TXN_FILE

    # NOTE: This appears to be broken in the newest and the current latest version
    # of Oasis App published on Ledger Live: 2.1.0 and 1.8.2:
    #
    # + oasis-node-21.2.7 registry entity gen_deregister --genesis.file testnet/genesis.json --signer.dir entity-0/ --signer.backend plugin --signer.plugin.name ledger --signer.plugin.path '/home/tadej/Apps/Oasis Core Ledger/oasis_core_ledger_1.2.0_linux_amd64/ledger-signer' --signer.plugin.config wallet_id:70e0b3,index:0 --transaction.file testnet/transactions/tx_entity_deregister.json --transaction.nonce 0 --transaction.fee.gas 1000 --transaction.fee.amount 2000
    # You are about to sign the following transaction:
    #   Method: registry.DeregisterEntity
    #   Body:
    #     <unknown method body: >
    #   Nonce:  0
    #   Fee:
    #     Amount: 0.000002 TEST
    #     Gas limit: 1000
    #     (gas price: 0.000000002 TEST per gas unit)
    # Other info:
    #   Genesis document's hash: 5ba68bc5e01e06f755c4c044dd11ec508e4c17f1faf40c0e67874388437a9e55
    #
    # You may need to review the transaction on your device if you use a hardware-based signer plugin...
    # ts=2021-07-09T16:50:47.053172716Z level=error module=cmd/common/consensus caller=consensus.go:139 msg="failed to sign transaction" err="signature/signer/plugin: failed to sign: ledger: failed to sign message: ledger/oasis: failed to sign: No more data"
    #
    # TXN_FILE="$TXNS_DIR/tx_entity_deregister.json"
    # $OASIS_NODE registry entity gen_deregister \
    #   "${TX_FLAGS[@]}" \
    #   --transaction.file $TXN_FILE \
    #   --transaction.nonce $ENTITY1_NONCE \
    #   --transaction.fee.gas 1000 \
    #   --transaction.fee.amount 2000

    # ENTITY1_NONCE=$((ENTITY1_NONCE + 1))
    # show_tx $TXN_FILE
    # submit_tx $TXN_FILE
}
