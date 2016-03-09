#!/bin/sh

CCL_URL='ftp://ftp.clozure.com/pub/release/1.11/ccl-1.11-linuxx86.tar.gz'
GETDIR="$(mktemp -d /tmp/ccl.XXXXXX)"
CURL="$(which curl)"
CURL_OPTIONS='-o'
WGET="$(which wget)"
WGET_OPTIONS='-O'
UNPACK="$(which tar)"
UNPACK_OPTIONS="-xf"

# mkdir -p $GETDIR
cd $GETDIR
if [ "$CURL" ]; then
    $CURL $CCL_URL $CURL_OPTIONS $(basename $CCL_URL)
elif [ "$WGET" ]; then
    $WGET $CCL_URL $WGET_OPTIONS $(basename $CCL_URL)
else
    echo "FATAL: Can not find neither CURL not WGET. Exiting"
    exit 1
fi

$UNPACK $UNPACK_OPTIONS $(basename $CCL_URL) && rm $(basename $CCL_URL)
mv $GETDIR/ccl/ /opt/
ln -sf /opt/ccl/lx86cl* /usr/bin/
rm -rf $GETDIR
