echo "{"

feeReport=$(lncli feereport)

echo "\"feeReport\":${feeReport}"

jq -c '.peers[]' ringOfFireConfig.json | while read peer; do
  peer=$(echo "$peer" | tr -d '"')
  node_id=$(echo "$peer" | cut -f1 -d@)
  peerInfo=$(lncli listchannels --peer "$node_id" | jq -r '{ chan_id: .channels[].chan_id, local_balance: .channels[].local_balance, remote_balance: .channels[].remote_balance, active: .channels[].active }')
  if [ -n "$peerInfo" ]
  then
    echo ",\"${node_id}\":${peerInfo}"
  #else
    #TODO check whether we can ping nodes we are not having a channel with
    #peerInfo=$(lncli connect "$node_id")
    #echo ",\"${node_id}\":${peerInfo}"
  fi
done

echo "}"
