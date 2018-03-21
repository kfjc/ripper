#!/bin/sh
source /conf.sh
mkdir -p $RIPPER_RECORDING_DIR

watch -n60 "/ripper-bin/check_dj_name.sh & /ripper-bin/move_latest_hour.sh & /ripper-bin/store_previous_playlist_id.sh & /ripper-bin/remove_old_mp3s.sh" &
forever start -s --workingDir $RIPPER_DIR /ripper-bin/httpd.js
cd $RIPPER_RECORDING_DIR
echo "Starting ffmpeg"
exec ffmpeg -i $STREAM_URL\
        -loglevel quiet\
        -c copy\
        -flags +global_header\
        -f segment\
        -segment_time 3600\
        -segment_atclocktime 1\
        -reset_timestamps 1\
        aircheck%d.mp3
