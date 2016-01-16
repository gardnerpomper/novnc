# novnc

This is the smallest Centos7 noVNC desktop I have been able to
build. The image is roughly 670MB. It is a very minimal desktop, as it
runs the openbox window manager and the only X11 program installed is
xterm. It can, however, be run on a local or remote machine and be
accessed with any fairly recent browser.

## Use Cases

This image is really provided as both an example, as to be used as a
base image for more targetted applications. It does have the following
important characteristics:

1. Provides a GUI environment in a docker container

2. Provides access to that GUI environment directly from the browser,
   without requiring any other software, such as a VNC or RDP viewer,
   or an X11 server.

3. Creates a user account inside the docker container with a UID/GID
   that can be set at runtime. This makes it much easier to mount a
   directory from the host and work on it from tools in the docker
   container, without creating permission problems on the host files.

## How to use

The run.sh script provides an example of how the container is intended
to be run. The script is included here, to illustrate:
```
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
```

### To build yourself

```
git clone https://github.com/gardnerpomper/novnc.git 
cd novnc
docker build -t novnc .
docker run -dt -v ${HOME}:/host -e NEWUID=$(id -u) -e NEWGID=$(id -g) -p 6080:6080 $IMAGE
```

### Browser access

In your browser, enter the url for the machine running the container,
specifying the port at 6080. Example:
```
http://localhost:6080
```
If you are running with boot2docker, you will need to enter the IP
address of the docker virtual machine, such as:
```
http://192.168.99.100:6080
```

### Using the openbox desktop

This is truly a minimal desktop. Your browser window will start out
blank. Right click on the background to bring up a menu, and select
Terminals->XTerm to open an xterm window. That is about all the GUI
work you can do; not even the configuration tools are installed.

### Installing other packages

The "me" user has sudo privileges, so you can install other packages
from the xterm prompt, if you want to try them out. Remember that they
will go away once you stop the container. Some packages you might want
to install:

1) emacs: sudo yum install emacs
2) xeyes: sudo yum install xorg-x11-apps

## Image size

I have tried to keep the image size down. One of the ways this was
done was to avoid installing the numpy package. The docker logs for
this container indicates that it would be faster with numpy included,
but that would take an extra 50MB. The line to include it is in the
Dockerfile, but commented out.

Another package that takes up alot of space is the "Fonts" group,
which is about 100MB. It seems like a selected set of fonts could save
considerable disk space, but I have been unable to identify a small
set that still lets the container run.

## Credits

* [NoVNC](http://kanaka.github.io/noVNC/)
* [Ubuntu-based docker-novnc project](https://github.com/zerodivide1/docker-novnc.git)

