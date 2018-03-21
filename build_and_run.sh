#!/bin/bash
source conf.sh

docker build -t ripper:latest .
docker container stop ripper
docker container rm ripper
docker run --restart=always -d -p 8888:8888 -v $RIPPER_DIR:/ripper --name=ripper ripper:latest
