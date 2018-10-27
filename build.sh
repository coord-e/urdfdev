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
  kill $(cat $pid_path)
fi

rosparam set robot_description -t "$urdf_path"
rosrun rviz rviz -d $(rospack find urdf_tutorial)/rviz/urdf.rviz &
echo "$!" > $pid_path
echo "Built $urdf_path and restarted rviz $(cat $pid_path)"
