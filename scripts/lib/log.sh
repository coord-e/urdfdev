function info() {
  tput setaf 2 && echo -n "   > " && tput sgr0 && echo "$@" && tput sgr0
}

function error() {
  tput setaf 1 && echo -n "ERR: " && tput sgr0 && echo "$@" && tput sgr0
}

function status() {
  tput setaf 2 && echo -n "  => " && tput sgr0 && tput bold && echo "$@" && tput sgr0
}

function cmd_info() {
  tput setaf 2 && echo -n "   + " && tput sgr0 && echo "$@" && tput sgr0
}

function exec_log_() {
  echo "+ $@" >> $URDFDEV_LOG
  $@
}

function exec_log() {
  exec_log_ "$@" &>> $URDFDEV_LOG
}

function build_exec {
  cmd_info "$@"
  set +euo pipefail
  exec_log_ "$@" >> $URDFDEV_LOG
  set -euo pipefail
}
