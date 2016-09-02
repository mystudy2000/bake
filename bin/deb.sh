#!/bin/bash

set -e

if [ -d build ]
then
  rm -rf build;
fi

mkdir build

VERSION=${VERSION:-0.12}
REVISION=${REVISION:-3}

TMPDIR=`mktemp -d`
PKG=bake_${VERSION}-${REVISION}
TARGET_DIR=${TMPDIR}/${PKG}

mkdir -p $TARGET_DIR/usr/bin;
mkdir -p $TARGET_DIR/DEBIAN;

cp bake.sh $TARGET_DIR/usr/bin/bake
cp var/deb.txt $TARGET_DIR/DEBIAN/control

# cd $TMP_DIR
dpkg-deb --build $TARGET_DIR
cp $TMPDIR/$PKG.deb build/
