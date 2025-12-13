#!/bin/bash

link="http://10.0.17.18/tables.html"

fullPage=$(curl -sL "$link")

tempTable=$(echo "$fullPage" | \
xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet select --template --copy-of "//table[1]//tr")

pressureTable=$(echo "$fullPage" | \
xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet select --template --copy-of "//table[2]//tr")

tempData=$(echo "$tempTable" | \
sed 's/<\/tr>/\n/g' | \
sed -e 's/<tr>//g' | \
sed -e 's/<th[^>]*>[^<]*<\/th>//g' | \
sed -e 's/<td[^>]*>//g' | \
sed -e 's/<\/td>/ /g' | \
sed -e 's/<[^>]*>//g' | \
sed '/^$/d' | \
tail -n +2)

pressureData=$(echo "$pressureTable" | \
sed 's/<\/tr>/\n/g' | \
sed -e 's/<tr>//g' | \
sed -e 's/<th[^>]*>[^<]*<\/th>//g' | \
sed -e 's/<td[^>]*>//g' | \
sed -e 's/<\/td>/ /g' | \
sed -e 's/<[^>]*>//g' | \
sed '/^$/d' | \
tail -n +2)

#pasting the tables together
paste -d ' ' <(echo "$pressureData" | awk '{print $1}') \
      	     <(echo "$tempData" | awk '{print $1}') \
             <(echo "$tempData" | awk '{print $2}')
