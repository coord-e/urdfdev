#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

set -euo pipefail

source "/opt/urdfdev/lib/log.sh"

status "Starting..."

model_path=$1
shift
sources=${@:-$(pwd)}
urdf_path=$(mktemp)

build_cmd="/opt/urdfdev/build.sh $model_path $urdf_path"

display_size=${URDFDEV_DISPLAY_SIZE:-1024x768}
novnc_port=${URDFDEV_NOVNC_PORT:-6080}

export DISPLAY=:0
info "Starting X virtual framebuffer..."
exec_log Xvfb $DISPLAY -screen 0 ${display_size}x24 +extension GLX +render -noreset &
info "Starting fluxbox..."
exec_log_ fluxbox -log "$URDFDEV_LOG" &> /dev/null &
info "Starting x11vnc..."
exec_log_ x11vnc -display $DISPLAY -rfbport 5900 -noxrecord -xkb -forever -bg -o "$URDFDEV_LOG" &> /dev/null
info "Starting noVNC..."
exec_log /opt/urdfdev/noVNC/utils/launch.sh --vnc localhost:5900 --listen ${novnc_port} &

info "Starting roscore..."
exec_log roscore &
exec_log wait-for-it ${ROS_MASTER_URI#*//}
info "rosmaster is launched."

exec_log rosparam set use_gui true

eval $build_cmd false

info "Waiting noVNC to be launched..."
wait-for-it -q localhost:$novnc_port -t 0 && status "Ready. You can now view RViz at http://localhost:6080/"

fswatch --event Created --event Updated --event Removed --event Renamed --recursive ${URDFDEV_FSWATCH_ADDITIONAL_OPTIONS:-} $sources | xargs -n1 $build_cmd true
