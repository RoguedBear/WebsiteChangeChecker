#!/bin/bash

# monitor.sh - Monitors a web page for changes
# sends an email notification if the file change

API_KEY = ''
CHAT_ID = ''
URL="https://jeemain.nta.nic.in/webinfo/public/home.aspx"

for (( ; ; )); do
    mv new.html old.html 2> /dev/null
    curl $URL -L --compressed -s > new.html
    sleep 5
    DIFF_OUTPUT="$(diff -I '<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE"' new.html old.html)"
    if [ "0" != "${#DIFF_OUTPUT}" ]; then
        curl -s "https://api.telegram.org/bot" + $API_KEY + "/sendMessage?chat_id=" + $CHAT_ID +"&parse_mode=Markdown&text='Website Changed!!!'"
        
        printf "Change Found!!\n"
        printf `date +%H-%M-%S\n`
        printf " Change found\n"
        printf $DIFF_OUTPUT
        printf "\n\n"
        
        cp `pwd`/new.html `pwd`/`date +%H:%M:%S`.html
        sleep 10
    fi
done
