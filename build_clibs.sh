#!/bin/bash
OLD_PWD=$PWD
ARCH=$1
PLATFORM=$2
PACKAGE_DIR=$3

if [ ! -d "$PACKAGE_DIR/c/build" ]; then
    mkdir -p "$PACKAGE_DIR/c/build"
fi

if [ -f "$PACKAGE_DIR/c/build/liblua5.1.a" ]; then
    exit
fi

cd $PACKAGE_DIR/c/lua5.1.5

if [ $ARCH = "x86_64" ]; then
    ARCH="64"
elif [ $ARCH = "x86" ]; then
    ARCH="32"
fi

make ARCH=$ARCH PLATFORM=$PLATFORM

cd $OLD_PWD

cp "$PACKAGE_DIR/c/lua5.1.5/src/liblua5.1.a" "$PACKAGE_DIR/c/build/"
