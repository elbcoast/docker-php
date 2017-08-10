#!/bin/ash

set -e

CUSER="www-data"
MYUID=`stat -c "%u" .`
MYGID=`stat -c "%g" .`

if [[ "$MYUID" -gt '0' && "$MYUID" != `id -u ${CUSER}` ]]; then
    usermod -u ${MYUID} ${CUSER}
    groupmod -g ${MYGID} ${CUSER}
    chown ${CUSER}:${CUSER} /tmp
fi

if [ -z "$DOCKERHOST" ]; then
    DOCKERHOST=`ip route list | grep ^default |awk '/default/ { print  $3}'`
fi


case "$1" in
    "root")
      exec /bin/ash ;;
    "shell")
      gosu ${CUSER} "/bin/ash" ;;
    "php-fpm")
      exec env XDEBUG_CONFIG="remote_host=$DOCKERHOST" php-fpm ;;
    "")
      exec env XDEBUG_CONFIG="remote_host=$DOCKERHOST" php-fpm ;;
    *)
      gosu ${CUSER} "$@" ;;
esac