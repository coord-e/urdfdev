function info() {
  tput setaf 2 && echo -n "=> " && tput sgr0 && tput bold && echo $@ && tput sgr0
}

function exec_log() {
  $@ &>> $URDFDEV_LOG
}
