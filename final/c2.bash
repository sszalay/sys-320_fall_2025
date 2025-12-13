#!/bin/bash

logfile="/var/www/html/access.log"
iocfile="/home/scott/sys-320_fall_2025/final/IOC.txt"

pattern=$(paste -sd'|' "$iocfile")

# searchs the logs for any IOC and print IP, date/time, and page
awk -v pat="$pattern" '
    $0 ~ pat {
        dt = substr($4,2) " " $5
        gsub(/]/,"",dt)
        print $1, dt, $7
    }
' "$logfile" > report.txt
