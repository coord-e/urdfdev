FROM ros:latest

ARG NOVNC_VERSION=1.0.0

COPY entrypoint.sh /
ADD https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz /tmp/novnc.tar.gz
RUN cd /tmp \
  && apt-get update \
  && apt-get install -y --no-install-recommends ros-$ROS_DISTRO-xacro ros-$ROS_DISTRO-urdf-tutorial xserver-xorg xvfb x11vnc net-tools \
  && tar xf novnc.tar.gz \
  && mv noVNC* noVNC

EXPOSE 6080
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]
