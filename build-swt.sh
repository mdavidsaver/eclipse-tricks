#!/bin/sh
set -e -x

# Debian arch: i386 or amd64
DARCH=`dpkg-architecture -qDEB_HOST_ARCH`

[ -z "$DARCH" ] && DARCH="unknown"
[ -z "$JAVA_HOME" ] && export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-$DARCH

ROOT=eclipse.platform.swt/bundles/org.eclipse.swt

rm -rf build-swt
install -d build-swt
install -d result-$DARCH-swt

COM="$ROOT/Eclipse SWT/common/library/"

cp "$COM/make_common.mak" "$COM/"*.c "$COM/"*.h build-swt/

COM="$ROOT/Eclipse SWT PI/gtk/library/"

cp "$COM/make_linux.mak" "$COM/"*.c "$COM/"*.h build-swt/

COM="$ROOT/Eclipse SWT PI/common/library/"

cp "$COM/"*.c "$COM/"*.h build-swt/

COM="$ROOT/Eclipse SWT OpenGL/glx/library/"

cp "$COM/"*.c "$COM/"*.h build-swt/

COM="$ROOT/Eclipse SWT WebKit/gtk/library/"

cp "$COM/"*.c "$COM/"*.h build-swt/

cd build-swt

make -f make_linux.mak make_swt

cp libswt-pi-gtk-*.so ../result-$DARCH-swt/

make -f make_linux.mak clean

make -f make_linux.mak GTK_VERSION=3.0

cp *.so ../result-$DARCH-swt/
