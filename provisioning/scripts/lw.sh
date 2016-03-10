#!/bin/sh

## LIMITATIONS: FOR PERSONAL USE ONLY ###

LW_KEY='lwper61:PIFRPFLP:BMryr3YJq7Z5OT5pJOVDUbQMpj8&timestamp=1457559680&download=qYoDTh6iLfIQUJ3pexJhXjPReTI'
LW_URL="http://downloads.lispworks.com/downloader/x86-linux/lwper61-x86-linux.tar.gz?id=${LW_KEY}"
LWDOC_URL="http://downloads.lispworks.com/downloader/x86-linux/lwdoc61-x86-linux.tar.gz?id=${LW_KEY}"
LWLIC_URL="http://downloads.lispworks.com/downloader/x86-linux/lwlper-license.sh?id=${LW_KEY}"
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
    $CURL $LW_URL $CURL_OPTIONS $(basename $LW_URL | cut -d'?' -f1)
    $CURL $LWDOC_URL $CURL_OPTIONS $(basename $LWDOC_URL | cut -d'?' -f1)
    $CURL $LWLIC_URL $CURL_OPTIONS $(basename $LWLIC_URL | cut -d'?' -f1)
elif [ "$WGET" ]; then
    $WGET $LW_URL $WGET_OPTIONS $(basename $LW_URL | cut -d'?' -f1)
    $WGET $LWDOC_URL $WGET_OPTIONS $(basename $LWDOC_URL | cut -d'?' -f1)
    $WGET $LWLIC_URL $WGET_OPTIONS $(basename $LWLIC_URL | cut -d'?' -f1)
else
    echo "FATAL: Can not find neither CURL not WGET. Exiting"
    exit 1
fi

$UNPACK $UNPACK_OPTIONS $(basename $LW_URL | cut -d'?' -f1) && rm $(basename $LW_URL | cut -d'?' -f1)
$UNPACK $UNPACK_OPTIONS $(basename $LWDOC_URL | cut -d'?' -f1) && rm $(basename $LWDOC_URL | cut -d'?' -f1)

if [ $? == 0 ]; then
mkdir -p /opt/lw/
mv lib /opt/lw/
mv lispworks-personal* /opt/lw/
mv $(basename $LWLIC_URL | cut -d'?' -f1) /opt/lw/
cd /opt/lw/
sh -x $(basename $LWLIC_URL | cut -d'?' -f1)
ln -sf /opt/lw/lispworks-personal* /usr/bin/
rm -rf $GETDIR
else
    echo "Error loading files. Please, check key: $LW_KEY"
    exit 1
fi
