FROM ros:latest

ARG NOVNC_VERSION=1.0.0

COPY entrypoint.sh /
COPY scripts /opt/urdfenv/

ADD https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz /tmp/novnc.tar.gz
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /bin/wait-for-it

ENV DEBIAN_FRONTEND=noninteractive

RUN cd /opt/urdfenv \
  && apt-get update \
  && apt-get install -y --no-install-recommends ros-$ROS_DISTRO-xacro ros-$ROS_DISTRO-urdf-tutorial xserver-xorg xvfb x11vnc net-tools fswatch fluxbox xdotool \
  && tar xf /tmp/novnc.tar.gz \
  && mv noVNC* noVNC \
  && chmod +x /bin/wait-for-it \
  && rm /tmp/novnc.tar.gz \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 6080
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]
