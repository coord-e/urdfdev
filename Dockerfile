FROM ros:latest

ARG URDFVIZ_VERSION=0.11.3
ARG NOVNC_VERSION=1.0.0

COPY entrypoint.sh /
ADD https://github.com/OTL/urdf-viz/releases/download/v${URDFVIZ_VERSION}/urdf-viz-v${URDFVIZ_VERSION}-x86_64-unknown-linux-gnu.tar.gz /tmp/urdf-viz.tar.gz
ADD https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz /tmp/novnc.tar.gz
RUN cd /tmp \
  && tar xf urdf-viz.tar.gz \
  && mv urdf-viz /usr/local/bin \
  && apt-get update \
  && apt-get install -y --no-install-recommends ros-$ROS_DISTRO-xacro ros-$ROS_DISTRO-urdf-tutorial xserver-xorg xvfb x11vnc net-tools \
  && tar xf novnc.tar.gz \
  && mv noVNC* noVNC

EXPOSE 6080

ENTRYPOINT ["/entrypoint.sh", "roslaunch", "urdf_tutorial", "display.launch"]
