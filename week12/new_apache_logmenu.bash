#! /bin/bash

logFile="/var/log/apache2/access.log"


function displayAllLogs() {
  cat "$logFile"
}

function displayOnlyIPs() {
  cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

function pageCount() {
  cat "$logFile" \
    | cut -d ' ' -f 7 \
    | sort \
    | uniq -c
}

function displayOnlyPages() {
  pageCount
}


function histogram() {

  local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '[' | sort | uniq)

  :> newtemp.txt

  echo "$visitsPerDay" | while read -r line;
  do
    local withoutHours=$(echo "$line" | cut -d " " -f 2 | cut -d ":" -f 1)
    local IP=$(echo "$line" | cut -d " " -f 1)

    echo "$IP $withoutHours" >> newtemp.txt
  done

  cat "newtemp.txt" | sort -n | uniq -c
}


function frequentVisitors() {
  # Reuse histogram output (count IP date)
  histogram | while read -r count ip date; do
    if [[ "$count" -gt 10 ]]; then
      echo "$count $ip $date"
    fi
  done
}


function suspiciousVisitors() {
  # If there is no ioc.txt, just warn and return.
  if [[ ! -f ioc.txt ]]; then
    echo "ioc.txt not found. Please create it with one indicator per line."
    return
  fi

  # Filter log by each IOC, then extract IPs.
  :> suspicious_ips.tmp

  while read -r ioc; do
    # Skip empty lines or comments
    [[ -z "$ioc" || "$ioc" =~ ^# ]] && continue
    grep -F "$ioc" "$logFile" | cut -d ' ' -f 1 >> suspicious_ips.tmp
  done < ioc.txt

  if [[ -s suspicious_ips.tmp ]]; then
    echo "Suspicious IP addresses:"
    sort suspicious_ips.tmp | uniq -c
  else
    echo "No suspicious access detected for indicators in ioc.txt."
  fi

  rm -f suspicious_ips.tmp
}

function countingCurlAccess() {
  cat "$logFile" \
    | grep "curl" \
    | awk '{print $1}' \
    | sort \
    | uniq -c
}

# menu

while :
do
  echo "Please select an option:"
  echo "[1] Display all logs"
  echo "[2] Display only IPs"
  echo "[3] Display only pages"
  echo "[4] Histogram (IP visits per day)"
  echo "[5] Frequent visitors (more than 10 visits/day)"
  echo "[6] Suspicious visitors (based on ioc.txt)"
  echo "[7] Count curl access per IP"
  echo "[8] Quit"

  read userInput
  echo ""

  if [[ "$userInput" == "8" ]]; then
    echo "Goodbye"
    break

  elif [[ "$userInput" == "1" ]]; then
    echo "Displaying all logs:"
    displayAllLogs

  elif [[ "$userInput" == "2" ]]; then
    echo "Displaying only IPs:"
    displayOnlyIPs

  elif [[ "$userInput" == "3" ]]; then
    echo "Displaying only pages:"
    displayOnlyPages

  elif [[ "$userInput" == "4" ]]; then
    echo "Histogram:"
    histogram

  elif [[ "$userInput" == "5" ]]; then
    echo "Frequent visitors (more than 10 visits/day):"
    frequentVisitors

  elif [[ "$userInput" == "6" ]]; then
    echo "Suspicious visitors:"
    suspiciousVisitors

  elif [[ "$userInput" == "7" ]]; then
    echo "Curl access per IP:"
    countingCurlAccess

  else
    echo "Invalid option. Please try again."
  fi

  echo ""
done
