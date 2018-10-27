#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

model_path=$1
urdf_path=$2

if [[ "$model_path" = *.xacro ]]; then
  rosrun xacro xacro --xacro-ns "$model_path" > $urdf_path
else
  cp "$model_path" "$urdf_path"
fi

rosnode list | grep rviz | xargs rosnode kill
rosnode kill joint_state_publisher robot_state_publisher
# Kill all joint_state_publisher processes, which is left after `rosnode kill`
ps a | grep "[j]oint_state_publisher" | awk '{print $1}' | xargs kill -9

rosparam set robot_description -t "$urdf_path"
rosrun rviz rviz -d $(rospack find urdf_tutorial)/rviz/urdf.rviz &
rosrun joint_state_publisher joint_state_publisher &
rosrun robot_state_publisher state_publisher &
echo "Built $urdf_path and restarted rviz"
