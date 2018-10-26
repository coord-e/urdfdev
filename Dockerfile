FROM ros:latest

ARG URDFVIZ_VERSION=0.11.3
ARG NOVNC_VERSION=1.0.0
ARG TURBOVNC_VERSION=2.2
ARG VIRTUALGL_VERSION=2.6

COPY entrypoint.sh /
ADD https://github.com/OTL/urdf-viz/releases/download/v${URDFVIZ_VERSION}/urdf-viz-v${URDFVIZ_VERSION}-x86_64-unknown-linux-gnu.tar.gz /tmp/urdf-viz.tar.gz
ADD https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz /tmp/novnc.tar.gz
ADD https://sourceforge.net/projects/turbovnc/files/2.2/turbovnc_${TURBOVNC_VERSION}_amd64.deb/download /tmp/turbovnc.deb
ADD https://sourceforge.net/projects/virtualgl/files/2.6/virtualgl_${VIRTUALGL_VERSION}_amd64.deb/download /tmp/virtualgl.deb 

RUN cd /tmp \
  && tar xf urdf-viz.tar.gz \
  && mv urdf-viz /usr/local/bin \
  && apt-get update \
  && apt-get install -y --no-install-recommends ros-$ROS_DISTRO-xacro xserver-xorg xvfb x11vnc net-tools xorg-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libxrandr-dev \
        libxinerama-dev \
        libxcursor-dev \
        libxi-dev \
        libxxf86vm-dev \
  && tar xf novnc.tar.gz \
  && mv noVNC* noVNC \
  && dpkg -i turbovnc.deb \
  && dpkg -i virtualgl.deb

EXPOSE 6080

ENTRYPOINT ["/entrypoint.sh"]
