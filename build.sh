#!/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"

model_path=$1
urdf_path=$2
pid_path=$3

if [[ "$model_path" = *.xacro ]]; then
  rosrun xacro xacro --xacro-ns "$model_path" > $urdf_path
else
  cp "$model_path" "$urdf_path"
fi

if [ -s "$pid_path" ]; then
  rosnode list | grep rviz | xargs rosnode kill
  rosnode kill joint_state_publisher robot_state_publisher
  # Kill all joint_state_publisher processes, which is left after `rosnode kill`
  ps a | grep "[j]oint_state_publisher" | awk '{print $1}' | xargs kill -9
fi

rosparam set robot_description -t "$urdf_path"
rosrun rviz rviz -d $(rospack find urdf_tutorial)/rviz/urdf.rviz &
echo "$!" > $pid_path
rosrun joint_state_publisher joint_state_publisher &
echo "$!" >> $pid_path
rosrun robot_state_publisher state_publisher &
echo "$!" >> $pid_path
echo "Built $urdf_path and restarted rviz $(cat $pid_path)"
