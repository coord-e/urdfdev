FROM ros:latest

ARG NOVNC_VERSION=1.0.0
ARG WEBSOCKIFY_VERSION=0.8.0

COPY urdfdev_entrypoint.sh /
COPY scripts /opt/urdfdev/

ADD https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz /tmp/novnc.tar.gz
ADD https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz /tmp/websockify.tar.gz
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /bin/wait-for-it

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=screen-256color

RUN cd /opt/urdfdev \
  && apt-get update \
  && apt-get install -y --no-install-recommends ros-$ROS_DISTRO-xacro ros-$ROS_DISTRO-urdf-tutorial xserver-xorg xvfb x11vnc net-tools fswatch fluxbox xdotool ncurses-bin \
  && tar xf /tmp/novnc.tar.gz \
  && mv noVNC* noVNC \
  && ln -rs noVNC/vnc_lite.html noVNC/index.html \
  && tar xf /tmp/websockify.tar.gz -C noVNC/utils \
  && mv noVNC/utils/websockify* noVNC/utils/websockify \
  && chmod +x /bin/wait-for-it \
  && rm /tmp/novnc.tar.gz \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 6080
WORKDIR /data

ENTRYPOINT ["/urdfdev_entrypoint.sh"]
