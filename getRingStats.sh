echo "{"

my_node_id=$(lncli getinfo | jq -r '.identity_pubkey')
feeReport=$(lncli feereport | jq -r '.')

echo "\"nodeId\":\"${my_node_id}\","
echo "\"feeReport\":${feeReport},"

echo "\"ringPeers\": ["
jq -c '.peers[]' ringOfFireConfig.json | while read peer; do
  peer=$(echo "$peer" | tr -d '"')
  node_id=$(echo "$peer" | cut -f1 -d@)
  peerInfo=$(lncli listchannels --peer "$node_id" | jq -r --arg node_id "$node_id" '{ nodeId: $node_id, chan_id: .channels[].chan_id, local_balance: .channels[].local_balance, remote_balance: .channels[].remote_balance, active: .channels[].active }')
  if [ -n "$peerInfo" ]
  then
    echo "${peerInfo},"
  #else
    #TODO check whether we can ping nodes we are not having a channel with
    #peerInfo=$(lncli connect "$node_id")
    #echo "\"${node_id}\":${peerInfo},"
  fi
done

echo "{}]"
echo "}"
