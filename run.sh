#!/bin/bash
IMAGE=gardnerpomper/novnc
#
# ----- run the "novnc" container with a specific UID/GID
# ----- and mount the home directory as /host in the container
# ----- when using boot2docker, you must specify the NEW UID/GID
# ----- when running on linux, you can just use your own
#
# boot2docker version:
docker run -dt -v ${HOME}:/host -e NEWUID=1000 -e NEWGID=50 -p 6080:6080 $IMAGE
# linux version:
#docker run -dt -v ${HOME}:/host -e NEWUID=$(id -u) -e NEWGID=$(id -g) -p 6080:6080 $IMAGE
