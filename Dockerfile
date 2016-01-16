FROM centos:centos7
MAINTAINER Gardner Pomper <gardner@networknow.org>
#
# ----- based on https://github.com/zerodivide1/docker-novnc.git, but
# ----- converted from ubuntu to centos.
# ----- Then added code to create a "me" user with a UID/GID that
# ----- can be set at runtime, which makes it easier to mount a host
# ----- volume without messing up the permissions
#
#
# ----- install all the system packages we need
#
RUN yum install -y epel-release 				&& \
    yum update -y 						&& \
    yum groups install -y Fonts 				&& \
    yum install -y git x11vnc wget unzip Xvfb openbox 	   	   \
#        liberation-mono-fonts liberation-narrow-fonts		   \
#        liberation-sans-fonts liberation-serif-fonts		   \
        xterm sudo net-tools 					&& \
#    yum install -y numpy					&& \
    yum clean all
#
# ----- create the "me" user so we don't run as root
# ----- and we can access any host volumes with the
# ----- correct UID/GID
#
RUN mkdir /dhome						&& \
    useradd me  -G wheel -d /dhome/me				&& \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#
# ----- copy in our custom scripts:
# -----    novnc_start.sh : starts noVNC server
# -----    runas_me.sh    : changes "me" user to give UID
#
ADD novnc_start.sh runas_me.sh /dhome/me/
#
# ----- pull the noVNC project code
#
RUN cd /dhome/me 						&& \
    git clone https://github.com/kanaka/noVNC.git 		&& \
    cd noVNC/utils 						&& \
    git clone https://github.com/kanaka/websockify websockify 	&& \
    cd /dhome/me 						&& \
    chmod 0755 novnc_start.sh runas_me.sh
#
# ----- set up the "me" user's default environment
#
USER me
ENV DISPLAY=:1 DEPTH=24 GEOMETRY=1280x1024
#
# ----- switch back to the root user
# ----- because the "runas_me.sh" entrypoint must have
# ----- root privileges to change the UID/GID of the "me" user
#
USER root
EXPOSE 6080

ENTRYPOINT ["/dhome/me/runas_me.sh"]
CMD ["/home/me/novnc_start.sh"]
