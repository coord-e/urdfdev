#!/bin/bash

set -euo pipefail

model_path=$1
shift
sources=${@:-$(pwd)}
urdf_path=$(mktemp)

build_cmd="/opt/urdfenv/build.sh $model_path $urdf_path"

display_size=${URDFENV_DISPLAY_SIZE:-1024x768}
novnc_port=${URDFENV_NOVNC_PORT:-6080}

export DISPLAY=:0
Xvfb $DISPLAY -screen 0 ${display_size}x24 +extension GLX +render -noreset &>> $URDFENV_LOG &
fluxbox -log $URDFENV_LOG &> /dev/null &
x11vnc -display $DISPLAY -rfbport 5900 -noxrecord -xkb -bg -o $URDFENV_LOG
/opt/urdfenv/noVNC/utils/launch.sh --vnc localhost:5900 --listen ${novnc_port} &>> $URDFENV_LOG &

source "/opt/ros/$ROS_DISTRO/setup.bash"
roscore &>> $URDFENV_LOG &
wait-for-it ${ROS_MASTER_URI#*//} &>> $URDFENV_LOG

rosparam set use_gui true &>> $URDFENV_LOG

eval $build_cmd false

wait-for-it localhost:$novnc_port && echo "Ready. go to http://localhost:6800"

fswatch --event Created --event Updated --event Removed --event Renamed --recursive $URDFENV_FSWATCH_ADDITIONAL_OPTIONS $sources | xargs -n1 $build_cmd true
