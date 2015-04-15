#!/bin/sh
set -e -x

# Debian arch: i386 or amd64
DARCH=`dpkg-architecture -qDEB_HOST_ARCH`

[ -z "$DARCH" ] && DARCH="unknown"
[ -z "$JAVA_HOME" ] && export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-$DARCH

ROOT=rt.equinox.framework/features/org.eclipse.equinox.executable.feature/library

rm -rf build-launcher
install -d build-launcher/gtk
install -d result-$DARCH-launcher

COM="$ROOT"

cp "$COM/make_version.mak" "$COM/"*.c "$COM/"*.h build-launcher/

COM="$ROOT/gtk"

cp "$COM/make_linux.mak" "$COM/"*.c "$COM/"*.h build-launcher/gtk/

cd build-launcher/gtk

make -f make_linux.mak

cp eclipse_*.so ../../result-$DARCH-launcher/
