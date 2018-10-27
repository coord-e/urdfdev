#!/bin/bash

set -euo pipefail

source "/opt/urdfdev/lib/log.sh"

export URDFDEV_LOG=${URDFDEV_LOG:-/var/log/urdfdev.log}
touch $URDFDEV_LOG

info "Logging to $URDFDEV_LOG"

/opt/urdfdev/run.sh $@ &
pid=$!
trap "kill $pid" 1 2 3 15

if [ "${URDFDEV_VERBOSE:-}" != "" ]; then
  tail -f $URDFDEV_LOG &
fi


wait $pid
