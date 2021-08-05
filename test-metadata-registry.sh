# Functions for testing metadata registry.

source common.sh

generate_entity_metadata_valid() {
  local entity_meta=$1
  cat << EOF > $entity_meta
{
  "v": 1,
  "serial": 1,
  "name": "My entity name: Neža Čadonić Pẽnìcatti",
  "url": "https://my.entity/url",
  "email": "my@entity.org",
  "keybase": "my_keybase_handle",
  "twitter": "my_twitter_handle"
}
EOF
}

generate_entity_metadata_invalid() {
  local entity_meta=$1
  cat << EOF > $entity_meta
{
  "v": 1,
  "serial": 5,
  "name": "This is some tooooooooooooooo long entity name (51)",
  "url": "https://my.entity/url",
  "email": "my@entity.org",
  "keybase": "my_keybase_handle",
  "twitter": "my_twitter_handle"
}
EOF
}

test_metadata_registry() {
    METADATA_FILE=$ENTITY_META_DIR/entity_invalid.json
    generate_entity_metadata_invalid $METADATA_FILE
    if $OASIS_REGISTRY entity update \
      "${SIGNER_FLAGS[@]}" \
      --skip-validation \
      $METADATA_FILE; then
        echo -e 2>&1 "Invalid Entity metadata signing should fail.\n"
        exit 1
     fi

    METADATA_FILE=$ENTITY_META_DIR/entity_valid.json
    generate_entity_metadata_valid $METADATA_FILE
    $OASIS_REGISTRY entity update \
      "${SIGNER_FLAGS[@]}" \
      $METADATA_FILE
}
