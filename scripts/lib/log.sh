function info() {
  tput setaf 2 && echo -n " > " && tput sgr0 && echo "$@" && tput sgr0
}

function status() {
  tput setaf 2 && echo -n "=> " && tput sgr0 && tput bold && echo "$@" && tput sgr0
}

function cmd_info() {
  tput setaf 2 && echo -n " + " && tput sgr0 && echo "$@" && tput sgr0
}

function exec_log_() {
  echo "+ $@" >> $URDFDEV_LOG
  $@
}

function exec_log() {
  exec_log_ "$@" &>> $URDFDEV_LOG
}

function exec_info {
  cmd_info "$@"
  exec_log_ "$@"
}
