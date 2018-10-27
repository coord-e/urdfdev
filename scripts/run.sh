#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

set -euo pipefail

source "/opt/urdfdev/lib/log.sh"

info "Starting..."

model_path=$1
shift
sources=${@:-$(pwd)}
urdf_path=$(mktemp)

build_cmd="/opt/urdfdev/build.sh $model_path $urdf_path"

display_size=${URDFDEV_DISPLAY_SIZE:-1024x768}
novnc_port=${URDFDEV_NOVNC_PORT:-6080}

export DISPLAY=:0
exec_log Xvfb $DISPLAY -screen 0 ${display_size}x24 +extension GLX +render -noreset &
exec_log_ fluxbox -log "$URDFDEV_LOG" &> /dev/null &
exec_log_ x11vnc -display $DISPLAY -rfbport 5900 -noxrecord -xkb -bg -o "$URDFDEV_LOG" &> /dev/null
exec_log /opt/urdfdev/noVNC/utils/launch.sh --vnc localhost:5900 --listen ${novnc_port} &

exec_log roscore &
exec_log wait-for-it ${ROS_MASTER_URI#*//}

exec_log rosparam set use_gui true

eval $build_cmd false

wait-for-it -q localhost:$novnc_port -t 0 && info "Ready. go to http://localhost:6800"

fswatch --event Created --event Updated --event Removed --event Renamed --recursive ${URDFDEV_FSWATCH_ADDITIONAL_OPTIONS:-} $sources | xargs -n1 $build_cmd true
