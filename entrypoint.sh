#!/bin/bash

model_path=$1
shift
sources=${@:-$(pwd)}
urdf_path=$(mktemp)

build_cmd="/build.sh $model_path $urdf_path"

display_size=${URDFENV_DISPLAY_SIZE:-1024x768}
novnc_port=${URDFENV_NOVNC_PORT:-6080}

export DISPLAY=:0
Xvfb $DISPLAY -screen 0 ${display_size}x24 +extension GLX +render -noreset &
fluxbox &
x11vnc -display $DISPLAY -rfbport 5900 -noxrecord -xkb -bg
/tmp/noVNC/utils/launch.sh --vnc localhost:5900 --listen ${novnc_port} &

source "/opt/ros/$ROS_DISTRO/setup.bash"
roscore &
wait-for-it ${ROS_MASTER_URI#*//}

rosparam set use_gui true

eval $build_cmd false
fswatch --event Created --event Updated --event Removed --event Renamed --recursive $URDFENV_FSWATCH_ADDITIONAL_OPTIONS $sources | xargs -n1 $build_cmd true
