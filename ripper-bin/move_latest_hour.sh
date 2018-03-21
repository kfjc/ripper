#!/bin/sh
source /conf.sh
mkdir -p $RIPPER_EXPORT_DIR
mkdir -p $RIPPER_INCOMPLETE_DIR

for f in $RIPPER_RECORDING_DIR/*.mp3
do
	[ -e "$f" ] || continue

	# Figure out when the file was last modified
	NOW=$(date +'%s')
	MOD_TIME=$(stat -c %Y $f)
	TIME_SINCE_MOD=$(expr $NOW - $MOD_TIME)

	# Don't touch files modified in the last 30sec
	if [ $TIME_SINCE_MOD -lt 30 ]; then
		continue
	fi

	# Construct date format and get DJ name to rename file.
	# As a hack, add 10 seconds to avoid naming files that ended
	# milliseconds before the hour as :59
	START_TIME=$(expr $MOD_TIME - 3600 + 10)
	TIME_FORMAT=$(date +%y%m%d%H%M -d "@$START_TIME")
	DJ_NAME=$(/ripper-bin/consume_dj_name.sh)
	DEST_FILENAME="$TIME_FORMAT"h_"$DJ_NAME"".mp3"

	# Check if the file is less than an hour long
	LENGTH_SEC=$(ffprobe -i $f -show_entries format=duration -v quiet -of csv="p=0" |cut -d'.' -f1)
	if [ $LENGTH_SEC -lt 3540 ]; then
		DEST=$RIPPER_INCOMPLETE_DIR/$DEST_FILENAME
	else
		DEST=$RIPPER_EXPORT_DIR/$DEST_FILENAME
	fi
	echo "move_latest_hour.sh: moving $f to $DEST (length: $LENGTH_SEC)"
	mv $f $DEST
done
