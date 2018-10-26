FROM ros:latest

ARG URDFVIZ_VERSION=0.11.3

ADD https://github.com/OTL/urdf-viz/releases/download/v{URDFVIZ_VERSION}/urdf-viz-v{URDFVIZ_VERSION}-x86_64-unknown-linux-gnu.tar.gz /tmp/urdf-viz.tar.gz
RUN cd /tmp \
  && tar xf urdf-viz.tar.gz \
  && mv urdf-viz /usr/local/bin
