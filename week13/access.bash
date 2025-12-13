#!/bin/bash
# Script called by incron when userlogs-1.bash is accessed

LOGFILE="/home/scott/sys-320_fall_2025/week13/fileaccesslog.txt"
MAILTO="scott.szalay@mymail.champlain.edu"

echo "$(date '+%Y-%m-%d %H:%M:%S') - userlogs-1.bash was accessed" >> "$LOGFILE"

echo "To: scott.szalay@mymail.champlain.edu" > emailform.txt
echo "Subject: File Accessed" >> emailform.txt
cat fileaccesslog.txt >> emailform.txt
ssmtp "$MAILTO"
