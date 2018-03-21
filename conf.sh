#!/bin/sh

# You might be interested in changing these:
## Stream URL
STREAM_URL="http://192.168.0.125:8000/"
## API endpoint that serves the current playlist data in json format
PLAYLIST_URL="http://kfjc.org:80/api/playlists/?id=0"
PREVIOUS_PLAYLIST_URL="http://kfjc.org:80/api/playlists/previous.php"
## How long to keep exported archives before deleting
DISCARD_AGE_SEC=172800 # 48 hours
## Working directory on host (mounted to the same in the container)
RIPPER_DIR=/ripper

# You probably don't care about changing these:
## Ripper working directory in container
RIPPER_RECORDING_DIR=$RIPPER_DIR/recording
RIPPER_EXPORT_DIR=$RIPPER_DIR/export
RIPPER_INCOMPLETE_DIR=$RIPPER_DIR/incomplete
RIPPER_DJ_SIGNIN_LOG=$RIPPER_DIR/dj_signin_log.txt
