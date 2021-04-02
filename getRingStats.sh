echo "{"

feeReport=$(lncli feereport)

echo "\"feeReport\":${feeReport}"

jq -c '.peers[]' ringOfFireConfig.json | while read peer; do
  peer=$(echo "$peer" | tr -d '"')
  peerInfo=$(lncli listchannels --peer "$peer" | jq -r '{ chan_id: .channels[].chan_id, local_balance: .channels[].local_balance, remote_balance: .channels[].remote_balance }')
  echo ",\"${peer}\":${peerInfo}"
done

echo "}"
