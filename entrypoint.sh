#!/bin/bash

/run.sh $@ &
pid=$!
trap "kill $pid" 1 2 3 15

wait $pid
