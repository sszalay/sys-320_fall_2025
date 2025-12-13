#!/bin/bash

REPORT_TXT="/home/scott/sys-320_fall_2025/final/report.txt"
OUT_HTML="/tmp/report.html"
WWW_HTML="/var/www/html/report.html"

# start HTML
{
    echo "<!DOCTYPE html>"
    echo "<html>"
    echo "<head>"
    echo "  <meta charset=\"UTF-8\">"
    echo "  <title>Access logs with IOC indicators</title>"
    echo "</head>"
    echo "<body>"
    echo "  <h2>Access logs with IOC indicators:</h2>"
    echo "  <table border=\"1\" cellpadding=\"4\" cellspacing=\"0\">"
} > "$OUT_HTML"

# each line: IP DATE/TIME PAGE  -> three table cells
while read -r ip datetime page; do
    echo "    <tr><td>${ip}</td><td>${datetime}</td><td>${page}</td></tr>" >> "$OUT_HTML"
done < "$REPORT_TXT"

# stop HTML
{
    echo "  </table>"
    echo "</body>"
    echo "</html>"
} >> "$OUT_HTML"

# move it to web root 
mv "$OUT_HTML" "$WWW_HTML"
echo "HTML report created at $WWW_HTML"
