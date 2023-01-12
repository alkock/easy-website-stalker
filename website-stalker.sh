#!/bin/bash
#-----------------------------------------------------------
#The URL you want to stalk
URL=https://www.google.de
#Prowl-API Key provided to you
PROWLAPIKEY=Your-Api-Key
#Name the sender of the message
APPLICATIONNAME=easywebsitestalker
#Name the event that happend
EVENT=Diff
#Define the Message that should be sent 
MESSAGE=There%20is%20a%20diff%20on%20google.de
#Check the diff for a special Term (case-insensitive)
SPECIALTERM=special-term
#Define a special message if a special-term is found
SPECIALMESSAGE=The%20Term%20$SPECIALTERM%20is%20in%20the%20diff

#Activate this if your site is in the hidden-web
#TOR=torsocks

#-----------------------------------------------------------

rm -rf old.html
mv new.html old.html
$TOR wget -O new.html $URL

diff old.html new.html

if [ $? -eq 0 ]
then
        echo "No changes"
else
        echo "Changes"
        curl "https://api.prowlapp.com/publicapi/add?apikey=$PROWLAPIKEY&application=$APPLICATIONNAME&=event=$EVENT&description=$MESSAGE
        if grep -q -i "$SPECIALTERM" new.html; then
                echo "The word $SPECIALTERM was found in the file!"
                curl "https://api.prowlapp.com/publicapi/add?apikey=$PROWLAPIKEY&application=$APPLICATIONNAME&event=$EVENT&description=$SPECIALMESSAGE
        else
                echo "The word '$SPECIALTERM' was not found in the file."
        fi

fi