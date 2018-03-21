#!/bin/sh
source /conf.sh

# Decide who was signed in the most since we created 
MOST_PRESENT_DJ=$(uniq -c $RIPPER_DJ_SIGNIN_LOG |sort -nr |head -1 |awk '{print $2}')
echo $MOST_PRESENT_DJ
rm $RIPPER_DJ_SIGNIN_LOG
