#!/bin/sh

Xvfb :0 &
x11vnc -display :0 -rfbport 5900 &
/tmp/noVNC/utils/launch.sh --vnc localhost:5900
