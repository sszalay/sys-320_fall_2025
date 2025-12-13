#! /bin/bash

authfile="/var/log/auth.log"

function getLogins(){
 logline=$(cat "$authfile" | grep "systemd-logind" | grep "New session")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,11 | tr -d '\.')
 echo "$dateAndUser" 
}


function getFailedLogins() {

    faillines=$(grep "Failed password" "$authfile")
    failedParsed=$(echo "$faillines" | awk '{print $1, $2, $3, $9, $11}')
    echo "$failedParsed"
}


# Sending logins as email - Do not forget to change email address
# to your own email address
echo "To: scott.szalay@mymail.champlain.edu" > emailform.txt
echo "Subject: Logins" >> emailform.txt
getLogins >> emailform.txt

echo "Failed login attempts:" >> emailform.txt
getFailedLogins >> emailform.txt


echo "Successful logins:" >> emailform.txt
getLogins >> emailform.txt
echo "" >> emailform.txt

cat emailform.txt | ssmtp "scott.szalay@mymail.champlain.edu" 

