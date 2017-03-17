#!/bin/bash

set -e

if [ -d build ]
then
  rm -rf build;
fi

mkdir build

VERSION=${VERSION:-$1}
REVISION=${REVISION:-$2}

if [ -z "$VERSION" ]
then
  echo "NO VERSION" >&2
  exit 1
fi

if [ -z "$REVISION" ]
then
  echo "NO REVISION" >&2
  exit 1
fi

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
