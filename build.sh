#!/bin/bash

model_path=$1
urdf_path=$2

if [[ "$model_path" = *.xacro ]]; then
  /ros_entrypoint.sh rosrun xacro xacro --xacro-ns "$model_path" > $urdf_path
else
  cp "$model_path" "$urdf_path"
fi
