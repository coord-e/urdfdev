#!/bin/bash

set -euo pipefail

export URDFENV_LOG=${URDFENV_LOG:-/var/log/urdfenv.log}
/opt/urdfenv/run.sh $@ &
pid=$!
trap "kill $pid" 1 2 3 15

if [ "${URDFENV_VERBOSE:-}" != "" ]; then
  tail -f $URDFENV_LOG &
else
  trap "cat $URDFENV_LOG >&2" ERR
fi


wait $pid
