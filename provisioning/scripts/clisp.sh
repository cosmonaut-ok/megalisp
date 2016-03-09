#!/bin/sh

CLISP_URL='ftp://ftp.gnu.org/pub/gnu/clisp/latest/clisp-2.49.tar.bz2'
GETDIR="$(mktemp -d /tmp/curl.XXXXXX)"
CURL="$(which curl)"
CURL_OPTIONS='-o'
WGET="$(which wget)"
WGET_OPTIONS='-O'
UNPACK="$(which tar)"
UNPACK_OPTIONS="-xf"

# mkdir -p $GETDIR
cd $GETDIR
if [ "$CURL" ]; then
    $CURL $CLISP_URL $CURL_OPTIONS $(basename $CLISP_URL)
elif [ "$WGET" ]; then
    $WGET $CLISP_URL $WGET_OPTIONS $(basename $CLISP_URL)
else
    echo "FATAL: Can not find neither CURL not WGET. Exiting"
    exit 1
fi

$UNPACK $UNPACK_OPTIONS $(basename $CLISP_URL) && rm $(basename $CLISP_URL)
cd clisp*
./configure --prefix=/usr --with-module=modules/clx/new-clx --with-module=modules/dbus --with-module=modules/i18n --with-module=modules/regexp --with-module=modules/syscalls
make
make install
rm -rf $GETDIR
