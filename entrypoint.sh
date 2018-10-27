#!/bin/bash

model_path=$1
urdf_path=$(mktemp)
pid_path=$(mktemp)

build_cmd="/build.sh $model_path $urdf_path $pid_path"


export DISPLAY=:0
Xvfb $DISPLAY -screen 0 1024x768x24 +extension GLX +render -noreset &
fluxbox &
x11vnc -display $DISPLAY -rfbport 5900 &
/tmp/noVNC/utils/launch.sh --vnc localhost:5900 &

source "/opt/ros/$ROS_DISTRO/setup.bash"
roscore &
wait-for-it ${ROS_MASTER_URI#*//}

rosparam set use_gui true

eval $build_cmd
fswatch --event Created --event Updated --event Removed --event Renamed --recursive $(pwd) | xargs -n1 $build_cmd
