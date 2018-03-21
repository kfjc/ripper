#!/bin/sh
source /conf.sh

PLAYLIST_INFO=$(curl -s $PREVIOUS_PLAYLIST_URL)
ID_FILE=$(echo $PLAYLIST_INFO | cut -d' ' -f1)
PL_NUM=$(echo $PLAYLIST_INFO | cut -d' ' -f2)

echo $PL_NUM > $RIPPER_EXPORT_DIR/$ID_FILE
