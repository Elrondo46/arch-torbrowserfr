# arch-torbrowserfr

To launch just do:

sudo docker run -t -i --rm -v /tmp/.X11-unix:/tmp/.X11-unix \
-v /dev/shm:/dev/shm \
-e DISPLAY=unix$DISPLAY \
tuxnvape/arch-torbrowserfr:stable

DO NOT FORGET USING xhost command to permit other local user X sessions

