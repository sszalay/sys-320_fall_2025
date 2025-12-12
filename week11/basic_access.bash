
ip="http://10.0.17.18"

for i in {1..20}
do
    echo "Request #$i"
    curl -s -o /dev/null -w "%{http_code}\n" "$ip"
done
