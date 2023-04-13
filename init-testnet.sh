#!/bin/sh

VALIDATOR_NAME=validator1
CHAIN_ID=xnodes
KEY_NAME=xnodes-key
CHAINFLAG="--chain-id ${CHAIN_ID}"
TOKEN_AMOUNT="10000000000000000000000000stake"
STAKING_AMOUNT="1000000000stake"

NAMESPACE_ID=$(openssl rand -hex 8)
echo $NAMESPACE_ID
RPC="https://rpc-blockspacerace.pops.one" 
DA_BLOCK_HEIGHT=$(curl ${RPC}/block | jq -r '.result.block.header.height')
echo $DA_BLOCK_HEIGHT

ignite chain build
xnodesd tendermint unsafe-reset-all
xnodesd init $VALIDATOR_NAME --chain-id $CHAIN_ID

xnodesd keys add $KEY_NAME --keyring-backend test
xnodesd add-genesis-account $KEY_NAME $TOKEN_AMOUNT --keyring-backend test
xnodesd gentx $KEY_NAME $STAKING_AMOUNT --chain-id $CHAIN_ID --keyring-backend test
xnodesd collect-gentxs
xnodesd start --rollkit.aggregator true --rollkit.da_layer celestia --rollkit.da_config='{"base_url":"http://localhost:26659","timeout":60000000000,"fee":6000,"gas_limit":6000000}' --rollkit.namespace_id $NAMESPACE_ID --rollkit.da_start_height $DA_BLOCK_HEIGHT