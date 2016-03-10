#!/bin/sh

## LIMITATIONS: FOR PERSONAL USE ONLY ###

ACL_URL="http://franz.com/ftp/pub/acl100express/linux86/acl100express-linux-x86.bz2"
GETDIR="$(mktemp -d /tmp/lw.XXXXXX)"
CURL="$(which curl) -s"
CURL_OPTIONS='-o'
WGET="$(which wget)"
WGET_OPTIONS='-O'
UNPACK="$(which tar)"
UNPACK_OPTIONS="-xf"

# mkdir -p $GETDIR
cd $GETDIR
if [ "$CURL" ]; then
    $CURL $ACL_URL $CURL_OPTIONS $(basename $ACL_URL .bz2).tar.bz2
elif [ "$WGET" ]; then
    $WGET $ACL_URL $WGET_OPTIONS $(basename $ACL_URL .bz2).tar.bz2
else
    echo "FATAL: Can not find neither CURL not WGET. Exiting"
    exit 1
fi

$UNPACK $UNPACK_OPTIONS $(basename $ACL_URL .bz2).tar.bz2 && rm $(basename $ACL_URL .bz2).tar.bz2

mkdir -p /opt/
mv acl* /opt/acl/
ln -s /opt/acl/alisp /usr/bin/
rm -rf $GETDIR
