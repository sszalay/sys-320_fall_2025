#!/bin/bash

URL="http://10.0.17.18/access.log"

# this is a temporary file to store page content
TMPFILE="/tmp/ioc_page.$$"

OUTFILE="IOC.txt"

curl -s "$URL" > "$TMPFILE"

#   etc/passwd
#   cmd=
#   /bin/bash
#   /bin/sh
#   1=1#
#   1=1--
grep -E "etc/passwd|cmd=|/bin/bash|/bin/sh|1=1#|1=1--" "$TMPFILE" \
    | sed -E 's/.*(etc\/passwd).*/\1/;
              s/.*(cmd=).*/\1/;
              s/.*(\/bin\/bash).*/\1/;
              s/.*(\/bin\/sh).*/\1/;
              s/.*(1=1#).*/\1/;
              s/.*(1=1--).*/\1/' \
    | sort -u > "$OUTFILE"

rm -f "$TMPFILE"
