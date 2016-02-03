#!/bin/sh

case "$1" in
'start')
  if [ -f ./.tcpdump_pid ]; then
    echo "now starting (`cat ./.tcpdump_pid`)"
  else
    export CMD="/usr/sbin/tcpdump"
    export PORT="port 80 or port 443"
    export RULE="net 192.168.0.0 mask 255.255.240.0"
    export FILE=dump_`date +%Y%m%d%H%M -d '9 hours'`

    echo "$CMD -w $FILE $PORT and $RULE"

    $CMD -w $FILE $PORT and $RULE &
    echo $! > ./.tcpdump_pid
  fi
  ;;
'stop')
  if [ -f ./.tcpdump_pid ]; then
    kill `cat ./.tcpdump_pid`
    rm -f ./.tcpdump_pid
  else
    echo "not starting tcpdump"
  fi
  ;;
'view')
  export CMD="/usr/sbin/tcpdump"
  export FILE=$2

  if [ -f $FILE ]; then
    $CMD -r $FILE -tttt
  else
    echo "not exist $FILE"
  fi
  ;;
*)
  echo "Usage: $0 { start | stop | view [file] }"
  exit 1
  ;;
esac

exit
