ARCH TOR-BROWSER

To authorize exporting X use this

xhost local:root

To have sound please modify your /etc/pulse/default.pa, add or modify these in the file:

load-module module-esound-protocol-tcp load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1

Now you can pull and/or start the tor-browser image with this line

sudo docker run -i -t --rm --name tor-docker
-e DISPLAY=$DISPLAY -e PULSE_SERVER="$(hostname -i):4713"
-v /tmp/.X11-unix:/tmp/.X11-unix:ro
-v /dev/shm:/dev/shm tuxnvape/arch-torbrowserfr
