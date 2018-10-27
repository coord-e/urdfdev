#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

set -euo pipefail

model_path=$1
urdf_path=$2
is_running=$3

if [ -v URDFENV_CUSTOM_BUILD ]; then
  eval $URDFENV_CUSTOM_BUILD &>> $URDFENV_LOG
elif [[ "$model_path" = *.xacro ]]; then
  rosrun xacro xacro $URDFENV_XACRO_ADDITIONAL_OPTIONS "$model_path" > $urdf_path 2>> $URDFENV_LOG
else
  cp "$model_path" "$urdf_path"
fi

if $is_running; then
  xdotool search --name RViz key ctrl+s &>> $URDFENV_LOG
  # Wait until saving is done
  xdotool search --sync --name '^[^*]*RViz$' &>> $URDFENV_LOG

  (rosnode list | grep -e rviz -e joint_state_publisher -e robot_state_publisher | xargs -r rosnode kill) &>> $URDFENV_LOG
  # Kill all joint_state_publisher processes, which is left after `rosnode kill`
  ps ax | grep "[j]oint_state_publisher" | awk '{print $1}' | xargs -r kill -9
fi

rosparam set robot_description -t "$urdf_path" &>> $URDFENV_LOG
rosrun rviz rviz -d $(rospack find urdf_tutorial)/rviz/urdf.rviz &>> $URDFENV_LOG &
rosrun joint_state_publisher joint_state_publisher &>> $URDFENV_LOG &
rosrun robot_state_publisher state_publisher &>> $URDFENV_LOG &

# Maximize rviz window
xdotool search --sync --name RViz windowsize 100% 100% &>> $URDFENV_LOG

echo "Built $urdf_path and restarted rviz"
