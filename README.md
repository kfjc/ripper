# Ripper

## What?
A docker image that sucks in the KFJC netcast stream and spits it out as hourly .mp3 chunks, served up via http on port 8888.

## How to use
1. Check that you like the options in `config.sh`
2. `./build-and-run.sh`
3. Gawk at hourly .mp3 output on port 8888, and/or write a script to grab mp3s as they come.

Don't forget about disk! Each hour weighs in at about 57.5Mb, which is about 2.76Gb for 48hrs or 19.32Gb for 2 weeks.

## Details
The main entry point is `ripper-bin/main.sh`. In summary, it does three things:
1. ffmpeg continually streams and segments
2. Every 60 seconds:
    - Check which DJ is signed in via query to `kfjc.org/api/playlists?id=0` (append name to dj_signin_log.txt)
    - Check previous playlist info from `kfjc.org/api/playlists/previous.php` and dump that in an .id file
    - Check for ffmpeg output files that are no longer being recorded to (ie, not modified for at least 30sec). If there's a new file:
      - See who appears most in dj_signin_log.txt and choose that as the DJ name for the hour; rm dj_signin_log.txt to clear it for the next hour
      - Move the correctly named output mp3 file to the export directory
3. Serves files from a simple HTTP server on port 8000 (because FTP or NFS configuration is a royal pain in the arse).

## HTTP interface
Directories are relative to `/ripper`. Use `?html=true` for a slightly more useful view; otherwise plain text directory listings are provided for machines to interpret.
 - `/dj_signin_log.txt` shows who's been signed in each minute since the top of the hour
 - `/export` holds completed 1hr mp3 segments
 - `/incomplete` holds mp3 segments less than 59mins (eg, the segment between ripper start and the top of the next hour)
 - `/recording` holds the mp3 currently being recorded. You can check the modification time to see if ripper is active.

## TODO
 - Move files out of recording dir on start
 - Extract more variables into config.sh
 - Run readonly image; don't run as root

## Thanks
https://github.com/opencoconut/ffmpeg
