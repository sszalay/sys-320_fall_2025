
# List all the IPs in the given network
[ $# -ne 1 ] && echo "Usage: $0 <Prefix>" && exit 1


prefix=$1


[ ${#prefix} -lt 5 ] && \
printf "Prefix length is too short\nPrefix example: 10.0.17\n" && \
exit 1


for i in {1..254}
do

      ping -c 1 "$prefix.$i" | grep "64 bytes" || \
      echo "$prefix.$i is down"
done
