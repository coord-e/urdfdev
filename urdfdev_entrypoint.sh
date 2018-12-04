#!/bin/bash

set -euo pipefail

source "/opt/urdfdev/lib/log.sh"

export URDFDEV_MODE=$1
shift

export URDFDEV_LOG=${URDFDEV_LOG:-/var/log/urdfdev.log}
touch $URDFDEV_LOG

info "Logging to $URDFDEV_LOG"
info "Working in $URDFDEV_MODE mode"

function dev_mode() {
  /opt/urdfdev/run.sh $@ &
  local pid=$!
  trap "kill $pid" 1 2 3 15
  if [ "${URDFDEV_VERBOSE:-}" != "" ]; then
    tail -f $URDFDEV_LOG &
  fi
  wait $pid
}

function build_mode() {
  /opt/urdfdev/build.sh $@
}

case $URDFDEV_MODE in
  "dev" )
    dev_mode $@
    ;;
  "build" )
    build_mode $@
    ;;
  * )
    error "Mode ""$URDFDEV_MODE"" is not defined"
    exit -1
    ;;
esac
