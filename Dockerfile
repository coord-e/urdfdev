FROM ros:latest

ARG URDFVIZ_VERSION=0.11.3
ARG NOVNC_VERSION=1.0.0

ADD https://github.com/OTL/urdf-viz/releases/download/v${URDFVIZ_VERSION}/urdf-viz-v${URDFVIZ_VERSION}-x86_64-unknown-linux-gnu.tar.gz /tmp/urdf-viz.tar.gz
ADD https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz /tmp/novnc.tar.gz
RUN cd /tmp \
  && tar xf urdf-viz.tar.gz \
  && mv urdf-viz /usr/local/bin \
  && apt-get update \
  && apt-get install -y --no-install-recommends ros-$ROS_DISTRO-xacro xserver-xorg xvfb x11vnc \
  && tar xf novnc.tar.gz

EXPOSE 6080
