#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

set -euo pipefail

source "/opt/urdfdev/lib/log.sh"

info "Rebuilding..."

model_path=$1
urdf_path=$2
is_running=$3

if [ -v URDFDEV_CUSTOM_BUILD ]; then
  exec_info eval $URDFDEV_CUSTOM_BUILD
elif [[ "$model_path" = *.xacro ]]; then
  exec_info rosrun xacro xacro ${URDFDEV_XACRO_ADDITIONAL_OPTIONS:-} "$model_path" -o "$urdf_path"
else
  exec_info cp "$model_path" "$urdf_path"
fi

if $is_running; then
  exec_log xdotool search --name RViz key ctrl+s
  # Wait until saving is done
  exec_log xdotool search --sync --name '^[^*]*RViz$'

  exec_log eval "rosnode list | grep -e rviz -e joint_state_publisher -e robot_state_publisher | xargs -r rosnode kill"
  # Kill all joint_state_publisher processes, which is left after `rosnode kill`
  ps ax | grep "[j]oint_state_publisher" | awk '{print $1}' | xargs -r kill -9
fi

exec_log rosparam set robot_description -t "$urdf_path"
exec_log rosrun rviz rviz -d $(rospack find urdf_tutorial)/rviz/urdf.rviz &
exec_log rosrun joint_state_publisher joint_state_publisher &
exec_log rosrun robot_state_publisher state_publisher &

# Maximize rviz window
exec_log xdotool search --sync --name RViz windowsize 100% 100%

info "Built $urdf_path and restarted rviz"
