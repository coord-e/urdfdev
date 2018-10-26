#!/bin/bash

model_path=$1

export DISPLAY=:0
Xvfb $DISPLAY -screen 0 1024x768x24 +extension GLX +render -noreset &
x11vnc -display $DISPLAY -rfbport 5900 &
/tmp/noVNC/utils/launch.sh --vnc localhost:5900 &
./ros_entrypoint.sh roslaunch urdf_tutorial display.launch model:=$model_path
