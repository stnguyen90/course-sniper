#!/bin/bash
# script to send simple email
# email subject
SUBJECT="Course Open"
# Email To ?
EMAIL="person@email.com"
# Email text/message
EMAILMESSAGE="/tmp/emailmessage.txt"
echo "This is an email message test"> $EMAILMESSAGE
echo "This is email text" >>$EMAILMESSAGE
# send an email using /bin/mail
/usr/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

