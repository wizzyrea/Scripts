#!/bin/bash -e
WORKINGPATH=~/
PATH=/var/www
TCOUNT=$WORKINGPATH/bz_count.txt
URL=$WORKINGPATH/bz_urls.txt
SITE=$WORKINGPATH/bz_sites.txt
COMBINED=$WORKINGPATH/bz_pasted.txt

cat /dev/null > $TCOUNT

cat $URL | while read URL
do
        wget -q --cookies=on --load-cookies=cookie.txt --keep-session-cookies $URL -O - | grep 'found' | head -1 | sed 's/<[^>]*>//g;s/^[ \t]*//;' >> $TCOUNT
done

paste -d , $SITE $TCOUNT > $COMBINED

exec 7<$URL
exec 8<$COMBINED

echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"
    \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
<head>
  <title> ByWater Ticket Counts </title>
</head>
<body>
<h1>ByWater Tickets</h1>
<table border=\"1\">" >> $PATH/index.html

while read -u 7 f1
do
    read -u 8 f2
    echo "<tr><td><a href=\"$f1\">$f2</a></tr></td>" >> $PATH/index.html
done
echo "</table> 
</body>" >> $PATH/index.html


