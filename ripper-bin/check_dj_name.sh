#!/bin/sh
source /conf.sh

# Sample the currently signed in DJ name (extract from json; to lowercase; strip non-alphanumeric or spce; space to _)
DJ_NAME=$(curl -s $PLAYLIST_URL\
  |jq -r '.show_info.air_name'\
  |tr '[:upper:]' '[:lower:]'\
  |tr -cd [:alnum:][' ']\
  |tr ' ' '_')
echo $DJ_NAME >> $RIPPER_DJ_SIGNIN_LOG
