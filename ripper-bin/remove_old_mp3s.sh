#!/bin/sh
source /conf.sh

for f in $RIPPER_EXPORT_DIR/*
do
	[ -e "$f" ] || continue

	NOW=$(date +'%s')
	MOD_TIME=$(stat -c %Y $f)
	TIME_SINCE_MOD=$(expr $NOW - $MOD_TIME)
	# Don't touch files modified more recently than the threshold
	if [ $TIME_SINCE_MOD -lt $DISCARD_AGE_SEC ]; then
		continue
	fi

	echo "remove_old_mp3s: deleting $f due to old age"
	rm $f
done
