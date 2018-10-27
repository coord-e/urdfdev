function info() {
  tput setaf 2 && echo -n "=> " && tput sgr0 && tput bold && echo $@ && tput sgr0
}

function exec_log_() {
  echo "+ $@" >> $URDFDEV_LOG
  $@
}

function exec_log() {
  exec_log_ $@ &>> $URDFDEV_LOG
}
