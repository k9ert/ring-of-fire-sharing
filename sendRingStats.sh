
user=$(jq -c '.auth.user' ringOfFireConfig.json | tr -d '"')
password=$(jq -c '.auth.password' ringOfFireConfig.json | tr -d '"')
url=$(jq -c '.url' ringOfFireConfig.json | tr -d '"')
ringStats=$(. getRingStats.sh)

curl -u "$user":"$password"  -X POST -H "Content-Type: application/json" -d "$ringStats"  "$url"/channel/123/balance
