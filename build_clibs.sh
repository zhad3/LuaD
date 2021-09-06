#!/bin/bash
OLD_PWD=$PWD
PACKAGE_DIR=$1
ARCH=$DUB_ARCH
PLATFORM=$DUB_PLATFORM
BUILD_TYPE=$DUB_BUILD_TYPE

if [ "$PLATFORM"="posix" ]; then
    PLATFORM=linux
fi

DEST_DIR=$PACKAGE_DIR/c/build/$ARCH-$BUILD_TYPE

if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi

if [ -f "$DEST_DIR/liblua5.1.a" ] && [ -z $DUB_FORCE ]; then
    exit
fi

cd "$PACKAGE_DIR/c/lua5.1.5"

if [ $ARCH = "x86_64" ]; then
    ARCH_LUA="64"
elif [ $ARCH = "x86" ]; then
    ARCH_LUA="32"
else
    ARCH_LUA=$ARCH
fi

MYCFLAGS=-fPIC

make ARCH=$ARCH_LUA PLATFORM=$PLATFORM

mv "$PACKAGE_DIR/c/lua5.1.5/src/liblua5.1.a" "$DEST_DIR"

make clean

cd "$OLD_PWD"

