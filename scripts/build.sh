#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

set -euo pipefail

source "/opt/urdfdev/lib/log.sh"

model_path=$1
urdf_path=$2
is_running=$3

status "Building..."

set +euo pipefail
if [ -v URDFDEV_CUSTOM_BUILD ]; then
  exec_info eval "$URDFDEV_CUSTOM_BUILD"
elif [[ "$model_path" = *.xacro ]]; then
  exec_info rosrun xacro xacro ${URDFDEV_XACRO_ADDITIONAL_OPTIONS:-} "$model_path" -o "$urdf_path"
else
  exec_info cp "$model_path" "$urdf_path"
fi
if [ "$?" != "0" ]; then
  error "Build failed. Check your files."
  exit
fi

exec_info check_urdf "$urdf_path"
if [ "$?" != "0" ]; then
  error "URDF check failed. Check your files."
  exit
fi
set -euo pipefail

if $is_running; then
  exec_log xdotool search --name RViz key ctrl+s
  # Wait until saving is done
  info "Waiting RViz to save changes..."
  exec_log xdotool search --sync --name '^[^*]*RViz$'

  info "Restarting visualization components..."
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

status "Built and started rviz"
