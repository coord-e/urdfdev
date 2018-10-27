#!/bin/bash

model_path=$1
urdf_path=$(mktemp)

build_cmd="/build.sh $model_path $urdf_path"

eval $build_cmd

export DISPLAY=:0
Xvfb $DISPLAY -screen 0 1024x768x24 +extension GLX +render -noreset &
x11vnc -display $DISPLAY -rfbport 5900 &
/tmp/noVNC/utils/launch.sh --vnc localhost:5900 &
/ros_entrypoint.sh roslaunch urdf_tutorial display.launch model:=$urdf_path &
fswatch --event Created --event Updated --event Removed --event Renamed --recursive $(pwd) | xargs -n1 $build_cmd
