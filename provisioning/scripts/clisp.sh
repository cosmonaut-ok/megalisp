#!/bin/sh

CLISP_URL='ftp://ftp.gnu.org/pub/gnu/clisp/latest/clisp-2.49.tar.bz2'
GETDIR="$(mktemp -d /tmp/curl.XXXXXX)"
CURL="$(which curl) -s"
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

mkdir -p lib/lib
mkdir -p lib/include

ln -s `find /usr/lib/ -name '*sigsegv.a` lib/lib/
ln -s `find /usr/include/ -name 'sigsegv.h` lib/include
ln -s `find /usr/include/libsvm -name svm.h` lib/include

./configure --with-libsigsegv-prefix=$(pwd)/lib --prefix=/usr/ --with-module=i18n --with-module=regexp --with-module=syscalls --with-module=fastcgi  --with-module=gtk2 --with-module=gdbm --with-module=libsvm build-with-gcc
cd build-with-gcc
make
make check && make install
rm -rf $GETDIR
