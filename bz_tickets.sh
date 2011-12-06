#!/bin/bash -e
TCOUNT=bz_count.txt
URL=bz_urls.txt
SITE=bz_sites.txt

cat /dev/null > $TCOUNT

cat $URL | while read URL
do
        wget -q --cookies=on --load-cookies=cookie.txt --keep-session-cookies $URL -O - | grep 'found' | head -1 | sed 's/<[^>]*>//g;s/^[ \t]*//;' >> $TCOUNT
done

paste -d , $SITE $TCOUNT > bz_pasted.txt

exec 7<$URL
exec 8<bz_pasted.txt

echo "<h1>ByWater Tickets</h1>" > combined.html
echo "<table border=\"1\">" >> combined.html
while read -u 7 f1
do
    read -u 8 f2
    echo "<tr><td><a href=\"$f1\">$f2</a></tr></td>" >> combined.html
done
echo "</table>" >> combined.html

sudo cp combined.html /var/www/index.html
