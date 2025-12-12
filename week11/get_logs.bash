
file="/var/log/apache2/access.log"

results=$(cat "$file" \
  | grep "page2\.html" \
  | cut -d' ' -f1,7 \
  | tr -d "[]")

pageCount() {
  cat "$file" \
    | cut -d' ' -f7 \
    | sort \
    | uniq -c
}

countingCurlAccess() {
  cat "$file" \
    | grep "curl" \
    | awk '{print $1}' \
    | sort \
    | uniq -c
}


#echo "$results"
#pageCount
countingCurlAccess
