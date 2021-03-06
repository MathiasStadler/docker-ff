FROM ubuntu:18.04

RUN apt update && apt-get install -y firefox
RUN apt update && apt-get install -y sudo
RUN apt install -y libcanberra-gtk-module libcanberra-gtk3-module
RUN apt install -y dbus-x11
RUN apt install -y apulse
RUN apt-get install -y libpulse0

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
CMD /usr/bin/apulse /usr/bin/firefox
