#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

model_path=$1
urdf_path=$2
is_running=$3

if [[ "$model_path" = *.xacro ]]; then
  rosrun xacro xacro $URDFENV_XACRO_ADDITIONAL_OPTIONS "$model_path" > $urdf_path
else
  cp "$model_path" "$urdf_path"
fi

if $is_running; then
  xdotool search --name RViz key ctrl+s
  # Wait until saving is done
  xdotool search --sync --name '^[^*]*RViz$'

  rosnode list | grep -e rviz -e joint_state_publisher -e robot_state_publisher | xargs -r rosnode kill
  # Kill all joint_state_publisher processes, which is left after `rosnode kill`
  ps a | grep "[j]oint_state_publisher" | awk '{print $1}' | xargs -r kill -9
fi

rosparam set robot_description -t "$urdf_path"
rosrun rviz rviz -d $(rospack find urdf_tutorial)/rviz/urdf.rviz &
rosrun joint_state_publisher joint_state_publisher &
rosrun robot_state_publisher state_publisher &

# Maximize rviz window
xdotool search --name RViz windowsize 100% 100%

echo "Built $urdf_path and restarted rviz"
