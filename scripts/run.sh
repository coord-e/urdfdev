#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

set -euo pipefail

model_path=$1
shift
sources=${@:-$(pwd)}
urdf_path=$(mktemp)

build_cmd="/opt/urdfdev/build.sh $model_path $urdf_path"

display_size=${URDFDEV_DISPLAY_SIZE:-1024x768}
novnc_port=${URDFDEV_NOVNC_PORT:-6080}

export DISPLAY=:0
Xvfb $DISPLAY -screen 0 ${display_size}x24 +extension GLX +render -noreset &>> $URDFDEV_LOG &
fluxbox -log $URDFDEV_LOG &> /dev/null &
x11vnc -display $DISPLAY -rfbport 5900 -noxrecord -xkb -bg -o $URDFDEV_LOG
/opt/urdfdev/noVNC/utils/launch.sh --vnc localhost:5900 --listen ${novnc_port} &>> $URDFDEV_LOG &

roscore &>> $URDFDEV_LOG &
wait-for-it ${ROS_MASTER_URI#*//} &>> $URDFDEV_LOG

rosparam set use_gui true &>> $URDFDEV_LOG

eval $build_cmd false

wait-for-it localhost:$novnc_port && echo "Ready. go to http://localhost:6800"

fswatch --event Created --event Updated --event Removed --event Renamed --recursive ${URDFDEV_FSWATCH_ADDITIONAL_OPTIONS:-} $sources | xargs -n1 $build_cmd true
