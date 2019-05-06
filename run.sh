
# create pulseaudio socket
pactl load-module module-native-protocol-unix socket=/tmp/pulseaudio.socket

# create config for pulseaudio clients
echo "default-server = unix:/tmp/pulseaudio.socket
# Prevent a server running in container
autospawn = no
daemon-binary = /bin/true
# Prevent the use of shared memory
enable-shm = false
" >/tmp/pulseaudio.client.conf

# Allow access to X server
xhost +SI:localuser:$(id -un)


docker run -ti --rm \
--shm-size=2g \
--net=host \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /dev/shm:/dev/shm \
-v /etc/machine-id:/etc/machine-id \
-v /run/user/$uid/pulse:/run/user/$uid/pulse \
-v ~/.pulse:/home/$dockerUsername/.pulse firefox/18.04:6 \
-v ~/.pulse:/home/$dockerUsername/.pulse \
--ipc=host \
--env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
    --volume /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
    --volume /tmp/pulseaudio.client.conf:/etc/pulse/client.conf \
    --user $(id -u):$(id -g) \
    --env HOME=/tmp  firefox/18.04:6
